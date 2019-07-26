/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_InvoiceControllerTest {
    @TestSetup
    static void datasetup(){
        User Objuser = [Select id from user where profile.name='System Administrator' AND Isactive=true AND Userroleid!=null limit 1];
        System.runAs(Objuser) {
            Contact con = Dal_TestUtils.createTestContact();  
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '008082001';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            
            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
            
        }
    }
    static testMethod void getOrdersFullFilment(){ 
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        
        DT_SYS_InvoiceList__x dtInvoice = new DT_SYS_InvoiceList__x(
            Amount__c ='16',JobName__c='NY',DivisionName__c = 'SAP' ,TransactionTypeDesc__c='desctype' ,Currency__c = '30' ,Customer__c='test'
        );
        
        Test.startTest();
        System.runAs(newUser){        
            Integer listLimit = 12;
            String userType = 'Distributor';
            String invoiceNumber = '100100';
            String purchaseOrder = '10000';
            String divisionName = 'testname'; 
            Dal_InvoiceController.mockallInvoiceList.add(dtInvoice);
            String invoiceFrom = string.valueofGmt(system.today());//string.valueOfGmt(datetime.newInstance(2018, 5, 18, 12, 30, 0)); 
            
            String invoiceTo = string.valueofGmt(system.today());//string.valueOfGmt(datetime.newInstance(2018, 6, 18, 12, 30, 0)); 
            
            Apexpages.currentpage().getparameters().put('InvoiceIds', 'invoice12345');
            Dal_InvoiceController.InvoiceExcelWrapper wrappr=new Dal_InvoiceController.InvoiceExcelWrapper(dtInvoice);
            
            Dal_InvoiceController inv = new Dal_InvoiceController();
           // inv.excelinvoice = wrappr;
            inv.exportAll();
            //inv.xlsHeader = 'test';
            inv.csvText = 'test';
            //system.assertEquals(null, inv.csvText);
            //system.assertEquals(null, inv.xlsHeader);
            
            inv.excelinvoice = new List<Dal_InvoiceController.InvoiceExcelWrapper>{wrappr};
            
            system.assertNotEquals(null, inv.csvText);
            system.assertNotEquals(null, inv.xlsHeader);
            Dal_InvoiceController.InvoiceWrapper dsl1 = new Dal_InvoiceController.InvoiceWrapper(dtInvoice);
            Dal_InvoiceController.InvoiceExcelWrapper dsl = new Dal_InvoiceController.InvoiceExcelWrapper(dtInvoice);
            Dal_InvoiceController.getInvoiceList(userType, invoiceNumber, purchaseOrder, divisionName, invoiceFrom, invoiceTo, listLimit);
            Dal_InvoiceController.getBrandlist();
            inv.getPDF();
            
            
            inv.clean(divisionName);
            Dal_InvoiceController.searchInvoice(userType, invoiceNumber, purchaseOrder, divisionName, invoiceFrom, invoiceTo, listLimit,'test');
            Dal_InvoiceController.searchInvoice(userType, invoiceNumber, purchaseOrder, divisionName, null, null, listLimit,'');
            Dal_InvoiceController.searchInvoice(userType, invoiceNumber, purchaseOrder, divisionName, null, invoiceTo, listLimit,'');
            Dal_InvoiceController.searchInvoice(userType, invoiceNumber, purchaseOrder, divisionName, invoiceFrom, null, listLimit,'');
            
        }
        Test.stopTest();          
    } 
    
}