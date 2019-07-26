// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	rerender: function(component, helper) {
        var ret = this.superRerender();
        helper.initializeSlider(component);
        return ret;
  }
})