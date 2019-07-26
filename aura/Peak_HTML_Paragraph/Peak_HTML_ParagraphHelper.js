/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    getLabel : function(component) {
        var paragraphText = component.get("v.paragraphText");
        this.fireLabelUtilEvent(component, paragraphText, 'paragraphText');
    },
    buildParagraph : function(component) {
        var paragraph = {};
        var paragraphType = component.get('v.paragraphType');
        var isLead = paragraphType.match(/lead/i);
        if (isLead) {
            paragraph.open = '<p class="lead-paragraph">';
        }else{
            paragraph.open = '<p>';
        }
        paragraph.close = '</p>';
        component.set('v.paragraph', paragraph);
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