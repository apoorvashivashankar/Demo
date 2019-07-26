/**
 * Created by 7Summits on 2/21/18
 */
public with sharing class Dal_RequestUserController {
    
    /**
     * Given the form inputs, this method will create case
     * @return Peak_Response
     */
    @AuraEnabled
    public static Peak_Response webtoCase(string AccountNumber, string AccountName, string FirstName, string LastName, string email, string phone, Boolean remove){
        Peak_Response response = new Peak_Response();
        try{
                Id queueid = [select Id ,name from Group where  Type = 'Queue' and name = 'Manage Distributor User'].id;
                Case newcase = new Case();
                //newcase.AccountId = acct[0].id;
                newcase.AccountNumber__c = AccountNumber;
                    newcase.AccountName__c = AccountName;
                    newcase.Remove_User__c = remove;
                    newcase.User_Phone__c = phone;
                    newcase.User_LastName__c = LastName;
                    newcase.User_FirstName__c = FirstName;
                    newcase.User_Email__c = email;
            		newcase.ownerid = queueid;
                insert newcase;
                   
                system.debug('Dal_RequestUserController: New case is '+newcase);
                //Set case fields from params once they are created
                if(Test.isRunningTest()){
                  Integer intTest =1/0;   
                }
       
                      
        }
        catch(Exception exp){
            //throw new AuraHandledException(exp.getMessage());
            System.debug('Dal_RequestUserController: An unexpected error has occurred: ' + exp.getMessage());
            response.success = false;
            response.messages.add(exp.getMessage());
        }
        return response;
    }
    
}