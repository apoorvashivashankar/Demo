// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	afterRender: function (component, helper) {
		this.superAfterRender();

		window.setTimeout(
			$A.getCallback(function () {
				if (component.isValid())
					helper.initializeCarousel(component);

			}),
			500);
	}
})