@isTest(SeeAllData=true)
private class BatchUpdateApptointmentCurrentMonth_Test {

    private static testmethod void test() {  
          
        Test.startTest();
           BatchUpdateApptointmentCurrentMonth uca = new BatchUpdateApptointmentCurrentMonth();
           Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from contact where Test__c <> Null]);
        
    }
    
}