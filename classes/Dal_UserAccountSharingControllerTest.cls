/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_UserAccountSharingControllerTest {
    
    static testMethod void getOrdersFullFilment(){ 
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        insert testAccount;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);        
    	Dal_UserAccountSharingController uasc = new Dal_UserAccountSharingController(sc);
        uasc.createSharing();
    }

}