/**
* Created by 7Summits on 3/5/18
*/
public without sharing class Dal_AccountOpenItemManager {

    /**
    * This Class return all the data required from External Object "DT_SYS_Open_Item SSC__c" 
    * @return List of Wrapper Class
    */
    @TestVisible
    private static list<DT_SYS_Open_Item__x> mockallOpenItemsList = new list<DT_SYS_Open_Item__x>();

    @TestVisible
    private static DT_SYS_Open_Item__x mockallOpenItems = new DT_SYS_Open_Item__x();


    public static list<Dal_AccountOpenItemWrapper> openItemList { get; set;}
    public static list<DT_SYS_Open_Item__x> allOpenItemsList {get; set;}
    public static list<DT_SYS_Open_Item__x> multipleallOpenItemsList {get; set;}

    //Constructor used for fetching data from external object "DT_SYS_Open_Item__x" and store in Org Cache.
    public Dal_AccountOpenItemManager(Account account){

        // if -- Data was already in Cache
        // else Query data from External object put it in Cache
        Integer forKey = 1;
        allOpenItemsList = new list<DT_SYS_Open_Item__x>();
        multipleallOpenItemsList = new list<DT_SYS_Open_Item__x>();
        if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+forKey)) {
            System.debug('InCACHE');
            System.debug('Data In Cache>'+ Cache.Org.get('AllOpenItem'));

        }else{

            for(DT_SYS_Open_Item__x openItem : [SELECT
                    AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,
                    DivisionName__c,AllPayersInd__c,ReasonCodeDesc__c,
                    Customer__c, CustomerPONo__c, DisplayUrl,
                    Division__c, DueDate__c, ExternalId,
                    GrossAmount__c, Id, id__c, JobName__c,
                    PastDueDays__c, Payer__c, Plant__c,
                    ReasonCode__c, ReferenceDate__c, ReferenceNo__c,
                    SalesReceiptNo__c, ShipFrom__c,ShipFromName__c,
                    TransactionType__c,BOL__c
            FROM DT_SYS_Open_Item__x WHERE Customer__c =: account.DW_ID__c AND ReferenceDate__c = LAST_N_DAYS:30]){
                allOpenItemsList.add(openItem);
            }
            if(allOpenItemsList.size() < 500){
                Cache.Org.put('AllOpenItem'+account.DW_ID__c+forKey, allOpenItemsList);
            }else{

                for(Integer i=0; i < allOpenItemsList.size() ;i++){
                    multipleallOpenItemsList.add(allOpenItemsList[i]);
                    if(multipleallOpenItemsList.size() == 500 || i == allOpenItemsList.size()-1){
                        Cache.Org.put('AllOpenItem'+account.DW_ID__c+forKey, multipleallOpenItemsList);
                        multipleallOpenItemsList = new list<DT_SYS_Open_Item__x>();
                        forKey++;
                        System.debug('forKey'+forKey);
                    }
                }
            }
            System.debug('Cache Created----->'+Cache.Org.get('AllOpenItem'+account.DW_ID__c+'1'));

        }

    }

    // get all External object record with Transaction type is "Open".First check from Cache if not found then from External object
    public static List<Dal_AccountOpenItemWrapper> getAllOpenItems(Account account, Integer listLimit){
        Integer forKey = 1;
        String typeOfList = 'AllOpen';
        System.debug('typeOfList-->'+'AllOpen');
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        System.debug('LIMIT-->'+listLimit);
        Integer count = 0;
        openItemList = new list<Dal_AccountOpenItemWrapper>();
        allOpenItemsList = new list<DT_SYS_Open_Item__x>();
        list<DT_SYS_Open_Item__x> multiAllOpenItemsList = new list<DT_SYS_Open_Item__x>();
        if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+'1')) {
            System.debug('AllOpenItem'+account.DW_ID__c);
            if(!Test.isRunningTest()){

                for(Integer i= 1 ; i <= 50 ; i++) {
                    if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+i)) {
                        multiAllOpenItemsList = (list<DT_SYS_Open_Item__x>)Cache.Org.get('AllOpenItem'+account.DW_ID__c+i);
                    }else {
                        break;
                    }
                    allOpenItemsList.addAll(multiAllOpenItemsList);
                }

            }else{
                allOpenItemsList.addAll(mockallOpenItemsList);
            }
            System.debug('Size-->'+allOpenItemsList.size());
            if(account != null && account.Id != null) {
                for(DT_SYS_Open_Item__x item : allOpenItemsList){
                    if(count < listLimit){
                        openItemList.add(new Dal_AccountOpenItemWrapper(item));
                        count++;
                    }

                }
                openItemList = sortPrductLst(openItemList,typeOfList);
                System.debug('Data for allopen items----->'+ openItemList);
            }
        }
        else{
            System.debug('Cache Data not found');
            if(account != null && account.Id != null) {
                if(!Test.isRunningTest()){
                    allOpenItemsList = [
                            SELECT
                                    AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,
                                    DivisionName__c,AllPayersInd__c,ReasonCodeDesc__c,
                                    Customer__c, CustomerPONo__c, DisplayUrl,
                                    Division__c, DueDate__c, ExternalId,
                                    GrossAmount__c, Id, id__c, JobName__c,
                                    PastDueDays__c, Payer__c, Plant__c,
                                    ReasonCode__c, ReferenceDate__c, ReferenceNo__c,
                                    SalesReceiptNo__c, ShipFrom__c,ShipFromName__c,
                                    TransactionType__c,BOL__c
                            FROM DT_SYS_Open_Item__x
                            WHERE Customer__c =: account.DW_ID__c AND ReferenceDate__c = LAST_N_DAYS:30
                            ORDER BY ReferenceDate__c DESC
                            LIMIT :listLimit
                    ];
                }else{
                    allOpenItemsList.add(mockallOpenItems);
                }
                for(DT_SYS_Open_Item__x item : allOpenItemsList){

                    openItemList.add(new Dal_AccountOpenItemWrapper(item));

                }

            }

        }
        return openItemList;
    }

    // get all External object record with AgingCode__c is "F" && AgingCode__c is "C".First check from Cache if not found then from External object
    public static List<Dal_AccountOpenItemWrapper> getPastOpenItems(Account account, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        String typeOfList = 'PastOpen';
        System.debug('typeOfList-->'+'PastOpen');
        System.debug('listLimit-->'+'listLimit');
        openItemList = new list<Dal_AccountOpenItemWrapper>();
        allOpenItemsList = new list<DT_SYS_Open_Item__x>();
        list<DT_SYS_Open_Item__x> multiAllOpenItemsList = new list<DT_SYS_Open_Item__x>();
        if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+'1')) {
            if(!Test.isRunningTest()){
                for(Integer i= 1 ; i <= 50 ; i++) {
                    if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+i)) {
                        multiAllOpenItemsList = (list<DT_SYS_Open_Item__x>)Cache.Org.get('AllOpenItem'+account.DW_ID__c+i);
                    }else {
                        break;
                    }
                    allOpenItemsList.addAll(multiAllOpenItemsList);
                }
            }else{
                allOpenItemsList.addAll(mockallOpenItemsList);
            }
            if(account != null && account.Id != null) {
                for(DT_SYS_Open_Item__x item : allOpenItemsList){
                    if(item.AgingCode__c != 'F' && item.AgingCode__c != 'C')
                    {
                        openItemList.add(new Dal_AccountOpenItemWrapper(item));
                        System.debug('Data from Cache----->');
                    }
                }
                openItemList = sortPrductLst(openItemList,typeOfList);
                System.debug('Data for RV- payment---->'+ openItemList);
            }
        }
        else{
            System.debug('Cache Data not found');
            if(account != null && account.Id != null) {
                if(!Test.isRunningTest()){
                    allOpenItemsList =[
                            Select
                                    AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,
                                    DivisionName__c,AllPayersInd__c,ReasonCodeDesc__c,
                                    Customer__c, CustomerPONo__c, DisplayUrl,
                                    Division__c, DueDate__c, ExternalId,
                                    GrossAmount__c, Id, id__c, JobName__c,
                                    PastDueDays__c, Payer__c, Plant__c,
                                    ReasonCode__c, ReferenceDate__c, ReferenceNo__c,
                                    SalesReceiptNo__c, ShipFrom__c,ShipFromName__c,
                                    TransactionType__c,BOL__c
                            FROM DT_SYS_Open_Item__x
                            WHERE Customer__c =: account.DW_ID__c and AgingCode__c !='F' and AgingCode__c !='C'
                            AND ReferenceDate__c = LAST_N_DAYS:30
                            ORDER BY ReferenceDate__c
                            LIMIT :listLimit];
                }else{
                    allOpenItemsList.add(mockallOpenItems);
                }
                for(DT_SYS_Open_Item__x item : allOpenItemsList){

                    openItemList.add(new Dal_AccountOpenItemWrapper(item));

                }


            }
        }
        return openItemList;
    }

    // get all External object record with AgingCode__c is "F" && AgingCode__c is "C".First check from Cache if not found then from External object
    public static List<Dal_AccountOpenItemWrapper> getCurrentOpenItems(Account account, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        String typeOfList = 'CurrentOpen';
        System.debug('typeOfList-->'+'CurrentOpen');
        openItemList = new list<Dal_AccountOpenItemWrapper>();
        allOpenItemsList = new list<DT_SYS_Open_Item__x>();
        list<DT_SYS_Open_Item__x> multiAllOpenItemsList = new list<DT_SYS_Open_Item__x>();
        if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+'1')) {
            if(!Test.isRunningTest()){
                for(Integer i= 1 ; i <= 50 ; i++) {
                    if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+i)) {
                        multiAllOpenItemsList = (list<DT_SYS_Open_Item__x>)Cache.Org.get('AllOpenItem'+account.DW_ID__c+i);
                    }else {
                        break;
                    }
                    allOpenItemsList.addAll(multiAllOpenItemsList);
                }
            }else{
                allOpenItemsList.addAll(mockallOpenItemsList);
            }
            if(account != null && account.Id != null) {
                for(DT_SYS_Open_Item__x item : allOpenItemsList){
                    if(item.AgingCode__c == 'F' || item.AgingCode__c == 'C')
                    {
                        openItemList.add(new Dal_AccountOpenItemWrapper(item));
                    }
                }
                openItemList = sortPrductLst(openItemList,typeOfList);
                System.debug('Data for DZ_1 openitem----->'+ openItemList);
            }
        }
        else{
            System.debug('Cache Data not found');
            if(account != null && account.Id != null) {
                if(!Test.isRunningTest()){
                    allOpenItemsList = [
                            Select
                                    AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,
                                    DivisionName__c,AllPayersInd__c,ReasonCodeDesc__c,
                                    Customer__c, CustomerPONo__c, DisplayUrl,
                                    Division__c, DueDate__c, ExternalId,
                                    GrossAmount__c, Id, id__c, JobName__c,
                                    PastDueDays__c, Payer__c, Plant__c,
                                    ReasonCode__c, ReferenceDate__c, ReferenceNo__c,
                                    SalesReceiptNo__c, ShipFrom__c,ShipFromName__c,
                                    TransactionType__c,BOL__c
                            FROM DT_SYS_Open_Item__x
                            WHERE Customer__c =: account.DW_ID__c and (AgingCode__c !='F' or AgingCode__c !='C')
                            AND ReferenceDate__c = LAST_N_DAYS:30
                            ORDER BY ReferenceDate__c
                            LIMIT :listLimit];

                }else{
                    allOpenItemsList.add(mockallOpenItems);
                }

                for(DT_SYS_Open_Item__x item : allOpenItemsList){

                    openItemList.add(new Dal_AccountOpenItemWrapper(item));

                }

            }

        }

        return openItemList;
    }

    // get all External object record with TransactionType__c = "Z2 || YG || DG" .First check from Cache if not found then from External object
    public static List<Dal_AccountOpenItemWrapper> getReturnsAndCreditsOpenItems(Account account, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        String typeOfList = 'Credits';
        System.debug('typeOfList-->'+'Credits');
        openItemList = new list<Dal_AccountOpenItemWrapper>();
        allOpenItemsList = new list<DT_SYS_Open_Item__x>();
        list<DT_SYS_Open_Item__x> multiAllOpenItemsList = new list<DT_SYS_Open_Item__x>();
        if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+'1')) {
            if(!Test.isRunningTest()){
                for(Integer i= 1 ; i <= 50 ; i++) {
                    if (Cache.Org.contains('AllOpenItem'+account.DW_ID__c+i)) {
                        multiAllOpenItemsList = (list<DT_SYS_Open_Item__x>)Cache.Org.get('AllOpenItem'+account.DW_ID__c+i);
                    }else {
                        break;
                    }
                    allOpenItemsList.addAll(multiAllOpenItemsList);
                }
            }else{
                allOpenItemsList.addAll(mockallOpenItemsList);
            }
            if(account != null && account.Id != null) {
                for(DT_SYS_Open_Item__x item : allOpenItemsList){
                    if(item.GrossAmount__c < 0)
                    {
                        System.debug('allOpenItemsList in Cache--->'+allOpenItemsList);
                        openItemList.add(new Dal_AccountOpenItemWrapper(item));
                    }
                }
                openItemList = sortPrductLst(openItemList,typeOfList);
                System.debug('Data for DZ_2 invoice----->'+ openItemList);
            }
        }
        else{
            System.debug('Cache Data not found');
            if(account != null && account.Id != null) {
                if(!Test.isRunningTest()){
                    allOpenItemsList = [SELECT AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,DivisionName__c, ReasonCodeDesc__c,AllPayersInd__c, Customer__c, CustomerPONo__c, DisplayUrl, Division__c, DueDate__c, ExternalId, GrossAmount__c, Id, id__c, JobName__c, PastDueDays__c, Payer__c, Plant__c, ReasonCode__c, ReferenceDate__c, ReferenceNo__c, SalesReceiptNo__c, ShipFrom__c, ShipFromName__c, TransactionType__c,BOL__c
                    FROM DT_SYS_Open_Item__x
                    WHERE Customer__c =: account.DW_ID__c AND GrossAmount__c < 0 AND ReferenceDate__c = LAST_N_DAYS:30
                    ORDER BY ReferenceDate__c
                    LIMIT :listLimit ];
                }else{
                    allOpenItemsList.add(mockallOpenItems);
                }
                System.debug('allOpenItemsList--->'+allOpenItemsList);
                for(DT_SYS_Open_Item__x item : allOpenItemsList){

                    openItemList.add(new Dal_AccountOpenItemWrapper(item));

                }

            }
        }
        return openItemList;
    }

    // Wrapper Class 
    public class Dal_AccountOpenItemWrapper{
        @AuraEnabled
        Public String TransactionType{get;set;}
        @AuraEnabled
        Public String ReasonCode{get;set;}
        @AuraEnabled
        Public String ReferenceNo{get;set;}
        @AuraEnabled
        Public Datetime ReferenceDate{get;set;}
        @AuraEnabled
        Public Datetime DueDate{get;set;}
        @AuraEnabled
        Public String ShipFrom{get;set;}
        @AuraEnabled
        Public Decimal GrossAmount{get;set;}
        @AuraEnabled
        Public String AgingCode{get;set;}
        @AuraEnabled
        Public String PastDueDays{get;set;}
        @AuraEnabled
        Public String CustomerPONo{get;set;}
        @AuraEnabled
        Public String JobName{get;set;}
        @AuraEnabled
        Public String SalesReceiptNo{get;set;}
        @AuraEnabled
        Public String Division{get;set;}
        @AuraEnabled
        Public String Payer{get;set;}
        @AuraEnabled
        Public String BolNumber{get;set;}

        public Dal_AccountOpenItemWrapper(DT_SYS_Open_Item__x openItem){
            this.TransactionType = openItem.TransactionTypeDesc__c;
            this.ReasonCode = openItem.ReasonCodeDesc__c;
            this.ReferenceNo = openItem.ReferenceNo__c;
            this.ReferenceDate = openItem.ReferenceDate__c;
            this.DueDate = openItem.DueDate__c;
            this.ShipFrom = openItem.ShipFromName__c;
            this.GrossAmount = openItem.GrossAmount__c;
            this.AgingCode = openItem.AgingCodeDesc__c;
            this.PastDueDays = openItem.PastDueDays__c;
            this.CustomerPONo = openItem.CustomerPONo__c;
            this.JobName = openItem.JobName__c;
            this.SalesReceiptNo = openItem.SalesReceiptNo__c;
            this.Division = openItem.DivisionName__c;
            this.Payer = openItem.Payer__c;
            this.BolNumber = openItem.Bol__c;
        }
    }

    public static List<Dal_AccountOpenItemWrapper> sortPrductLst(List<Dal_AccountOpenItemWrapper> openItemReturnLst,String listType) {

        System.debug('orderLocationReturnLst-->' + openItemReturnLst);
        Map<String, Dal_AccountOpenItemWrapper> orderMap = new Map<String, Dal_AccountOpenItemWrapper>(); // Reversed for sorting
        List<String> sortThis = new List<String>();
        Integer count = 0;
        for (Dal_AccountOpenItemWrapper openItemWrapper : openItemReturnLst) {
            count++;
            String reference = String.valueOf(openItemWrapper.ReferenceDate);
            if (orderMap.containsKey(reference)) {
                orderMap.put(reference + String.valueOf(count), openItemWrapper); // For simplicity in this example, we assume the name is unique
                sortThis.add(reference + String.valueOf(count));
            } else {
                orderMap.put(reference, openItemWrapper); // For simplicity in this example, we assume the name is unique
                sortThis.add(reference);
            }

        }

        sortThis.sort(); // Sort by Color in this case
        System.debug('sortThis-->' + sortThis);
        List<Dal_AccountOpenItemWrapper> nameSortedLocation = new List<Dal_AccountOpenItemWrapper>();

        for (String s : sortThis) {
            nameSortedLocation.add(orderMap.get(s));
        }

        System.debug('Sorted by ReferenceDate-->' + nameSortedLocation);
        if(listType == 'AllOpen')
        {
            List<Dal_AccountOpenItemWrapper> finalList = new List<Dal_AccountOpenItemWrapper>();
            for(Integer i = nameSortedLocation.size()-1; i>=0;i--)
            {
                finalList.add(nameSortedLocation.get(i));
            }
            nameSortedLocation = finalList;
        }

        return nameSortedLocation;
    }


    /*
   * Method Name: queryInvoice
   * Description: Method to query on  DT_SYS_InvoiceList__x object for searching
   * @param: poNumber, divisionName, invoicePaymentNumber, transactionFrom, transactionTo, customerId, listLimit) {
   * @return DT_SYS_InvoiceList__x : Invoice List
   */
    public static list<Dal_AccountOpenItemWrapper> queryOpenAccount(String poNumber,String divisionName,String invoicePaymentNumber, String transactionFrom, String transactionTo, String customerId, String filterType, Integer listLimit) {
        System.debug('Open Account >>>' +' '+poNumber+' '+divisionName+' '+invoicePaymentNumber+' '+transactionFrom+' '+transactionTo+' '+customerId+' '+listLimit);
        openItemList = new list<Dal_AccountOpenItemWrapper>();
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        String transDueDateTo = null;
        String transDueDateFrom = null;
       /* Date transDueDateTo;
        Date transDueDateFrom;
        Datetime pickDateFrom;
        Datetime pickDateTo;*/

        if(transactionFrom != null){

            if(!nullorempty(transactionFrom)){
                //Date dt1 = Date.valueOf(transactionFrom);
                //transDueDateFrom = String.valueOf(transactionFrom);
                //transDueDateFrom = Date.valueOf(transactionFrom);
                //pickDateFrom = Datetime.valueOf(Date.valueOf(transDueDateFrom));
                transDueDateFrom = String.valueOf(Date.valueOf(transactionFrom));
                transDueDateFrom = transDueDateFrom+'T05:00:00.000+0000';
                //pickDateFrom = (DateTime) JSON.deserialize(transactionFrom, DateTime.class);
            }

        }

        if( transactionTo != null){

            if(!nullorempty(transactionTo)){
                //Date dt = Date.valueOf(transactionTo);
                //transDueDateTo = String.valueOf(transactionTo);
                //transDueDateTo = Date.valueOf(transactionTo)+1;
                //pickDateTo = Datetime.valueOf(Date.valueOf(transDueDateTo));
                transDueDateTo = String.valueOf(Date.valueOf(transactionTo));
                transDueDateTo = transDueDateTo+'T05:00:00.000+0000';
                //pickDateTo = (DateTime) JSON.deserialize(transactionTo, DateTime.class);
            }
        }

        System.debug('Date >>>' +' '+transDueDateTo+' '+transDueDateFrom);

        List<DT_SYS_Open_Item__x> openAccountList = new List<DT_SYS_Open_Item__x>();
        String dFormat = 'yyyy-MM-dd';

        try{
            String query = 'SELECT AgingCode__c,AgingCodeDesc__c,TransactionTypeDesc__c,'+
                    'DivisionName__c,AllPayersInd__c,ReasonCodeDesc__c,'+
                    'Customer__c, CustomerPONo__c, DisplayUrl,Division__c, DueDate__c, ExternalId,'+
                    'GrossAmount__c, Id, id__c, JobName__c,PastDueDays__c, Payer__c, Plant__c,'+
                    'ReasonCode__c, ReferenceDate__c, ReferenceNo__c,'+
                    'SalesReceiptNo__c, ShipFrom__c,ShipFromName__c,'+
                    'TransactionType__c,BOL__c From DT_SYS_Open_Item__x where  Customer__c = \'' + customerId + '\'' ;

            if(poNumber!=null && String.isNotBlank(poNumber))
            {
                query += ' AND CustomerPONo__c like \'%' + poNumber.toUpperCase() + '%\'';
            }
            if(divisionName!=null && String.isNotBlank(divisionName))
            {
                query += ' AND DivisionName__c like \'%' + divisionName + '%\'';
            }
            if(invoicePaymentNumber!=null && String.isNotBlank(invoicePaymentNumber))
            {
                query += ' AND ReferenceNo__c like \'%' + invoicePaymentNumber.toUpperCase() + '%\'';
            }
            if(transDueDateFrom!=null && transDueDateTo == null){

                //query += ' AND ReferenceDate__c >= \'' + transDueDateFrom + '\'';
                query += ' AND ReferenceDate__c >='+transDueDateFrom;
            }
            if(transDueDateTo!=null && transDueDateFrom == null){

                //query += ' AND ReferenceDate__c <= \'' + transDueDateTo + '\'';
                query += ' AND ReferenceDate__c <='+transDueDateTo;
            }
            if(transDueDateTo!=null && transDueDateFrom!=null){

                //query += ' AND ReferenceDate__c >= \'' + String.escapeSingleQuotes(transDueDateFrom)  + '\' AND ReferenceDate__c <= \'' + String.escapeSingleQuotes(transDueDateTo)  + '\'';
                //query += ' AND ReferenceDate__c >= '+transactionFrom +' AND ReferenceDate__c <= '+transactionTo;
                query += ' AND ReferenceDate__c >= '+transDueDateFrom +' AND ReferenceDate__c <= '+transDueDateTo;
            }
            if(filterType == 'Current Due'){

                query += ' AND ( AgingCode__c = \'' + 'F' + '\' OR AgingCode__c = \'' + 'C' + '\')';
            }
            if(filterType == 'Past Due'){

                query += ' AND ( AgingCode__c != \'' + 'F' + '\' AND AgingCode__c != \'' + 'C' + '\')';
            }
            if(filterType == 'Credits'){

                query += ' AND GrossAmount__c < 0 ';
            }
            if(filterType == 'Total Due'){
                query += ' ORDER BY ReferenceDate__c DESC LIMIT ' + listLimit;
            }else{
                query += ' ORDER BY ReferenceDate__c LIMIT ' + listLimit;
            }

            System.debug('Query------>'+query);
            openAccountList = Database.query(query);
            System.debug('invoiceList --->'+openAccountList);
            System.debug('invoiceList from  actual query--->'+openAccountList.size());

            for(DT_SYS_Open_Item__x item : openAccountList){

                openItemList.add(new Dal_AccountOpenItemWrapper(item));

            }
        }
        catch(Exception exp){
            System.debug('invoiceList : An unexpected error has occurred: ' + exp.getMessage());
        }
        return openItemList;
    }

    public static Boolean nullorempty(String val){
        System.debug('val is '+val);
        Boolean nullempty = false;
        if(val == null || val ==''){
            nullempty = true;
        }else{
            nullempty = false;
        }
        System.debug('nullempty is '+nullempty);
        return nullempty;
    }

}