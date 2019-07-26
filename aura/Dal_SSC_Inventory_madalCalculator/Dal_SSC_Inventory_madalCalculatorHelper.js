/**
 * Created by ranja on 11-12-2018.
 */
({
    setToBlank : function(cmp, event, helper) {
        cmp.set('v.cartonCount','');
        cmp.set('v.eachCount','');
        cmp.set('v.sqFtCount','');
        cmp.set('v.pieceCount','');
        cmp.set('v.palletCount','');
        cmp.set('v.sqMtCount','');
        cmp.set('v.linearCount','');
        cmp.set('v.shCount', '');
    },

    handleCalculateHelper : function(cmp,event,helper){
        debugger;

        var materialId = cmp.get('v.materialId');
        var selectedUOM = cmp.get('v.selectedUOM');
        var selectedQuantity = cmp.get('v.selectedQuantity');
        var listOfUOM = cmp.get('v.listOfUOM');

        cmp.set('v.showSpinner',true);

        if(!selectedUOM)
            selectedUOM = listOfUOM[0];

        try{

         var params = {
            Material : materialId ,
            ToUOM : selectedUOM ,
            Quantity : selectedQuantity
         };

         var promise = helper.doCallout(cmp, 'c.getConversionCalculation', params);
         promise.then(function(response){

            // make sure we have a valid response
            if(response !== undefined && Array.isArray(response)){
                console.log('Resp from Calc: ', response);

                for(var i=0;i<response.length;i++) {
                    if(response[i].ToUOM == 'CT')
                        cmp.set('v.cartonCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'EA')
                        cmp.set('v.eachCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'SF')
                        cmp.set('v.sqFtCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'PC')
                        cmp.set('v.pieceCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'PL')
                        cmp.set('v.palletCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'SM')
                        cmp.set('v.sqMtCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'LF')
                        cmp.set('v.linearCount',response[i].ConvertedQty);
                    else if(response[i].ToUOM == 'SH')
                        cmp.set('v.shCount',response[i].ConvertedQty);

                }
            }
            cmp.set('v.showSpinner',false);

         }, function(response){
            // handle error state
            //helper.showtoast('This Product is presently not available at any Location.  Please select another Product.','error');
             cmp.set('v.showSpinner',false);
            console.log('searchProducts:fail:', response);

         });
         } catch(ex){
             cmp.set('v.showSpinner',false);
         }

    },

})