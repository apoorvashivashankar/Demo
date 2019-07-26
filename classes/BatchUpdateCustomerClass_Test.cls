@isTest(SeeAllData=true)
private class BatchUpdateCustomerClass_Test {

    private static testmethod void test() {  
          
        Test.startTest();
            BatchUpdateCustomerClassCount uca = new BatchUpdateCustomerClassCount();
            Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        
        // after the testing stops, assert records were updated properly
        //System.assertEquals(10, [select count() from contact where Test__c <> Null]);
        
    }
    
}