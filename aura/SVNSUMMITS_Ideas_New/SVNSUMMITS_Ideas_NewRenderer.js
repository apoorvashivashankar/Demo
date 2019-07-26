// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 10/10/16.
 */
({

	afterRender: function (component, helper) {
		this.superAfterRender();

		var cmpSpinner = component.find("spinner");
		$A.util.addClass(cmpSpinner, "hide");

		var cmpSpinnerSubmit = component.find("spinnerSubmit");
		$A.util.addClass(cmpSpinnerSubmit, "hide");
	}
})