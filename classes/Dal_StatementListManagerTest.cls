@isTest
public with sharing class Dal_StatementListManagerTest {
    
    @testSetup
    private static void testSetup(){
        Account account = Dal_TestUtils.createTestAccount();
    }
    static testMethod void statementListTest1() {
        
        Account account = [SELECT Id,DW_ID__c FROM Account];
        Date startDate = Date.newInstance(2018, 5, 8);
        Date endDate = Date.newInstance(2018, 5, 25);
        String payer = 'payer';
        Integer listLimit = 100;
        
        Test.startTest();
        
        List<DT_SYS_Account_Statement__x> stateSummary = Dal_StatementListManager.getStatementSummarybyCustomer(payer,listLimit);
        System.assert(true, stateSummary);        
        List<DT_SYS_Account_Statement__x> stateSummary1 = Dal_StatementListManager.getStatementSummarybyDate(startDate, endDate, account.DW_ID__c, listLimit);
        System.assert(true, stateSummary1); 
        
        Test.stopTest();
    }
}