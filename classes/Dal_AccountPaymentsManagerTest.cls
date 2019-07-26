@isTest
public class Dal_AccountPaymentsManagerTest {
    @testSetup
    private static void testSetup(){
        Account account = Dal_TestUtils.createTestAccount();
    }
    static testMethod void paymentSummaryTest() {
        Account account = [Select Id, Name from Account limit 1];
        
        Test.startTest();
		List<DT_SYS_Account_Payment__x> paymentSummary = Dal_AccountPaymentsManager.getPaymentSummary(account.Id, 1000);
        System.assert(true, paymentSummary.size()>0);
        Test.stopTest();
        
    }
}