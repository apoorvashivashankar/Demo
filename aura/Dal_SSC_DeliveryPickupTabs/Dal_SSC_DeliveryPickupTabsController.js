({
	doInit : function(component, event, helper) {
		helper.doCallout(component,"c.getPickupDashboardCounts",null).then(function(response){
			component.set("v.pickupDeliveryCount", response[0]);
			component.set("v.scheduledPickupCount", response[1]);
			component.set("v.scheduledDeliveryCount", response[2]);
        }).catch(function(error){
            console.log('delivery pickup error',error);
            $A.reportError("error message here", error);
        });
	}
})