/**
 * Created by ranja on 26-11-2018.
 */
({
      doinit:function(cmp,event,helper){
        // helper.getLeadData(cmp,event,helper);
         helper.getDonutChartData(cmp,event,helper);
         helper.getPieChartData(cmp,event,helper);
         helper.getOpenLeadData(cmp,event,helper);
      },

      afterScriptsLoaded : function(cmp, event, helper) {
        //  component.set("v.ready", true);
        helper.generateChart(cmp);
      },

      changeDonutData : function(cmp,event,helper){
           //helper.getLeadData(cmp,event,helper);
           helper.getDonutChartData(cmp,event,helper);
      },
      changePieChartData : function(cmp,event,helper){
             //helper.getLeadData(cmp,event,helper);
             helper.getPieChartData(cmp,event,helper);
      },
      changeOpenLeadData : function(cmp,event,helper){
             //helper.getLeadData(cmp,event,helper);
             helper.getOpenLeadData(cmp,event,helper);
      },

      navigateToReportDetailPage : function(cmp,event,helper){
      //    debugger;

          var type = event.getSource().get("v.value");
          if(type == 'StatusLeadReport'){
              var statusReportId = cmp.get("v.statusId");
              helper.navigateToReportDetail(cmp,event,helper,statusReportId);
          }
          if(type == 'ConversionLeadReport'){
              var conversionReportId = cmp.get("v.conversionId");
              helper.navigateToReportDetail(cmp,event,helper,conversionReportId);
          }
          if(type == 'OpenLeadReport'){
              var openReportId = cmp.get("v.openId");
               helper.navigateToReportDetail(cmp,event,helper,openReportId);
          }

      }
})