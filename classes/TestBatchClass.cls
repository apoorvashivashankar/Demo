@IsTest(SeeAllData=true)
private class TestBatchClass{
static testmethod void testm1()
    {
     /*   test.startTest();
        database.executebatch(new CRPendingcount());
        test.stopTest();*/
        CRPendingcount bc = new CRPendingcount();
        bc.query = 'select id from change_request__c where Change_Request_Age__c>2 limit 100';
        
        Test.startTest();
        Database.executeBatch(bc, 100);
        Test.stopTest();
        
    }}