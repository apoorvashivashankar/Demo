// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	sendFilterEvent: function (component) {
		var appEvent = $A.get("e.c:SVNSUMMITS_News_Author_Filter_Event");

		appEvent.setParams({
			"filterByAuthor": component.get('v.selection')
		});
		appEvent.fire();
	},

	getAuthors: function (component) {
		var action = component.get("c.getAuthors");

		action.setCallback(this, function (response) {
			var valuesTemp = [];
			var state = response.getState();

			if (state === 'SUCCESS') {
				var values = response.getReturnValue();

				for (var value in values) {
					if (values.hasOwnProperty(value)) {
						valuesTemp.push({
							key: value,
							value: values[value]
						});
					}
				}
			}

			component.set("v.values", valuesTemp);
		});

		$A.enqueueAction(action);
	},

	initializeAuthorDropdown: function (component) {
		var placeHolder = component.get('v.placeHolderAuthor');

		$(".author").addClass("ui fluid search").dropdown({placeholder: placeHolder});
	}
})