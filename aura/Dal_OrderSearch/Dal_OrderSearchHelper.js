/**
 * Created by 7Summits on 4/9/18.
 */
({
    getIndexFrmParent : function(target,helper,attributeToFind){
    	//User can click on any child element, so traverse till intended parent found
    	var SelIndex = target.getAttribute(attributeToFind);
    	while(!SelIndex){
        	target = target.parentNode ;
       	 	SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);           
    	}
    	return SelIndex;
	},
    
    getLineStatusOptions: function(cmp, userType, orderType){
        var self = this;

        var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

        cmp.set('v.orderDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        cmp.set('v.orderDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

        // set the controller action type
        var actionName = 'c.getLineStatuses';

        var params = {'userType': userType, 'orderType': orderType};
        // make call to controller to get open items
        var promise = self.doCallout(cmp, actionName, params);

        // set callbacks for callout response
        promise.then(function(response){
            console.log('Line Status: ',response);
           self.handleGetStatusOptions(cmp, response);
        });
    },
    handleGetStatusOptions: function(cmp, response){
        console.log(response);
    //    cmp.set('v.lineStatuses', response);

        var custResp = {};
            custResp = response;
            for(var i=0;i<custResp.length;i++) {
            custResp[i].isChecked = false;
            }
        cmp.set('v.lineStatuses', custResp);
        //console.log("LineStatuses in Init" + cmp.get("v.lineStatuses").toString());
        //
  /*      var statuses=[];
        response.forEach(function(element) {
            console.log(element.value);
            statuses.push(element.value);
          });
        cmp.set("v.orderStatus", statuses.toString());
        console.log("In helper Class:"+statuses.toString());
        this.searchOrders(cmp,null,this);
*/
    },
    searchOrders : function(component, event, helper) {
        debugger;
	console.log('In SearchOrders');
       var listComponent = component.find("orderListComponent");

      var userType = component.get("v.communityType");
      var orderListType = component.get("v.listType");
       var orderNumber = component.get("v.orderNumber");
       var poNumber = component.get("v.poNumber");
       var jobName = component.get("v.jobName"); 
       console.log('dates in search controller before '+component.get("v.orderDateEnd")+'--'+component.get("v.orderDateStart"));
             
       var orderDateStart = component.get("v.orderDateStart");
       var orderDateEnd = component.get("v.orderDateEnd");
       var orderStatus = component.get("v.orderStatus");       
       console.log('dates in search controller after '+orderDateStart+'--'+orderDateEnd);
        console.log('orderStatus:'+orderStatus);
        listComponent.searchOrderList(userType, orderListType, orderNumber, poNumber, jobName, orderDateStart, orderDateEnd, orderStatus);
    }
})