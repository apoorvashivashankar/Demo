@isTest(SeeAllData=false)
public class Dal_Address_Validation_ControllerTest {

    @testSetup
    static void testsetup(){
        
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
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
          //  UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
           
        }
    
    }
   @isTest 
   static void getATP_By_TimePhaseTest(){
       Contact con = [SELECT Id FROM Contact];
       Account account = [SELECT Id FROM Account];
         Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        String uniqueName = Dal_TestUtils.getUserString();
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
       
       
        
        Test.startTest();
        System.runAs(newUser){
			Test.setMock(WebServiceMock.class, new WebServiceMockDalImplAddValidation());
            String lineOne = '502';
            String lineTwo = 'Overlook Dr';
            String stateProvince = 'TX';
            String city = 'Rockwall';
            String code = '75032-8952';
            String country = 'US';
            String errorMessage = 'No Record Found';
            String successMessage = 'Successfully Validated';
            Dal_Address_Validation_Controller.getValidatedAddress(lineOne, lineTwo, stateProvince, city, code, country);
        }
        Test.stopTest();
    }
}