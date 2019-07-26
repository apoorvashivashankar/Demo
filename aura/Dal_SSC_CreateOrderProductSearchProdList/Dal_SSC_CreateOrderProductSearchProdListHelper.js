/**
 * Created by ranja on 12-01-2019.
 */
({
    doPaginationOnLoad : function(cmp,event,helper) {

        var responseFromSearchResult = cmp.get('v.responseFromSearchResult');
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts') || [];
        //var totalPages = cmp.get('v.totalPages');
        var pageNumber = cmp.get('v.pageNumber');
        var indexOfProduct = event.getSource().get('v.value');
        var displayProdList = cmp.get('v.displayProdList');
        var perPageCount = cmp.get('v.perPageCount');

        var indexForTotal = (pageNumber > 1) ? (((pageNumber-1) * perPageCount) + indexOfProduct) : indexOfProduct;

        if(displayProdList[indexOfProduct]) {

            if(displayProdList[indexOfProduct].isChecked) {
                listOfSelectedProducts.push(displayProdList[indexOfProduct]);
            } else {
                for(var i=0;i<listOfSelectedProducts.length;i++) {
                    if(listOfSelectedProducts[i] === displayProdList[indexOfProduct])
                        listOfSelectedProducts.splice(i,1);
                }
            }

            cmp.set('v.responseFromSearchResult',responseFromSearchResult);
            cmp.set('v.displayProdList',displayProdList);
            cmp.set('v.listOfSelectedProducts', listOfSelectedProducts);
            cmp.set('v.count', listOfSelectedProducts.length);

        }
    }
})