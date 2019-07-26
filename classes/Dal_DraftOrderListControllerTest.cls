@isTest
public class Dal_DraftOrderListControllerTest {
    
    @isTest
    public static void testGetDraftOrders(){ 
     
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            
            User testUser = Dal_TestUtils.createStandardUser();
            insert testUser; 
            Account testAccount = [Select Id from Account where Name='Test Account' limit 1];
            testUser.Selected_Location__c = testAccount.Id;
            update testUser; 
            
            UserContactDefaults__c testSetting = new UserContactDefaults__c(Default_Account_Id__c=testAccount.Id, Default_Contact_Record_Type_Id__c='012F0000000msd2');
            insert testSetting;
            
            list <DT_Order__c> testOrders = new list <DT_Order__c>(); 
            for (integer i=0; i<5; i++){
                DT_Order__c testOrder = new DT_Order__c(AccountName__c = testAccount.Id);
                testOrders.add(testOrder); 
            }
            insert testOrders; 
        }
        
      //  system.runas(testUser){       
            list <DT_Order__c> testOrders = Dal_DraftOrderListController.getDraftOrders(5);
            system.debug('test orders: ' + testOrders);
//system.assert(testOrders.size() == 5);
       // }    
    }
    
    @isTest
    public static void testDeleteDraftOrder(){ 
        Account testAccount = Dal_TestUtils.createTestAccount();
        
        DT_Order__c testOrder = new DT_Order__c(AccountName__c = testAccount.Id);
        insert testOrder; 
        Boolean testBoolean = Dal_DraftOrderListController.deleteDraftOrder(testOrder.Id);  
        system.assert(testBoolean == true);
        
        Dal_DraftOrderListController.resumeDraftOrder(testOrder.Id);
    }
    
    @isTest
    public static void testResumeDraftOrder(){ 
        Account testAccount = Dal_TestUtils.createTestAccount();
        
        DT_Order__c testOrder = new DT_Order__c(AccountName__c = testAccount.Id);
        insert testOrder; 
        
        Dal_DraftOrderListController.resumeDraftOrder(testOrder.Id);
    }   
}