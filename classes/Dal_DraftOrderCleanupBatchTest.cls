/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Dal_DraftOrderCleanupBatchTest {

    @testSetup
    static void setup() {
        Date todayValue = System.today().addDays(-7);
        String Draft = 'Draft';
        List<DT_Order__c> orders = new List<DT_Order__c>();
        for (Integer i=0;i<10;i++) {
            orders.add(new DT_Order__c(name='order'+i, Status__c= Draft));
        }
        insert orders;
		
    }
    static testmethod void test() {
        List<DT_Order__c> orders = [Select Id, name FROM DT_Order__c];
        Test.startTest();
            Dal_DraftOrderCleanupBatch docb = new Dal_DraftOrderCleanupBatch();
            Database.QueryLocator ql = docb.start(null);
            docb.execute(null,orders);
            docb.Finish(null);        
        Test.stopTest();

    }

}