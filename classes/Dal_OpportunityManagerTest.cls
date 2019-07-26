/**
* Created by presh on 23-11-2018.
*/

@istest
public with sharing class Dal_OpportunityManagerTest {
    
    public static testMethod void getOpportunity(){
        
        List<Account> aList = new List<Account> {
            new Account (Name = 'My Test Account')
                };
                    
                    insert aList;
        
        List<Opportunity> oList = new List<Opportunity>();
        Opportunity opp =  new Opportunity();
        opp.Name ='00New mAWS Deal';
        opp.AccountID =aList[0].id;
        opp.StageName = 'Negotiations';
        opp.Amount = 3000;
        opp.CloseDate = System.today();
        oList.add(opp);
        Opportunity opp1 =  new Opportunity();         
        opp1.Name = '01mAWS Usage'; 
        opp1.AccountId = aList[0].id;
        opp1.StageName = 'Negotiations';
        opp1.CloseDate = System.today();
        opp1.Type = 'New Business';
        opp1.Amount = 555888555;
        oList.add(opp1);
        insert oList;
        Datetime oppDateFrom = date.newInstance(1983, 7, 15);
        Datetime oppDateTo = date.newInstance(1983, 7, 15);
        String oppDataEdit = '{"Name":"Google- test","Description":"looking for testing.","OwnerId":null,"StageName":"3 - Bidding","AccountId":"'+aList[0].id+'","Probability":"25","Amount":null,"Bid_Date__c":null,"recordId":"'+oList[0].Id+'","Bid_Date":null}';
        String oppData = '{"Name":"Google- test","Description":"looking for testing.","OwnerId":null,"StageName":"3 - Bidding","AccountId":"'+aList[0].id+'","Probability":"25","Amount":null,"Bid_Date__c":null,"recordId":"","Bid_Date":null}';
        Test.startTest();
        Dal_OpportunityManager.searchOpenOpportunity(String.valueOf(oppDateFrom),String.valueOf(oppDateTo));
        Dal_OpportunityManager.searchAllOpportunity('Test','user',String.valueOf(oppDateFrom.Date()),String.valueOf(oppDateTo.Date()),'Open',10);
        Dal_OpportunityManager.getStatusPickListValues();
        Dal_OpportunityManager.getRecordTypeIdForOpportunity();
        Dal_OpportunityManager.editOpportunity(oppData);
        Dal_OpportunityManager.editOpportunity(oppDataEdit);
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData='true')
    public static  void getOpportunityReport(){
        String oppConversionRange = '1 Month';
        String OpenOppRange = '1 Month';
        String oppStatusRange = '1 Month';
        Test.startTest();
        Dal_OpportunityManager.getReportForOpportunityConversion(oppConversionRange);
        Dal_OpportunityManager.getReportForOpportunityOpen(OpenOppRange);
        Dal_OpportunityManager.getReportForOpportunityStatus(oppStatusRange);
        Test.stopTest();
    }
}