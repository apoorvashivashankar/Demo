/**
 * Created by Yadav on 11/26/2018.
 */
({
    getOpportunityData:function(cmp,event,helper){
    //            debugger;
                     /* var ready = cmp.get("v.ready");
                        if (ready === false) {
                            return;
                        }
        */
                      var action = cmp.get("c.getreportForOpportunityDashboard");
                      action.setParams({
                            oppConversionRange : cmp.get("v.opportunityConversion"),
                            oppStatusRange  :cmp.get("v.opportunityStatus"),
                            OpenOppRange  :cmp.get("v.opportunityOpen")
                      })

                      action.setCallback(this, function(response) {
                          var state = response.getState();
                          if (state === "SUCCESS") {

        // --------------------------------- For Open Lead------------------------------------------------------------------

                               cmp.set("v.opportunityCount",response.getReturnValue().OpenOpportunity);
                               console.log("opportunityCount--->",cmp.get("v.opportunityCount"));
        // ----------------------------------Setting Drop Down Value------------------------------------------------
                               cmp.set("v.opportunityConversion",response.getReturnValue().ConversionDropDownValue);
                               cmp.set("v.opportunityStatus",response.getReturnValue().StatusDropDownValue);
                               cmp.set("v.opportunityOpen",response.getReturnValue().OpenDropDownValue);
        // --------------------------------- For Doghnut Chart------------------------------------------------------------------

                               var reportResultData = JSON.parse(response.getReturnValue().Conversion);
                               var chartData = [];
                               var chartLabels = [];
                               if(reportResultData.groupingsDown.groupings != null){

                                   for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                                       //Collect all labels for Chart.js data
                                       var labelTemp = reportResultData.groupingsDown.groupings[i].label;
                                       chartLabels.push(labelTemp);

                                       var keyTemp = reportResultData.groupingsDown.groupings[i].key;

                                       //Collect all values for Chart.js data
                                       var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value ;
                                       chartData.push(valueTemp);

                                   }
                                   for(var i=0;i<chartLabels.length;i++){
                                       if(chartLabels[i]=="true"){
                                           cmp.set("v.converted",chartData[i]);
                                       }else{
                                           cmp.set("v.notConverted",chartData[i]);
                                       }
                                   }
                                   var total = cmp.get("v.converted") + cmp.get("v.notConverted");
                                   var percentage = cmp.get("v.converted")/ total *100;
                                   console.log('percentage--->'+percentage);
                                   cmp.set("v.percentage",percentage);

                                //------------------------------------Doghnut Chart-----------------------------------------------------------------

                               var doghnutData = {
                                           labels: ['Converted','Not Converted'],
                                           datasets: [
                                               {
                                                   label: 'Percentage',
                                                   backgroundColor: ["#CF0A2C"],
                                                   data: [cmp.get("v.converted"),cmp.get("v.notConverted")]
                                               }
                                           ]
                               }

                               var ctx1 = cmp.find("donutchart").getElement();


                               var donutChart = new Chart(ctx1 ,{
                                           type: 'doughnut',
                                           data: doghnutData,
                                           plugins: [{
                                                 beforeDraw: function(chart) {
                                                   var width = chart.chart.width,
                                                       height = chart.chart.height,
                                                       ctx = chart.chart.ctx;

                                                   ctx.restore();
                                                   var fontSize = (height / 150).toFixed(2);
                                                   ctx.font = fontSize + "em sans-serif";
                                                   ctx.fillStyle = "#CF0A2C";
                                                   ctx.textBaseline = "middle";

                                                   var text = cmp.get("v.percentage").toFixed(2),
                                                       textX = Math.round((width - ctx.measureText(text).width) / 2),
                                                       textY = height / 2;
                                                   console.log('----');
                                                   ctx.fillText(text, textX, textY);
                                                   ctx.save();
                                                 }
                                             }],
                                           options: {

                                               legend: {
                                                   display: false,
                                               },
                                               responsive: true,

                                                 cutoutPercentage: 85
                                           }
                               });
                               }
        //----------------------------------------For Pie Chart Data--------------------------------------------------------

                               var reportStatusData = JSON.parse(response.getReturnValue().Status);
                               var chartStatusData = [];
                               var chartStatusLabels = [];
                               if(reportStatusData.groupingsDown.groupings != null){
                                   for(var i=0; i < (reportStatusData.groupingsDown.groupings.length); i++){

                                                                         //Collect all labels for Chart.js data
                                                                         var labelTemp = reportStatusData.groupingsDown.groupings[i].label;
                                                                         chartStatusLabels.push(labelTemp);

                                                                         var keyTemp = reportStatusData.groupingsDown.groupings[i].key;

                                                                         //Collect all values for Chart.js data
                                                                         var valueTemp = reportStatusData.factMap[keyTemp + '!T'].aggregates[0].value ;
                                                                         chartStatusData.push(valueTemp);

                                   }



        //--------------------------------------Pie Chart-------------------------------------------------------------------
                               var chartdata = {
                                           labels: chartStatusLabels,
                                           datasets: [
                                               {
                                                   label:'Status',
                                                   data: chartStatusData,
                                                   color : 'white',
                                                   backgroundColor : ["#A81C20", "#CE376E", "#DA69BD", "#CD9DFF"],
                                                   fill: false,
                                                   pointBackgroundColor: "#FFFFFF",
                                               }
                                           ]
                               }
                               var ctx = cmp.find("piechart").getElement();

                               var pieChart = new Chart(ctx ,{
                                          type: 'pie',
                                          data: chartdata,
                                          options: {
                                              legend: {
                                                  usePointStyle : true,
                                                  padding: 10,
                                                  position :'right',

                                              },

                                             responsive: true
                                          }
                                });

                               }

                          }
                          else if (state === "INCOMPLETE") {

                          }
                          else if (state === "ERROR") {

                          }
                      });
                      $A.enqueueAction(action);
    },

    generateChart : function(component, event, helper) {
               	 /*   debugger;
               	var leads = component.get("v.leadList");

                   var chartdata = {
                           labels: ['New','In Progress', 'Rejected', 'Converted'],
                           datasets: [
                               {

                                   fontColor: ['white', 'white', 'white'],
                                   label:'Day',
                                   data: [ 3, 12, 5, 2],
                                   color : 'white',
                                   backgroundColor : ["#A81C20", "#CE376E", "#DA69BD", "#CD9DFF"],
                                   fill: false,
                                   pointBackgroundColor: "#FFFFFF",
                               }
                           ]
                       }
                       var doghnutData = {
                                   labels: ['Africa','null'],
                                   datasets: [
                                       {
                                           label: 'Day',
                                           backgroundColor: ["#CF0A2C"],
                                           data: [86,14]
                                       }
                                   ]
                               }
                       //Get the context of the canvas element we want to select
                       var ctx = component.find("piechart").getElement();
                       var ctx1 = component.find("donutchart").getElement();

                       var pieChart = new Chart(ctx ,{
                           type: 'pie',
                           data: chartdata,
                           options: {
                               legend: {
                                   usePointStyle : true,
                                   position: 'bottom',
                                   padding: 10,
                               },
                               responsive: true
                           }
                       });
                       var donutChart = new Chart(ctx1 ,{
                                   type: 'doughnut',
                                   data: doghnutData,
                                   *//* plugins: [{
                                         beforeDraw: function(chart) {
                                           var width = chart.chart.width,
                                               height = chart.chart.height,
                                               ctx = chart.chart.ctx;

                                           ctx.restore();
                                           var fontSize = (height / 150).toFixed(2);
                                           ctx.font = fontSize + "em sans-serif";
                                           ctx.fillStyle = "#CF0A2C";
                                           ctx.textBaseline = "middle";

                                           var text = "86%",
                                               textX = Math.round((width - ctx.measureText(text).width) / 2),
                                               textY = height / 2;
                                           console.log('----');
                                           ctx.fillText(text, textX, textY);
                                           ctx.save();
                                         }
                                     }],*//*
                                   options: {

                                       legend: {
                                           display: false,
                                       },
                                       responsive: true,
                                         maintainAspectRatio: false,
                                         cutoutPercentage: 85
                                   }
                       });
                      *//* var donutChart = new Chart(ctx1 ,{
                                   type: 'doughnut',
                                   data: doghnutData,
                                   options: {
                                       cutoutPercentage : 95,
                                       legend: {
                                           usePointStyle : true,
                                           position: 'bottom',
                                           padding: 10,
                                       },
                                       responsive: true
                                   }
                       });*//*

           */
    },

    getDonutChartData : function(cmp,event,helper){
    //    debugger;
        var action = cmp.get("c.getReportForOpportunityConversion");
        action.setParams({ oppConversionRange : cmp.get("v.opportunityConversion") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

        // ----------------------------------Setting Drop Down Value------------------------------------------------
                   cmp.set("v.opportunityConversion",response.getReturnValue().ConversionDropDownValue);
        // --------------------------------- For Doghnut Chart------------------------------------------------------------------

                   var reportResultData = JSON.parse(response.getReturnValue().Conversion);
                   var chartData = [];
                   var chartLabels = [];
                   if(reportResultData.groupingsDown.groupings != null){

                       for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                           //Collect all labels for Chart.js data
                           var labelTemp = reportResultData.groupingsDown.groupings[i].label;
                           chartLabels.push(labelTemp);

                           var keyTemp = reportResultData.groupingsDown.groupings[i].key;

                           //Collect all values for Chart.js data
                           var valueTemp = reportResultData.factMap[keyTemp + '!T'].aggregates[0].value ;
                           chartData.push(valueTemp);

                       }
                       for(var i=0;i<chartLabels.length;i++){
                           if(chartLabels[i]=="true"){
                               cmp.set("v.converted",chartData[i]);
                           }else{
                               cmp.set("v.notConverted",chartData[i]);
                           }
                       }
                       var total = cmp.get("v.converted") + cmp.get("v.notConverted");
                       var percentage = cmp.get("v.converted")/ total *100;
                       /*var percent = percentage + '%';
                       console.log('percentage--->'+percent);*/
                       console.log('percentage--->'+percentage);
                       cmp.set("v.percentage",percentage);

        //------------------------------------Doghnut Chart-----------------------------------------------------------------

                   var doghnutData = {
                               labels: ['Converted','Not Converted'],
                               datasets: [
                                   {
                                       label: 'Percentage',
                                       backgroundColor: ["#CF0A2C"],
                                       data: [cmp.get("v.converted"),cmp.get("v.notConverted")]
                                   }
                               ]
                   }

                   var ctx1 = cmp.find("donutchart").getElement();


                   var donutChart = new Chart(ctx1 ,{
                               type: 'doughnut',
                               data: doghnutData,
                               plugins: [{
                                     beforeDraw: function(chart) {
                                       var width = chart.chart.width,
                                           height = chart.chart.height,
                                           ctx = chart.chart.ctx;

                                       ctx.restore();
                                       var fontSize = (height / 150).toFixed(2);
                                       ctx.font = fontSize + "em sans-serif";
                                       ctx.fillStyle = "#CF0A2C";
                                       ctx.textBaseline = "middle";

                                       var text = cmp.get("v.percentage").toFixed(2),
                                           textX = Math.round((width - ctx.measureText(text).width) / 2),
                                           textY = height / 2;
                                       var finalText = Math.round(text)+'%';
                                       console.log('----');
                                       var temp = text + '%';
                                       ctx.fillText(finalText, textX, textY);
                                       ctx.save();
                                     }
                                 }],
                               options: {

                                   legend: {
                                       display: false,
                                   },
                                   responsive: true,

                                     cutoutPercentage: 85
                               }
                   });
                }

        }
        else if (state === "INCOMPLETE") {

        }
        else if (state === "ERROR") {

        }
        });
        $A.enqueueAction(action);
    },
    getOpenOpportunityData : function(cmp,event,helper){
        var action = cmp.get("c.getReportForOpportunityOpen");
        action.setParams({ OpenOppRange  :cmp.get("v.opportunityOpen") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

        // ----------------------------------Setting Drop Down Value------------------------------------------------
              cmp.set("v.opportunityOpen",response.getReturnValue().OpenDropDownValue);
        // --------------------------------- For Open Lead------------------------------------------------------------------

               cmp.set("v.opportunityCount",response.getReturnValue().OpenOpportunity);
               console.log("opportunityCount--->",cmp.get("v.opportunityCount"));
            }
            else if (state === "INCOMPLETE") {

            }
            else if (state === "ERROR") {

            }
        });
        $A.enqueueAction(action);
    },

     getPieChartData : function(cmp,event,helper){
             var action = cmp.get("c.getReportForOpportunityStatus");
             action.setParams({ oppStatusRange  :cmp.get("v.opportunityStatus") });
             action.setCallback(this, function(response) {
                 var state = response.getState();
                 if (state === "SUCCESS") {
             // ----------------------------------Setting Drop Down Value------------------------------------------------
                        cmp.set("v.opportunityStatus",response.getReturnValue().StatusDropDownValue);

             //----------------------------------------For Pie Chart Data--------------------------------------------------------

                        var reportStatusData = JSON.parse(response.getReturnValue().Status);
                        var chartStatusData = [];
                        var chartStatusLabels = [];
                        if(reportStatusData.groupingsDown.groupings != null){
                            for(var i=0; i < (reportStatusData.groupingsDown.groupings.length); i++){

                                  //Collect all labels for Chart.js data
                                  var labelTemp = reportStatusData.groupingsDown.groupings[i].label;
                                  chartStatusLabels.push(labelTemp);

                                  var keyTemp = reportStatusData.groupingsDown.groupings[i].key;

                                  //Collect all values for Chart.js data
                                  var valueTemp = reportStatusData.factMap[keyTemp + '!T'].aggregates[0].value ;
                                  chartStatusData.push(valueTemp);

                            }

             //--------------------------------------Pie Chart-------------------------------------------------------------------
                        var chartdata = {
                                    labels: chartStatusLabels,
                                    datasets: [
                                        {
                                            label:'Status',
                                            data: chartStatusData,
                                            color : 'white',
                                            backgroundColor : ["#A81C20", "#CE376E", "#DA69BD", "#CD9DFF"],
                                            fill: false,
                                            pointBackgroundColor: "#FFFFFF",
                                        }
                                    ]
                        }
                        var ctx = cmp.find("piechart").getElement();

                        var pieChart = new Chart(ctx ,{
                                   type: 'pie',
                                   data: chartdata,
                                   options: {
                                       legend: {
                                           usePointStyle : true,
                                           padding: 10,
                                           position :'bottom',

                                       },

                                      responsive: true
                                   }
                         });

                        }
                 }
                 else if (state === "INCOMPLETE") {

                 }
                 else if (state === "ERROR") {

                 }
             });
             $A.enqueueAction(action);
        },

    navigateToReportDetail : function(cmp,event,helper,reportId) {
    //    debugger;

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/report/'+reportId
        });
        urlEvent.fire();
    },
})