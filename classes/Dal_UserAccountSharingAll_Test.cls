@isTest(seeAllData=false)
public class Dal_UserAccountSharingAll_Test {
    
    @TestSetup
    static void datasetup(){
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();  
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '008082001';
        	account.GroupKey__c = '99999';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;

           
                Profile p = [select Id,name from Profile where name = 'Customer Community Plus Login User'];
                String uniqueName = Dal_TestUtils.getUserString();
                User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                        emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                        timezonesidkey = 'America/Los_Angeles', alias = 'nuser', lastname = 'lastname',
                        Selected_Location__c = con.accountId, contactId = con.id,Share_All_Group_Accounts__c = true
                );
                insert newUser;
        }
    }    
    static testMethod void getOrdersFullFilment(){
        User u = [SELECT Id,lastname FROM User WHERE lastname = 'lastname' LIMIT 1];
        System.runAs(u){
            Dal_UserAccountSharingAll.generateSharing();
        }
        
    }
}