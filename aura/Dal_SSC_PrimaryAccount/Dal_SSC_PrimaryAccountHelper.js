/**
 * Created by 7Summits on 3/7/18.
 */
({
    doGetData : function(component){
        var self = this;
        var promise = this.doCallout(component, 'c.getPrimarySSCLocation');

        promise.then(function(data){
            console.log('Dal_SSC_PrimaryAccount:', data);

            var storeHours = self.createStoreHours(data);

            component.set('v.primaryAccount', data);
            component.set('v.storeHours', storeHours);
            component.set('v.isLoading', false);
        }, function(){
            console.log('Dal_SSC_PrimaryAccount:failed to load data');
        });
    },

    createStoreHours: function(data){
        var mfStartHour = this.formatStoreHour(data.mfstarthours);
        var mfEndHour = this.formatStoreHour(data.mfendhours);
        var satStartHour = this.formatStoreHour(data.satstarthours);
        var satEndHour = this.formatStoreHour(data.satendhours);
        var sunStartHour = this.formatStoreHour(data.sunstarthours);
        var sunEndHour = this.formatStoreHour(data.sunendhours);


        return {
            mfStartHour: mfStartHour,
            mfEndHour: mfEndHour,
            satStartHour: satStartHour,
            satEndHour: satEndHour,
            sunStartHour: sunStartHour,
            sunEndHour: sunEndHour
        }
    },

    formatStoreHour: function(storeHour){
        var timeLabel = undefined;

        if(storeHour !== undefined && typeof storeHour.split === 'function'){
            var hour = parseInt(storeHour.split(':')[0], 10);
            timeLabel = this.createTimeLabel(hour);
        }

        return timeLabel;
    },

    createTimeLabel: function(time){
        switch(time){
            case 0:
                return '12AM';
            case 1:
                return '1AM';
            case 2:
                return '2AM';
            case 3:
                return '3AM';
            case 4:
                return '4AM';
            case 5:
                return '5AM';
            case 6:
                return '6AM';
            case 7:
                return '7AM';
            case 8:
                return '8AM';
            case 9:
                return '9AM';
            case 10:
                return '10AM';
            case 11:
                return '11AM';
            case 12:
                return '12PM';
            case 13:
                return '1PM';
            case 14:
                return '2PM';
            case 15:
                return '3PM';
            case 16:
                return '4PM';
            case 17:
                return '5PM';
            case 18:
                return '6PM';
            case 19:
                return '7PM';
            case 20:
                return '8PM';
            case 21:
                return '9PM';
            case 22:
                return '10PM';
            case 23:
                return '11PM';
            default:
                return undefined;
        }
    }

})