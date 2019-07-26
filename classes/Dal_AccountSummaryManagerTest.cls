@isTest
public class Dal_AccountSummaryManagerTest {
    
    @testSetup
    static void testsetup(){
        
    }
    static testmethod void accountSummaryTest(){
        
        List<DT_SYS_Account_Summary__x> accSummary = Dal_AccountSummaryManager.getAccountSummary(null);
        System.assert(true, accSummary.size()>0);
        
    }
    
}