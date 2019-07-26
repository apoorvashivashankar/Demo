/**
 * Created by 7Summits on 4/11/18.
 */
({
    getPriceBookLink: function(cmp){
        var self = this;

        // get the 'CommunityShared' custom settings
        var themeSettings = this.getThemeSettings(cmp, 'CommunityShared');

        Promise.all([themeSettings]).then(function(values) {
            self.handleInitStatementsSuccess(cmp, values[0].results, values[1]);
        }, function(response){
            console.log('Dal_SSC_PriceBook:getPricebook:Error:', response);
        });
    },
    handleInitStatementsSuccess: function(cmp, themeSettings) {
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        var visualForceBaseUrl = settings.visualForceUrl__c || '';

        var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
        var priceBookUrl = baseCommunityUrl + '/Dal_Pricebook';
        window.open(priceBookUrl, '_blank');
    }
})