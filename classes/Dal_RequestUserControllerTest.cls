/**
 * Created by 7Summits on 2/21/18
 */
@isTest(SeeAllData=false)

public class Dal_RequestUserControllerTest {
    
    static testmethod void webtocasetest() {  
      	//setup test data
        Account newacct = Dal_TestUtils.createTestAccount();
        Group g1 = new Group(Name='Manage Distributor User', type='Queue');
        insert g1;
        
        Test.startTest();
        
        Peak_Response response = Dal_RequestUserController.webtoCase(newacct.AccountNumber,'test','TestUser','LastName','test@test.com','123-45-5678',false);
        system.assertEquals(response.success, false);
        string emessage = null;
        Peak_Response responseerr = Dal_RequestUserController.webtoCase('dummy','teast','TestUser','LastName','test@test.com','123-45-5678',false);
        system.assertEquals(responseerr.success,false);
        
        Test.stopTest();
    }
 


}