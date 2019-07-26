/**
 * Created by 7Summits on 3/1/18
 */
public without sharing class Dal_SSC_PrimaryAccountController {

     /**
     * This method will return SSC__c object on basis of selected location id presnent in Account.
     * @return Peak_Response
     */
    
    @AuraEnabled
    public static AddressWrapper getPrimarySSCLocation(){
    	
    	AddressWrapper wrapper;
        
       // Calling of utility class "Dal_BaseController" return account with selected location.
       Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
       
       // fetching SSC__c object from selected Account and setting it in Peak Response utlity class .
           if(selectedAccount !=null) {
               SSC__c storeaddress = [Select id, Name, City__c, Street_Address__c, Zip_Code__c, State__c, SSC_Phone_Number__c, SSC_Fax_Number__c from SSC__c where id =: selectedAccount.SSC__c];
               system.debug('storeaddress '+storeaddress); 
               if(storeaddress != null) {
                    System.debug('in'+storeaddress);
                    list<Hours_Of_Operation__c> hours = [select Close_Time__c,Open_Time__c,Name from Hours_Of_Operation__c where SSC__c =: storeaddress.Id];
                    system.debug('Hours_Of_Operation__c '+hours);
                    wrapper  = new AddressWrapper(storeaddress,hours);
                   	System.debug('wrapper-->'+wrapper);
                }
           }
          
       return wrapper ;
    }
    public class AddressWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String City;
        @AuraEnabled public String Street_Address;
        @AuraEnabled public String Zip_Code;
        @AuraEnabled public String State;
        @AuraEnabled public String SSC_Phone_Number;
        @AuraEnabled public String SSC_Fax_Number;
        @AuraEnabled public String mfstarthours;
        @AuraEnabled public String mfendhours;
        @AuraEnabled public String satstarthours;
        @AuraEnabled public String satendhours;
        @AuraEnabled public String sunstarthours;
        @AuraEnabled public String sunendhours;
            
            public AddressWrapper(SSC__c sscValue,List<Hours_Of_Operation__c> hours){
                   this.Name = sscValue.Name;
                   this.City = sscValue.City__c;
                   this.Street_Address =sscValue.Street_Address__c;
                   this.Zip_Code = sscValue.Zip_Code__c;
                   this.State = sscValue.State__c;
                   this.SSC_Phone_Number = sscValue.SSC_Phone_Number__c;
                   this.SSC_Fax_Number = sscValue.SSC_Fax_Number__c;
                   for(Hours_Of_Operation__c hour :hours)
                    {
                        if(hour.Name == 'Saturday')
                        {
                            this.satstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                            this.satendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute());                            
                        }
                        else if (hour.Name == 'Monday' || hour.Name == 'Tuesday' || hour.Name =='Wednesday' ||hour.Name =='Thursday' || hour.Name =='Friday'){
                          	this.mfstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                            this.mfendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute()); 
                        }
                        else if(hour.Name == 'Sunday'){
                            this.sunstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                            this.sunendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute()); 
                        }
                       
                    }
            }
    }
}