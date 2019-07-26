@isTest
private class TestCSRDisconnectedCaseUtility {

    @isTest static void test_method_one() {
        Account acc = Dal_TestUtils.createTestAccount();
        Contact con = Dal_TestUtils.createTestContact();
        con.AccountId = acc.Id;
        update con;
        String objectName = 'Case';
        String strRecordTypeName = 'CSR Disconnected Call';
        ID caseDisconnectedRecordTypeId;
        caseDisconnectedRecordTypeId = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();

        Case cas = new Case();
        cas.RecordTypeId = caseDisconnectedRecordTypeId;                
        cas.AccountId = acc.Id;
        cas.ContactId = con.Id;
        
        Test.starttest();
        CSRDisconnectedCaseUtility cntrl = new CSRDisconnectedCaseUtility();
        CSRDisconnectedCaseUtility.createCase(cas);
        Test.stoptest();
    }

    @isTest static void test_method_two() {
       Account acc = Dal_TestUtils.createTestAccount();
        Contact con = Dal_TestUtils.createTestContact();
        con.AccountId = acc.Id;
        update con;

        Case cas = new Case();
        cas.AccountId = acc.Id;
        cas.ContactId = con.Id;
        cas.Subject = 'Test Case';
        cas.Status = 'New';
        cas.Type = 'NSPR';
        cas.Order_Number__c = '1452';
        cas.Customer_PO__c = '09876';
        cas.Shipment__c = '7654';
        cas.SAP_TransferOrderHeader__c = '123456';
        Insert cas;

        DT_SYS_OrderHeader__x mockOrder = new DT_SYS_OrderHeader__x(HostSystem__c ='SAP', SalesOrder__c = '1452', CustomerPONo__c = '09876');
        NewCaseWizardController.mockOrders.add(mockOrder);
        SalesOrderList__x mockSalesOrder = new SalesOrderList__x(Customer__c = acc.Id, CustomerPONo__c = '09876', SalesOrder__c = '1452',HostSystem__c ='SAP');
        NewCaseWizardController.mockSalesOrders.add(mockSalesOrder);
        
        Test.starttest();
        try {
            CSRDisconnectedCaseUtility cntrl = new CSRDisconnectedCaseUtility();
            CSRDisconnectedCaseUtility.createCase(cas);
        }  catch (Exception e) {}
          
        Test.stoptest();        
        
    }
}