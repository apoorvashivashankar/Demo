({
    initPeakContentTile: function(component, event, helper){
        var className = "";
        var centered = component.get("v.centered");
        var darkText = component.get("v.darkText");

        if (centered){
            className+="centered ";
        }

        if (darkText){
            className+="darktext ";
        }

        component.set("v.className",className);
    }
})