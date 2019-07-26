/**
* Created by presh on 21-11-2018.
*/

public with sharing class Dal_LeadManager {

    /*
  * Method Name: searchOpenLead
  * Description: Method to get Lead Record List.
  * @param: Not Any
  * @return List of Lead records.
  */
    @AuraEnabled
    public static List<Object> searchOpenLead(String leadDateToui, String leadDateFromui) {

        Date leadDateTo;
        Date leadDateFrom;
        /*Datetime leadDatetimeTo;
        String tim = ' 17:59:59';*/
        //Datetime leadDatetimeFrom;
        if (!nullorempty(leadDateToui)) {
            //String FinalDate = leadDateToui+tim;
            leadDateTo = Date.valueof(leadDateToui)+1;
            //leadDatetimeTo = Datetime.newInstance(leadDateTo, System.now().time());
            //leadDatetimeTo = Datetime.valueOf(FinalDate);

            //leadDatetimeTo = Datetime.valueOf(leadDateTo);
            //leadDateTo = string.valueof(dt);
        }
        if (!nullorempty(leadDateFromui)) {
            leadDateFrom = Date.valueof(leadDateFromui);
            //leadDateFrom = string.valueof(dt1);
        }

        List<Object> returnList = new List<Object>();
        String userId = UserInfo.getUserId();
        returnList = [SELECT Id,Name,FirstName,LastName,Lead_Score__c,LeadSource, Company, CreatedDate,OwnerId, Status FROM Lead WHERE OwnerId = :userId AND CreatedDate >=:leadDateFrom AND CreatedDate <=:leadDateTo AND IsConverted = FALSE ORDER BY CreatedDate DESC];
        system.debug('-------returnList----' + returnList);
        return returnList;

    }

    /*
  * Method Name: createLead
  * Description: Method to create Lead Record.
  * @param: leadValue
  * @return Lead Id.
  */
    @AuraEnabled
    public static Id createLead(String leadValue) {
        System.debug('-----------' + leadValue);
        Dal_LeadJSON leadJson = new Dal_LeadJSON();
        leadJson = Dal_LeadJSON.parse(leadValue);

        if (leadJson.recordId != null && leadJson.recordId != '') {
            Lead lead = [SELECT Id FROM Lead WHERE Id = :leadJson.recordId LIMIT 1];
            lead.Salutation = leadJson.Salutation;
            lead.FirstName = leadJson.FirstName;
            lead.LastName = leadJson.LastName;
            lead.Company = leadJson.Company;
            lead.Street = leadJson.Street;
            lead.City = leadJson.City;
            lead.State = leadJson.State;
            lead.Job_Title__c = leadJson.Job_Title;
            lead.Phone = leadJson.Phone;
            lead.MobilePhone = leadJson.MobilePhone;
            lead.PostalCode = leadJson.PostalCode;
            lead.Country = leadJson.Country;
            lead.Email = leadJson.Email;
            lead.Description = leadJson.Description;
            lead.Call_Source__c = leadJson.Call_Source;
            lead.Lead_Score__c = leadJson.Lead_Score;
            lead.LeadSource = leadJson.LeadSource;
            lead.Disqual_Reason__c = leadJson.Disqual_Reason;
            //lead. = leadJson.Lead_Score;
            lead.Status = leadJson.Status;
            System.debug('Lead to Update: ' + lead);
            update lead;
            return lead.Id;
        } else {
            Lead lead = new Lead();
            lead.Salutation = leadJson.Salutation;
            lead.FirstName = leadJson.FirstName;
            lead.LastName = leadJson.LastName;
            lead.Company = leadJson.Company;
            lead.Street = leadJson.Street;
            lead.City = leadJson.City;
            lead.State = leadJson.State;
            lead.Job_Title__c = leadJson.Job_Title;
            lead.Phone = leadJson.Phone;
            lead.MobilePhone = leadJson.MobilePhone;
            lead.PostalCode  = leadJson.PostalCode;
            lead.Country = leadJson.Country;
            lead.Email = leadJson.Email;
            lead.Description = leadJson.Description;
            lead.Call_Source__c = leadJson.Call_Source;
            lead.Lead_Score__c = leadJson.Lead_Score;
            lead.LeadSource = leadJson.LeadSource;
            lead.Disqual_Reason__c = leadJson.Disqual_Reason;
            lead.Status = leadJson.Status;
            System.debug('Lead to convert: ' + lead);
            insert lead;
            return lead.Id;
        }
    }
    /*
   * Method Name: getRecordTypeIdForLead
   * Description: Method to get Record Type.
   * @param: Not Any
   * @return Record Type Id.
   */
    @AuraEnabled
    public static Id getRecordTypeIdForLead(){
        RecordType rt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName ='Statements_Leads'];
        return rt.Id;
    }

        /*
     * Method Name: fetchUsers
     * Description: Method to get User Record.
     * @param: inputKeyword
     * @return List of User.
     */
    @AuraEnabled
    public static List<User> fetchUsers(String inputKeyword) {
        List<User> returnList = new List<User>();
        returnList = Database.query('SELECT Id, Username, LastName, FirstName, Name, CompanyName, Title FROM User WHERE Name like \'%' + inputKeyword + '%\' ORDER BY createdDate ASC LIMIT 7');

        return returnList;
    }

    /*
    * Method Name: fetchCurrentUser
    * Description: Method to get User Record.
    * @param: Not Any
    * @return List of User.
    */
    @AuraEnabled
    public static List<User> fetchCurrentUser() {
        return [SELECT Id, Username, LastName, FirstName, CompanyName, Name FROM User WHERE Id = :UserInfo.getUserId()];
    }
    /*
    * Method Name: fetchLeadOwner
    * Description: Method to get Lead Owner.
    * @param: leadId
    * @return Lead Owner Id.
    */
    @AuraEnabled
    public static user fetchLeadOwner(String leadId) {
        System.debug('IN FETCH LEAD OWNER');
        List<Lead> lead = [SELECT Id,Name,FirstName,LastName,Lead_Score__c,LeadSource, Company, CreatedDate,OwnerId FROM Lead where Id = :leadId];
        return leadOwner(lead[0].OwnerId);
        //return lead.owner.Id;
    }
    /*
    * Method Name: leadOwner
    * Description: Method to get User Id.
    * @param: OwnerId
    * @return User Record.
    */
    private static user leadOwner(String OwnerId) {
        List<user> user = [SELECT Id, Name from User WHERE Id = :OwnerId];
        return user[0];
    }
    /*
    * Method Name: fetchAccounts
    * Description: Method to get Account Records.
    * @param: inputKeyword
    * @return List of Account Record.
    */
    @AuraEnabled
    public static List<Account> fetchAccounts(String inputKeyword) {
        List<Account> returnList = new List<Account>();
        returnList = Database.query('SELECT Id, Name, Type, Phone FROM Account WHERE Name like \'%' + inputKeyword + '%\' ORDER BY createdDate ASC LIMIT 7');

        return returnList;
    }

    /*
    * Method Name: fetchContacts
    * Description: Method to get Contact Records.
    * @param: inputKeyword
    * @return List of Contact Record.
    */
    @AuraEnabled
    public static List<Contact> fetchContacts(String inputKeyword) {
        List<Contact> returnList = new List<Contact>();
        returnList = Database.query('SELECT Id, LastName, FirstName, Salutation, Name, Phone, Email, Title FROM Contact WHERE Name like \'%' + inputKeyword + '%\' ORDER BY createdDate ASC LIMIT 7');

        return returnList;
    }

    /*
    * Method Name: createOpportunity
    * Description: Method to Convert Lead into Account, Contact and Opportunity.
    * @param: opportunityValue
    * @return Opportunity Id
    */
    @AuraEnabled
    public static Id createOpportunity(String opportunityValue) {
        System.debug('-----------' + opportunityValue);
        Dal_LeadConvert leadConvert = new Dal_LeadConvert();
        leadConvert = Dal_LeadConvert.parse(opportunityValue);
        Lead lead = [SELECT Id,Name,FirstName,Description,LastName,Lead_Score__c,LeadSource, Company, CreatedDate,OwnerId, Status FROM Lead where Id = :leadConvert.recordId];
        Id accountId;
        Id contactId;
        Id opportunityId;
        if (leadConvert.isAccountNew == true && leadConvert.isContactNew == false) {

            Account acc = new Account();
            acc.name = leadConvert.selectedAccount;
            acc.Contact__c = leadConvert.selectedContact;
            insert acc;

            Opportunity opp = new Opportunity();
            opp.Name = leadConvert.opportunityName;
            opp.closeDate = date.today();
            opp.StageName = '2 - Specification';
            opp.Description = lead.Description;
            //opp.LeadSource = 'Statement Dealer';
            //opp.Amount = 10;
            opp.AccountId = acc.Id;
            insert opp;

            accountId = acc.Id;
            opportunityId = opp.Id;

        }
        if (leadConvert.isContactNew == true && leadConvert.isAccountNew == false) {

            String fullName = leadConvert.selectedContact;
            String[] name = fullName.split(' ');
            Contact con = new Contact();
            con.FirstName = name[0];
            con.LastName = name[1];
            con.AccountId = leadConvert.selectedAccount;
            insert con;

            Opportunity opp = new Opportunity();
            opp.Name = leadConvert.opportunityName;
            opp.closeDate = date.today();
            opp.Description = lead.Description;
            opp.StageName = '2 - Specification';
            //opp.LeadSource = 'Statement Dealer';
            //opp.Amount = 10;
            opp.AccountId = leadConvert.selectedAccount;
            insert opp;

            accountId = leadConvert.selectedAccount;
            contactId = con.Id;
            opportunityId = opp.Id;

        }

        if (leadConvert.isContactNew == false && leadConvert.isAccountNew == false) {

            Opportunity opp = new Opportunity();
            opp.Name = leadConvert.opportunityName;
            opp.closeDate = date.today();
            opp.Description = lead.Description;
            opp.StageName = '2 - Specification';
            //opp.LeadSource = 'Statement Dealer';
            //opp.Amount = 10;
            opp.AccountId = leadConvert.selectedAccount;
            insert opp;

            accountId = leadConvert.selectedAccount;
            contactId = leadConvert.selectedContact;
            opportunityId = opp.Id;

        }

        if (leadConvert.isContactNew == true && leadConvert.isAccountNew == true) {

            Account acc = new Account();
            acc.name = leadConvert.selectedAccount;
            insert acc;

            String fullName = leadConvert.selectedContact;
            String[] name = fullName.split(' ');
            Contact con = new Contact();
            con.FirstName = name[0];
            con.LastName = name[1];
            con.AccountId = acc.Id;
            insert con;

            Opportunity opp = new Opportunity();
            opp.Name = leadConvert.opportunityName;
            opp.closeDate = date.today();
            opp.Description = lead.Description;
            opp.StageName = '2 - Specification';
            //opp.LeadSource = 'Statement Dealer';
            //opp.Amount = 10;
            opp.AccountId = acc.Id;
            insert opp;

            accountId = acc.Id;
            contactId = con.Id;
            opportunityId = opp.Id;

        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadConvert.recordId);
        lc.setAccountId(accountId);
        lc.setContactId(contactId);
        lc.setOpportunityId(opportunityId);
        lc.setOwnerId(lead.OwnerId);
        /*LeadStatus convertStatus = [SELECT Id, MasterLabel,IsDefault,IsConverted FROM LeadStatus WHERE MasterLabel =:leadConvert.convertedStatus LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);*/
        lc.setConvertedStatus(leadConvert.convertedStatus);

        lc.setSendNotificationEmail(leadConvert.sendEmail);
        if (leadConvert.sendEmail == true) {
            lc.isSendNotificationEmail();
        }
        system.debug('----lc' + lc);
        Database.LeadConvertResult lcr = Database.convertLead(lc);

        System.debug('-----lcr' + lcr);


        return opportunityId;
    }

    /*
    * Method Name: searchAllLeads
    * Description: Method to get List of Lead Record.
    * @param: firstname,lastname,leadSource,leadScore,leadDateFrom,leadDateTo,lineStatus,listLimit,
    * @return List of Lead Records.
    */

    @AuraEnabled
    public static List<Object> searchAllLeads(String firstname, String lastname, String leadSource, String leadScore, String leadDateFrom, String leadDateTo, String lineStatus, Integer listLimit) {
        System.debug('All Leads params' + ' ' + firstname + ' ' + lastname + ' ' + leadSource + ' ' + leadScore + ' ' + leadDateTo + ' ' + lineStatus + ' ' + listLimit);
        List<Object> returnList = new List<Object>();

        try {
            returnList = queryLeadList(firstname, lastname, leadSource, leadScore, leadDateFrom, leadDateTo, lineStatus, listLimit);
        } catch (Exception exp) {
            System.debug('getOpenLead : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;
    }

    /*
    * Method Name: queryLeadList
    * Description: Method to get List of Lead Record.
    * @param: firstname,lastname,leadSource,leadScore,leadDateFromui,leadDateToui,lineStatus,listLimit,
    * @return List of Lead Records.
    */
    private static List<Lead> queryLeadList(String firstname, String lastname, String leadSource, String leadScore, String leadDateFromui, String leadDateToui, String lineStatus, Integer listLimit) {

        System.debug('Search params-->' + ' ' + firstname + ' ' + lastname + '  ' + leadSource + ' ' + leadScore + ' ' + leadDateFromui + ' ' + leadDateToui + ' ' + lineStatus + ' ' + listLimit);
        List<Lead> leadListRecords = new List<Lead>();

        Date leadDateTo;
        Date leadDateFrom;
        /*Datetime leadDatetimeTo;
        String tim = ' 17:59:59';*/
        //Datetime leadDatetimeFrom;
        if (!nullorempty(leadDateToui)) {
            //String FinalDate = leadDateToui+tim;
            leadDateTo = Date.valueof(leadDateToui)+1;
            //leadDatetimeTo = Datetime.newInstance(leadDateTo, System.now().time());
            //leadDatetimeTo = Datetime.valueOf(FinalDate);

            //leadDatetimeTo = Datetime.valueOf(leadDateTo);
            //leadDateTo = string.valueof(dt);
        }
        if (!nullorempty(leadDateFromui)) {
            leadDateFrom = Date.valueof(leadDateFromui);
            //leadDateFrom = string.valueof(dt1);
        }

        system.debug('both are not null -- LeadDateFrom -' + leadDateFrom + ' -leadDateTo -' + leadDateTo);
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

        String userId = UserInfo.getUserId();
        //string dformat = 'yyyy-MM-dd';
        String query;
        try {
            query = 'SELECT Id, Name, FirstName,LastName,Lead_Score__c,LeadSource, Company,' +
                    ' Status, CreatedDate, OwnerId' +
                    ' FROM Lead Where OwnerId = \'' + userId + '\' AND IsConverted = false';

            if (String.isNotBlank(firstname)) {

                query += ' AND FirstName like \'%' + firstname + '%\'';
            }

            if (String.isNotBlank(lastname)) {

                query += ' AND LastName like \'%' + lastname + '%\'';
            }

            if (String.isNotBlank(leadSource)) {
                /*leadSource = leadSource.remove('*');
                leadSource = leadSource.toUpperCase();*/
                query += ' AND LeadSource like \'%' + LeadSource + '%\'';
            }

            if (String.isNotBlank(lineStatus)) {
                /*lineStatus = lineStatus.remove('*');
                lineStatus = lineStatus.toUpperCase();*/
                query += ' AND Status like \'%' + lineStatus + '%\'';
            }

            if (leadDateFrom != null) {
                query += ' AND CreatedDate >=:leadDateFrom ';
            }

            if (leadDateTo != null) {
                query += ' AND CreatedDate <=:leadDateTo ';
            }

            query += ' ORDER BY CreatedDate DESC LIMIT ' + listLimit;

            System.debug('Query is --' + query);

            leadListRecords = Database.query(query);

        } catch (Exception exp) {
            System.debug('queryLeadList : An unexpected error has occurred: ' + exp.getMessage());
        }

        return leadListRecords;

    }

    /*
    * Method Name: nullorempty
    * Description: Method to check the String is Null or Blank.
    * @param: val
    * @return true or false.
    */
    public static Boolean nullorempty(String val) {
        system.debug('val is ' + val);
        Boolean nullempty = false;
        if (val == null || val == '') {
            nullempty = true;
        } else {
            nullempty = false;
        }
        system.debug('nullempty is ' + nullempty);
        return nullempty;
    }
    /*
    * Method Name: getStatusPickListValues
    * Description: Method to get Picklist Value.
    * @param: Not Any
    * @return Picklist Value.
    */
    @AuraEnabled
    public static Map<String, list<String>> getStatusPickListValues() {
        Map<String, list<String>> picklistvalue = new Map<String, list<string>>();
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        system.debug('ple' + ple);
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        picklistvalue.put('Status', pickListValuesList);
        List<String> pickListLeadSourceValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult1 = Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : ple1) {
            pickListLeadSourceValuesList.add(pickListVal.getLabel());
        }
        picklistvalue.put('leadSource', pickListLeadSourceValuesList);
        return picklistvalue;
    }

    /*
    * Method Name: getreportForLeadConversionRate
    * Description: Method to get Report Data.
    * @param: LeadConversionRange,LeadStatusRange,OpenLeadRange
    * @return Report Data.
    */

    /*@AuraEnabled
    public static Map<String, String> getreportForLeadConversionRate(String LeadConversionRange, String LeadStatusRange, String OpenLeadRange) {

        System.debug('LeadConversionRange-----'+LeadConversionRange + '----LeadStatusRange--'+LeadStatusRange + '---OpenLeadRange---'+OpenLeadRange);
        //Using report id for example purpose
        Map<String, String> recordMap = new Map<String, String>();
        String userId = UserInfo.getUserId();
        list<Contact> con = [SELECT Id,Open_Lead_Range__c,lead_Conversion__c,Lead_Status_Range__c,OwnerId  from Contact WHERE OwnerId =:userId];
        Report reportRec = [SELECT Id, Name FROM Report WHERE Id = '00O29000000LmnP'];

        //String reportId = reportRec.Id;

        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportRec.Id);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate = reportMd.getStandardDateFilter();

        list<String>startEndDateList = new List<String>();
        if(LeadConversionRange != null && String.isNotBlank(LeadConversionRange)) {
            con[0].lead_Conversion__c = LeadConversionRange;
            update con[0];
            startEndDateList = getReportDate(LeadConversionRange);
            rsdate.setStartDate(startEndDateList[0]);
            rsdate.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, reportMd);
        system.debug('---------' + JSON.serialize(reportResult));

        recordMap.put('Conversion', JSON.serialize(reportResult));
        //return JSON.serialize(reportResult);

        Report reportRec1 = [SELECT Id,Name FROM Report WHERE ID = '00O29000000LmnF'];

        Reports.ReportDescribeResult describe1 = Reports.ReportManager.describeReport(reportRec1.Id);
        Reports.ReportMetadata reportMd1 = describe1.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate1 = reportMd1.getStandardDateFilter();

        if(LeadStatusRange != null && String.isNotBlank(LeadStatusRange)) {
            con[0].Lead_Status_Range__c = LeadStatusRange;
            update con[0];
            startEndDateList = getReportDate(LeadStatusRange);
            rsdate1.setStartDate(startEndDateList[0]);
            rsdate1.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult1 =
                Reports.ReportManager.runReport(reportRec1.Id, reportMd1);
        System.debug('---------' + JSON.serialize(reportResult1));
        recordMap.put('Status', JSON.serialize(reportResult1));
        //return JSON.serialize(reportResult);

        if(OpenLeadRange != null && String.isNotBlank(OpenLeadRange)) {
            con[0].Open_Lead_Range__c = OpenLeadRange;
            update con[0];
            startEndDateList = getReportDate(OpenLeadRange);
            String leadCount = String.valueOf([SELECT COUNT() FROM Lead WHERE Status = 'Open']);
            recordMap.put('OpenLead', leadCount);
        }else{
            String leadCount = String.valueOf([SELECT COUNT() FROM Lead WHERE Status = 'Open']);
            recordMap.put('OpenLead', leadCount);
        }

        recordMap.put('ConversionDropDownValue',con[0].lead_Conversion__c);
        recordMap.put('StatusDropDownValue',con[0].Lead_Status_Range__c);
        recordMap.put('OpenDropDownValue',con[0].Open_Lead_Range__c);
        *//*getReportForLeadStatus(con[0].lead_Conversion__c);
        getReportForLeadConversion(con[0].Lead_Status_Range__c);
        getReportForLeadOpen(con[0].Open_Lead_Range__c);
*//*
        return recordMap;

    }*/

    @AuraEnabled
    public static Map<String, String> getReportForLeadStatus(String LeadStatusRange) {

        System.debug('LeadStatusRange-----'+LeadStatusRange);
        //Using report id for example purpose
        Map<String, String> recordMap = new Map<String, String>();
        String userId = UserInfo.getUserId();
        List<Contact> con = [SELECT Id,Open_Lead_Range__c,lead_Conversion__c,Lead_Status_Range__c,OwnerId,User__c  from Contact WHERE User__c =:userId];
        List<String>startEndDateList = new List<String>();
        Dal_SYS_Lead_Opportunity__mdt LeadReportId= [SELECT DeveloperName, Id, LeadAndOpportunityID__c, Label FROM Dal_SYS_Lead_Opportunity__mdt WHERE Label='LeadStatusReportId'];
        Report reportRec1 = [SELECT Id,Name FROM Report WHERE ID =:LeadReportId.LeadAndOpportunityID__c];

        Reports.ReportDescribeResult describe1 = Reports.ReportManager.describeReport(reportRec1.Id);
        Reports.ReportMetadata reportMd1 = describe1.getReportMetadata();
        reportMd1.getStandardDateFilter();
        Reports.StandardDateFilter rsdate1 = reportMd1.getStandardDateFilter();

        if(LeadStatusRange != null && String.isNotBlank(LeadStatusRange)) {
            con[0].Lead_Status_Range__c = LeadStatusRange;
            update con[0];
            startEndDateList = getReportDate(LeadStatusRange);
            rsdate1.setStartDate(startEndDateList[0]);
            rsdate1.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult1 =
                Reports.ReportManager.runReport(reportRec1.Id, reportMd1);
        System.debug('---------' + JSON.serialize(reportResult1));
        recordMap.put('Status', JSON.serialize(reportResult1));
        recordMap.put('StatusDropDownValue',con[0].Lead_Status_Range__c);
        return recordMap;

    }

    @AuraEnabled
    public static Map<String, String> getReportForLeadConversion(String LeadConversionRange) {

        System.debug('LeadConversionRange-----'+LeadConversionRange);
        //Using report id for example purpose
        Map<String, String> recordMap = new Map<String, String>();
        String userId = UserInfo.getUserId();
        list<Contact> con = [SELECT Id,Open_Lead_Range__c,lead_Conversion__c,Lead_Status_Range__c,OwnerId,User__c  from Contact WHERE User__c =:userId];
        Dal_SYS_Lead_Opportunity__mdt LeadReportId= [SELECT DeveloperName, Id, LeadAndOpportunityID__c, Label FROM Dal_SYS_Lead_Opportunity__mdt WHERE Label='LeadConversionReportId'];
        Report reportRec = [SELECT Id, Name FROM Report WHERE Id =:LeadReportId.LeadAndOpportunityID__c];
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportRec.Id);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        reportMd.getStandardDateFilter();
        Reports.StandardDateFilter rsdate = reportMd.getStandardDateFilter();

        List<String>startEndDateList = new List<String>();
        if(LeadConversionRange != null && String.isNotBlank(LeadConversionRange)) {
            con[0].lead_Conversion__c = LeadConversionRange;
            update con[0];
            startEndDateList = getReportDate(LeadConversionRange);
            rsdate.setStartDate(startEndDateList[0]);
            rsdate.setEndDate(startEndDateList[1]);
        }

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, reportMd);
        system.debug('---------' + JSON.serialize(reportResult));

        recordMap.put('Conversion', JSON.serialize(reportResult));
        recordMap.put('ConversionDropDownValue',con[0].lead_Conversion__c);
        return recordMap;

    }

    @AuraEnabled
    public static Map<String, String> getReportForLeadOpen(String OpenLeadRange) {

        System.debug('OpenLeadRange-----'+OpenLeadRange);
        //Using report id for example purpose
        Map<String, String> recordMap = new Map<String, String>();
        List<String>startEndDateList = new List<String>();
        List<String> leadStatusList = new List<String>{'New','In Progress'};
        String userId = UserInfo.getUserId();

        List<Contact> con = [SELECT Id,Open_Lead_Range__c,lead_Conversion__c,Lead_Status_Range__c,OwnerId,User__c  from Contact WHERE User__c =:userId];
        if(OpenLeadRange != null && String.isNotBlank(OpenLeadRange)) {
            con[0].Open_Lead_Range__c = OpenLeadRange;
            update con[0];
            startEndDateList = getReportDate(OpenLeadRange);
            String leadCount = String.valueOf([SELECT COUNT() FROM Lead WHERE Status =:leadStatusList AND IsConverted = FALSE AND OwnerId =:userId]);
            recordMap.put('OpenLead', leadCount);
        }else{
            String leadCount = String.valueOf([SELECT COUNT() FROM Lead WHERE Status =:leadStatusList AND IsConverted = FALSE AND OwnerId =:userId]);
            recordMap.put('OpenLead', leadCount);
        }
        recordMap.put('OpenDropDownValue',con[0].Open_Lead_Range__c);
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

        /*rsdate.setStartDate(dt);
        rsdate.setEndDate(de);*/
    }
/*

    @AuraEnabled
    public static String getreportForTotalNumberofOpenLeads() {
        //Using report id for example purpose
        Report reportRec = [
                SELECT
                        Id
                FROM Report
                WHERE Id = '00O29000000LmMOEA0'
        ];

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, true);

        return JSON.serialize(reportResult);
    }

    @AuraEnabled
    public static String getreportForLeadStatus() {
        //Using report id for example purpose
        Report reportRec = [
                SELECT
                        Id
                FROM Report
                WHERE Id = '00O29000000LmLuEAK'
        ];

        Reports.ReportResults reportResult =
                Reports.ReportManager.runReport(reportRec.Id, true);

        return JSON.serialize(reportResult);
    }

*/

}