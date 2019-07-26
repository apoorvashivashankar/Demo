/**
 * Created by brianpoulsen on 3/20/17.
 */
({
	buildAnchor : function(component) {

        var anchorName = component.get("v.anchorName");

        function makeAnchor(text) {

            var anchor = document.createElement('a');

            anchor.setAttribute("name", text);
            anchor.setAttribute("id", text);

            return anchor.outerHTML;
        }

        component.set("v.anchor", makeAnchor(anchorName));
	}
})