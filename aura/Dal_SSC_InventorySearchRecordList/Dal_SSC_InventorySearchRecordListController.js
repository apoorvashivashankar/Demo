/**
 * Created by Yadav on 10/31/2018.
 */
({
    
    onCheck : function(cmp,event,helper) {
    //    debugger;
        
        var responseWrapperData = cmp.get('v.responseWrapperData');
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts') || [];
        var totalPages = cmp.get('v.totalPages');
        var pageNumber = cmp.get('v.pageNumber');
        var indexOfProduct = event.getSource().get('v.value');
        var displayProdList = cmp.get('v.displayProdList');
        var indexForTotal = (pageNumber > 1) ? (((pageNumber-1) * 30) + indexOfProduct) : indexOfProduct;
        
        if(displayProdList[indexOfProduct]) {
            
            if(displayProdList[indexOfProduct].isChecked) {
                listOfSelectedProducts.push(displayProdList[indexOfProduct]);
            } else {
                for(var i=0;i<listOfSelectedProducts.length;i++) {
                    if(listOfSelectedProducts[i] === displayProdList[indexOfProduct])
                        listOfSelectedProducts.splice(i,1);
                }
            }
            
            cmp.set('v.responseWrapperData',responseWrapperData);
            cmp.set('v.listOfSelectedProducts', listOfSelectedProducts);
            cmp.set('v.count', listOfSelectedProducts.length);
        }
    },
    
    changePageData : function(cmp,event,helper) {
    //    debugger;
        
        cmp.set('v.isPageLoading', true);
        cmp.set('v.isInventoryBaseLoading',true);
        var responseWrapperData = cmp.get('v.responseWrapperData');
        var totalPages = cmp.get('v.totalPages');
        var pageNumber = cmp.get('v.pageNumber');
        //var indexOfPage = event.currentTarget.name;
        var indexOfPage = event.getSource().get('v.value');
        var listOfProdToDisp = [];
        var orglPgNo = pageNumber;
        console.log('indexOfPage: ', indexOfPage);
        
        if(indexOfPage === 'next') {
            pageNumber+=1;
        } else if(indexOfPage === 'prev') {
            if(pageNumber != 1)
                pageNumber-=1;
            else
                pageNumber = 1;
        } else {
            pageNumber = indexOfPage;
        }
        
        if(Math.ceil((responseWrapperData.length)/30)!= (pageNumber-1)){
            
            var indexStart = (pageNumber - 1)*30;
            var indexEnd;
            
            if(((responseWrapperData.length) % 30) == 0) {
                indexEnd = ((pageNumber)*30);
            } else {
                indexEnd = ((Math.ceil((responseWrapperData.length)/30)) == pageNumber) ? (((pageNumber-1)*30) +(responseWrapperData.length)%(30)) : (30*pageNumber);
            }
            
            for(var i=indexStart;i<indexEnd;i++) {
                listOfProdToDisp.push(responseWrapperData[i]);
            }
            
            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.displayProdList',listOfProdToDisp);
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
            window.scrollTo(0, 500);
        } else {
            pageNumber = orglPgNo;
            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
            cmp.set('v.disableNext',true);
            window.scrollTo(0, 500);
        }
    },
    
    navigateToNextPage : function(cmp,event,helper) {
    //    debugger;
        
        
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
        var listOfWrapperData = [];
        
        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate()+1);
        var _newDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth()+1) + '-' + tomorrow.getDate() ;
        
        if(listOfSelectedProducts && listOfSelectedProducts.length > 0) {
            for(var i=0;i<listOfSelectedProducts.length;i++) {
                var wrapperData = {};
                wrapperData.sku = listOfSelectedProducts[i].DW_ID__c;
                wrapperData.quantity = '1';
                wrapperData.uom = listOfSelectedProducts[i].Base_UoM__c;
                wrapperData.CodeSet = 'Legacy';
                wrapperData.SupplyplantId = '4101';
                wrapperData.SupplyplantType = 'SAP_Plant';
                wrapperData.reqShipdate = _newDate;
                listOfWrapperData.push(wrapperData);
            }
            
            console.log('Navigation Params', listOfWrapperData);
            helper.getExternalData(cmp,event,helper,listOfWrapperData);
        }
    }
    
})