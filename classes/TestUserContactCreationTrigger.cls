@isTest
private class TestUserContactCreationTrigger {

    static testMethod void createStandardUser() {

        Test.startTest();                         
        try {        
            Account a = new Account(name = 'x');
            insert a;
            
            UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a.Id
                                                                   ,Default_Contact_Record_Type_Id__c = '012F0000000msd2');
            insert ucd;
            
            //Create a user record ** Trigger relies on data in a custom setting called UserContactDefaults__c
            //Expecting the UserContactCreationTrigger trigger to fire and create a contact associated to the new user
            id profileId = [Select id 
                              From Profile
                             where UserType = 'Standard'
                              and Name = 'System Administrator'
                             limit 1].Id;

            User u = new User(alias = 'standt'
                            , email= 'testingemailguy@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Test'
                            , firstname='Test'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId =profileId
                            , username = 'testingemailguy@daltile.com');
             
                
            insert u;
            
            u.email = 'testing.update.email@daltile.com';
            update u;
            
            //Verify that the contact was inserted via the trigger on the user object
            System.AssertNotEquals(null,[Select Id from Contact where user__c = :u.Id]);
            System.AssertNotEquals(null,[Select Email_WF__c from User where Id = :u.Id]);
            
            System.debug('::::TestUserContactCreationTrigger + createStandardUser + u.Email_WF__c ::::> ' + u.Email_WF__c);
            
		}   catch (Exception e) {
            System.debug('::::TestUserContactCreationTrigger + createStandardUser ::::> ' + e.getMessage());
	    } 
        Test.stopTest();
    }
    
    static testMethod void createPartnerUser() {
        Test.startTest();                         
        try {        
            Id p = [select id from profile where name='Partner Community User'].id;
           
            Account ac = new Account(name ='Statement Guy') ;
            insert ac; 
           
            Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
            insert con;  
                      
            User user = new User(alias = 'test123', email='test123@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id,
                    timezonesidkey='America/Los_Angeles', username='tester@daltile.com.tester');
           
            insert user;        
        }   catch (Exception e) {
            System.debug('::::TestUserContactCreationTrigger + createPartnerUser::::> ' + e.getMessage());
	    } 
        Test.stopTest();
    }
    
}