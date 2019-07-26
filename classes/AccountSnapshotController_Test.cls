@isTest(seeAllData=true) 
public class AccountSnapshotController_Test {
    
    static testMethod void testMethod1() {
    
        Test.StartTest(); 

            ApexPages.currentPage().getParameters().put('id', '001A000000OOgSAIA1');
            
            AccountSnapshotController  acctSnapshot = new AccountSnapshotController();
            
            acctSnapshot.getSalesGrowthPlan();
            acctSnapshot.getTasks();
            acctSnapshot.getEvents();
            acctSnapshot.getSalesStatus();
            acctSnapshot.getYtdSalesGrid();
            acctSnapshot.getPieData();
            acctSnapshot.getOpportunitiesClosedWon();
            acctSnapshot.getOpportunitiesOpen();

        Test.StopTest();
    }
    
}