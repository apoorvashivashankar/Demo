/**
 * Created by 7Summits on 2/13/18.
 */

@IsTest
public class Dal_TestUtils {// Create an account so we can create a Contact
    
    static Integer s_num = 1;
    
    public static Account createTestAccount(){
        Account account = new Account(name=Peak_TestConstants.ACCOUNT_NAME, Division__c=Dal_TestConstants.USER_DIVISION);
        insert account;
        return account;
    }

    // Create a contact associated with an account
    public static Contact createTestContact(){
        Account account = createTestAccount();
        Contact contact = new Contact(firstName=Peak_TestConstants.FIRSTNAME, lastName=Peak_TestConstants.LASTNAME, email=Peak_TestConstants.STANDARD_EMAIL,Contact_Type__c = 'Service');
        contact.accountId = account.id;
        insert contact;

        return contact;
    }

    // create a standard user with selected location
    public static User createStandardUser() {
        User testUser;
        
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        system.runAs(new User(Id=userInfo.getUserId())) {

        Contact contact = createTestContact();

        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name='Customer Community Plus User'];


        if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            testUser = new User(
                Alias = Peak_TestConstants.STANDARD_ALIAS,
                Email=Peak_TestConstants.STANDARD_EMAIL,
                EmailEncodingKey=Peak_TestConstants.ENCODING,
                FirstName=Peak_TestConstants.FIRSTNAME,
                LastName=Peak_TestConstants.LASTNAME,
                LanguageLocaleKey=Peak_TestConstants.LOCALE,
                LocaleSidKey=Peak_TestConstants.LOCALE,
                ProfileId = standardProfile.Id,
                TimeZoneSidKey=Peak_TestConstants.TIMEZONE,
                UserName=Peak_TestConstants.STANDARD_USERNAME,
                CommunityNickname=Peak_TestConstants.FIRSTNAME,
                IsActive=true,
                ContactId=contact.id,
                Selected_Location__c=Dal_TestConstants.USER_SELECTED_LOCATION
              
            );

        }
        }
        return testUser;
    }
    
    

   public static String getFakeId(Schema.SObjectType sot)
   {
      String result = String.valueOf(s_num++);
      return sot.getDescribe().getKeyPrefix() + 
         '0'.repeat(12-result.length()) + result;
   }

    public static String getUserString(){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        return uniqueName;
    }
}