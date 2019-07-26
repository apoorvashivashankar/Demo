/**
* Created by presh on 23-11-2018.
*/
@istest
public with sharing class Dal_LeadManagerTest {
    
    public static testMethod void getLead(){
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact con = new Contact(FirstName ='test',LastName='user');
        insert con;
        Lead  lstLead =   new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open');
        insert lstLead;
        String leadId = lstLead.Id;
        String data='{"FirstName":"Test","LastName":"User","Salutation":"Mr.","Company":"MTX Group Inc","Street":"123","Job_Title__c":"Architect","City":"Jaipur","Phone":"123456789","State":"Rajasthan","MobilePhone":"987654321","PostalCode":"30581","Email":"test@gmail.com","Country":"India","Call_Source__c":"Sales Person Created","Lead_Score__c":"Warm","Status":"Unqualified","Disqual_Reason__c":"Lack of Vision","Name":{"displayValue":null,"value":null},"recordId":""}';
        String dataElse= '{"FirstName":"Test","LastName":"User","Salutation":"Mr.","Company":"MTX Group Inc","Street":"123","Job_Title__c":"Architect","City":"Jaipur","Phone":"123456789","State":"Rajasthan","MobilePhone":"987654321","PostalCode":"30581","Email":"test@gmail.com","Country":"India","Call_Source__c":"Sales Person Created","Lead_Score__c":"Warm","Status":"Unqualified","Disqual_Reason__c":"Lack of Vision","Name":{"displayValue":null,"value":null},"recordId":"'+ leadId+'"}';
        
        Datetime leadDateFrom = date.newInstance(1983, 7, 15);
        Datetime leadDateTo = date.newInstance(1983, 7, 15);
        
        Test.startTest();
        Dal_LeadManager.searchOpenLead(String.valueOf(leadDateFrom),String.valueOf(leadDateTo));
        Dal_LeadManager.createLead(data);
        Dal_LeadManager.createLead(dataElse);
        Dal_LeadManager.searchAllLeads('Test','user','Direct Mail','Warm',String.valueOf(leadDateFrom.Date()),String.valueOf(leadDateTo.Date()),'Open',10);
        Dal_LeadManager.getStatusPickListValues();
        Dal_LeadManager.fetchCurrentUser();
        Dal_LeadManager.getRecordTypeIdForLead();
        Dal_LeadManager.fetchUsers('Preshit Chhabra');
        Dal_LeadManager.fetchLeadOwner(lstLead.Id);
        Dal_LeadManager.fetchAccounts('test');
        Dal_LeadManager.fetchContacts('test');
        // Dal_LeadManager.createOpportunity(opportunityValue);
        
        
        Test.stopTest();
    }
    @isTest(SeeAllData='true')
    public static void getLeadReport(){
        
        Lead  lstLead =   new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open');
        insert lstLead;
        
        Lead  AstLead =   new Lead(Company = 'Stark', LastName = 'Tony', Status = 'Open');
        insert AstLead;
        
        Lead  CtLead =   new Lead(Company = 'Avenger', LastName = 'Boss', Status = 'Open');
        insert CtLead;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Contact con = new Contact(FirstName ='test',LastName='user');
        insert con;
        
        String LeadConversionRange = '1 Month';
        String OpenLeadRange = '1 Month';
        String LeadStatusRange = '1 Month';
        
        String opportunityValueForAccount = '{"selectedOwner":"","sendEmail":false,"isAccountNew":false,"selectedAccount":"'+acc.Id+'","isContactNew":true,"selectedContact":"test Contact","opportunityName":"Google- test ","convertedStatus":"Qualified","opportunityRating":"hot","recordId":"'+ AstLead.Id +'"}"';
        system.debug('-opportunityValueForAccount----'+opportunityValueForAccount);
        String opportunityValueForContact = '{"selectedOwner":"","sendEmail":false,"isAccountNew":true,"selectedAccount":"test","isContactNew":false,"selectedContact":"'+con.Id+'","opportunityName":"Google- test ","convertedStatus":"Qualified","opportunityRating":"hot","recordId":"'+ CtLead.Id +'"}"';
        String opportunityValue = '{"selectedOwner":"","sendEmail":false,"isAccountNew":true,"selectedAccount":"test","isContactNew":true,"selectedContact":"test Contact","opportunityName":"Google- test ","convertedStatus":"Qualified","opportunityRating":"hot","recordId":"'+ lstLead.Id +'"}"';
        test.startTest();
        Dal_LeadManager.getReportForLeadConversion(LeadConversionRange);
        Dal_LeadManager.getReportForLeadOpen(OpenLeadRange);
        Dal_LeadManager.getReportForLeadStatus(LeadStatusRange);
        Dal_LeadManager.createOpportunity(opportunityValue);
        Dal_LeadManager.createOpportunity(opportunityValueForAccount);
        Dal_LeadManager.createOpportunity(opportunityValueForContact);
        test.stopTest();
    }
}