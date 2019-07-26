/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    buildList : function(component) {

        var listType = component.get('v.listType');
        var object = [];

        for(var i = 1; i <= 10; i++){
            var listItem = component.get('v.listItem' + i);
            if (listItem) {
                object.push(listItem);
            }
        }
        if(listType.match(/numbered/i)){
            component.set('v.listType', 'ordered');
        }else{
            component.set('v.listType', 'unordered');
        }
        component.set('v.itemList', object);
    }
})