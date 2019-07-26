@isTest(seeAllData=true) 
public class AccountGroupKeySnapshotController_Test {
    
    static testMethod void testMethod1() {
    
        Test.StartTest(); 

            Account a = [SELECT ID, GroupKey__c, DW_ID__c FROM ACCOUNT WHERE Id = '0010G00001vEDyLQAW'];
    
           //invoke the page that runs the controller methods
            Test.setCurrentPage(Page.AccountGroupkeySnapshotTest);
            
            ApexPages.currentPage().getParameters().put('id', '0010G00001vEDyLQAW');
            
            ApexPages.StandardController sc                 = new ApexPages.StandardController(a);
            AccountGroupKeySnapshotController  acctSnapshot = new AccountGroupKeySnapshotController(sc);

            
            acctSnapshot.getSalesStatus();
            acctSnapshot.getSalesByProductTeam();
            acctSnapshot.getProductTeamPieData();
            acctSnapshot.getSalesByAccount();
            acctSnapshot.getAccountPieData();
            acctSnapshot.getSalesByProductLine();
            acctSnapshot.getSalesByPeriod();
            acctSnapshot.getPieData();
            
            acctSnapshot.getDivisionOptions();
            acctSnapshot.getDateOptions();
            acctSnapshot.refreshSales();
            
            System.currentPageReference().getParameters().put('division', 'All');
            System.currentPageReference().getParameters().put('date', 'Previous Year / All Periods');
            
            acctSnapshot.selectedDivisionVal = 'All';
            acctSnapshot.selectedDateVal     = 'Previous Year / All Periods';
            
            
            acctSnapshot.getSalesStatus();
            acctSnapshot.getSalesByProductTeam();
            acctSnapshot.getProductTeamPieData();
            acctSnapshot.getSalesByAccount();
            acctSnapshot.getAccountPieData();
            acctSnapshot.getSalesByProductLine();
            acctSnapshot.getSalesByPeriod();
            acctSnapshot.getPieData();
            
            acctSnapshot.getDivisionOptions();
            acctSnapshot.getDateOptions();
            acctSnapshot.refreshSales();

          
            for(Integer i=0;i<12;i++) {        
                acctSnapshot.getMonthName(i);
            }
        
        Test.StopTest();
    }
    
}