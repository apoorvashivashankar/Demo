@isTest(SeeAllData=false)
public class Dal_AccountOpenItemsControllerTest {

    @testSetup
    static void testSetup(){


        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();
            List<SSC__c> sscList = new List<SSC__c>();
            SSC__c ssc = new SSC__c();
            ssc.Name = 'SSC Account';
            sscList.add(ssc);
            insert sscList;


            Account account = new Account();
            account.Id = con.AccountId;
            account.SSC__c = ssc.Id;
            update account;

            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;

        }

    }
    static testmethod void accountOpenItemsTest(){

        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];

        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                Selected_Location__c = account.Id, contactId = contact.id


        );
        insert newUser;

        Test.startTest();
        System.runAs(newUser){
            Integer listLimit = 1000;
            List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> AccountWrap = Dal_AccountOpenItemsController.getAllOpenItems(listLimit);
            List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> AccountWrap1 = Dal_AccountOpenItemsController.getPastOpenItems(listLimit);
            List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> AccountWrap2 = Dal_AccountOpenItemsController.getCurrentOpenItems(listLimit);
            List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> AccountWrap3 = Dal_AccountOpenItemsController.getReturnsAndCreditsOpenItems(listLimit);
			Dal_AccountOpenItemsController.getBrandlist();
            Dal_AccountOpenItemsController.getBrandsAccount();
            Dal_AccountOpenItemsController.getCustomerId();
            Dal_AccountOpenItemsController.searchOpenAccount('','','','DalTile Sales SBU','2019-1-23','2019-1-25','',10);
        }
        Test.stopTest();

    }
}