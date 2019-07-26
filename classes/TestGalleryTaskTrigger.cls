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
private class TestGalleryTaskTrigger {

    static testMethod void myUnitTest() {
        Account a1 = new Account(
            name = 'TestAcct1'
            ); 
        
        insert a1;
        
        Opportunity o1 = new Opportunity (  
            AccountId = a1.Id
            , Name = 'TEST OPP1'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , CloseDate=  date.today()
            , StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
            );
        insert o1;
        
        Task t=new Task();
            t.WhatId=o1.Id;
            t.RecordTypeId='012F0000000mpvb';
            t.Number_of_Gallery_Visits__c=8;
            t.OwnerId=UserInfo.getUserId();
            t.Status='Completed';
            t.Gallery_Visit_Date__c=Date.today().addDays(3);
            t.Gallery_Visit_From_Opp__c=true;
            t.Gallery_Visit_Instructions__c='Test';
        insert t;
    }
    
}