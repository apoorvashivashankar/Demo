/**
 * Created by michaelsullivan on 6/7/17.
 */
({
    initPeakMyStats: function (component, event, helper) {

        var tile1Query = component.get("v.statQuery");
        var tile2Query = component.get("v.statQuery2");
        var tile3Query = component.get("v.statQuery3");
        var tile4Query = component.get("v.statQuery4");

        if (tile1Query !== "noQuery" && tile1Query !== ''){
            helper.queryManager("v.stat1", tile1Query, component);
        }
        if (tile2Query !== "noQuery" && tile2Query !== ''){
            helper.queryManager("v.stat2", tile2Query, component);
        }
        if (tile3Query !== "noQuery" && tile3Query !== ''){
            helper.queryManager("v.stat3", tile3Query, component);
        }
        if (tile4Query !== "noQuery" && tile4Query !== ''){
            helper.queryManager("v.stat4", tile4Query, component);
        }

        //setting the slds class based on how many stats (1-4) are active in component
        helper.setStatContainerClasses(component);

    }

})