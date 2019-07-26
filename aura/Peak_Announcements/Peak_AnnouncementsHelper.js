({
    /*
        Eventually refactor to extend Peak_Base and use shared doCallout!
     */
    doCallout: function (component, method, params, hideToast) {
        var that = this;
        return new Promise(function (resolve, reject) {
            var action = component.get(method);
            if (params)
                action.setParams(params);

            action.setCallback(component, function (response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message && !hideToast) {
                        that.showMessage("error", errors[0].message);
                    } else if (!hideToast) {
                        that.showMessage("error", "Unknown Error");
                    }
                    reject(errors);
                }
            })
            $A.enqueueAction(action);
        });
    },
    showMessage: function (level, message) {
        console.log("Message (" + level + "): " + message);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": level === "error" ? "Error" : "Message",
            "message": message,
            "type": level
        });
        toastEvent.fire();
    },
    // Get Community Announcements
    getActiveAnnouncements: function (component) {
        var helper = this;
        var queryLimit = component.get("v.numberOfResults");
        var displayChannel = component.get("v.displayChannel");
        var displayType = component.get("v.displayType");
        var hiddenAnnouncements = component.get("v.hiddenAnnouncements");
        var params = {
            "numResultsString": queryLimit,
            "displayChannelString": displayChannel,
            "displayTypeString": displayType,
            "hiddenAnnouncementString": hiddenAnnouncements,
        };
        return new Promise(function (resolve, reject) {
            helper.doCallout(component, "c.getActiveAnnouncements", params, true).then(function (response) {
                if (response) {
                    resolve(response);
                    component.set("v.peakResponse",response);
                    if(response.results.length > 0)
                        component.set("v.isInit", true);
                } else {
                    reject(response);
                }
                console.log('++ response ++', response);
            })
        })
    },
    slickCarousel:function(component) {
        window.setTimeout(
            $A.getCallback(function() {
                jQuery(component.find("carousel").getElement()).slick({
                        dots: true,
                        infinite: true,
                        speed: 300,
                        slidesToShow: 1,
                        slidesToScroll: 1,
                        responsive: [
                            {
                                breakpoint: 640,
                                settings: {
                                    slidesToShow: 1,
                                    infinite: true,
                                    dots: false
                                }
                            }
                        ]
                    });
                }), 500
            );

            // prevent default "pull-to-refresh" behavior when running in S1
            // jQuery(component.find("carousel").getElement()).on("touchmove", function () {
            //     return false;
            // });
    },
    getCookieValues: function(component) {
        var userId = component.get("v.userId");
        var networkId = component.get("v.networkId");
        var name = "announcements"+userId+networkId;
        var announcementCookieValues = (name = (document.cookie + ';').match(new RegExp(name + '=.*;'))) && name[0].split(/=|;/)[1];
        return announcementCookieValues;
    },
    getIdentifyingData: function(component) {
        var helper = this;
        return new Promise(function (resolve, reject) {
            helper.doCallout(component, "c.getNetworkId", null, true).then(function (response) {
                if (response) {
                    resolve(response);
                    component.set("v.networkId",response);
                } else {
                    reject(response);
                }
                //console.log('++ response ++', response);
            });
            helper.doCallout(component, "c.getUserId", null, true).then(function (response) {
                if (response) {
                    resolve(response);
                    component.set("v.userId",response);
                } else {
                    reject(response);
                }
                //console.log('++ response ++', response);
            });
        });
    }
})