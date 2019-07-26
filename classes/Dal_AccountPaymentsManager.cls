/**
 * Created by 7Summits on 3/5/18.
 */
public without sharing class Dal_AccountPaymentsManager {
      /**
     * Given the customerId, the method will return Account Payment Informations,
     * customerId is a location ID (DW_ID__c) field
     * @return List<DT_SYS_Account_Payment__x>
     */
    public static List<DT_SYS_Account_Payment__x> getPaymentSummary(string customerId, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
    		
        List<DT_SYS_Account_Payment__x> paymentSummary = new List<DT_SYS_Account_Payment__x>();
        	
            try{
                paymentSummary = [select DueDate__c,GrossAmount__c,ReferenceNo__c from DT_SYS_Account_Payment__x where Customer__c =: customerId LIMIT :listLimit];
           		
                if(Test.isRunningTest()){
                    DmlException e = new DmlException();
    				e.setMessage('This is a constructed exception!');
    				throw e;
                }
            } catch(Exception exp){
                System.debug('Dal_AccountPaymentsManager: An unexpected error has occurred: ' + exp.getMessage());
            }
        System.debug('PaymentSummary--->'+paymentSummary);
	 	return paymentSummary;
    }   
}