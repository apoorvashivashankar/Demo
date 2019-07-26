/**
* Created by 7Summits on 3/5/18.
*/

public class Dal_AccountOpenItemsController {
    /**
    * This Class return all the data required from External Object "DT_SYS_Open_Item SSC__c"
    * @return List of Wrapper Class of Dal_AccountOpenItemManager
    */
    
    
    //This Method will return All Open Items of a selected Account by Calling Dal_AccountOpenItemManager Class.
    @AuraEnabled
    public static List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> getAllOpenItems(Integer listLimit) {
        
        // Get the user's selected location ID
        System.debug('listLimit---->' + listLimit);
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        Dal_AccountOpenItemManager dalManager = new Dal_AccountOpenItemManager(selectedAccount);
        
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> openItem = Dal_AccountOpenItemManager.getAllOpenItems(selectedAccount, listLimit);
        
        System.debug('AllOpenItems-------------->' + openItem);
        return openItem;
    }
    
    //This Method will return Past Open Items of a selected Account by Calling Dal_AccountOpenItemManager Class.
    @AuraEnabled
    public static List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> getPastOpenItems(Integer listLimit) {
        
        // Get the user's selected location ID
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        System.debug('selectedAccount-------------->' + selectedAccount);
        Dal_AccountOpenItemManager dalManager = new Dal_AccountOpenItemManager(selectedAccount);
        
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> openItem = Dal_AccountOpenItemManager.getPastOpenItems(selectedAccount, listLimit);
        
        System.debug('AllOpenItems-------------->' + openItem);
        return openItem;
    }
    
    //This Method will return Current Open Items of a selected Account by Calling Dal_AccountOpenItemManager Class.
    @AuraEnabled
    public static List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> getCurrentOpenItems(Integer listLimit) {
        
        // Get the user's selected location ID
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        System.debug('selectedAccount-------------->' + selectedAccount);
        Dal_AccountOpenItemManager dalManager = new Dal_AccountOpenItemManager(selectedAccount);
        
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> openItem = Dal_AccountOpenItemManager.getCurrentOpenItems(selectedAccount, listLimit);
        
        System.debug('AllOpenItems-------------->' + openItem);
        return openItem;
    }
    
    //This Method will return All 'Returns & Credits' of a selected Account by Calling Dal_AccountOpenItemManager Class.
    @AuraEnabled
    public static List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> getReturnsAndCreditsOpenItems(Integer listLimit) {
        
        // Get the user's selected location ID
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        Dal_AccountOpenItemManager dalManager = new Dal_AccountOpenItemManager(selectedAccount);
        
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> openItem = Dal_AccountOpenItemManager.getReturnsAndCreditsOpenItems(selectedAccount, listLimit);
        
        System.debug('AllOpenItems-------------->' + openItem);
        return openItem;
    }
    
    @AuraEnabled
    public static List<Dal_OrderSearchController.StatusOption> getBrandlist() {
        
        system.debug('calling to get brands');
        List<Dal_OrderSearchController.StatusOption> brandoptions = new List<Dal_OrderSearchController.StatusOption>();
        Set<String> brands = Dal_AccountOpenItemsController.getBrandsAccount();
        system.debug(' brands ' + brands);
        for (String brand : brands) {
            brandoptions.add(new Dal_OrderSearchController.StatusOption(brand, brand));
        }
        System.debug('brandoptions' + brandoptions);
        
        return brandoptions;
    }
    
    public static Set<String> getBrandsAccount(){
        
        String customerId = Dal_AccountOpenItemsController.getCustomerId();
        Set<String> division_name = new Set<String>();
        if(!Test.isRunningTest()){
            for(DT_SYS_Open_Item__x inv : [SELECT DivisionName__c, TransactionTypeDesc__c
                                           FROM DT_SYS_Open_Item__x
                                           where Customer__c =: customerId]){
                                               system.debug('inside for loop controller'+inv.DivisionName__c);
                                               division_name.add(inv.DivisionName__c);
                                           }
        }else{
            division_name.add('test');
        }
        
        return division_name;
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
    
    @AuraEnabled
    public static List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> searchOpenAccount(String userType, String invoiceNumber, String purchaseOrder, String divisionName,String invoiceFrom, String invoiceTo, String filterType, Integer listLimit) {
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accountWrapper = new List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper>();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        //queryOpenAccount(String poNumber,String divisionName,String invoicePaymentNumber, String transactionFrom, String transactionTo, String customerId, String listType, Integer listLimit)
        String customerId =selectedAccount.DW_ID__c;
        accountWrapper= Dal_AccountOpenItemManager.queryOpenAccount(purchaseOrder,divisionName,invoiceNumber,invoiceFrom,invoiceTo,customerId,filterType,listLimit);
        System.debug('userType-- '+userType + ' invoiceNumber-- '+invoiceNumber+ ' purchaseOrder-- '+purchaseOrder+ ' divisionName-- '+divisionName + ' invoiceFrom-- '+invoiceFrom +' invoiceFrom-- ' +invoiceTo + ' filterType ' + filterType + ' listLimit--'+listLimit);
        return accountWrapper;
    }
    
    
}