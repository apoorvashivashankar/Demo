@isTest
public with sharing class testPCRTrigger {

static testMethod void runPCRTest() {
    
    ssc__C s = new ssc__c(  Name='asa',
                            Manager__c=UserInfo.getUserID(),
                            DW_ID__c='666'                                  
                            );
    Insert s;
        
        Profile_Change_Request__c pcr = new Profile_Change_Request__c();
                    // c.RecordtypeId='012Z0000000CpSa';
                     pcr.Stone_Center_Name__c=s.ID;
                     pcr.Item_Number__c='12345';
                     pcr.Color_Description__c='red';
                     pcr.Current_Inventory_sqft__c=Decimal.valueOf('12345');
                     pcr.Monthly_Sales_Forecast_sqft__c=Decimal.valueOf('12345');
                     pcr.Thickness_Finish__c='12x12';
                     try{
                        Insert pcr;
                        UPDATE pcr;
                     }
                     catch(Exception e){}

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
                     }
                     catch(Exception e){}

      }
     
  
}