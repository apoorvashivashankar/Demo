@isTest
private class TestUserContactUtility  {

    static UserContactUtility con;
    
    static testMethod void runTest() {

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

    con = new UserContactUtility();
    con.hateThisController();

    }

}