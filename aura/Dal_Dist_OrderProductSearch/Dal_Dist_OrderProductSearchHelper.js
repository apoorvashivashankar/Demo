/**
 * Created by 7Summits on 5/1/18.
 */
({

    doSearch: function(cmp){
        var self = this;
        var searchMinLength = cmp.get('v.searchMinLength');
        var searchValue = cmp.get('v.searchValue');

        if(searchValue.length >= searchMinLength){
            cmp.set('v.isSearching', true);
            cmp.set('v.hasSearched', true);
            cmp.set('v.hasSearchLengthError', false);

            var params = {
                searchParameter: searchValue
            };

            var promise = this.doCallout(cmp, 'c.searchProducts', params);

            promise.then(function(response){

                console.log('searchResultsResponse', response);

                // make sure we have a valid response
                if(response !== undefined && Array.isArray(response)){
                    cmp.set('v.searchResults', response);
                }

                // set loading state
                cmp.set('v.isSearching', false);
                cmp.set('v.hasSearchError', false);
            }, function(response){
                // handle error state
                console.log('searchProducts:fail:', response);
                cmp.set('v.searchResults', []);
                cmp.set('v.hasSearchError', true);
                cmp.set('v.isSearching', false);
            });
        }

        // search string didn't meet min length requirement
        else {
            cmp.set('v.hasSearchLengthError', true);
            cmp.set('v.searchResults', []);
        }

    },

    addToOrder: function(cmp, productIndex){
        var searchResults = cmp.get('v.searchResults');

        // make sure we have a valid index
        if(productIndex !== undefined && searchResults[productIndex] !== undefined){
            var store = cmp.get('v.store');
            var hasSelectedProductForCartId = cmp.get('v.hasSelectedProductForCartId');

            // update view
            searchResults[productIndex].added = true;
            cmp.set('v.searchResults', searchResults);

            // check if we added the selected product to the cartId where the actual search was
            // initiated. If we have added a product to that cartId just add every other product
            // to the end of the product list.

            var cartId = cmp.get('v.cartId');

            if(hasSelectedProductForCartId === false){

                // if cartId is undefined set it to 0
                cartId = (cartId !== undefined) ? cartId : 0;

                store.addProductFromSearchResultByCartId(cartId, searchResults[productIndex]);
                cartId++;
                cmp.set('v.cartId',cartId);
                cmp.set('v.hasSelectedProductForCartId', true);
            } else {

                store.addProductFromSearchResultByCartId(cartId, searchResults[productIndex]);
                cartId++;
                cmp.set('v.cartId',cartId);
                //store.addProductFromSearchResult(searchResults[productIndex]);
            }

        }

    },

    checkForResultsAlreadyInCart: function(cmp){
        var searchResults = cmp.get('v.searchResults');
        var store = cmp.get('v.store');
        var cartProducts = store.getCartProducts();

        // add all the cartProduct skus to a map
        var cartProductSkus = {};
        cartProducts.forEach(function(product){
            if(product.sku !== undefined){
                cartProductSkus[product.sku] = product.sku;
            }
        });

        // iterate through the search results and see if we find a match, if so set it to added
        searchResults.forEach(function(result){
            result.added = (result.DW_ID__c !== undefined && cartProductSkus.hasOwnProperty(result.DW_ID__c));
        });

        cmp.set('v.searchResults', searchResults);
    }


})