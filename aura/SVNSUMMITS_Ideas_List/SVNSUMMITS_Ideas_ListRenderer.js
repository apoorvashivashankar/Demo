// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    rerender: function(component, helper) {
        // By default, after the component finished loading data/handling events,
        // it will call this render function this.superRender() will call the
        // render function in the parent component.
        var ret = this.superRerender();

        // Calls the helper function to append the SVG icon
        if (component.get("v.displayMode") === 'Full') {
            helper.initializeDropdown(component);
        }

        return ret;
    }
})