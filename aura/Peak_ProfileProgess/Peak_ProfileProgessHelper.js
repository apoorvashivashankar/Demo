({
    getProfileInfo : function(component) {
        var action = component.get('c.getUser');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var user = response.getReturnValue();
                this.getProfileFields(component, user.Id);
                component.set('v.userId', user.Id);
            }
        });
        $A.enqueueAction(action);
    },
    getProfileFields : function(component, user){
        var action = component.get('c.getUserById');
        var fields = component.get('v.requiredFields').replace(/\s/g,'');
        var requiredFields = fields.split(';');
        component.set('v.totalFields', requiredFields.length);
        action.setParams({
            userId : user,
            aboutMeFieldNameList : requiredFields
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var results = response.getReturnValue();
                var count = 0;
                var format = component.get('v.resultFormat');
                var theme = component.get('v.theme');
                var remainTheme = component.get('v.remainTheme');
                var circleColor = component.get('v.circleColor');
                var threshold = component.get('v.threshold');
                var thresholdNumber = component.get('v.thresholdNumber');
                var beforeTheme = component.get('v.beforeTheme');
                var afterTheme = component.get('v.afterTheme');
                var includeText = component.get('v.includeText');
                var header = component.get('v.header');
                var subHeader = component.get('v.subHeader');
                var description = component.get('v.description');
                var linkText = component.get('v.linkText');
                if(!threshold || beforeTheme == undefined && afterTheme == undefined){
                    beforeTheme = theme;
                    afterTheme = theme;
                }
                if(thresholdNumber == undefined){
                    thresholdNumber = 50;
                }
                requiredFields.forEach(function(element) {
                    if(results[element] != undefined && results[element] != '' && results[element].indexOf('profilephoto/005/') == -1){
                        count++;
                    }
                })
                component.set('v.completedFields', count);
                if(count < requiredFields.length){
                    component.set('v.isInit', true);
                    var container = component.find("progressWrapper");
                    $A.createComponent("c:Peak_ProgressCircle",
                        {
                            'themeBeforeThreshold': beforeTheme,
                            'themeAfterThreshold': afterTheme,
                            'totalProgress': component.get('v.totalFields'),
                            'actualProgress': count,
                            'resultFormat': format,
                            'remainingColor': remainTheme,
                            'threshold': thresholdNumber,
                            'backgroundColor': circleColor
                        },
                        function(cmp, status, errorMessage) {
                            container.set("v.body", cmp);
                        }
                    );
                }else{
                    component.set('v.isInit', false);
                }
                if(includeText){
                    if(header == '' && subHeader == '' && description == '' && linkText == ''){
                        component.set('v.includeText', false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    goToPath: function(component, event){
        var link = event.currentTarget.dataset.link;
        if(link == ''){
            this.goToProfile(component);
        }else{
            this.goToUrl(component, link);
        }
    },
    goToProfile : function (component) {
        var id = component.get('v.userId');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id,
        });
        navEvt.fire();
    },
    goToUrl : function (component, link) {
        var event = $A.get("e.force:navigateToURL");
        event.setParams({
            "url": link
        });
        event.fire();
    }
})