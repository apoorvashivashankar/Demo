/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Dal_SubmittedDraftCleanupBatchTest {

    @testSetup
    static void setup() {

        String submitted = 'Submitted';
        List<DT_Order__c> orders = new List<DT_Order__c>();
        for (Integer i=0;i<10;i++) {
            orders.add(new DT_Order__c(name='order'+i, Status__c = submitted));
        }
        insert orders;

    }
    static testmethod void test() {
        List<DT_Order__c> orders = [Select Id, name FROM DT_Order__c];
        Test.startTest();
            Dal_SubmittedDraftCleanupBatch sdcb = new Dal_SubmittedDraftCleanupBatch();
            Database.QueryLocator ql = sdcb.start(null);
            sdcb.execute(null,orders);
            sdcb.Finish(null);
        Test.stopTest();

    }

}