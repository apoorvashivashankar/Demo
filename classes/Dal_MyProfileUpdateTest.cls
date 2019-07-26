@isTest(seeAllData=false)
public class Dal_MyProfileUpdateTest {
    @testSetup
    static void testSetup(){
        User Objuser = [Select id from user where profile.name='System Administrator' AND Isactive=true AND Userroleid!=null limit 1];
        System.runAs(Objuser) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'TestOrder1';
            insert order;
            system.debug('Test 1');
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            account.Division__c = 'OASIS';
            update account;
            system.debug('Test 2');
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            system.debug('Test 3');
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            
            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            system.debug('Test 4');
            insert newUser;
            system.debug('Test 5');
        }
    }
    public static testMethod void orderProcessTest() {   
        system.debug('Test 6');
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
       system.debug('Test 7');
        Dal_MyProfileUpdate.getIndividualJobDetail(newUser.Id); 
        system.debug('Test 8');
        Dal_MyProfileUpdate.saveUserRecord(newUser);    
    }   
}