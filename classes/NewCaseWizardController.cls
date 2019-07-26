public class NewCaseWizardController {

    //This is Used to test Class Coverage
	@TestVisible private Static List<DT_SYS_OrderHeader__x> mockOrders = new List<DT_SYS_OrderHeader__x>();
	@TestVisible private Static List<SalesOrderList__x> mockSalesOrders = new List<SalesOrderList__x>();

    @AuraEnabled
    public static caseData getCasesByNoFields(String orderNo, String custPo, String shipmentNo, String stoNo){
        caseData wrap = new caseData();
        wrap.caseList = new List<Case>();
        wrap.orderData = new orderWrap();
        wrap.stoData = new stoWrap();

        List<Case> caseList = new List<Case>();
        String query = ' SELECT Id, CaseNumber, Subject, Order_Number__c, Customer_PO__c, Shipment__c, ' +
            	'SAP_TransferOrderHeader__c, Status, Account.Name, Contact.Name, CreatedDate ' +
			'FROM Case WHERE ';

        if(string.isNotBlank(orderNo)){
            query += ' Order_Number__c =:orderNo OR';
            wrap.orderData = validateSalesOrderNo(orderNo);
            if(wrap.orderData.validOrderNo){
                custPo = wrap.orderData.orderRec.CustomerPONo__c;
            }
        }
        if(string.isNotBlank(custPo)){
            query += ' Customer_PO__c =:custPo OR';
        }
        if(string.isNotBlank(shipmentNo)){
            query += ' Shipment__c =:shipmentNo OR';
        }
        if(string.isNotBlank(stoNo)){
            query += ' SAP_TransferOrderHeader__c =:stoNo ';
            wrap.stoData = validateStockNo(stoNo);
        }

        System.debug('query+++++'+query);
        String caseQuery = query.removeEnd('OR');
        System.debug('caseQuery+++++'+caseQuery);

        caseList = (List<Case>)Database.query(caseQuery);
        wrap.caseList = caseList;

        System.debug('caseList+++++'+caseList);
        System.debug('wrap+++++'+wrap);

        return wrap;
    }

    @AuraEnabled
    public Static orderWrap validateSalesOrderNo(String orderNo){
        orderWrap returnObj = new orderWrap();
        returnObj.validOrderNo = false;

        List<DT_SYS_OrderHeader__x> orderObjList = (!mockOrders.isempty()) 
            ? mockOrders
            : new List<DT_SYS_OrderHeader__x>([SELECT Id, SalesOrder__c, CustomerPONo__c, HostSystem__c
                                               FROM DT_SYS_OrderHeader__x
                                               WHERE HostSystem__c = 'SAP' AND SalesOrder__c =:orderNo LIMIT 1]);

        if(orderObjList.size() > 0){
            returnObj.validOrderNo = true;
            returnObj.orderRec = orderObjList[0];
        }

        return returnObj;
    }

    @AuraEnabled
    public static stoWrap validateStockNo(String sapNo){
        stoWrap returnObj = new stoWrap();
        returnObj.validSTONo = false;

        List<SAP_TransferOrderHeader__x> transferOrderList = new List<SAP_TransferOrderHeader__x>();
        for(SAP_TransferOrderHeader__x rec : [SELECT id, TransferOrder__c 
                                              FROM SAP_TransferOrderHeader__x 
                                              WHERE TransferOrder__c =:sapNo LIMIT 1]){
            transferOrderList.add(rec);
        }

        if(transferOrderList.size() > 0){
            returnObj.validSTONo = true;
            returnObj.stoRec = transferOrderList[0];
        }

        return returnObj;
    }
    @AuraEnabled
    public static List<String> getAccConName(String accId, String conId){
        List<String> listOfdata = new List<String>();
        for(Contact conObj : [SELECT Id, Name,Account.Name FROM Contact where Id =: conId]){
            listOfdata.add(conObj.Name);
            listOfdata.add(conObj.Account.Name);
            
        }
        return listOfdata;
    }
	@AuraEnabled
    public Static String getRecordTypeId(){
		id rid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR Case').getRecordTypeId();
        return (String)rid;
    }
    
    @AuraEnabled
    public Static List<Case> getCasesByAccountAndContact(String accId, String conId){
        system.debug('accId+++++++'+accId);
        system.debug('conId+++++++'+conId);
        // String query = 'SELECT id, CaseNumber, Subject, Order_Number__c, Customer_PO__c, Shipment__c,SAP_TransferOrderHeader__c, Status, Account.Name, Contact.Name, CreatedDate FROM Case ';
        String query = 'SELECT id, CaseNumber, Subject,ShipToAccount__c,Division__c, Status, Account.Name,Contact.Name, CreatedDate,Order_Number__c, Customer_PO__c, Shipment__c,SAP_TransferOrderHeader__c FROM Case ';
        if(String.isNotBlank(conId) && String.isNotBlank(accId)){
            query +=' WHERE AccountId = \'' + String.valueOf(accId) + '\'';
            query +=' AND ContactId = \'' + String.valueOf(conId) + '\'';
        }
        else if(String.isNotBlank(accId)){
            query +=' WHERE AccountId = \'' + String.valueOf(accId) + '\'';
        }
        else if(String.isNotBlank(conId)){
            query +=' WHERE ContactId = \'' + String.valueOf(conId) + '\'';
        }
        query +=' ORDER BY CreatedDate ASC ';
        
        System.debug('Query+++'+query);
        List<Case> casesList = new List<Case>();
        casesList = Database.query(query);
        return casesList;
    }

    @AuraEnabled
    public Static List<Options> getContactsByAccounts(String accId){
        List<Options> contactListOptions = new List<Options>();
        for(Account acc : [SELECT Id, Name,  (
            SELECT Id, IsDirect, ContactId, Contact.Name
            FROM AccountContactRelations where Contact.Contact_Type__c = 'Service'
        )
        FROM Account WHERE ID =:accId]){
        	for(AccountContactRelation rel : acc.AccountContactRelations){
            	Options opt = new Options();
                opt.label = rel.Contact.Name + (rel.IsDirect ? '' : ' (Indirect)');
                opt.value = rel.ContactId;
                contactListOptions.add(opt);
            }
        }
        System.debug('contactListOptions++++'+contactListOptions);
        return contactListOptions;
    }
    
    @AuraEnabled
    public Static List<Options> getAccountsByContacts(String conId){
        System.debug('getAccountsByContacts + conId:...' + conId);
        List<Options> accountListOptions = new List<Options>();
        for(Contact con : [SELECT Id, Name, (
            	SELECT Id, IsDirect, Account.Name, AccountId, Contact.Name
            	FROM AccountContactRelations
        	)
        	// FROM Contact WHERE ID =:conId and Contact_Type__c = 'Service']){
        	FROM Contact WHERE ID =:conId]){                
            for(AccountContactRelation rel : con.AccountContactRelations){
            	Options opt = new Options();
                opt.label = rel.Account.Name + (rel.IsDirect ? '' : ' (Indirect)');
                opt.value = rel.AccountId;
                accountListOptions.add(opt);
            }
		}
        System.debug('accountListOptions++++'+accountListOptions);
        return accountListOptions;
    }
    
    public class Options{
        @AuraEnabled public String label{get; set;}
        @AuraEnabled public String value{get; set;}
    }
    
    public class caseData{
        @AuraEnabled List<Case> caseList{get;set;}
        @AuraEnabled orderWrap orderData{get;set;}
        @AuraEnabled stoWrap stoData{get; set;}
    }
    
    public class orderWrap{
        @AuraEnabled public Boolean validOrderNo{get; set;}
        @AuraEnabled DT_SYS_OrderHeader__x orderRec {get; set;}
    }
    
    public class stoWrap{
        @AuraEnabled public Boolean validSTONo{get; set;}
        @AuraEnabled SAP_TransferOrderHeader__x stoRec {get; set;}
    }
}