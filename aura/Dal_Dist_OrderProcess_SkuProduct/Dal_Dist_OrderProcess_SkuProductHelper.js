/**
 * Created by 7Summits on 3/7/18.
 */
({

    // callback function passed to the window listener, need to keep
    // a reference to it so we can remove it.
    handleScrollCallback: null,

    /**
     * When the store updates we want to get the new data from the store and update
     * our local attributes to cause a rerender. This function will be called on init
     * as well as on rerender.
     */
    handleStoreUpdate: function(cmp){
        var store = cmp.get('v.store');
        console.log('handleStoreUpdate::', JSON.parse(JSON.stringify(store.getCartProducts())), JSON.parse(JSON.stringify(store.getShippingInfo())), JSON.parse(JSON.stringify(store.getOrderInfo())));

        // get products
        var products = store.getCartProducts();

        // check if all products have valid data or not
        var allProductsHaveValidATP = store.hasValidProducts();

        // check if a atp call is in progress
        var isAtpLoading = false;
        var isPriceBySkuLoading = false;
        for(var x=0; x < products.length; x++){
            var product = products[x];

            // check if any of the products are loading atp data
            if(product.isAtpLoading === true){
                isAtpLoading = true;
            }

            // check if any of the products are loading price by sku
            if(product.isPriceBySkuLoading === true){
                isPriceBySkuLoading = true;
            }
        }

        // set view attributes
        cmp.set('v.cartProducts', products);
        cmp.set('v.isAtpLoading', isAtpLoading);
        cmp.set('v.isPriceBySkuLoading', isPriceBySkuLoading);
        cmp.set('v.allProductsHaveValidATP', allProductsHaveValidATP);
        cmp.set('v.orderDefaults', store.getDefaults());
        cmp.set('v.isLoadingDefaultPriceRecords', store.getLoadingDefaultPriceRecords());

        // get total order cost
        var orderTotal = $A.localizationService.formatCurrency(store.getOrderTotal());
        cmp.set('v.orderTotal', orderTotal);

        // get total order weight
        var orderWeight = $A.localizationService.formatNumber(store.getOrderWeight());
        cmp.set('v.orderWeight', orderWeight);
    },

    saveOrder: function(cmp, evt){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var poNumber = evt.getParam('poNumber');
        var jobName = evt.getParam('jobName');

        // close the modal
        baseHelper.closeModal(cmp);

        // show loading
        cmp.set('v.isSaving', true);

        // update the poNumber and jobName to the store
        store.updateOrderInfoToStore({
            poNumber: poNumber,
            jobName: jobName
        });

        // save the order to the server
        var promise = store.saveOrder();
        promise.then(function(){
            var savedOrdersUrl = cmp.get('v.savedOrdersUrl');
            baseHelper.doGotoURL(savedOrdersUrl);
        }, function(response){
            // handle error logic if needed
            console.log('Dal_Dist_OrderProcess_SkuProduct:save:error', response);
            cmp.set('v.isSaving', false);
            baseHelper.showMessage('Error', 'Unable to Save Order.');
        });

    },

    saveContinueOrder: function(cmp){
        var store = cmp.get('v.store');

        cmp.set('v.isSaving', true);
		
        
        // save the order to the server
        var promise = store.saveContinueSku();

        promise.then(function(){
            // no need to handle success, will go to detail page upon success
        }, function(response){
            console.log('Dal_Dist_OrderProcess_SkuProduct:saveContinue:error', response);
            var baseHelper = store.getHelper();
            cmp.set('v.isSaving', false);
            baseHelper.showMessage('Error', 'Unable to Save Order.');
        });
    },

    /**
     * Initialize the sticky nav callback function. We need to create and
     * store a reference to is so we can remove it successfully when it
     * is no longer needed.
     */
    initStickyFooter: function(){
        var saveButtonsTop = document.getElementById('btnSaveContinue');
        var stickySaveFooter = document.getElementById('stickySaveFooter');
        this.handleScrollCallback = this.helpers.handleScroll.bind(this.helpers, saveButtonsTop, stickySaveFooter);
    },

    /**
     * Called on component rerender, will look at the isActive attribute
     * that is passed in from the tabs to determine if this tab is visible
     * or not. If it is set the sticky nav check on scroll, if not remove.
     * @param cmp
     */
    setStickyFooter: function(cmp){
        // if the tab is active we want to set the listener to watch the scroll
        // event to see if the sticky header should be visible
        if(cmp.get('v.isActive') === true){
            window.addEventListener('scroll', this.handleScrollCallback);
        } else {
            window.removeEventListener('scroll', this.handleScrollCallback);
        }
    },

    // internal helpers
    helpers: {

        // Used in the handleScroll which fires when the user scrolls, so in order
        // to only execute functionality at a certain time we want to keep track
        // of the current showing sticky nav state.
        showingStickyNav: false,

        /**
         * Called on window.scroll to determine if we should show or not show
         * the sticky navigation.
         * @param saveButtonsTop
         * @param stickySaveFooter
         */
        handleScroll: function(saveButtonsTop, stickySaveFooter){
            // we only want to fire the add/remove class functions if we are changing
            // from a show to hide or from a hide to show state. If the state is the
            // the same do nothing, relax.
            if(this.showingStickyNav !== this.showStickyNav(saveButtonsTop)){
                if (this.showStickyNav(saveButtonsTop)) {
                    stickySaveFooter.classList.add('active');
                    this.showingStickyNav = true;
                } else {
                    stickySaveFooter.classList.remove('active');
                    this.showingStickyNav = false;
                }
            }
        },

        /**
         * Given a dom element will return whether or not
         * we should show the sticky nav
         * @param el
         * @returns {boolean}
         */
        showStickyNav: function(el){
            var bounding = el.getBoundingClientRect();
            var elHeight = el.clientHeight;
            return bounding.top < -(elHeight);
        }

    }, // end helpers
    
    isFormValid: function(cmp){

        // fields to validate
        var fieldsToValidate = ['defaultShippingDate'];

        // call the validation helper
        return baseHelper.validateForm(cmp, null, fieldsToValidate, true);
    }

})