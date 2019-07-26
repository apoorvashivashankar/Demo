/**
 * Created by ranja on 13-11-2018.
 */
({
      doInit: function(cmp,event,helper) {
      //   debugger;

         cmp.set('v.isInventoryBaseLoading',true);
         cmp.set('v.isPageLoading',true);
         helper.getSeries(cmp,event,helper);
      },

      getColors : function (cmp, event, helper) {
      //   debugger;

         var serId = cmp.find('series').get('v.value');

         if(serId) {
             helper.getAllProductsOfSeries(cmp,serId);
         } else {
             cmp.set('v.listOfColors',[]);
         }
     },

     searchProductsByFilters : function(cmp,event,helper) {
     //   debugger;

        var isSeriesNotSelected = cmp.get('v.isSeriesNotSelected');
        var isColorNotSelected = cmp.get('v.isColorNotSelected');
        if(!isSeriesNotSelected && !isColorNotSelected)
            helper.getSearchedProductBySku(cmp,event,helper);

     },

     checkSeriesSelected : function (cmp, event, helper) {
         var selectedProduct = cmp.get('v.selectedColor');
         var selectedSeries = cmp.get('v.selectedSeries');

         if(!selectedSeries) {
             cmp.set('v.isSeriesNotSelected',true);
         } else {
             cmp.set('v.isSeriesNotSelected',false);
         }

     },

     checkProductSelected : function (cmp, event, helper) {
         var selectedProduct = cmp.get('v.selectedColor');
         var selectedSeries = cmp.get('v.selectedSeries');
         if(!selectedSeries) {
             cmp.set('v.isSeriesNotSelected',true);
         } else {
             cmp.set('v.isSeriesNotSelected',false);
         }
         if(!selectedProduct) {
             cmp.set('v.isColorNotSelected',true);
         } else {
             cmp.set('v.isColorNotSelected',false);
         }
     },

     onCheck : function(cmp,event,helper) {
     //    debugger;

        var responseWrapperData = cmp.get('v.responseWrapperData');
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts') || [];
        var indexOfProduct = event.getSource().get('v.value');

        if(responseWrapperData[indexOfProduct]) {
            if(responseWrapperData[indexOfProduct].isChecked)
                responseWrapperData[indexOfProduct].isChecked = false;
            else
                responseWrapperData[indexOfProduct].isChecked = true;

            if(responseWrapperData[indexOfProduct].isChecked) {
                listOfSelectedProducts.push(responseWrapperData[indexOfProduct]);
            } else {
                for(var i=0;i<listOfSelectedProducts.length;i++) {
                    if(listOfSelectedProducts[i] === responseWrapperData[indexOfProduct])
                        listOfSelectedProducts.splice(i,1);
                }
            }

            cmp.set('v.responseWrapperData',responseWrapperData);
            cmp.set('v.listOfSelectedProducts', listOfSelectedProducts);
            cmp.set('v.count', listOfSelectedProducts.length);
         }
     },

     navigateToNextPage : function(cmp,event,helper) {
     //   debugger;

        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
        var listOfWrapperData = [];

        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate()+1);
        var _newDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth()+1) + '-' + tomorrow.getDate() ;

        if(listOfSelectedProducts.length > 0) {
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
        }

        console.log('Navigation Params', listOfWrapperData);
        helper.getExternalData(cmp,event,helper,listOfWrapperData);

     }
})