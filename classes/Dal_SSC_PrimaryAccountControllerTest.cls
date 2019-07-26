@isTest(seeAllData=false)
public class Dal_SSC_PrimaryAccountControllerTest {
    
    @TestSetup
    private static void testSetup(){    
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();  
        
        List<SSC__c> sscList = new List<SSC__c>();
        SSC__c ssc = new SSC__c();
        ssc.Name = 'SSC Account';
        sscList.add(ssc);
        insert sscList;
        
        Datetime cDT = System.now();
        List<Hours_Of_Operation__c> hoursList = new List<Hours_Of_Operation__c>();
        Hours_Of_Operation__c hours = new Hours_Of_Operation__c();
        hours.Open_Time__c = cDT.time();
        hours.Close_Time__c = cDT.time();
        hours.Name = 'Monday';
        hours.SSC__c = ssc.Id;
        hoursList.add(hours);
        Hours_Of_Operation__c hoursOne = new Hours_Of_Operation__c();
        hoursOne.Open_Time__c = cDT.time();
        hoursOne.Close_Time__c = cDT.time();
        hoursOne.Name = 'Sunday';
        hoursOne.SSC__c = ssc.Id;
        hoursList.add(hoursOne);
        Hours_Of_Operation__c hoursTwo = new Hours_Of_Operation__c();
        hoursTwo.Open_Time__c = cDT.time();
        hoursTwo.Close_Time__c = cDT.time();
        hoursTwo.Name = 'Saturday';
        hoursTwo.SSC__c = ssc.Id;
        hoursList.add(hoursTwo);
        
        insert hoursList;
        
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
    static testMethod void runPositivePrimaryAccountTest(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];

        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
          System.runAs(newUser){
            Dal_SSC_PrimaryAccountController.AddressWrapper response = Dal_SSC_PrimaryAccountController.getPrimarySSCLocation();  
            System.assert(response != null);
        //    System.assertEquals(true, response.success);
          } 
        Test.stopTest();
    }
    static testMethod void runNegativePrimaryAccountTest(){
        Test.startTest(); 
        	Dal_SSC_PrimaryAccountController.AddressWrapper response = Dal_SSC_PrimaryAccountController.getPrimarySSCLocation();
      	//  	System.assertEquals(false, response.success);
        Test.stopTest();
    }
}