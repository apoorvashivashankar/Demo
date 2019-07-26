// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    
	rerender: function() {
    	// By default, after the component finished loading data/handling events,
    	// it will call this render function this.superRender() will call the
    	// render function in the parent component.
    	var ret = this.superRerender();
        
        //Commented to resolve the java script Error of Renderer/afterRender
    	//svg4everybody();
        
        return ret;
    }
})