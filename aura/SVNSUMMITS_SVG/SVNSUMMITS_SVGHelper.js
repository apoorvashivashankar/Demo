// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
  renderIcon: function(component) {
    var prefix = "slds-";
    var svgns = "http://www.w3.org/2000/svg";
    var xlinkns = "http://www.w3.org/1999/xlink";
    var size = component.get("v.size");
    var name = component.get("v.name");
    var classname = component.get("v.class");
    var category = component.get("v.category");

    var containerClassName = [
        prefix+"icon__container",
        prefix+"icon-"+category+"-"+name,
        classname
        ].join(' ');
    var iconClassName = prefix+"icon "+prefix+"icon--" + size;
    component.set("v.containerClass", containerClassName);

    var svgroot = document.createElementNS(svgns, "svg");
    svgroot.setAttribute("aria-hidden", "true");
    svgroot.setAttribute("class", iconClassName);
    svgroot.setAttribute("name", name);
	
    var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePrefix", sitePath.replace("/s",""));
            
            // Add an "href" attribute (using the "xlink" namespace)
            var shape = document.createElementNS(svgns, "use");
            shape.setAttributeNS(xlinkns, "href", component.get("v.sitePrefix")+component.get("v.svgPath"));
            svgroot.appendChild(shape);
        
            var container = component.find("container").getElement();
            container.insertBefore(svgroot, container.firstChild);
            
		});
        $A.enqueueAction(action);
      
      
  }
})