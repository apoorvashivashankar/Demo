/**
 * Created by ranja on 04-01-2019.
 */
({
    doInit : function(cmp,event,helper) {
        //debugger;

        //cmp.set('v.showSpinner',true);
        var _displayMilesList = [];
        var milesWrapperList = cmp.get('v.milesWrapperList');
        var startOfList = cmp.get('v.startOfList');
        var pgNb = 1;
		var pageNumber = cmp.get('v.pageNumber') || 1;

        if(milesWrapperList && milesWrapperList.length > 0) {
            var end = (((milesWrapperList.length - startOfList) > 4) ? 4 : milesWrapperList.length );
            for(var i=startOfList;i<parseInt(end);i++) {
                _displayMilesList.push(milesWrapperList[i]);
            }
            pgNb = Math.ceil((milesWrapperList.length) / 4) ;
        }

        var totalPages = (milesWrapperList.length > 4) ? pgNb :  1 ;

        if(totalPages === pageNumber)
            cmp.set('v.disableNext',true);

         cmp.set('v.totalPages',totalPages);
        //cmp.set('v.showSpinner',false);
        cmp.set('v.displayMilesList', _displayMilesList);
        //console.log('_displayMilesList: ', _displayMilesList);
    },

    changeSelectedMiles : function(cmp,event,helper) {
        debugger;
        try{

        cmp.set('v.showSpinner',true);
        var skuIndex = cmp.get('v.indexOfDist');
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        var action = cmp.get("c.getMiles");
        action.setParams({
            sku : finalResponseWrapper[skuIndex].sku,
            UOM : finalResponseWrapper[skuIndex].pricingUOM,
            milesRadius : cmp.get('v.selectedMile')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _resp = response.getReturnValue();
                console.log('_resp: ',_resp);
                var _displayMilesList = [];
                var totalPages = 1;
                var pgNb = 1;
                var pageNumber = 1;
                if(_resp) {

                    if( _resp.length > 0) {
                        var end = (((_resp.length - 0) > 4) ? 4 : _resp.length );
                        for(var i=0;i<parseInt(end);i++) {
                            _displayMilesList.push(_resp[i]);
                        }
                        pgNb = Math.ceil((_resp.length) / 4) ;
                        totalPages = (_resp.length > 4) ? pgNb :  1 ;
                    }
                    if(totalPages === pageNumber)
                        cmp.set('v.disableNext',true);

                    cmp.set('v.milesWrapperList', _resp);
                    cmp.set('v.totalPages',totalPages);
                    cmp.set('v.displayMilesList',_displayMilesList);
                    cmp.set('v.showSpinner',false);
                    cmp.set('v.pageNumber',pageNumber);
                }
            } else {
                cmp.set('v.showSpinner',false);
            }
        });
        $A.enqueueAction(action);

        } catch(ex) {
            cmp.set('v.showSpinner',false);
        }
    },

    handleChangeData : function(cmp,event,helper) {
		debugger;
        cmp.set('v.showSpinner',true);
        var responseWrapperData = cmp.get('v.milesWrapperList');
        var totalPages = cmp.get('v.totalPages');
        var pageNumber = cmp.get('v.pageNumber');
        var indexOfPage = event.getSource().get('v.value');
        var displayMilesList = [];
        var orglPgNo = pageNumber;

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

        if(Math.ceil((responseWrapperData.length)/4)!= (pageNumber-1)){

            var indexStart = (pageNumber - 1)*4;
            var indexEnd;

            if(((responseWrapperData.length) % 4) == 0) {
                indexEnd = ((pageNumber)*4);
            } else {
                indexEnd = ((Math.ceil((responseWrapperData.length)/4)) == pageNumber) ? (((pageNumber-1)*4) +(responseWrapperData.length)%(4)) : (4*pageNumber);
            }

            for(var i=indexStart;i<indexEnd;i++) {
                displayMilesList.push(responseWrapperData[i]);
            }

            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.displayMilesList',displayMilesList);
            window.scrollTo(0, 300);
            cmp.set('v.showSpinner',false);
            
            if(pageNumber === totalPages)
                cmp.set('v.disableNext',true);
            else 
                cmp.set('v.disableNext',false);
            
        } else {
            pageNumber = orglPgNo;
            cmp.set('v.pageNumber',pageNumber);
            cmp.set('v.disableNext',true);
            window.scrollTo(0, 300);
            cmp.set('v.showSpinner',false);
        }
    },

    changeAddress : function(cmp,event,helper) {
         debugger;
        var selected = event.getSource().get("v.text");
        var skuIndex = cmp.get('v.indexOfDist');
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var displayMilesList = cmp.get('v.displayMilesList');
		var pageNumber = cmp.get('v.pageNumber');
        var finalRespIndex = 0;
		var displayIndex = event.getSource().get("v.label");

        finalRespIndex = parseInt(displayIndex) + ((4) * (parseInt(pageNumber) - 1));
        var flag = false;

        //console.log('bef: ',finalResponseWrapper);

        if(selected) {
            finalResponseWrapper[skuIndex].supplyPlant = selected;
            flag = true;
        }

        if(flag && displayMilesList[displayIndex].supplyplantID)
            finalResponseWrapper[skuIndex].supplyPlantId = displayMilesList[displayIndex].supplyplantID;

        if(flag && displayMilesList[displayIndex].availableQty)
            finalResponseWrapper[skuIndex].availableQty = displayMilesList[displayIndex].availableQty;

        if(flag && displayMilesList[displayIndex].totalCartons)
            finalResponseWrapper[skuIndex].totalCartons = displayMilesList[displayIndex].totalCartons;

        finalResponseWrapper[skuIndex].isStoreChanged = true;

        //console.log('aft: ',finalResponseWrapper);
        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
    },

    handleChangeStore : function(cmp,event,helper) {
        cmp.find('overlayLib').notifyClose();
    },

    handleCloseModal : function(cmp,event,helper) {

        var selectedAddressMile = cmp.get('v.selectedAddressMile');
        var skuIndex = cmp.get('v.indexOfDist');
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var prevSupplyPlantId = cmp.get('v.prevSupplyPlantId');
        var isStoreChanged = cmp.get('v.isStoreChanged');
        var availableQty = cmp.get('v.availableQty');
        var totalCartons = cmp.get('v.totalCartons');


        if(selectedAddressMile)
            finalResponseWrapper[skuIndex].supplyPlant = selectedAddressMile;
        if(prevSupplyPlantId)
            finalResponseWrapper[skuIndex].supplyPlantId = prevSupplyPlantId;
        if(availableQty)
            finalResponseWrapper[skuIndex].availableQty = availableQty;
        if(totalCartons)
            finalResponseWrapper[skuIndex].totalCartons = totalCartons;
        if(totalCartons)
            finalResponseWrapper[skuIndex].isStoreChanged = isStoreChanged;

        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
        //cmp.set('v.isStoreChanged', true);

        cmp.find('overlayLib').notifyClose();
    },


})