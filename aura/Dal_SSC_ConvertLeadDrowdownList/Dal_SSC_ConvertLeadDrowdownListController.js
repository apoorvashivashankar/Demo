/**
 * Created by ranja on 25-11-2018.
 */
({
    selectRecord : function(cmp, event, helper){
    // get the selected record from list
      var getSelectRecord = cmp.get("v.oRecord");
    // call the event
      var compEvent = cmp.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.
      compEvent.setParams({"selectedValue" : getSelectRecord.Id, 'selectedName' : getSelectRecord.Name});
    // fire the event
      compEvent.fire();

    },
})