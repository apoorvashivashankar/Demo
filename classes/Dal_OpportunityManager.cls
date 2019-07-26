/**
 * Created by presh on 22-11-2018.
 */

public with sharing class Dal_OpportunityManager {

    /*
  * Method Name: searchOpenOpportunity
  * Description: Method to get Opportunity Record List.
  * @param: Not Any
  * @return List of Opportunity records.
  */
    @AuraEnabled
    public static List<Object> searchOpenOpportunity(String oppDateToui,String oppDateFromui){
        system.debug('--oppDateToui---'+oppDateToui + '-oppDateFromui----'+oppDateFromui);
        Date oppDateFrom;
        Date oppDateTo;
        //Datetime oppDatetimeTo;
        if(!nullorempty(oppDateFromui)){
            oppDateFrom = Date.valueof(oppDateFromui);
            // oppDateFrom = string.valueof(dt);
        }
        if(!nullorempty(oppDateToui)){
            oppDateTo = Date.valueof(oppDateToui)+1;
            //oppDatetimeTo = Datetime.newInstance(oppDateTo, System.now().time());
            // oppDateTo = string.valueof(dt1);
        }

        List<Object> returnList = new List<Object>();
        String userId = UserInfo.getUserId();
        returnList = [SELECT Id, Name, StageName, AccountId, Account.Name,OwnerId,Rating__c,CloseDate FROM Opportunity Where OwnerId =:userId AND CloseDate >=:oppDateFrom AND CloseDate <=:oppDateTo ORDER BY CloseDate DESC];
        System.debug('-------returnList----'+returnList);
        return returnList;
    }

    /*
  * Method Name: editOpportunity
  * Description: Method to update Opportunity Record.
  * @param: oppData
  * @return Opportunity Id.
  */

    @AuraEnabled
    public static Id editOpportunity(String oppData){
        System.debug('----'+oppData);
        Dal_OpportunityEditJSON oppJson = new Dal_OpportunityEditJSON();
        oppJson = Dal_OpportunityEditJSON.parse(oppData);

        if(oppJson.recordId != null && oppJson.recordId != ''){
            Opportunity opp = [SELECT Id, Name, StageName,Amount, AccountId,Probability,Description,Account.Name,OwnerId,CloseDate FROM Opportunity WHERE Id =:oppJson.recordId];
            OpportunityStage oppStageName = [SELECT MasterLabel, DefaultProbability From OpportunityStage WHERE MasterLabel =:oppJson.StageName];
            System.debug('---OpportunityStage----'+oppStageName);
            opp.Name = oppJson.Name;
            opp.CloseDate= Date.today();
            opp.StageName = oppJson.StageName;
            if(oppJson.Amount!= null && oppJson.Amount != ''){
                opp.Amount = Decimal.valueOf(oppJson.Amount);
            }else{
                opp.Amount = 0;
            }
            opp.Probability = oppStageName.DefaultProbability;
            opp.AccountId = oppJson.AccountId;
            if(oppJson.Bid_Date!= null && oppJson.Bid_Date != ''){
                opp.Bid_Date__c = Date.valueOf(oppJson.Bid_Date);
            }else{
                opp.Bid_Date__c = null;
            }
            //opp.LeadSource = 'Statement Dealer';
            opp.Description = oppJson.Description;
            update opp;
            System.debug('---Opportunity----'+opp);
            return opp.Id;
        }else{
            Opportunity opp = new Opportunity();
            opp.Name = oppJson.Name;
            opp.CloseDate= Date.today();
            opp.StageName = oppJson.StageName;
            if(oppJson.Amount!= null && oppJson.Amount != ''){
                opp.Amount = Decimal.valueOf(oppJson.Amount);
            }else{
                opp.Amount = 0;
            }
            //opp.Probability = oppStageName.DefaultProbability;
            opp.AccountId = oppJson.AccountId;
            if(oppJson.Bid_Date!= null && oppJson.Bid_Date != ''){
                opp.Bid_Date__c = Date.valueOf(oppJson.Bid_Date);
            }else{
                opp.Bid_Date__c = null;
            }
            //opp.LeadSource = 'Statement Dealer';
            opp.Description = oppJson.Description;
            insert opp;
            System.debug('---Opportunity----'+opp);
            return opp.Id;
        }


     }

    /*
  * Method Name: getStatusPickListValues
  * Description: Method to get Picklist value.
  * @param: oppData
  * @return list of picklist Value.
  */
    @AuraEnabled
    public static List<String> getStatusPickListValues(){

        List<String> pickListValuesList= new List<String>();
        RecordType rt = [SELECT Id, Name,SobjectType, DeveloperName FROM RecordType Where DeveloperName ='Project'];
        //Opportunity opp = new Opportunity(RecordTypeId= rt.Id);
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;

    }

    /*
   * Method Name: getRecordTypeIdForOpportunity
   * Description: Method to get Record Type.
   * @param: Not Any
   * @return Record Type Id.
   */
    @AuraEnabled
    public static Id getRecordTypeIdForOpportunity(){
        RecordType rt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName ='Project'];
        return rt.Id;
    }

    /*
  * Method Name: getStatusPickListValues
  * Description: Method to get list of Opportunity Records.
  * @param: name,account,oppDateStart,oppDateEnd,oppStage,listLimit
  * @return list of Opportunity Records.
  */
    @AuraEnabled
    public static List<Object> searchAllOpportunity(String name, String account, String oppDateStart, String oppDateEnd, String oppStage, Integer listLimit) {
        System.debug('All Opportunity params' +' '+name+' '+account+' '+oppDateEnd+' '+oppStage+' '+listLimit);
/*
        //String customerId = getCustomerId();
        String hostsystem = null;
        String leadCount ;
        List<String> formattedDate = Dal_OrderSearchController.forDateValue(oppDateEnd,oppDateEnd);*/
        /*   String leadDateTimeFrom = '';
           String leadDateTimeTo ='';
           String leadTime = 'T00:00:00Z';
           leadDateTimeFrom = String.valueOf(oppDateEnd) + String.valueOf(leadTime);
           leadDateTimeTo = String.valueOf(leadDateTo) + String.valueOf(leadTime);*/
        List<Object> returnList = new List<Object>();

        try{
            returnList = queryOpportunityList(name,account,oppDateStart,oppDateEnd,oppStage,listLimit);
        } catch(Exception exp){
            System.debug('getOpenLead : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;
    }

    /*
    * Method Name: getreportForOpportunityDashboard
    * Description: Method to get Report Data.
    * @param: oppConversionRange,oppStatusRange,OpenOppRange
    * @return Report Data.
    */

    /*@AuraEnabled
    public static Map<String,String> getreportForOpportunityDashboard(String oppConversionRange, String oppStatusRange, String OpenOppRange){
        //Using report id for example purpose
        Map<String,String> recordMap = new Map<String,String>();

        String userId = UserInfo.getUserId();
        List<Contact> con = [SELECT Id,Open_Opportunity_Range__c,Opportunity_Conversion_Range__c,Opp__c,OwnerId  from Contact WHERE OwnerId =:userId];
        List<String>startEndDateList = new List<String>();
        Report reportRec = [SELECT Id FROM Report WHERE Id = '00O29000000Lmp1'];

        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportRec.Id);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate = reportMd.getStandardDateFilter();


        if(oppConversionRange != null && String.isNotBlank(oppConversionRange)) {
            con[0].Opportunity_Conversion_Range__c = oppConversionRange;
            update con[0];
            startEndDateList = getReportDate(oppConversionRange);
            rsdate.setStartDate(startEndDateList[0]);
            rsdate.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, reportMd);
        System.debug('---------'+JSON.serialize(reportResult));

        recordMap.put('Conversion',JSON.serialize(reportResult));
        //return JSON.serialize(reportResult);

        Report reportRec1 = [SELECT Id FROM Report WHERE Id = '00O29000000Lmp6'];

        Reports.ReportDescribeResult describe1 = Reports.ReportManager.describeReport(reportRec1.Id);
        Reports.ReportMetadata reportMd1 = describe1.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate1 = reportMd1.getStandardDateFilter();

        if(oppStatusRange != null && String.isNotBlank(oppStatusRange)) {
            con[0].Opp__c = oppStatusRange;
            update con[0];
            startEndDateList = getReportDate(oppStatusRange);
            rsdate1.setStartDate(startEndDateList[0]);
            rsdate1.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult1 =
                Reports.ReportManager.runReport(reportRec1.Id, reportMd1);
        System.debug('---------'+JSON.serialize(reportResult1));
        recordMap.put('Status',JSON.serialize(reportResult1));
        //return JSON.serialize(reportResult);

        if(OpenOppRange != null && String.isNotBlank(OpenOppRange)) {
            con[0].Open_Opportunity_Range__c = OpenOppRange;
            update con[0];
            startEndDateList = getReportDate(OpenOppRange);
        }

        String oppCount = String.valueOf([SELECT COUNT() FROM Opportunity]);
        recordMap.put('OpenOpportunity',oppCount);

        recordMap.put('ConversionDropDownValue',con[0].Opportunity_Conversion_Range__c);
        recordMap.put('StatusDropDownValue',con[0].Opp__c);
        recordMap.put('OpenDropDownValue',con[0].Open_Opportunity_Range__c);

        return recordMap;

    }*/

    @AuraEnabled
    public static Map<String, String> getReportForOpportunityConversion(String oppConversionRange) {
        //Using report id for example purpose
        Map<String,String> recordMap = new Map<String,String>();

        String userId = UserInfo.getUserId();
        List<Contact> con = [SELECT Id,Open_Opportunity_Range__c,Opportunity_Conversion_Range__c,Opp__c,OwnerId,User__c   from Contact WHERE User__c  =:userId];
        List<String>startEndDateList = new List<String>();
        Dal_SYS_Lead_Opportunity__mdt OpportunityReportId= [SELECT DeveloperName, Id, LeadAndOpportunityID__c, Label FROM Dal_SYS_Lead_Opportunity__mdt WHERE Label='OpportunityConversionId'];
        Report reportRec = [SELECT Id FROM Report WHERE Id =:OpportunityReportId.LeadAndOpportunityID__c];

        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportRec.Id);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate = reportMd.getStandardDateFilter();

        if(oppConversionRange != null && String.isNotBlank(oppConversionRange)) {
            con[0].Opportunity_Conversion_Range__c = oppConversionRange;
            update con[0];
            startEndDateList = getReportDate(oppConversionRange);
            rsdate.setStartDate(startEndDateList[0]);
            rsdate.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, reportMd);
        System.debug('---------'+JSON.serialize(reportResult));

        recordMap.put('Conversion',JSON.serialize(reportResult));
        recordMap.put('ConversionDropDownValue',con[0].Opportunity_Conversion_Range__c);

        return recordMap;
    }


    @AuraEnabled
    public static Map<String, String> getReportForOpportunityStatus(String oppStatusRange) {
        //Using report id for example purpose
        Map<String,String> recordMap = new Map<String,String>();

        String userId = UserInfo.getUserId();
        List<Contact> con = [SELECT Id,Open_Opportunity_Range__c,Opportunity_Conversion_Range__c,Opp__c,OwnerId,User__c   from Contact WHERE User__c  =:userId];
        List<String>startEndDateList = new List<String>();
        Dal_SYS_Lead_Opportunity__mdt OpportunityReportId= [SELECT DeveloperName, Id, LeadAndOpportunityID__c, Label FROM Dal_SYS_Lead_Opportunity__mdt WHERE Label='OpportunityStatusReportId'];
        Report reportRec1 = [SELECT Id FROM Report WHERE Id =:OpportunityReportId.LeadAndOpportunityID__c];

        Reports.ReportDescribeResult describe1 = Reports.ReportManager.describeReport(reportRec1.Id);
        Reports.ReportMetadata reportMd1 = describe1.getReportMetadata();
        reportMd1.getStandardDateFilter();
        Reports.StandardDateFilter rsdate1 = reportMd1.getStandardDateFilter();

        if(oppStatusRange != null && String.isNotBlank(oppStatusRange)) {
            con[0].Opp__c = oppStatusRange;
            update con[0];
            startEndDateList = getReportDate(oppStatusRange);
            rsdate1.setStartDate(startEndDateList[0]);
            rsdate1.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult1 =
                Reports.ReportManager.runReport(reportRec1.Id, reportMd1);
        System.debug('---------'+JSON.serialize(reportResult1));
        recordMap.put('Status',JSON.serialize(reportResult1));
        //return JSON.serialize(reportResult);
        recordMap.put('StatusDropDownValue',con[0].Opp__c);
        return recordMap;

    }

    @AuraEnabled
    public static Map<String, String> getReportForOpportunityOpen(String OpenOppRange) {
        Map<String,String> recordMap = new Map<String,String>();

        String userId = UserInfo.getUserId();
        List<Contact> con = [SELECT Id,Open_Opportunity_Range__c,Opportunity_Conversion_Range__c,Opp__c,OwnerId,User__c   from Contact WHERE User__c  =:userId];
        List<String>startEndDateList = new List<String>();
        if(OpenOppRange != null && String.isNotBlank(OpenOppRange)) {
            con[0].Open_Opportunity_Range__c = OpenOppRange;
            update con[0];
            startEndDateList = getReportDate(OpenOppRange);
        }

        String oppCount = String.valueOf([SELECT COUNT() FROM Opportunity WHERE StageName != '5 - Closed Won' AND StageName != '5 - Closed' AND StageName != '5 - Closed Lost' AND OwnerId =:userId]);
        recordMap.put('OpenOpportunity',oppCount);
        system.debug('oppCount----'+oppCount);
        recordMap.put('OpenDropDownValue',con[0].Open_Opportunity_Range__c);
        return recordMap;

    }

    private static list<String> getReportDate( String range){

        //String month = '1';
        String dt;
        String de;
        List<String> dateList = new List<String>();
        if (range == '1 Month') {
            dt = String.valueOf(date.today().addMonths(-1));
            de = String.valueOf(date.today());

        }
        if (range == '3 Month') {
            dt = String.valueOf(date.today().addMonths(-3));
            de = String.valueOf(date.today());

        }
        if (range == '6 Month') {
            dt = String.valueOf(date.today().addMonths(-6));
            de = String.valueOf(date.today());
        }
        if (range == '9 Month') {
            dt = String.valueOf(date.today().addMonths(-9));
            de = String.valueOf(date.today());
        }
        if (range == '1 Year') {
            dt = String.valueOf(date.today().addMonths(-12));
            de = String.valueOf(date.today());
        }
        dateList.add(dt);
        dateList.add(de);
        System.debug('---dateList--'+dateList);
        return dateList;

    }

    /*
    * Method Name: queryOpportunityList
    * Description: Method to get List of Lead Record.
    * @param: name,account,oppDateFromui,oppDateToui,oppStage,listLimit
    * @return List of Opportunity Records.
    */
    private static List<Object> queryOpportunityList(String name, String account,String oppDateFromui, String oppDateToui, String oppStage, Integer listLimit) {

        System.debug('Search params-->' + ' ' + name + ' ' + account + ' ' + oppDateFromui + ' ' + oppDateToui + ' ' + oppStage + ' ' + listLimit);
        List<Opportunity> OppListRecords = new List<Opportunity>();

        Date oppDateFrom;
        Date oppDateTo;
        //Datetime oppDatetimeTo;
        if(!nullorempty(oppDateFromui)){
             oppDateFrom = Date.valueof(oppDateFromui);
           // oppDateFrom = string.valueof(dt);
        }
        if(!nullorempty(oppDateToui)){
             oppDateTo = Date.valueof(oppDateToui)+1;
            //oppDatetimeTo = Datetime.newInstance(oppDateTo, System.now().time());
           // oppDateTo = string.valueof(dt1);
        }

        system.debug('both are not null -- oppDateEnd -'+oppDateFrom+' -oppDateEnd -'+oppDateTo);
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

        String userId = UserInfo.getUserId();
        string dformat = 'yyyy-MM-dd';
        String query;
        try {
            query = 'SELECT  Name, StageName,AccountId,' +
                    ' CloseDate, OwnerId, Account.Name,Rating__c' +
                    ' FROM Opportunity Where OwnerId = \'' + userId + '\'';

            if (String.isNotBlank(name)) {

                query += ' AND Name like \'%' + name + '%\'';
            }


            if(String.isNotBlank(account)){
                /*leadSource = leadSource.remove('*');
                leadSource = leadSource.toUpperCase();*/
                query += ' AND Account.Name like \'%' + account + '%\'';
            }

            if(String.isNotBlank(oppStage)){
                /*oppStage = oppStage.remove('*');
                oppStage = oppStage.toUpperCase();*/
                query += ' AND StageName like \'%' + oppStage + '%\'';
            }

            if(oppDateFrom != null){
                query += ' AND CloseDate >=:oppDateFrom ';
            }

            if(oppDateTo != null){
                query += ' AND CloseDate <=:oppDateTo ';
            }

             query += ' ORDER BY CloseDate DESC LIMIT ' + listLimit;

            System.debug('Query is --'+query);

            OppListRecords = Database.query(query);

        }
        catch(Exception exp){
            System.debug('queryLeadList : An unexpected error has occurred: ' + exp.getMessage());
        }

        return OppListRecords;

    }

    private static Boolean nullorempty(String val){
        system.debug('val is '+val);
        Boolean nullempty = false;
        if(val == null || val ==''){
            nullempty = true;
        }else{
            nullempty = false;
        }
        system.debug('nullempty is '+nullempty);
        return nullempty;
    }

}