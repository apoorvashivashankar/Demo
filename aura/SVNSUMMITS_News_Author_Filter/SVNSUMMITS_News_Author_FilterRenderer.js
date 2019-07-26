// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	rerender: function(component, helper) {
        // By default, after the component finished loading data/handling events,
        // it will call this render function this.superRender() will call the
        // render function in the parent component.
        var ret = this.superRerender();
        helper.initializeAuthorDropdown(component);
        return ret;
  }
})