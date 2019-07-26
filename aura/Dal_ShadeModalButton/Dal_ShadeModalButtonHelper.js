({
    handleShowModal: function (cmp) {
        var overlay = new Promise(function(resolve, reject){
            var contentComponent = cmp.get('v.content');
            var showCloseButton = cmp.get('v.showCloseButton');
            var customClasses = cmp.get('v.customOverlayClasses');

            if(contentComponent !== undefined && contentComponent !== ''){
                $A.createComponent(contentComponent, {}, function(content, status) {
                    if (status === 'SUCCESS') {

                        // create overlay object and open it
                        var overlay = cmp.find('overlayLib').showCustomModal({
                            body: content || '',
                            showCloseButton: showCloseButton || false,
                            cssClass: customClasses || ''
                        }); // end showCustomModal

                        // creating an overlay returns a promise, resolve the promise
                        // by returning the overlay upon success else reject.
                        overlay.then(function(overlay){
                            resolve({
                                overlay: overlay
                            });
                        }, function(){
                            reject();
                        });
                    }

                    // Content body not found, reject
                    else {
                        console.log('Dal_Dist_FormModalBase:Error:Could not find content body.');
                        reject();
                    }// end if
                });
            }

            // Content body not provided, reject
            else {
                console.log('Dal_Dist_FormModalBase:Error:Content body not provided.');
                reject();
            }// end if

        });

        // set reference to the overlay
        cmp.set('v.overlay', overlay);
    }
})