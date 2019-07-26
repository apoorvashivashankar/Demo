@isTest
private class testAccountStoneCenterTrigger {
	
    static testMethod void testBulkInsert() {

    List<Sales__c> sales = new List<Sales__c>();
    List<account> accts = new List<account>();
    SSC__c ssc = new SSC__c(Closed__c = false
	, DW_ID__c = '123'    	
	, Stone__c = TRUE
	, Loc_Type__c = 'SSC');
    insert ssc;



    Account a = new Account(
   	Name='TestAccount');
    insert a;

    System.debug('RD 1 - The Account : ' + a.Name + ' / Stone Center: ' + a.Stone_Center__c);


    // add 200 sales to the list to be inserted
    for (Integer b=0;b<200;b++) {
        Sales__c s = new Sales__c(
            Account__c = a.ID,
            loc_sf__c = '123',
            DW_ID__C = '123' + b);
        sales.add(s);
    }
    System.debug('The Account : ' + a);  

    // Switch to the runtime context
    Test.startTest();  

        try{
           insert sales;
        }
        catch(Exception e){
            System.debug('::::testAccountStoneCenterTrigger + testBulkInsert::::> ' + e.getMessage());
        }        

    // Switch back to the original context
    Test.stopTest();     

    // query for all accounts created and assert that the Stone Center was added correctly from the Sales records
//    for (Account a1: [Select Stone_Center__c from Account WHERE ID = :a.Id]) {
  //      System.debug('a1.Stone_Center__c : ' + a1.Stone_Center__c + ' / sscId: ' + sscId);
    //    System.assertEquals(a1.Stone_Center__c, sscId);
    //}
    }
}