/**
 * Created by Yadav on 11/26/2018.
 */
({
    doinit:function(cmp,event,helper){
        //helper.getOpportunityData(component,event,helper);
         helper.getDonutChartData(cmp,event,helper);
         helper.getPieChartData(cmp,event,helper);
         helper.getOpenOpportunityData(cmp,event,helper);
    },

    afterScriptsLoaded : function(component, event, helper) {
        //  component.set("v.ready", true);
        helper.generateChart(component);
    },

    changeDonutData : function(cmp,event,helper){
           helper.getDonutChartData(cmp,event,helper);
    },
    changePieChartData : function(cmp,event,helper){
          helper.getPieChartData(cmp,event,helper);
    },
    changeOpenOpportunityData : function(cmp,event,helper){
         helper.getOpenOpportunityData(cmp,event,helper);
    },

    navigateToReportDetailPage : function(cmp,event,helper){
    //  debugger;

      var type = event.getSource().get("v.value");
      if(type == 'StatusOpportunityReport'){
          var statusReportId = cmp.get("v.statusId");
          helper.navigateToReportDetail(cmp,event,helper,statusReportId);
      }
      if(type == 'ConversionOpportunityReport'){
          var conversionReportId = cmp.get("v.conversionId");
          helper.navigateToReportDetail(cmp,event,helper,conversionReportId);
      }
      if(type == 'OpenOpportunityReport'){
          var openReportId = cmp.get("v.openId");
          helper.navigateToReportDetail(cmp,event,helper,openReportId);
      }

    }
})