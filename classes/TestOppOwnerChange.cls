/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestOppOwnerChange {

    static testMethod void myUnitTest() {
        Account acc=new Account();
        acc.Name='Test Acc';
        insert acc;
        Account acc2=new Account();
        acc2.Name='Test Acc2';
        insert acc2;
        Opportunity o=new Opportunity();
        o.Name='test';
        o.AccountId=acc.id;
        //Below line is uncommented  by SR
        o.OwnerId=userinfo.getUserId();
        o.CloseDate=date.today();
        o.StageName='Design';
        try{
           insert o;
        }
        catch(Exception e){}
        Account a = new Account(name = 'x');
        insert a;
        //User u=[select id from User where id!=:o.OwnerId AND IsActive=TRUE limit 1];
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
                        , email= 'sometestemailfortestingpurposes@daltile.com'
                        , emailencodingkey='UTF-8'
                        , lastname='Test'
                        , firstname='Test'
                        , languagelocalekey='en_US'
                        , localesidkey='en_US'
                        , timezonesidkey='GMT'
                        , ProfileId =profileId
                        , username = 'abc123BC@daltile.com');
         
        
        insert u;
        if(u!=null){
            o.OwnerId=u.id;
        }
        o.AccountId=acc2.id;
        try{
           update o;
        }
        catch(Exception e){}
        
        
    }
}