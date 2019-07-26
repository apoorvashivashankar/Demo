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
public with sharing class  testAutosubProfCR {
	static testMethod void runPCRTest() {
    
    ssc__C s = new ssc__c(  Name='asa',
                            Manager__c=UserInfo.getUserID(),
                            Stone__c=TRUE,
                            DW_ID__c='666'                                  
                            );
    Insert s;
        Test.startTest(); 
        System.debug('::::Starting Test....');
        Profile_Change_Request__c pcr = new Profile_Change_Request__c();
                    // c.RecordtypeId='012Z0000000CpSa';
                     pcr.Stone_Center_Name__c=s.ID;
                     pcr.Item_Number__c='12345';
                     pcr.Color_Description__c='red';
                     pcr.Current_Inventory_sqft__c=Decimal.valueOf('12345');
//                     pcr.Monthly_Sales_Forecast_sqft__c=Decimal.valueOf('12345');
//                     pcr.Thickness_Finish__c='12x12';
                     try{
                        Insert pcr;
                        UPDATE pcr;
                        System.debug('::::First Test Status:....' + pcr.Status__c);
                     }
                     catch(Exception e){}
        System.debug('::::Starting Test....');
        Profile_Change_Request__c pcr1 = new Profile_Change_Request__c();
                    // c.RecordtypeId='012Z0000000CpSa';
                     pcr1.Stone_Center_Name__c=s.ID;
                     pcr1.Item_Number__c='12345';
                     pcr1.Color_Description__c='red';
                     pcr1.Current_Inventory_sqft__c=NULL;
                     pcr1.Monthly_Sales_Forecast_sqft__c=Decimal.valueOf('12345');
                     pcr1.Thickness_Finish__c='12x12';
                     try{
                        Insert pcr1;
                        UPDATE pcr1;
                        System.debug('::::Second Test Status:....' + pcr.Status__c);                       
                     }
                     catch(Exception e){}
                     pcr1.Current_Inventory_sqft__c=Decimal.valueOf('12345');
                     pcr1.Monthly_Sales_Forecast_sqft__c=NULL;
                     pcr1.Thickness_Finish__c=NULL;
                     try{
                        UPDATE pcr1;
                     }
                     catch(Exception e){}

        Profile_Change_Request__c pcr2 = new Profile_Change_Request__c();
                    // c.RecordtypeId='012Z0000000CpSa';
                     pcr2.Stone_Center_Name__c=s.ID;
                     pcr2.Item_Number__c='12345';
                     pcr2.Color_Description__c='red';
                     pcr2.Current_Inventory_sqft__c=Decimal.valueOf('12345');
                     pcr2.Monthly_Sales_Forecast_sqft__c=NULL;
                     pcr2.Thickness_Finish__c=NULL;
                     try{
                        Insert pcr2;
                     }
                     catch(Exception e){}
                     pcr2.Current_Inventory_sqft__c=NULL;
                     pcr2.Monthly_Sales_Forecast_sqft__c=Decimal.valueOf('12345');
                     pcr2.Thickness_Finish__c='12x12';
                     try{
                        UPDATE pcr2;
                        System.debug('::::Last Test Status:....' + pcr.Status__c);
                     }
                     catch(Exception e){}				
        			System.debug('::::Done With Test....');
					Test.stopTest();	
      }
}