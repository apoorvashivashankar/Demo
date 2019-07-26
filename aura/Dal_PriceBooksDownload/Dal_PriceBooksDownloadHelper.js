({
	downloadDB : function(component, event, helper) {
         var self = this;

        // get the 'CommunityShared' custom settings
        var themeSettings = this.getThemeSettings(component, 'CommunityShared');

        Promise.all([themeSettings]).then(function(values) {
            self.handleInitStatementsSuccess(component, values[0].results, values[1]);
        }, function(response){
            console.log('Dal_SSC_PriceBook:getPricebook:Error:', response);
        });
	},
    handleInitStatementsSuccess: function(cmp, themeSettings) {
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        var visualForceBaseUrl = settings.visualForceUrl__c || '';

        var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
        var priceBookUrl = baseCommunityUrl + '/Dal_Pricebook?brandName='+cmp.find("selectedBrand").get("v.value");
        if( $A.get("$Browser.isIPhone") || $A.get("$Browser.isTablet"))
        	window.location.assign(priceBookUrl, '_blank');
        else
            window.open(priceBookUrl, '_blank');

    }

})