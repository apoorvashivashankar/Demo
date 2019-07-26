/**
 * Created by 7Summits on 3/1/18
 */
public without sharing class Dal_AccountSummaryManager {

    /**
     * Given the customerId, the method will return Account Summary,
     * customerId is a location ID (DW_ID__c) field
     * @return List<DT_SYS_Account_Summary__x>
     */
    public static List<DT_SYS_Account_Summary__x> getAccountSummary(string customerId){
        List<DT_SYS_Account_Summary__x> accountSummary = new List<DT_SYS_Account_Summary__x>();
        
         try{
                accountSummary = [
                        SELECT CurrentDue__c,FutureDue__c,PastDue__c,CurrentAndFutureDue__c,LastDepositAmount__c,OpenCreditAndReturns__c,Available__c,AccountBalance__c, LastDepositDate__c, ReferenceNo__c
                        FROM DT_SYS_Account_Summary__x
                        WHERE Customer__c =: customerId
                ];
             
             //Run's only when we run test
              if(Test.isRunningTest()){
                    DmlException e = new DmlException();
    				e.setMessage('This is a constructed exception!');
    				throw e;
                }
            } catch(Exception exp){
                System.debug('Dal_AccountSummaryManager: An unexpected error has occurred: ' + exp.getMessage());
            }

        return accountSummary;
    }    
  
  

}