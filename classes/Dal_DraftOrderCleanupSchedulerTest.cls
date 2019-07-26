/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/
@isTest
private class Dal_DraftOrderCleanupSchedulerTest {

    static testmethod void test() {
        Test.startTest();
            String Draft = 'Draft';
            List<DT_Order__c> orders = new List<DT_Order__c>();
            for (Integer i=0;i<10;i++) {
                orders.add(new DT_Order__c(name='order'+i, Status__c= Draft));
            }
            insert orders;

            // Schedule the test job
            String cron = '';
            String jobId = System.schedule('Dal_SubmittedDraftCleanupScheduler',
                                           Dal_DraftOrderCleanupScheduler.CRON_EXPRESSION,
                                           new Dal_DraftOrderCleanupScheduler());

            Dal_DraftOrderCleanupScheduler.schedule(cron);

            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
                              NextFireTime
                              FROM CronTrigger WHERE id = :jobId];

            // Verify the expressions are the same
            System.assertEquals(Dal_DraftOrderCleanupScheduler.CRON_EXPRESSION,
                                ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();

    }
}