@isTest
public class Test_Accept_Cases_From_Queues_Controller {
    
    @isTest static void test_method_one() {
    	Account acc = Dal_TestUtils.createTestAccount();
		Contact con = Dal_TestUtils.createTestContact();
		con.AccountId = acc.Id;
		update con;
		List<Case> caseList = new List<Case>();
		Case cas = new Case();
		cas.AccountId = acc.Id;
		cas.ContactId = con.Id;
		cas.Subject = 'Test Case';
		cas.Status = 'New';
		cas.Type = 'NSPR';
    	caseList.add(cas);
        Case cas1 = new Case();
		cas1.AccountId = acc.Id;
		cas1.ContactId = con.Id;
		cas1.Subject = 'Test Case121324';
		cas1.Status = 'New';
		cas1.Type = 'NSPR';
        caseList.add(cas1);
        Test.starttest();
        insert caseList;
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(caseList);
  		stdSetController.setSelected(caseList);
        Accept_Cases_From_Queues_Controller acfq = new Accept_Cases_From_Queues_Controller(stdSetController);
        acfq.save();
        Test.stoptest();
    
    }

}