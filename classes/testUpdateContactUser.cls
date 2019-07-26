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
private class testUpdateContactUser {

    static testMethod void myUnitTest() {

        //Create a user record ** Trigger relies on data in a custom setting called UserContactDefaults__c
        //Expecting the UserContactCreationTrigger trigger to fire and create a contact associated to the new user
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
        
        Region__c r04 = new Region__c(Select__c = true
        , SBU__c = 'SC'
        , DW_ID__c = '04'
        , Name = 'DT Mid-West');
        insert r04;

        Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
        , COS__c = 111
        , CustClass__c = 'S8Q'
        , Cust_Count__c = 123
        , Customer_Class_Details__c = 'TEST THIS'
        , CustomerCountry__c = 'US'
        , CustomerSBU__c = 'SC'
        , Duplicate__c = false
        , Net_Sales__c = 111
        , Price_Region__c = r04.Id
        , PPS_Rgn__c = '04');
        insert cc1;

        SSC__c ssc = new SSC__c(Closed__c = false
        , DW_ID__c = '000111'    
        , Loc_Type__c = 'SSC'
        , Manager__c = UserInfo.getUserId()
        , Region__c = r04.Id
        , ROM__c = UserInfo.getUserId()
        , RSM__c = UserInfo.getUserId()
        , RVP__c = UserInfo.getUserId()     
        , Sales_Region__c = '04'
        , SBU__c = 'SC'
        , Select__c = true
        , SSC_Fax_Number__c = '123-345-5567'
        , SSC_Phone_Number__c = '123-345-5567'
        , State__c = 'TX'
        , Street_Address__c = '12345 1st street'
        , Zip_Code__c = '12345');
        insert ssc;  
        
        Account a = new Account(Name='Person Account Test123',
        RecordTypeId = rt.id, 
        Region__c = r04.id, 
        SSC__c = ssc.id);
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = [SELECT ID, firstName, lastName, Name, email FROM User where ProfileID = :p.Id AND IsActive = TRUE LIMIT 1];
        Contact uC = new Contact ( firstName = u.firstName
                                 , lastName = u.lastName
                                 , email = u.email
                                 , User__c = u.Id
                                 , AccountId = a.Id);
        insert uC;
                    
        Case c = new Case (Origin = 'Email'
                         , SuppliedEmail = u.email
                         , SuppliedName = u.name
                         , Subject = 'Testing'
                         , Description = 'Test email from : ' + u.email);
        insert c;
        
        // Verify against support email address
        System.AssertNotEquals(null,[Select Id from Case where user__c = :u.Id]);
        
        Case c1 = new Case (Origin = 'Email'
                         , SuppliedEmail = 'empower@daltile.com'
                         , SuppliedName = 'Jonny Test-a-Lot'
                         , Subject = 'Testing'
                         , Description = 'Test email from : empower@daltile.com');
        insert c1;
        
        //Verify that the contact was inserted via the trigger on the user object
        System.AssertNotEquals(null,[Select Id from Case where user__c = :u.Id]);
        
    }
}