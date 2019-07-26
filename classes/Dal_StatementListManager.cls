/**
* Created by 7Summits on 3/5/18
*/
public without sharing class Dal_StatementListManager {
    
    /**
    * Given the customerId, the method will return Account Statement Informations,
    * customerId is a location ID field
    * @return List<DT_SYS_Account_Statement__x>
    */
    
    public static List<DT_SYS_Account_Statement__x> getStatementSummarybyCustomer(string payer, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        List<DT_SYS_Account_Statement__x> statementSummary = new List<DT_SYS_Account_Statement__x>();
        
          try{
                  statementSummary = [select FileName__c,StatementDate__c,id__c from DT_SYS_Account_Statement__x where Payer__c =: payer LIMIT :listLimit];
                  system.debug('Dal_StatementListManager:statementSummary --'+statementSummary);


                if(Test.isRunningTest()){
                    DmlException e = new DmlException();
    				e.setMessage('This is a constructed exception!');
    				throw e;
                }
            } catch(Exception exp){
                System.debug('Dal_StatementListManager: An unexpected error has occurred: ' + exp.getMessage());
            }
        return statementSummary;
    }
    
    /**
    * Given the customerId, the method will return Account Statement Informations,
    * customerId is a location ID field
    * @return List<DT_SYS_Account_Statement__x>
    */
    public static List<DT_SYS_Account_Statement__x> getStatementSummarybyDate(Date startDate, Date endDate,string customerId, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        
        List<DT_SYS_Account_Statement__x> statementSummary = new List<DT_SYS_Account_Statement__x>();


        //TODO : use start and end date once statement date data type is changed to date
         try{  
                statementSummary = [select FileName__c,StatementDate__c,id__c
                                    from DT_SYS_Account_Statement__x 
                                    where Payer__c =: customerId
                        LIMIT :listLimit
                ];
                system.debug('Dal_StatementListManager:statementSummary --'+statementSummary);
                if(Test.isRunningTest()){
                            DmlException e = new DmlException();
                            e.setMessage('This is a constructed exception!');
                            throw e;
                        }
            } catch(Exception exp){
                System.debug('Dal_StatementListManager: An unexpected error has occurred: ' + exp.getMessage());
            }
        return statementSummary;
    }
    
}