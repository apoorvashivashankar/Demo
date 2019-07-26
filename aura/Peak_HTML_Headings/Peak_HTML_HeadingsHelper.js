/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    getLabel : function(component) {
        var headingText = component.get("v.headingText");
        this.fireLabelUtilEvent(component, headingText, 'headingText');
    },
    buildHeading : function(component) {
        var heading = {};
        var headingTag = component.get("v.headingTag").substring(0,2).toLowerCase();
        var headingAlignment = component.get("v.headingAlignment");
        heading.open = '<' + headingTag + ' class="slds-text-align_' + headingAlignment + '">';
        heading.close = '</' + headingTag + '>';
        component.set('v.heading', heading);
    },
    fireLabelUtilEvent: function (component, text, attribute) {
        var labelUtilEvent = component.getEvent('labelUtilEvent');
        labelUtilEvent.setParams({
            'labelText': text,
            'attribute': attribute
        });
        labelUtilEvent.fire();
    }
})