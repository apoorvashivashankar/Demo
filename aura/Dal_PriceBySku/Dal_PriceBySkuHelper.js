/**
 * Created by 7Summits on 5/1/18.
 */
({
    init: function(cmp){
        var promise = this.initPriceBySku(cmp);

        // waiting for the store to init and then setting store again
        // which causes a component reRender, will the current store values
        promise.then(function(response){
            cmp.set('v.store', response);
        });
    }
})