/**
 * Created by 7Summits on 4/4/18.
 */
({
    init: function(cmp){
        this.getMaterialRecords(cmp)
    },
    
    getMaterialRecords: function(cmp){
        var self = this;
        var effectiveDate = cmp.get('v.effectiveDateValue');
        var appliedPromotion = cmp.get('v.appliedPromotion');
        var listLimit = cmp.get("v.listMaximum");

        var params = {
            promotionrecord: appliedPromotion,
            effectiveDate: new Date(effectiveDate),
            listlimit: listLimit
        };

        var promise = this.doListCallout(cmp, 'c.getMaterialRecordsByDate', params);

        promise.then(function(response){
            self.handleGetPriceRecordsSuccess(cmp, response);
        }, function(response){
            console.log('Dal_PricingByMaterialsList:Error:', response);
        });
    },

    searchPromotionList: function(cmp, effectiveDate, appliedPromotion, skuNumber, description){
        var self = this;

        // set the controller action type
        var listLimit = cmp.get("v.listMaximum");

        var params = {
            'effectiveDate': effectiveDate,
            'promotionrecord': appliedPromotion,
            'skuNumber': skuNumber,
            'description': description,
            'listLimit' : listLimit
        };

        var promise = this.doListCallout(cmp, 'c.searchMaterialRecords', params);

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetPriceRecordsSuccess(cmp, response);
        });

    },

    handleGetPriceRecordsSuccess: function(cmp, response) {
        debugger;
        var communityType = cmp.get("v.communityType");
        if(communityType == 'Distributor'){
            cmp.set('v.columns', [
                {label: 'SKU #', fieldName: 'PriceRecordCode__c', type: 'text', sortable: true},
                {label: 'DESCRIPTION', fieldName: 'PriceRecordDescription__c', type: 'text', sortable: true},
                {label: 'PRICE', fieldName: 'price', type: 'text', sortable: true},
                {label: 'SOURCE OF SUPPLY', fieldName: 'supplyPlant', type: 'text', sortable: true},
                {label: 'Start Date', fieldName: 'ValidFrom__c', type: 'date', sortable: true},
                {label: 'End Date', fieldName: 'ValidTo__c', type: 'date', sortable: true}
            ]);
        } else {
            cmp.set('v.columns', [
                {label: 'SKU #', fieldName: 'PriceRecordCode__c', type: 'text', sortable: true},
                {label: 'DESCRIPTION', fieldName: 'PriceRecordDescription__c', type: 'text', sortable: true},
                {label: 'PRICE', fieldName: 'price', type: 'text', sortable: true},
                {label: 'Start Date', fieldName: 'ValidFrom__c', type: 'date', sortable: true},
                {label: 'End Date', fieldName: 'ValidTo__c', type: 'date', sortable: true}
            ]);
        }

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                rowData.push({
                    id: index,
                    PriceRecordCode__c: item.Material__c,
                    PriceRecordDescription__c: item.MaterialDesc__c,
                    ValidFrom__c: new Date(item.NetPriceEffectiveDateFrom__c) || '',
                    price: '$' +item.NetPriceRate__c + ' / ' +item.NetPriceQuantityUOM__c,
                    supplyPlant: item.PlantCategory__c,
                    ValidTo__c: new Date(item.NetPriceEffectiveDateTo__c) || ''
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);

        this.initTable(cmp);
    },

})