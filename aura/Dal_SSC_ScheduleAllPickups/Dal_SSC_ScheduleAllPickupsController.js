/**
 * Created by 7Summits on 4/26/18.
 */
({

    doAllPickupInit:function(cmp, evt, helper){
        debugger;
        helper.handleStoreUpdate(cmp);

        var store = cmp.get('v.store');

        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');

        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

        if(selectedProductType == 'reschedule') {
            cmp.set("v.isReschedule",true);
        } else {
            cmp.set("v.isReschedule",false);
        }
        cmp.set('v.pickupPhone','');
        if(selectedProductType == 'multiple') {
            cmp.set('v.isMultiple',true);
        } else {
            cmp.set('v.isMultiple',false);
        }

        /*var _url = new URL(pageUrl).searchParams.get("futuredate");
        if(_url != undefined && _url != ""){
            var _urlStr = _url.toString();
            var _pickDate = _urlStr.substring(0,4)+"-"+_urlStr.substring(4,6)+"-"+_urlStr.substring(6,8);
            var pickNewDate = new Date(_pickDate);

            if(pickNewDate > Date.now){
                 cmp.set("v.tempPickDate",_pickDate);
            }

        }*/
        /*var _pickDate = "2018-12-25";
        cmp.set("v.tempPickDate",_pickDate);*/

    },

    handleSaveNext: function(cmp, evt, helper){
        helper.handleSaveNext(cmp);
        cmp.set('v.pickupPhone','');
        cmp.set('v.pickupTimeSelected','');
    },

     handleSaveDiff: function(cmp, evt, helper){
        helper.handleSaveDiff(cmp,evt,helper);
     },

    handleCancel: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        console.log('AllPickupLabel--->',$A.get("$Label.c.Dal_SSC_ScheduleAllPickups_GotoUrl_Label"));
        baseHelper.doGotoURL($A.get("$Label.c.Dal_SSC_ScheduleAllPickups_GotoUrl_Label"));
    },

    handleChange: function(cmp, evt, helper){
        console.log('on change evt '+cmp.get('v.pickupFirstName'));
        helper.updateStore(cmp);
    },

    handleWhoWillChange: function(cmp, evt, helper){

        var changeValue = evt.getParam("value");
        var firstName;
        var lastName;
        var phoneNumber;
        cmp.set('v.pickupWhoWillValue', changeValue);
        if(changeValue == 'other')
        {
            firstName = cmp.get('v.pickupFirstName');
            cmp.set('v.contactpickupFirstName',firstName);
            lastName = cmp.get('v.pickupLastName');
            cmp.set('v.contactpickupLastName',lastName);
            phoneNumber = cmp.get('v.pickupPhone');
            cmp.set('v.contactpickupPhone',phoneNumber);
            cmp.set('v.pickupFirstName', '');
            cmp.set('v.pickupLastName', '');
            cmp.set('v.pickupPhone', '');
        }
        else if(changeValue == 'me')
        {
            var first = cmp.get('v.contactpickupFirstName');
            cmp.set('v.pickupFirstName',first);
            var last = cmp.get('v.contactpickupLastName');
            cmp.set('v.pickupLastName',last);
            var phone = cmp.get('v.contactpickupPhone');
            cmp.set('v.pickupPhone',phone);

        }
        helper.updateStore(cmp);
    },

    handlePickDateChange: function(cmp, evt, helper){
        helper.handlePickupDateChange(cmp);
    },

    handlePickupTimeSelected: function(cmp, evt, helper){
        var selectedPickupTime = evt.currentTarget.dataset.value;
        cmp.set('v.pickupTimeSelected', selectedPickupTime);
        helper.updateStore(cmp);
    }

})