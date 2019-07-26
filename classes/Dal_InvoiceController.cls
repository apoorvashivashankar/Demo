/**
* Created by 7Summits on 5/21/18.
**/
public without sharing class Dal_InvoiceController {

    @TestVisible
    private static list<DT_SYS_InvoiceList__x> mockallInvoiceList = new list<DT_SYS_InvoiceList__x>();
    public String pdf{get;set;}
    public String customer {get; set;}
    public string username {get;set;}
    public string password {get;set;}
    public String respBody{get;set;}
    public string theme {get;set;}
    public List<String> invoices {get;set;}
    public String invoicelist {get;set;}
    public List<DT_SYS_InvoiceList__x> invoicePdfList {get;set;}
    public List<InvoiceExcelWrapper> excelinvoice {get;set;}

    public String csvText {
        get {
            if (excelinvoice == null) {
                return null;
            } else {
                csvText = '';
                // header row
                csvText += 'Payer,Transaction type,Invoice number,Total header amount,';
                csvText += 'Freight charges,Energy Surcharge,Taxes,Currency,';
                csvText += 'Billing date,Due Date,Purchase Order,Division Name,';
                if (Dal_BaseController.getSitePrefix().contains('SSC')) {
                    csvText += 'Sales Receipt,';
                }
                csvText += 'Job name,Original Invoice Number,Original Invoice Date,BOL,Customer Id\n';
                // data rows
                for (InvoiceExcelWrapper iew : excelInvoice) {
                    csvText += clean(iew.Payer) + ',';
                    csvText += clean(iew.TransactionType) + ',';
                    csvText += clean(iew.Invoice_Number) + ',';
                    csvText += clean(iew.Total_Header_Amount) + ',';
                    csvText += clean(iew.FreightCharges) + ',';
                    csvText += clean(iew.EnergySurcharge) + ',';
                    csvText += clean(iew.TaxAmount) + ',';
                    csvText += clean(iew.Currencytype) + ',';
                    csvText += clean(iew.Billing_Date) + ',';
                    csvText += clean(iew.DueDate) + ',';
                    csvText += clean(iew.Purchase_Order) + ',';
                    csvText += clean(iew.Division_Name) + ',';
                    if (Dal_BaseController.getSitePrefix().contains('SSC')) {
                        csvText += clean(iew.SalesSlip) + ',';
                    }
                    csvText += clean(iew.JobName) + ',';
                    csvText += clean(iew.OriginalInvoiceNum) + ',';
                    csvText += clean(iew.OriginalInvoiceDate) + ',';
                    csvText += clean(iew.Bol) + ',';
                    csvText += clean(customer) + ',';

                    csvText += '\n';
                }
                return csvText;
            }
        }
        set;
    }
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }

    // returns a csv cleaned version of the input
    public String clean(String input) {
        return input == null ? '' : input.escapeCsv();
    }

    public Pagereference exportAll(){
        return new Pagereference('/apex/Dal_ExportAllInvoice');
    }
    public Dal_InvoiceController(){

        String invoiceids = Apexpages.currentpage().getparameters().get('InvoiceIds');
        //system.debug('invoiceids '+invoiceids);
        if(invoiceids != null)
            invoices = invoiceids.split(',');

        Set<String> invoiceIdSet = new Set<String>();
        invoiceIdSet.addAll(invoices);

        //system.debug(' invoices '+invoices);
        invoicelist ='';
        if(invoices!=null){
            for(String inv : invoices){
                invoicelist = invoicelist +'<dal:Invoice><dal:InvoiceNumber>'+inv+'</dal:InvoiceNumber></dal:Invoice>';
            }
            system.debug('invoicelist '+invoicelist);
        }

        String customerId = Dal_InvoiceController.getCustomerId();
        customer = customerId;
        System.debug('customerId'+customerId);
        DT_SYS_Authentication__mdt auth = Dal_BaseController.getCredentials('AllServices');
        username = auth.DT_SYS_UserName__c;
        password = auth.DT_SYS_Password__c;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        theme = Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c)? 'red':'blue';
        system.debug('mockallInvoiceList>>'+mockallInvoiceList);
        if(Test.isRunningTest()){
            invoicePdfList = new list<DT_SYS_InvoiceList__x>();
            invoicePdfList.addAll(mockallInvoiceList);
        }else{
            invoicePdfList =  [SELECT SAP_Customer__c ,TransactionTypeDesc__c, Amount__c, BillDate__c, Bol__c, CustomerPONo__c,
                    Customer__c,DivisionName__c, Division__c, DueDate__c, EnergySurcharge__c, FreightCharges__c, Invoice__c, JobName__c,
                    OriginalInvoice__c, OriginalInvoiceDate__c, Payer__c,Currency__c, SalesSlip__c, TaxAmount__c
            FROM DT_SYS_InvoiceList__x WHERE Customer__c =: customerId];
        }
        excelinvoice = new List<InvoiceExcelWrapper>();
        system.debug('Invoice odata count --'+invoicePdfList.size());
        for(DT_SYS_InvoiceList__x inv : invoicePdfList){
            //system.debug(' list item inv --'+inv);
            if(invoiceIdSet.contains(inv.Invoice__c)){
                excelinvoice.add(new InvoiceExcelWrapper(inv));
            }
        }


        //system.debug('invoicePdfList ----'+excelinvoice.size());

    }
    public void getPDF(){
        try{
            HttpRequest req = new HttpRequest();
            Blob b = Blob.valueOf(username+':'+password);
            req.setEndpoint(Label.Dal_PDF_Service_URL);
            req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(b));
            req.setHeader('Content-Type','text/xml;charset=utf-8');
            req.setHeader('SOAPAction','http://tempuri.org/IPDFsService/GetPDF_CustomerInvoices');
            req.setBody('<?xml version=\'1.0\' encoding=\'utf-8\'?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:dal="http://schemas.datacontract.org/2004/07/DAL_Connect_PDFs.Model" ><soapenv:Header/> <soapenv:Body><tem:GetPDF_CustomerInvoices><tem:request><dal:Customer>'+customer+'</dal:Customer><dal:Invoices>'+invoicelist+'</dal:Invoices></tem:request></tem:GetPDF_CustomerInvoices></soapenv:Body></soapenv:Envelope>');
            req.setMethod('POST');
            system.debug('ingetpdf----->');
            Http x = new Http();
            HttpResponse resp = x.send(req);
            //respBody = resp.getBody();
            DOM.Document document = new DOM.Document();
            document.load(resp.getBody());
            //system.debug('ingetpdf----->'+respBody);
            pdf = document.getRootElement()
                    .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('GetPDF_CustomerInvoicesResponse','http://tempuri.org/')
                    .getChildElement('GetPDF_CustomerInvoicesResult','http://tempuri.org/').getText();
            //system.debug('PDF----->'+pdf);
        } catch(Exception ex){
            //respBody = ex.getMessage();
        }
    }

    public List<DT_SYS_InvoiceList__x> getInvoiceListForDownload{get;set;}

    // Wrapper class for sending data to frontEnd
    public Class InvoiceWrapper{
        @AuraEnabled public String Invoice_Date;
        @AuraEnabled public String TransactionType;
        @AuraEnabled public String Invoice_Number;
        @AuraEnabled public String Total_Header_Amount;
        @AuraEnabled public String Billing_Date;
        @AuraEnabled public String Purchase_Order;
        @AuraEnabled public String Division_Name;
        @AuraEnabled public String SalesSlip;


        public InvoiceWrapper(DT_SYS_InvoiceList__x invoice){
            String invoiceAmountValue = invoice.Amount__c;
            invoiceAmountValue =  invoiceAmountValue.substring(0 ,invoiceAmountValue.length()-1);
            this.TransactionType = invoice.TransactionTypeDesc__c;
            this.Invoice_Number = invoice.Invoice__c;
            this.Total_Header_Amount = invoiceAmountValue;
            this.Billing_Date = invoice.BillDate__c;
            this.Purchase_Order = invoice.CustomerPONo__c;
            this.Division_Name = invoice.DivisionName__c;
            this.SalesSlip = invoice.SalesSlip__c;

        }
    }

    public Class InvoiceExcelWrapper{
        public String Invoice_Date{get;set;}
        public String TransactionType{get;set;}
        public String Invoice_Number{get;set;}
        public String Total_Header_Amount {get;set;}
        public String Billing_Date {get;set;}
        public String Purchase_Order {get;set;}
        public String Division_Name {get;set;}
        public String SalesSlip {get;set;}
        public string JobName {get;set;}
        public String FreightCharges{get;set;}
        public String EnergySurcharge{get;set;}
        public String TaxAmount{get;set;}
        public String DueDate{get;set;}
        public String Currencytype{get;set;}
        public String OriginalInvoiceNum{get;set;}
        public String OriginalInvoiceDate{get;set;}
        public String Payer{get;set;}
        public String Bol{get;set;}

        public InvoiceExcelWrapper(DT_SYS_InvoiceList__x invoice){

            system.debug('invoice input is '+invoice);

            this.TransactionType = invoice.TransactionTypeDesc__c;
            this.Invoice_Number = invoice.Invoice__c;
            this.Total_Header_Amount = invoice.Amount__c;
            this.Billing_Date = invoice.BillDate__c;
            this.Purchase_Order = invoice.CustomerPONo__c;
            this.Division_Name = invoice.DivisionName__c;
            this.SalesSlip = invoice.SalesSlip__c;
            this.JobName = invoice.JobName__c;
            this.FreightCharges = invoice.FreightCharges__c;
            this.EnergySurcharge = invoice.EnergySurcharge__c;
            this.TaxAmount = invoice.TaxAmount__c;
            this.DueDate = invoice.DueDate__c;
            this.Currencytype = invoice.Currency__c;
            this.Payer = invoice.Payer__c;
            this.OriginalInvoiceNum = invoice.OriginalInvoice__c;
            this.OriginalInvoiceDate = invoice.OriginalInvoiceDate__c;
            this.Bol = invoice.Bol__c;
        }
    }

    @AuraEnabled
    public static List<Object> getInvoiceList(String userType,String invoiceNumber,String purchaseOrder,String divisionName,String invoiceDateStart,String invoiceDateEnd,Integer listLimit){
        System.debug('In__getInvoiceList >>>' +' '+userType+' '+invoiceNumber+' '+purchaseOrder+' '+divisionName+' '+invoiceDateStart+' '+invoiceDateEnd+' '+listLimit);
        Integer count = 0;

        String customerId = Dal_InvoiceController.getCustomerId();
        List<Object> returnList = new List<Object>();

        List<InvoiceWrapper> invoiceList = searchInvoice(userType, invoiceNumber,purchaseOrder,divisionName, invoiceDateStart,invoiceDateEnd, listLimit,'');
        if(Integer.valueOf(invoiceList.size()) > Integer.valueOf(listLimit)) {
            count = invoiceList.size();
            invoiceList.remove(invoiceList.size() - 1);
            System.debug('count -->'+count);
        }else{
            count = Integer.valueOf(listLimit);
        }/*else{

             count = Integer.valueOf([Select COUNT() from DT_SYS_InvoiceList__x WHERE Customer__c =: customerId ]);
            System.debug('count in else-->'+count);
        }*/

        System.debug(count);
        String invoiceCount = String.valueOf(count);
        //String invoiceCount = String.valueOf([Select COUNT() from DT_SYS_InvoiceList__x WHERE Customer__c =: customerId ]);
        System.debug('invoiceList initial load--->'+invoiceList);
        System.debug('invoiceList initial load--->'+invoiceList.size());

        returnList.add(invoiceList);
        returnList.add(invoiceCount);
        return returnList;
    }

    @AuraEnabled
    public static List<InvoiceWrapper> searchInvoice(string userType,String invoiceNumber,String purchaseOrder,String divisionName, String invoiceFrom, String invoiceTo, Integer listLimit,String jobName) {

        System.debug('Invoice >>>' +' '+userType+' '+invoiceNumber+' '+purchaseOrder+' '+purchaseOrder+' '+divisionName+' '+invoiceFrom+' '+invoiceTo+' '+listLimit+' '+jobName);
        System.debug('In__searchInvoice');
        String customerId = Dal_InvoiceController.getCustomerId();

        String limitValue = String.valueOf(Integer.valueOf(listLimit));
        limitValue = limitValue.trim();
        Integer tempLimit = Integer.valueOf(limitValue);
        listLimit = Integer.valueOf(limitValue)+1;

        System.debug('customerId-->'+customerId);
        System.debug('purchaseOrder '+purchaseOrder);
        System.debug('divisionName '+divisionName);
        System.debug('invoiceNumber '+invoiceNumber);
        System.debug('invoiceFrom '+invoiceFrom);
        System.debug('invoiceTo '+invoiceTo);
        System.debug('listLimit '+listLimit);
		System.debug('jobName '+jobName);
        List<DT_SYS_InvoiceList__x> invoiceList = new List<DT_SYS_InvoiceList__x>();
        List<InvoiceWrapper> invoiceWrapperList = new List<InvoiceWrapper>();

        if(customerId !=null) {

            System.debug('Invoice not null--->'+invoiceList.size());

            invoiceList = queryInvoice(purchaseOrder,divisionName,invoiceNumber,invoiceFrom,invoiceTo,customerId,listLimit,jobName);
            if(Integer.valueOf(invoiceList.size()) > Integer.valueOf(tempLimit)){
                invoiceList.remove(invoiceList.size() - 1);
                System.debug('record Removed -->'+invoiceList.size());
            }
            System.debug('Invoice  List in search--->'+invoiceList);
            if(invoiceList.size() > 0 && String.isNotBlank(invoiceList[0].id)) {

                //System.debug('Invoice  List in search--->'+invoiceList[0]);

                for(DT_SYS_InvoiceList__x invoice : invoiceList){
                    InvoiceWrapper wrapperInvoice = new InvoiceWrapper(invoice);
                    invoiceWrapperList.add(wrapperInvoice);
                }
            }
        }

        System.debug('invoiceWrapperList for search-->'+invoiceWrapperList.size());

        return invoiceWrapperList;
    }



    /*
   * Method Name: queryInvoice
   * Description: Method to query on  DT_SYS_InvoiceList__x object for searching
   * @param: purchaseOrder, divisionName, invoiceNumber, invoiceFrom, invoiceTo, customerId, listLimit) {
   * @return DT_SYS_InvoiceList__x : Invoice List
   */
    public static List<DT_SYS_InvoiceList__x> queryInvoice(String purchaseOrder,String divisionName,String invoiceNumber, String invoiceFrom, String invoiceTo, String customerId, Integer listLimit,String jobName) {
        System.debug('Invoice >>>' +' '+purchaseOrder+' '+divisionName+' '+invoiceNumber+' '+invoiceFrom+' '+invoiceTo+' '+customerId+' '+listLimit+' '+jobName);

        //division_name = new List<String>();
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        string invDateTo = null;
        string invDateFrom = null;

        if(invoiceFrom != null){

            if(!nullorempty(invoiceFrom)){
                Date dt1 = date.valueof(invoiceFrom);
                invDateFrom = string.valueof(dt1);
            }

        }

        if( invoiceTo != null){

            if(!nullorempty(invoiceTo)){
                Date dt = date.valueof(invoiceTo);
                invDateTo = string.valueof(dt);
            }
        }

        System.debug('Date >>>' +' '+invDateTo+' '+invDateFrom);

        List<DT_SYS_InvoiceList__x> invoiceList = new List<DT_SYS_InvoiceList__x>();
        string dformat = 'yyyy-MM-dd';

        try{
            String query = 'SELECT Amount__c, BillDate__c, CustomerPONo__c,'+
                    ' Division__c, DueDate__c, EnergySurcharge__c, FreightCharges__c,Invoice__c, '+
                    ' JobName__c, Payer__c, SAP_Customer__c, SalesSlip__c, TaxAmount__c, '+
                    ' TransactionType__c,DivisionName__c, Currency__c, TransactionTypeDesc__c, Bol__c '+
                    ' FROM DT_SYS_InvoiceList__x where Customer__c = \'' + customerId + '\'' ;

            if(purchaseOrder!=null && String.isNotBlank(purchaseOrder))
            {
                query += ' AND CustomerPONo__c like \'%' + purchaseOrder.toUpperCase() + '%\'';
            }
            if(divisionName!=null && String.isNotBlank(divisionName))
            {
                query += ' AND DivisionName__c = \'' + divisionName + '\'';
            }
            if(invoiceNumber!=null && String.isNotBlank(invoiceNumber))
            {
                query += ' AND Invoice__c like \'%' + invoiceNumber.toUpperCase() + '%\'';
            }
            if(jobName!=null && String.isNotBlank(jobName)) //Added by Daltile for deffect #653 R4-Bridge
                
            {
                query += ' AND JobName__c like \'%' + jobName.toUpperCase() + '%\'';
            }
            if(invDateFrom!=null && invDateTo == null){
                /*system.debug('invDateFrom is '+invDateFrom);
             Date dt = date.today();
             Date newdt = dt.addDays(1);
             string todate = newdt.format();
             string fromdate = invDateFrom.format();*/
                query += ' AND BillDate__c >= \'' + invDateFrom + '\'';
            }
            if(invDateTo!=null && invDateFrom == null){
                /*system.debug('invDateTo is '+invDateTo);
             string todate = invDateTo.format();*/
                query += ' AND BillDate__c <= \'' + invDateTo + '\'';
            }
            if(invDateTo!=null && invDateFrom!=null){
                /*system.debug('invDateTo is '+invDateFrom);
             system.debug('invDateFrom is '+invDateTo);
             string todate = invDateTo.format();
             string fromdate = invDateFrom.format();*/
                query += ' AND BillDate__c >= \'' + invDateFrom + '\' AND BillDate__c <= \'' + invDateTo + '\'';
            }


            query += ' ORDER BY BillDate__c DESC LIMIT ' + listLimit;
            System.debug('Query------>'+query);
            invoiceList = Database.query(query);
            System.debug('invoiceList from  actual query--->'+invoiceList.size());
        }
        catch(Exception exp){
            System.debug('invoiceList : An unexpected error has occurred: ' + exp.getMessage());
        }

/*
        for(DT_SYS_InvoiceList__x invoice : invoiceList){
            if(!division_name.contains(invoice.DivisionName__c))
            division_name.add(invoice.DivisionName__c);
        }*/


        return invoiceList;
    }

    /* Method Name: getCustomerId
    * Description: Method to get Customer Id
    * @param: Not Any
    * @return Customer Id
    */
    public static String getCustomerId(){
        String customerId;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        system.debug('customerId'+customerId);
        return customerId;
    }

    public static Set<String> getBrandsInvoice(){

        String customerId = Dal_InvoiceController.getCustomerId();
        Set<String> division_name = new Set<String>();
        List<DT_SYS_InvoiceList__x> invoice = [SELECT DivisionName__c, Currency__c, TransactionTypeDesc__c
        FROM DT_SYS_InvoiceList__x
        where Customer__c =: customerId];

        for(DT_SYS_InvoiceList__x inv : invoice){
            system.debug('inside for loop controller'+inv.DivisionName__c);
            division_name.add(inv.DivisionName__c);
        }

        return division_name;
    }


    @AuraEnabled
    public static List<Dal_OrderSearchController.StatusOption> getBrandlist(){

        system.debug('calling to get brands');
        List<Dal_OrderSearchController.StatusOption> brandoptions = new List<Dal_OrderSearchController.StatusOption>();
        Set<String> brands = Dal_InvoiceController.getBrandsInvoice();
        system.debug(' brands '+brands);
        for(String brand : brands){
            brandoptions.add(new Dal_OrderSearchController.StatusOption(brand, brand));
        }
        System.debug('brandoptions'+brandoptions);

        return brandoptions;
    }
    public static Boolean nullorempty(String val){
        system.debug('val is '+val);
        Boolean nullempty = false;
        if(val == null || val ==''){
            nullempty = true;
        }else{
            nullempty = false;
        }
        system.debug('nullempty is '+nullempty);
        return nullempty;
    }

}