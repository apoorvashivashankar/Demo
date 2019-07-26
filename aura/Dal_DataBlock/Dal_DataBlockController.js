/**
 * Created by 7Summits on 2/28/18.
 */
({

    init: function(cmp, evt, helper){
        debugger;
        cmp.set('v.tempValue','');
        try {
        	var val = cmp.get("v.value").toString();

        	if(val && val.length>0){
        	    if(val.includes(".")){
                      val = val.substring(0, val.indexOf("."));
                }
            	if(val.charAt(0) === '-') {
            	    var charTemp;
            	    var res = "";
                    var count = 0;
                    var reversed = "";
                    var val = val.substring(1);
                       debugger;
                         for(var i=val.length ; i >=0 ; i--)
                                                 {
                                                 	count++;
                                                 	if(count == 4)
                                                    {
                                                        if(i!=0){
                                                            res = res.concat(",");
                                                            count = 0;
                                                            i++;
                                                        }
                                                    }
                                                    else{

                                                 		res = 	res.concat(val.charAt(i-1));
                                                    }
                                                 }
                          var reversed = "";
                          for (var i = res.length - 1; i >= 0; i--){
                                 reversed = reversed.concat(res.charAt(i));
                          }
                          console.log("reversed",reversed);
                       cmp.set("v.tempValue",'-'+'$'+reversed);
            	}
        	}
        } catch(err) {
          	//console('Exception' ,err.getMessage());
        }

    },


    toggleInnerComp: function(cmp, evt){
        var id = cmp.get('v.id');
        var componentName = evt.currentTarget.dataset.name;
        console.log('componentName',componentName);
        var compEvent = cmp.getEvent('toggleDetailEvt');

        compEvent.setParams({
            'id': id,
            'componentName': componentName
        });

        compEvent.fire();
    }

})