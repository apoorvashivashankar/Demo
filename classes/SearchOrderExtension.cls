public without sharing class SearchOrderExtension {

    public final case caseRecord;
    public String searchString{get; set;}
    public List<DT_SYS_OrderHeader__x> serachResults{get; set;}
    public Boolean showSearch {get; set;}
    public DT_SYS_OrderHeader__x existingOrder{get; set;}
    public List<searchResultWrap> searchResultsWrap {get; set;}
    public Boolean noRecords {get; set;}
    public String selectedSalesOrder {get; set;}
    public String selectedCustomerPo {get; set;}
    public Boolean invalidOrderNo {get; set;}
    //This is Used to test Class Coverage
    @TestVisible private Static List<DT_SYS_OrderHeader__x> mockOrders = new List<DT_SYS_OrderHeader__x>();
    @TestVisible private Static List<SalesOrderList__x> mockSalesOrders = new List<SalesOrderList__x>();

    // The extension constructor initializes the private member
    // variable caseRecord by using the getRecord method from the standard
    // controller.
    public SearchOrderExtension(ApexPages.StandardController stdController) {
        showSearch = true;
        noRecords = false;
        invalidOrderNo = false;
        this.caseRecord = (Case)stdController.getRecord();
        serachResults = new List<DT_SYS_OrderHeader__x>();
        searchResultsWrap = new List<searchResultWrap>();
        case caseRec;
        for(case rec : [SELECT Id, Order_Number__c FROM Case WHERE Id =:caseRecord.Id LIMIT 1]){
            caseRec = rec;
        }
        
        if(String.isNotBlank(caseRec.Order_Number__c)){
            showSearch = false;
            List<DT_SYS_OrderHeader__x> orderRecs = getOrderRecord(caseRec.Order_Number__c);
            if(orderRecs.size() > 0){
                existingOrder = orderRecs[0];
            }
            else{
                invalidOrderNo = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Order Number on the Case is invalid!'));
            }
        }
    }

        public PageReference doSearch(){
            serachResults = new List<DT_SYS_OrderHeader__x>();
            searchResultsWrap = new List<searchResultWrap>();
            if(String.isNotBlank(searchString)){
                searchResultsWrap = getMatachingRecords();
                //serachResults = getRecords();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Enter an Order Number to Search!'));
            }
      return null;
        }

        /*public List<DT_SYS_OrderHeader__x> getRecords(){
            List<DT_SYS_OrderHeader__x> orderList = new List<DT_SYS_OrderHeader__x>();
            List<SalesOrderList__x> salesOrderList = new List<SalesOrderList__x>();
            List<String> customerPoList   = new List<String>();
            List<String> salesOrderNoList = new List<String>();
            System.debug('SearchString+++'+searchString);
            for(SalesOrderList__x sOrder : [SELECT Id, SalesOrder__c, Customer__c, HostSystem__c, CustomerPONo__c FROM SalesOrderList__x
                                                   WHERE Customer__c = '600967001' AND CustomerPONo__c = '28071 GRABOWSKI']){
                                                                                             salesOrderList.add(sOrder);
                                                                                             customerPoList.add(sOrder.CustomerPONo__c);
                                                                                             salesOrderNoList.add(sOrder.SalesOrder__c);
                                                                                         }
            if(salesOrderList.size() > 0){
                System.debug('salesOrderList+++'+salesOrderList);
                for(DT_SYS_OrderHeader__x rec : [SELECT Id, SalesOrder__c,CustomerPONo__c,HostSystem__c FROM DT_SYS_OrderHeader__x
                                                        WHERE HostSystem__c ='SAP' AND SalesOrder__c IN:salesOrderNoList]){
                                                                                                    orderList.add(rec);
                                                                                                }
            }
            if(orderList.size() == 0){
                noRecords = true;
            }
            System.debug('orderList++++'+orderList.size());
            return orderList;
        }*/

        public List<searchResultWrap> getMatachingRecords(){

            List<DT_SYS_OrderHeader__x> orderList = (!mockOrders.isempty()) ? mockOrders : new List<DT_SYS_OrderHeader__x>([SELECT Id, SalesOrder__c,CustomerPONo__c,HostSystem__c
                                                                                            FROM DT_SYS_OrderHeader__x
                                                                                            WHERE HostSystem__c ='SAP' AND SalesOrder__c =:SearchString]);
            List<searchResultWrap> results = new List<searchResultWrap>();
            for(DT_SYS_OrderHeader__x rec : orderList){
                searchResultWrap obj = new searchResultWrap();
                obj.recordId = rec.Id;
                obj.salesOrder = rec.SalesOrder__c;
                obj.hostSystem = rec.HostSystem__c;
                obj.customerPo = rec.CustomerPONo__c;
                results.add(obj);
                System.debug('In Orderheader');
            }
            if(results.size() == 0){
                case caseRec = [SELECT Id, Account.Customer_Base__c FROM Case WHERE Id =:caseRecord.Id];
                system.debug('In SalesOrder Loop');
                List<SalesOrderList__x> salesOrderList = (!mockSalesOrders.isempty()) ? mockSalesOrders : new List<SalesOrderList__x>([SELECT Id, SalesOrder__c, Customer__c, HostSystem__c, CustomerPONo__c
                                                                                                          FROM SalesOrderList__x
                                                                                                          WHERE Customer__c =: caseRec.Account.Customer_Base__c AND (CustomerPONo__c =:SearchString OR SalesOrder__c =:SearchString)]);

//              List<SalesOrderList__x> salesOrderList = (!mockSalesOrders.isempty()) ? mockSalesOrders : new List<SalesOrderList__x>([SELECT Id, SalesOrder__c, Customer__c, HostSystem__c, CustomerPONo__c
//                                                                                                   FROM SalesOrderList__x
//                                                                                                   WHERE Customer__c = '600967001' AND (CustomerPONo__c =:SearchString OR SalesOrder__c =:SearchString)]);
                for(SalesOrderList__x sOrder : salesOrderList){
                    searchResultWrap obj = new searchResultWrap();
                    obj.recordId = sOrder.Id;
                    obj.salesOrder = sOrder.SalesOrder__c;
                    obj.hostSystem = sOrder.HostSystem__c;
                    obj.customerPo = sOrder.CustomerPONo__c;
                    results.add(obj);
                }

            }
        System.debug('results++++++++++'+results);
        mockOrders.clear();
        mockSalesOrders.clear();
        return results;
    }

        public List<DT_SYS_OrderHeader__x> getOrderRecord(String orderNo){
            List<DT_SYS_OrderHeader__x> returnList = new List<DT_SYS_OrderHeader__x>();
            for(DT_SYS_OrderHeader__x rec : [SELECT Id, SalesOrder__c, CustomerPONo__c, HostSystem__c, JobName__c, Account_Contact_Name__c, Account_Contact_Phone__c FROM DT_SYS_OrderHeader__x WHERE HostSystem__c = 'SAP' AND SalesOrder__c =:orderNo]){
                returnList.add(rec);
            }
            return returnList;
        }

        public PageReference copyToCase(){
            system.debug('selectedSalesOrder++++'+selectedSalesOrder);
            if(String.isNotBlank(selectedSalesOrder))
            caseRecord.Order_Number__c = selectedSalesOrder;
            caseRecord.Customer_PO__c = selectedCustomerPo;
            update caseRecord;

      String URL = System.Label.Lightning_Base_URL+caseRecord.Id+'/view';
            PageReference pageRef = new PageReference(URL);
      pageRef.setRedirect(true);
            return pageRef;
        }

        public Class searchResultWrap{
            public String salesOrder {get; set;}
            public String customerPo {get; set;}
            public String hostSystem {get; set;}
            public String recordId   {get; set;}
        }

        @AuraEnabled
        public static List<DT_SYS_OrderHeader__x> getSalesOrder(String caseId){
            System.debug('Method Entry'+caseId);
            List<DT_SYS_OrderHeader__x> returnList = new List<DT_SYS_OrderHeader__x>();
            if(String.isNotBlank(caseId)){
                case caseRec = [SELECT Id, Order_Number__c FROM Case WHERE Id =:caseId];System.debug('caseRec+++++++++++'+caseRec);
                if(caseRec.Order_Number__c != null){
                    for(DT_SYS_OrderHeader__x rec : [SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c,
                            Account_Address_Line1__c, Account_Address_Line2__c, Account_Address_Line3__c,
                            Account_Address_Name__c, Account_Address_Name2__c, Account_Address_PostalCode__c, Account_Address_StateProvince__c,
                            Account_Contact_Name__c,Account_Contact_LastName__c,Account_Contact_FirstName__c, Account_Contact_Phone__c, Account_Contact_eMail__c, Account_Id_Type__c,
                            Account_Id_Value__c, Fulfilment_FreightTerms__c,CreatedByUser_Id_Type__c, CreatedByUser_Id_Value__c,
                            CreatedTime__c, CustomerPONo__c, Fulfilment_CarrierPaidBy__c, Fulfilment_Carrier_CustomerAcctWithCarri__c,
                            Fulfilment_Carrier_SCAC__c, Fulfilment_Method__c,ShipFromLoc__c,Total_Charge_ESC__c, Fulfilment_ShipComplete__c, Fulfilment_ShipMode__c,
                            Fulfilment_ShipToAddress_Address_City__c, Fulfilment_ShipToAddress_Address_Country__c,
                            Fulfilment_ShipToAddress_Address_Line1__c, Fulfilment_ShipToAddress_Address_Line2__c,
                            Fulfilment_ShipToAddress_Address_Line3__c, Fulfilment_ShipToAddress_Address_Name__c, Fulfilment_ShipToAddress_Address_Name2__c,
                            Fulfilment_ShipToAddress_Address_PostalC__c, Fulfilment_ShipToAddress_Address_StatePr__c,
                            Fulfilment_ShipToAddress_SameAsAccount__c, HeaderCharge_CUS__c, HeaderCharge_FRT__c, HeaderCharge_HND__c,
                            HeaderCharge_IFR__c, HeaderCharge_MIS__c, HeaderCharge_RES__c, HostSystem__c, JobName__c, Notes__c,
                            OrderPlantName__c, OrderPlant__c, SalesOrder__c,Total_SubTotal__c,Total_Payment__c,Total_PaymentsReceived__c,WeightUOM__c,TaxStatus__c, Status__c,StatusDesc2__c, Total_Charges__c, Total_Collection__c,
                            Total_Deposit__c, Total_Discount__c, Total_Due__c,Total_ShippingHandling__c, Total_HeaderCharges__c, Total_Materials__c, Total_TaxAmt_City__c,
                            Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c, Total_TaxRate_City__c,
                            Total_TaxRate_County__c, Total_TaxRate_District__c,CashPayment__c,CashOnDeliveryInd__c, Total_RefundToApply__c ,Total_Refund__c,Total_TaxRate_State__c, Total_TaxRate__c, Total_Tax__c,
                            Total_Total__c, Total_Weight__c, id__c FROM DT_SYS_OrderHeader__x
                            WHERE HostSystem__c = 'SAP' AND SalesOrder__c =:caseRec.Order_Number__c]){
                        returnList.add(rec);
                    }
                }
            }
            system.debug('returnList++++'+returnList);
            return returnList;
        }


}