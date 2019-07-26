// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 2/3/17.
 */
({
	parseNamespace: function (component, obj) {
		var self = this;
		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			for (var k in obj) {
				if (typeof obj[k] == "object" && obj[k] !== null) {
					self.parseNamespace(component, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					var withoutNamespace = k.replace(model.namespacePrefix + '__', '');
					obj[withoutNamespace] = obj[k];
				}
			}
		}
		return obj;
	},

	setNamespace: function (component, obj) {
		var self = this;
		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			for (var k in obj) {
				if (typeof obj[k] == "object" && obj[k] !== null) {
					self.setNamespace(component, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					var withoutNamespace = k.replace(model.namespacePrefix + '__', '');
					if (obj[withoutNamespace]) {
						obj[k] = obj[withoutNamespace];
						delete obj[withoutNamespace];
					}
				} else if (k.indexOf('__c') >= 0) {
					obj[model.namespacePrefix + '__' + k] = obj[k];
					delete obj[k];
				}
			}
		}
		return obj;
	},

	getNameSpacePrefix : function (component) {
		var nameSpace = '';

		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			nameSpace = model.namespacePrefix + '__';
		}
		return nameSpace;
	},

	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				'url': url,
				'isredirect': true
			}).fire();
	},

	goToRecord: function (component, recordId) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": recordId,
				"slideDevName": "related"
			}).fire();
	},

	showMessage: function (level, message) {
		console.log("Message (" + level + "): " + message);
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": level === "error" ? "Error" : "Message",
			"message": message,
			"type": level
		});
		toastEvent.fire();
	},

	debug: function (component, msg, variable) {
		if (component.get("v.debugMode")) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
})