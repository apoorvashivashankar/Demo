/**
 * Created by francoiskorb on 12/27/17.
 */
({
	getSitePath: function(component) {
		var action = component.get("c.getDomain");

		action.setCallback(this, function(actionResult) {
			var state = actionResult.getState();

			if (state === 'SUCCESS') {
				var domain = actionResult.getReturnValue();
				component.set("v.sitePath", domain);
			}
		});

		$A.enqueueAction(action);
	},

	getSiteNamespace: function(component){
		var nameSpace = '';

		var ns    = component.getConcreteComponent().getType();
		var parts = ns.split(':');
		nameSpace = parts ? parts[0] + '__' : '';

		component.set('v.nameSpace', nameSpace);
	}
})