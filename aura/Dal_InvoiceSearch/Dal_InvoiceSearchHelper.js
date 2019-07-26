/**
 * Created by 7Summits on 4/9/18.
 */
({
    getBrandOptions: function(cmp){
        var self = this;

        // set the controller action type
        var actionName = 'c.getBrandlist';

        //var params = {'userType': userType, 'orderType': orderType};
        // make call to controller to get open items
        var promise = self.doCallout(cmp, actionName);

        // set callbacks for callout response
        promise.then(function(response){
            console.log('Brand ',response);
           self.handleGetBrandOptions(cmp, response);
        });
    },
    handleGetBrandOptions: function(cmp, response){
        console.log(response);
        cmp.set('v.brandlist', brandsList);
    }
})