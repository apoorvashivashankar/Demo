@isTest
public class Dal_NavigationControllerTest {
    
    @testSetup
    static void testSetup(){
        
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '008082001';
            account.Division__c = '44';
            update account;
            
           /*
            Case caseObj = new Case();
            caseObj.Status = 'new';
            insert caseObj;
            */
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
        }
    }
    
    static testmethod void NavigationTest(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();

            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_CUST_SERVICE;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_PURCHASER;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_ACCOUNTING;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_SALES_REP;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_LEADER_PRINCIPLE;
                Dal_NavigationController.fetchNavMenuVisibilty();    
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_CUST_SERVICE;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_PURCHASER;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_ACCOUNTING;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_SALES_REP;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_LEADER_PRINCILPLE;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_DEALER_SALES_REP;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_DEALER_LEADER_PRINCILPLE;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.DISTRIBUTOR_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.DIST_SALES_REP_1;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
                Dal_NavigationController.communityName = Dal_Constants.SSC_COMMUNITY;
                Dal_NavigationController.profileName = Dal_Constants.SSC_PURCHASER_II;
                Dal_NavigationController.fetchNavMenuVisibilty();
                
            }
            
        }
        Test.stopTest();
    }
    static testmethod void NavigationTest1(){
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User' limit 1];
            String uniqueName = Dal_TestUtils.getUserString();
         
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser2', lastname='lastname2',
                                    Selected_Location__c = con.AccountId, contactId = con.id
                                   );
            insert newUser;
            System.runAs(newUser){
                Dal_NavigationController.fetchNavMenuVisibilty();
            }
        }
        Test.stopTest();
    }
    
}