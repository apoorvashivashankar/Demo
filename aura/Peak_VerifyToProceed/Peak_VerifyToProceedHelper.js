({
    setClassName: function (component) {
        // Start with base class
        var className = component.get("v.contentTileClassname");
        var darkText = component.get("v.darkText");

        // If not using dark text, add the inverse text color scheme
        if (!darkText){
            className += " slds-theme_inverse-text";
        }

        component.set("v.contentTileClassname",className);
    }
})