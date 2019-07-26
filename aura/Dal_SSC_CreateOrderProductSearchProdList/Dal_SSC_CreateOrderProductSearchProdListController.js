/**
 * Created by ranja on 27-12-2018.
 */
({
    onCheck : function(cmp,event,helper) {

        helper.doPaginationOnLoad(cmp,event,helper);
    },

    changePageData : function(cmp,event,helper) {

        try{
        helper.startSpinner(cmp);
        var responseFromSearchResult = cmp.get('v.responseFromSearchResult');
        var totalPages = cmp.get('v.totalPages');
        var pageNumber = cmp.get('v.pageNumber');
        var perPageCount = cmp.get('v.perPageCount');
        var indexOfPage = event.getSource().get('v.value');
        var listOfProdToDisp = [];
        var orglPgNo = pageNumber;
        console.log('index Of Page: ', indexOfPage);

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

        if(Math.ceil((responseFromSearchResult.length)/perPageCount)!= (pageNumber-1)){

            var indexStart = (pageNumber - 1)*perPageCount;
            var indexEnd;

            if(((responseFromSearchResult.length) % perPageCount) == 0) {
                indexEnd = ((pageNumber)*perPageCount);
            } else {
                indexEnd = ((Math.ceil((responseFromSearchResult.length)/perPageCount)) == pageNumber) ? (((pageNumber-1)*perPageCount) +(responseFromSearchResult.length)%(perPageCount)) : (perPageCount*pageNumber);
            }

            for(var i=indexStart;i<indexEnd;i++) {
                listOfProdToDisp.push(responseFromSearchResult[i]);
            }

            cmp.set('v.disableNext',false);
            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.displayProdList',listOfProdToDisp);
            helper.stopSpinner(cmp);
            helper.moveToTop(300);
        } else {
            pageNumber = orglPgNo;
            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.disableNext',true);
            helper.stopSpinner(cmp);
            helper.moveToTop(300);
        }
        } catch(ex) {
            helper.stopSpinner(cmp);
            helper.moveToTop(300);
        }

    },

    openSkuDetailPage : function(cmp,event,helper) {
        debugger;

        var responseFromSearchResult = cmp.get('v.responseFromSearchResult');
        var indexOfProduct = event.currentTarget.name;
        var listOfSelectedProducts =  [];
        var displayProdList = cmp.get('v.displayProdList');

        if(displayProdList[indexOfProduct])
            listOfSelectedProducts.push(displayProdList[indexOfProduct]); 

        cmp.set('v.listOfSelectedProducts',listOfSelectedProducts);
        console.log('ON SKU CLICK-> listOfSelectedProducts: ', listOfSelectedProducts);
        var profileName = cmp.get('v.profileName');
        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProdListCaptureEvt");
        appEvent.setParams({ "quantity" : listOfSelectedProducts.length ,"profile" : profileName});
        appEvent.fire();

        helper.goToCreateOrderDetailPageHelper(cmp,event,helper);

    },

    sortByOrder : function(cmp,event,helper) {
		debugger;
        try{
        helper.startSpinner(cmp);
        var responseFromSearchResult = cmp.get('v.responseFromSearchResult');
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var displayProdList = cmp.get('v.displayProdList');
        var sortOn =  createOrderWrapper.sortByName.split('-');
        var sortBy = false;
        if(sortOn[0] === 'N') {
           sortBy = sortOn[1] === 'A' ? true : false;
        } else if (sortOn[0] === 'C') {
           sortBy = sortOn[1] === 'A' ? true : false;
        }

        responseFromSearchResult.sort(function(a,b){
            //Logic
            if(sortOn[0] === 'N') {
                if(sortBy)
                    return (a.Description > b.Description) ? 1 : -1;
                else
                    return (a.Description > b.Description) ? -1 : 1;

            } else {
                if(sortBy)
                    return (a.Product_Color__r.Name > b.Product_Color__r.Name) ? 1 : -1;
                else
                    return (a.Product_Color__r.Name > b.Product_Color__r.Name) ? -1 : 1;
            }

        });
        
        helper.moveToTop(300);
        cmp.set('v.responseFromSearchResult',responseFromSearchResult);
        var displaysort = [];
        for(var i = 0; i<10; i++){
                displaysort.push(responseFromSearchResult[i]);
        }
        cmp.set('v.displayProdList',displaysort);
        helper.stopSpinner(cmp);
        } catch(ex) {
            helper.stopSpinner(cmp);
            helper.moveToTop(300);
        }
    },

    handleDisplayQuantityChange : function(cmp,event,helper) {
        var responseFromSearchResult = cmp.get('v.responseFromSearchResult');
        var skuList = [];
        var perPageCount = cmp.get('v.perPageCount');

        if(responseFromSearchResult && responseFromSearchResult.length > 0 ) {
            for(var i=0;i<responseFromSearchResult.length;i++) {
                if(i<perPageCount){
                    skuList.push(responseFromSearchResult[i]);
                }
            }

            var pgNb = Math.ceil((responseFromSearchResult.length) / perPageCount) ;
            var totalPages = (responseFromSearchResult.length > perPageCount) ? pgNb :  1 ;
            cmp.set('v.pageNumber', 1);
            cmp.set('v.totalPages', totalPages);
            cmp.set('v.displayProdList',skuList);
            if( totalPages === 1 )
                cmp.set('v.disableNext', true);
            else
                cmp.set('v.disableNext', false);
        }
    },

})