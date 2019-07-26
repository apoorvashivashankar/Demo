/**
 * Created by 7Summits on 3/5/18.
 */
public with sharing class Dal_StatementListController {
    
    /**
    * This Class return all the data required from External Object "DT_SYS_Account_Statement__x" 
    * @return Peak Response
    */
    
    @TestVisible 
    private static list<DT_SYS_Account_Statement__x> mockedAccountStatement = new List<DT_SYS_Account_Statement__x>();
    Public static List<DT_SYS_Account_Statement__x> statementSummary = new List<DT_SYS_Account_Statement__x>();
	Public static Account selectedAccount = Dal_BaseController.getUserSelectedLocation();

    //Calling Dal_StatementListManager method getStatementSummarybyCustomer and getting 'DT_SYS_Account_Statement__x' External object data.   
    @AuraEnabled
    public static StatementsWrapper getStatementSummarybyCustomer(Integer listLimit) {
        StatementsWrapper statementsWrapper = new StatementsWrapper();

        // get account summary data
        if(!Test.isRunningTest()){
           statementSummary = Dal_StatementListManager.getStatementSummarybyCustomer(selectedAccount.PayerAccount__c, listLimit);
        } else {
            statementSummary.addAll(mockedAccountStatement);
        }

        // set the statement and account name to the object
        statementsWrapper.accountName = selectedAccount.Name;
        statementsWrapper.statements = statementSummary;

        return statementsWrapper;
    }
    
    //This method call Dal_StatementListManager class by passing date and getting statement Summary of external object by date.    
    @AuraEnabled
    public static StatementsWrapper getStatementSummarybyDate(Date startDate, Date endDate, Integer listLimit) {
        StatementsWrapper statementsWrapper = new StatementsWrapper();

        // get account summary data
        if(!Test.isRunningTest()){
           statementSummary = Dal_StatementListManager.getStatementSummarybyDate(startDate, endDate, selectedAccount.PayerAccount__c, listLimit);
        }else{
           statementSummary.addAll(mockedAccountStatement);
        }

        // set the statement and account name to the object
        statementsWrapper.accountName = selectedAccount.Name;
        statementsWrapper.statements = statementSummary;

        return statementsWrapper;
    }

    public class StatementsWrapper {
        @AuraEnabled public String accountName {get;set;}
        @AuraEnabled public List<DT_SYS_Account_Statement__x> statements{get;set;}

        public StatementsWrapper(){
            accountName = null;
            statements = null;
        }
    }

}