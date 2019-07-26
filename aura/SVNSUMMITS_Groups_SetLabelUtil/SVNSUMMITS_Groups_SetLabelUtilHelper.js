/**
 * Created by joecallin on 6/11/17.
 */
({
    setLabel: function (component) {
        var labelRegex = /^\$Label\.([a-zA-Z0-9_]*\.){1}([a-zA-Z0-9_]+)$/;
        var text = component.get('v.text');

        if (text !== undefined && text !== '') {
            if (text.indexOf('$Label') !== -1) {
                var label = '';

                if (labelRegex.test(text)) {
                    label = $A.getReference(text);
                } else {
                    label = 'This is an invalid label. Please check it.'
                }
                component.set('v.label', label);


            } else {
                component.set('v.label', text);
            }
        } else {
            component.set('v.label', text);
        }
    }
})