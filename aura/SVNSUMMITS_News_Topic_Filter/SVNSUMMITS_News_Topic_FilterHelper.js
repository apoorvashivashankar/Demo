// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	sendFilterEvent: function (component) {
		var appEvent = $A.get("e.c:SVNSUMMITS_News_Topic_Filter_Event");

		appEvent.setParams({
			"filterByTopic": component.get('v.selection')
		});
		appEvent.fire();
	},

	getTopics: function (component) {
		var action = component.get("c.getTopics");

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

	initializeTopicDropdown: function (component) {
		var placeholder = component.get('v.placeholderTopic');

		$(".topic").addClass("ui fluid search").dropdown({placeholder: placeholder});
	}
})