@isTest
private class Dal_DeleteOrderBatchTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @testSetup 
    static void setup() {
        Date todayValue = System.today().addDays(-7);
        String Submit = 'Submit';
        List<DT_Order__c> orders = new List<DT_Order__c>();
        for (Integer i=0;i<10;i++) {
            orders.add(new DT_Order__c(name='order'+i, 
                Submit_Date__c= todayValue, Status__c= Submit));
        }
        insert orders;
    }
    static testmethod void test() {        
        Test.startTest();
          String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new Dal_DeleteOrderBatch()); 
        Test.stopTest();
        System.assertEquals(10, [select count() from DT_Order__c where Status__c = 'Submit']);
    }
    
}