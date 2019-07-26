@isTest
private class TestUpdateCustClass {

    static testMethod void UpdateCustClass() {
    
        Customer_Class__c cc=new Customer_Class__c();
        cc.Name='xxx';
        cc.CustClass__c='xxx';
        insert cc;
              
        Account acc1=new Account();
        acc1.Name='Test Acc';
        acc1.Class__c='xxx';
        insert acc1;
        
        Account acc2=new Account();
        acc2.Name='Test Acc';
        acc2.Class__c=null;
        insert acc2;
        
    }
}