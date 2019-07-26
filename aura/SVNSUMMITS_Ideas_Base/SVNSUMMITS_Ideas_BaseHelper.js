// Copyright ©2016-2017 7Summits Inc. All rights reserved.
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
					var withoutNamespace  = k.replace(model.namespacePrefix + '__', '');
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

	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				'url': url,
				'isredirect': true
			}).fire();
	},

	gotoRecord: function (component, recordId) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": recordId,
				"slideDevName": "related"
			}).fire();
	},

	showMessage: function (level, title, message) {
		console.log("Message (" + level + "): " + message);

		$A.get("e.force:showToast")
			.setParams({
				"title": title,
				"message": message,
				"type": level
			}).fire();
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