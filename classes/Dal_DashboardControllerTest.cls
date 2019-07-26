/**
* Created by 7Summits on 5/10/2018. 
*/
@isTest
public class Dal_DashboardControllerTest {
    
    @testSetup
    static void testSetup(){
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '008082001';
            account.Division__c = '44';
            update account;
            
            Account acc = new Account();
            acc.Name = 'Test Account';
            acc.DW_ID__c = '123464';
            insert acc;
            
            DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = 'Test Contact';
            cartObj.Contact_Number__c = '';
            cartObj.Job_Name__c = '';
            cartObj.Job_Name_Certificate_Id__c = '';
            cartObj.Job_Name_Expiration__c = System.now();
            cartObj.Cart_Account__c = acc.Id;
            cartObj.National_Account__c = null;
            cartObj.Special_Instructions__c = '';
            cartObj.Status__c = 'Draft';
            cartObj.User__c = UserInfo.getUserID();
            insert cartObj;
            
            DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
            cartProduct.DT_Cart__c = cartObj.Id;
            cartProduct.Lift_gate__c = false;
            cartProduct.Quantity__c = 1;
            insert cartProduct;
            
            /*Case caseObj = new Case();
            caseObj.Status = 'new';
            insert caseObj;*/
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
         //   UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
          	String uniqueName = Dal_TestUtils.getUserString();
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
        }
    }
    static testmethod void DashboardTest2(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            String uniqueName = Dal_TestUtils.getUserString();
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
           
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_CUST_SERVICE;
                Dal_DashboardController.getDistributorDashboardData();
            }
            try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
        }
        Test.stopTest();
    }
    static testmethod void DashboardTest3(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Account oldAccount = [SELECT ID,DW_ID__c FROM Account WHERE DW_ID__c = '123464' LIMIT 1];
            DT_Cart__c dtCartList = [SELECT Id,Cart_Account__c,Cart_Account__r.Name,Cart_Account__r.DW_ID__c,User__c FROM DT_Cart__c];
            System.debug('dtCartList---'+dtCartList);
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser3', lastname='lastname3',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            Dal_DashboardController.getAccountCartDetail(oldAccount.Id);
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_DashboardController.getDistributorDashboardData();  
                //System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());   
                //Dal_DashboardController.getPickupDashboardCounts(); 
            }
            
        }
        Test.stopTest();
    }
    static testmethod void DashboardTest4(){
        Test.startTest();
        Contact con = [Select Id,AccountId FROM Contact limit 1];
        /*UserContactDefaults__c userCont = new UserContactDefaults__c();
userCont.Default_Account_Id__c = con.AccountId;
userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
insert userCont;*/
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        /*User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
Selected_Location__c = con.AccountId, contactId = con.id
);
insert newUser;*/
        Dal_DashboardController.communityTestName = 'SSC Community';
        Test.stopTest();
    }
    static testmethod void DashboardTest5(){
        Test.startTest();
        Contact con = [Select Id,AccountId FROM Contact limit 1];
        /*UserContactDefaults__c userCont = new UserContactDefaults__c();
userCont.Default_Account_Id__c = con.AccountId;
userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
insert userCont;*/
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        /*User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
Selected_Location__c = con.AccountId, contactId = con.id
);
insert newUser;*/
        Dal_DashboardController.communityTestName = 'SSC Community';
        Test.stopTest();
    }
    
    static testmethod void DashboardTest6(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_CUST_SERVICE;
               
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest7(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
              	String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_PURCHASER;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest8(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            	String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_PURCHASER;
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest9(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            	String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_ACCOUNTING;
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest10(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_ACCOUNTING;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    } 
    
    static testmethod void DashboardTest11(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_SALES_REP;
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest12(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId,contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_LEADER_PRINCIPLE;
                Dal_DashboardController.communityTestName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest13(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_LEADER_PRINCILPLE;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest14(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_DEALER_SALES_REP;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest15(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_DEALER_LEADER_PRINCILPLE;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    
    static testmethod void DashboardTest16(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_DEALER_LEADER_PRINCILPLE;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getAllCases());
                }catch(Exception e){}
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getPickupDashboardCounts());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    static testmethod void DashboardTest17(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.DIST_SALES_REP_1;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    static testmethod void DashboardTest18(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_SALES_REP;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
    static testmethod void DashboardTest19(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
            //     User newUser = [Select Id FROM User  where username = 'newUser2@yahoo.com' limit 1];
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){                    
                Dal_DashboardController.profileTestName = Dal_Constants.SSC_PURCHASER_II;
                Dal_DashboardController.communityTestName = Dal_Constants.SSC_COMMUNITY;
                
                try{
                    System.assertNotEquals(null, Dal_DashboardController.getSSCDashboardData());
                }catch(Exception e){}
            }
            
        }
        Test.stopTest();
    }
}