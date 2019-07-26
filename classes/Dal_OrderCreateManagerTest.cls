@isTest(seeAllData=false)
public class Dal_OrderCreateManagerTest {
    
    @testSetup
    static void testSetup(){
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c dtorder = new DT_Order__c();
            dtorder.Name = 'test-dtorder-name';
            dtorder.Delegate_First_Name__c = '123';
            dtorder.Requested_Ship_date__c = system.today();
            dtorder.Default_Requested_Ship_Date__c = system.today();
            dtorder.Carrier__c = '8ret';
            insert dtorder;
            
            DT_Order_Product__c dtorderproduct = new DT_Order_Product__c();
            dtorderproduct.Name = '0000';
            dtorderproduct.DT_Order_Id__c = dtorder.Id;
            insert dtorderproduct;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            account.Division__c = 'OASIS';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
          String uniqueName = Dal_TestUtils.getUserString(); 
            User newUser = new User(profileId = p.id,username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
        }
        
    }
    @isTest static void testMethod1(){
        /*Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1]; 
        User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
        emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
        Selected_Location__c = account.Id, contactId = con.id
        );
        insert newUser; */
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com' LIMIT 1];
        DT_Order__c dtorder = [SELECT Id FROM DT_Order__c LIMIT 1];
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new Dal_OrderCreateMock());
            Dal_OrderCreateManager dalordercreatemanager = new Dal_OrderCreateManager(dtorder.Id);
            dalordercreatemanager.getOrderCreate();
        }	
        test.stopTest();
    }
    
}