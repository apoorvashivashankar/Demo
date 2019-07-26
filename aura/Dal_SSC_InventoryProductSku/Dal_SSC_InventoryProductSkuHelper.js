/**
 * Created by Yadav on 10/30/2018.
 */
({
    getSearchedProductBySku : function(cmp,event,helper){
    //    debugger;

        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading', true);
        cmp.set('v.searchPressed',true);

        var listOfColors = cmp.get('v.listOfColors');
        var _selectedColor = cmp.get("v.selectedColor");
        var _params = [];
        var param = [];
        var divCode = cmp.get('v.divisionCode');


        if(_selectedColor && divCode && listOfColors){
         cmp.set('v.isProductSelected',false);
            //console.log('_selectedColor: ',_selectedColor);
        if(_selectedColor === 'ALL' || _selectedColor === 'All' || _selectedColor == 'All') {
            if(listOfColors.length > 0) {
                for(var i=0;i<listOfColors.length;i++)
                    _params.push(listOfColors[i].colorCode);
            }
        } else {
            _params.push(_selectedColor);
        }
        param.push(_params);
            console.log('IN get prod:',param );

		var selectedBrand = cmp.get('v.selectedBrand');            
        if(!selectedBrand) {       
        	if(divCode == 40)
            	param.push('DB');
        	else 
             	param.push('AO');
        }  else {
            param.push(selectedBrand);
        }
            
        var skuKeyword = cmp.get('v.skuKeyword');
            
            if(!skuKeyword){
                skuKeyword = '';
            }
		param.push(skuKeyword);
        
        console.log('param for series: ',param);
        helper.getSearchedProductBySkuColl(cmp,event,helper,param);
        } else {
            cmp.set('v.selectedColor','ALL');
            cmp.set('v.isInventoryBaseLoading',false);
        	cmp.set('v.isPageLoading', false);
        }
    },

    getSearchedProduct : function(cmp,event,helper){
    //    debugger;

        var searchValue = cmp.get("v.skuValue");
        
        var _params = {
            searchParameter : searchValue
        };
        this.doCallout(cmp, "c.getProduct", _params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                 cmp.set('v.isPageLoading', false);
                cmp.set('v.isInventoryBaseLoading',false);
                cmp.set('v.responseWrapperData',response.getReturnValue());
            } else {
                 cmp.set('v.isPageLoading', false);
                cmp.set('v.isInventoryBaseLoading',false);
            }
        });
    },

    getAllProductsOfSeries : function (cmp,helper, _serId,selBrand) {
    //    debugger;

        this.doCallout(cmp, 'c.getInventoryColorCodes', {SeriesId : _serId, brand : selBrand}, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                console.log('colors: ',response.getReturnValue());

                if(_resp){
                     cmp.set('v.isProductSelected',false);
                    cmp.set('v.listOfColors', response.getReturnValue());
               		
                	helper.getSearchedProductBySku(cmp,event,helper);
                } 

            }
        });
    },

    handleSearchClickAll : function(cmp,event,helper) {
    //    debugger;

        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading', true);

        var paramValue = cmp.get('v.skuKeyword');
		
        if(paramValue) {

        var divisionCode = cmp.get('v.divisionCode');
        var brand = cmp.get('v.selectedBrand');
        if(!brand){
            if(divisionCode == 41) {
                 brand = 'AO';
            } else {
                 brand = 'DB';
            }
        }
        
        var _params = {
            searchParameter : paramValue,
            brand :  brand
        };
        cmp.set('v.listOfColors',[]);
        helper.doCallout(cmp, "c.getProduct", _params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){  
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);

                var _resp = response.getReturnValue();

                var custResp = {};
                var skuList = [];
                custResp = response.getReturnValue(); 
                if(custResp) {
                

                for(var i=0;i<custResp.length;i++) {
                    custResp[i].isChecked = false;
                    if(i<30){
                        skuList.push(custResp[i]);
                    }
                }
                var pgNb = Math.ceil((custResp.length) / 30) ;
                var totalPages = (custResp.length > 30) ? pgNb :  1 ;
                }

                cmp.set('v.responseWrapperData', custResp);
                cmp.set('v.totalPages', totalPages);
                cmp.set('v.displayProdList',skuList);
                cmp.set('v.pageNumber',1);
                cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);
            } else {
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);
            }
        });
        
        } else {
            cmp.set('v.listOfSizes',[]);
            cmp.set('v.listOfColors',[]);
            cmp.set('v.responseWrapperData', []);
            cmp.set('v.displayProdList',[]);
            cmp.set('v.isInventoryBaseLoading',false);
            cmp.set('v.isPageLoading', false);
        }

    },


})