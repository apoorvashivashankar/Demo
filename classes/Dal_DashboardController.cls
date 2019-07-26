/**
* Created by 7Summits on 5/10/2018.
*/
public class Dal_DashboardController {

    /*
    * Method Name: getDistributorDashboardData
    * Description: get a data blocks wrapper data for dashboard
    * @param: None
    * @return List<Object>
    */
    @TestVisible
    public static String communityTestName;
    @TestVisible
    public static String profileTestName;    
    
    public static String communityName;
  
    @AuraEnabled
    public static List<Object> getDistributorDashboardData(){
        List<Object> listOfObjects = new List<Object>();
        DataBlock dBlock;
        MyDashboardMetricWrapper dbMetric = getDashboardData();
         String communityUrl;
        if(Test.isRunningTest()){
            communityUrl = 'https://c.cs24.visual.force.com';
        }
        else
        {
           communityUrl = Network.communitiesLanding().getUrl();
        }
//       	String communityUrl = Network.communitiesLanding().getUrl();
        if(dbMetric.isInvoiceVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Invoices (Last 60 Days)';
            dBlock.value = String.valueOf(dbMetric.distinvoiceCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+'account-invoices';
            dBlock.iconType = 'icon-invoice';
            listOfObjects.add(dBlock);   
        }
        if(dbMetric.isOpenOrdersVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Open Orders';
            dBlock.value = String.valueOf(dbMetric.distopenOrderCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+System.Label.Dal_OpenOrder;
            dBlock.iconType = 'icon-order';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isShipmentsVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Shipments (Last 90 Days)';
            dBlock.value = String.valueOf(dbMetric.distshipmentCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+System.Label.Dal_ShipmentLabel;
            dBlock.iconType = 'icon-shipment';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isOpportunitiesVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Opportunities (Last 90 Days)';
            dBlock.value = String.valueOf(dbMetric.opportunityCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+'opportunity';
            dBlock.iconType = 'icon-opportunity';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isOpenCasesVisible){
            dBlock = new DataBlock();
            dBlock.label = 'My Open Cases';
            dBlock.value = String.valueOf(dbMetric.openCasesCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.iconType = 'icon-case';
            dBlock.ctaUrl = communityUrl+'case/Case/00BA0000001frjD';
            listOfObjects.add(dBlock);
        }
        return listOfObjects;
    }

    /*
    * Method Name: getSSCDashboardData
    * Description: get a data blocks wrapper data for ssc dashboard metrices
    * @param: None
    * @return List<Object>
    */
    @AuraEnabled
    public static List<Object> getSSCDashboardData(){
        List<Object> listOfObjects = new List<Object>();
        DataBlock dBlock;

        MyDashboardMetricWrapper dbMetric = getDashboardData();
        String communityUrl;
         if(Test.isRunningTest()){
             communityUrl = 'https://c.cs24.visual.force.com'; 	
         }
        else{
            communityUrl = Network.communitiesLanding().getUrl();
        }
        if(dbMetric.isOrderForPickupAndDeliveryVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Orders for Pickup and Delivery';
            dBlock.value = String.valueOf(dbMetric.sscorderForPickupAndDeliveryCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View All';
            dBlock.ctaUrl = communityUrl+System.Label.Dal_OrderPickupDelivery_Label;
            dBlock.hasInnerComponent = true;
            dBlock.innerComponentLabelOpen = 'Show Orders';
            dBlock.innerComponentLabelClose = 'Hide Orders';
            dBlock.innerComponentName = 'c:Dal_SSC_DeliveryPickupTabs';
            dBlock.iconType = 'icon-order';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isOpenOrdersVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Open Orders';
            dBlock.value = String.valueOf(dbMetric.sscopenOrderCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+System.Label.Dal_SSC_OpenOrder;
            dBlock.iconType = 'icon-order';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isCompletedOrderVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Completed Orders';
            dBlock.value = String.valueOf(dbMetric.ssccompletedOrderCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View Completed Orders';
            dBlock.ctaUrl = communityUrl+System.Label.Dal_CompletedOrder_label;
            dBlock.iconType = 'icon-order';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isOpenCasesVisible){
            dBlock = new DataBlock();
            dBlock.label = 'My Open Cases';
            dBlock.value = String.valueOf(dbMetric.openCasesCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+'case/Case/00BA0000001frjD';
            dBlock.iconType = 'icon-case';
            listOfObjects.add(dBlock);
        }
        if(dbMetric.isInvoiceVisible){
            dBlock = new DataBlock();
            dBlock.label = 'Invoices (Last 60 Days)';
            dBlock.value = String.valueOf(dbMetric.sscinvoiceCount);
            dBlock.valueFontSize = 'large';
            dBlock.ctaLabel = 'View';
            dBlock.ctaUrl = communityUrl+'account-invoices';
            dBlock.iconType = 'icon-invoice';
            listOfObjects.add(dBlock);
        }
        return listOfObjects;
    }

    /*
    * Method Name: getDistributorDashboardData
    * Description: get a data blocks wrapper data for distributor dashboard metrices
    * @param: None
    * @return MyDashboardMetricWrapper
    */
 	private static MyDashboardMetricWrapper getDashboardData(){
        MyDashboardMetricWrapper wrapper = new MyDashboardMetricWrapper();
		Account selectedAccount = Dal_BaseController.getUserSelectedLocation();	
        Dal_OrderManager.OrderCountstatusWrapper countWrapper = Dal_OrderProcessController.getStatusCount();
        system.debug('MyDashboardMetricWrapper '+countWrapper);
        
        if(countWrapper!=null){        
		wrapper.sscopenOrderCount = countWrapper.openordercount != null? Integer.valueof(countWrapper.openordercount):0;
        wrapper.distshipmentCount = countWrapper.ShipmentCountLast90Days != null? Integer.valueof(countWrapper.ShipmentCountLast90Days):0;
        wrapper.distinvoiceCount = countWrapper.InvoiceCountLast30Days !=null?Integer.valueOf(countWrapper.InvoiceCountLast30Days):0;
        wrapper.distopenOrderCount = countWrapper.OrderCountWithLinesOpen !=null?Integer.valueOf(countWrapper.OrderCountWithLinesOpen):0;
        wrapper.sscorderForPickupAndDeliveryCount = countWrapper.readyforpickupdeliverycount != null ? Integer.valueof(countWrapper.readyforpickupdeliverycount) : 0;
        wrapper.ssccompletedOrderCount = countWrapper.completedordercount != null ? Integer.valueof(countWrapper.completedordercount): 0;
        wrapper.sscinvoiceCount = countWrapper.sscInvoicecount != null ? Integer.valueof(countWrapper.sscInvoicecount): 0;
        }
  		
        if(!Test.isRunningTest()){
            User currentUser = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        	wrapper.opportunityCount =Integer.valueOf([SELECT COUNT() FROM Opportunity WHERE Account.DW_ID__c =:selectedAccount.DW_ID__c and CreatedDate >= LAST_N_DAYS:90]);
        	wrapper.openCasesCount = Integer.valueOf([SELECT COUNT() FROM Case WHERE Status != 'Closed' AND ContactId = :currentUser.ContactId]);
        } else{
            wrapper.opportunityCount = 1;
            wrapper.openCasesCount = 2;
        }
        // For Profile
        Id profileId=userinfo.getProfileId();
        system.debug('profileId---->'+profileId);
        String profileName;
        
        If(!Test.isRunningTest())
        {
           	profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        }else{
            profileName = profileTestName;
        }
        
        system.debug('ProfileName-------->'+profileName);

       	
		If(!Test.isRunningTest())
        {
           	String communityId=Network.getNetworkId();
        	communityName = [Select Id,Name from Network where Id=:communityId].Name;   
        }else{
            communityName = communityTestName;
        }
      
        system.debug('communityName-------->'+communityName);

        if(profileName == Dal_Constants.DIST_CUST_SERVICE && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
             wrapper.isInvoiceVisible = false; 
             wrapper.isOpenOrdersVisible = true;
             wrapper.isShipmentsVisible = true ;
             wrapper.isOpportunitiesVisible = false;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_CUST_SERVICE && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = true ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.DIST_PURCHASER && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isShipmentsVisible = true ;
             wrapper.isOpportunitiesVisible = false;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_PURCHASER  && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = true ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.DIST_ACCOUNTING && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
             wrapper.isInvoiceVisible = true;
             wrapper.isOpenOrdersVisible = false;
             wrapper.isShipmentsVisible = false ;
             wrapper.isOpportunitiesVisible = false;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_ACCOUNTING && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = true;
             wrapper.isOpenOrdersVisible = false;
             wrapper.isOrderForPickupAndDeliveryVisible = false ;
             wrapper.iscompletedOrderVisible = false;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.DIST_SALES_REP && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isShipmentsVisible = true ;
             wrapper.isOpportunitiesVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_SALES_REP && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = false ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.DIST_LEADER_PRINCIPLE && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
             wrapper.isInvoiceVisible = true;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isShipmentsVisible = false;
             wrapper.isOpportunitiesVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_LEADER_PRINCILPLE && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = true ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
             wrapper.isInventorySearchVisible = true;
             wrapper.isInventoryBrandedVisible = true;
             wrapper.isInventoryInstallationVisible = true;
             wrapper.isSalesLeadVisible = true;
             wrapper.isMyLeadsVisible = true;
             wrapper.isMyOpportunitiesVisible = true;

        }else if(profileName == Dal_Constants.SSC_DEALER_SALES_REP && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = false ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
    	}else if(profileName == Dal_Constants.SSC_DEALER_LEADER_PRINCILPLE && communityName == Dal_Constants.SSC_COMMUNITY){
             wrapper.isInvoiceVisible = false;
             wrapper.isOpenOrdersVisible = true;
             wrapper.isOrderForPickupAndDeliveryVisible = true ;
             wrapper.iscompletedOrderVisible = true;
             wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.SSC_PURCHASER_II && communityName == Dal_Constants.SSC_COMMUNITY){
            wrapper.isInvoiceVisible = false;
            wrapper.isOpenOrdersVisible = true;
            wrapper.isOrderForPickupAndDeliveryVisible = false ;
            wrapper.iscompletedOrderVisible = true;
            wrapper.isOpenCasesVisible = true;
        }else if(profileName == Dal_Constants.DIST_SALES_REP_1 && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            wrapper.isInvoiceVisible = false;
            wrapper.isOpenOrdersVisible = true;
            wrapper.isShipmentsVisible = true ;
            wrapper.isOpportunitiesVisible = false;
            wrapper.isOpenCasesVisible = true;
        }else{
            wrapper.isInvoiceVisible = true;
            wrapper.isOpenOrdersVisible = true;
            wrapper.isShipmentsVisible = true ;
            wrapper.isOpportunitiesVisible = true;
            wrapper.isOpenCasesVisible = true;
            wrapper.isOrderForPickupAndDeliveryVisible = true;
            wrapper.iscompletedOrderVisible = true;
        }
     
        return wrapper;
    }

    /*
	* Method Name: getAllCases
	* Description: Purpose to retrieve an list of cases that recently viewed
	* @param: None
	* @return Peak_Response
	*/
    @AuraEnabled
    public static Peak_Response getAllCases(){
        Peak_Response response = new  Peak_Response();
        List<Case> caseList =new List<Case>();
        caseList = [SELECT Id,CaseNumber, Status, CreatedDate FROM Case];
        if(caseList.size() > 0 && String.isNotBlank(caseList[0].id)) {
            for(Case caseObj : caseList){
                response.results.add(caseObj);
            }
            response.messages.add('Record Found');
        	response.peakResults = null;
            return response;
        }else{
           	System.debug('Case not found');
            response.success= false;
       		response.messages.add('Record not found');
       		response.results = null;
       		response.peakResults = null;
       		return response;
         }
    }

    @AuraEnabled
    public static List<String> getPickupDashboardCounts(){
        List<String> returnList = new List<String>();
        Dal_OrderManager.OrderCountstatusWrapper countWrapper = Dal_OrderProcessController.getStatusCount();
        returnList.add(String.valueOf(countWrapper.readyforpickupdeliverycount.format()));
        returnList.add(String.valueOf(countWrapper.scheduledforpickup.format()));
        returnList.add(String.valueOf(countWrapper.scheduledfordeliverycount.format()));
        return returnList;
    }

    @AuraEnabled
    public static AccountCartWrapper getAccountCartDetail(String oldAccountId){
        System.debug('accountId-->'+oldAccountId);
        String UserId = UserInfo.getUserId();
        List<DT_Cart__c> dtCartList = new List<DT_Cart__c>();
        List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
        AccountCartWrapper accountCartWrapper = new AccountCartWrapper();
        String brandName;

        try{
            dtCartList = [SELECT Id,Cart_Account__c,Cart_Account__r.Name,Cart_Account__r.DW_ID__c, Cart_Account__r.ShippingCity,Cart_Account__r.Division_Name__r.Name, User__c FROM DT_Cart__c WHERE Cart_Account__c =: oldAccountId AND User__c =:UserId];

            if(dtCartList.size() > 0){
                cartProductList = [Select Id, Name,Dt_Cart__r.Id,DT_Cart__c,LastModifiedDate From DT_Cart_Product__c Where DT_Cart__c =: dtCartList[0].Id ORDER BY LastModifiedDate DESC ];
            }
            if(cartProductList.size() > 0){
                System.debug('InIF-->'+cartProductList[0].DT_Cart__c);
                accountCartWrapper.accountNumber = String.isEmpty(dtCartList[0].Cart_Account__r.DW_ID__c) ? '' : dtCartList[0].Cart_Account__r.DW_ID__c + ' / ';
                accountCartWrapper.accountName = String.isEmpty(dtCartList[0].Cart_Account__r.Name) ? '' : dtCartList[0].Cart_Account__r.Name +' / ';
                accountCartWrapper.city = String.isEmpty(dtCartList[0].Cart_Account__r.ShippingCity) ? '' : dtCartList[0].Cart_Account__r.ShippingCity +' / ';
                brandName = dtCartList[0].Cart_Account__r.Division_Name__r.Name;
                brandName= brandName.remove('Sales SBU');
                brandName= brandName.remove('DISTRB SBU');
                accountCartWrapper.divisionName = String.isEmpty(dtCartList[0].Cart_Account__r.Division_Name__r.Name) ? '' : brandName;
				
                Integer numberDaysDue = Date.Today().daysBetween(cartProductList[0].LastModifiedDate.Date());
                System.debug('--numberDaysDue-before:'+numberDaysDue);

                if(numberDaysDue <= 0){
                    accountCartWrapper.count = 6 - ((numberDaysDue * -1)+1);
                } else{
                    accountCartWrapper.count = 6 - (numberDaysDue+1);
                }

                if(Date.Today().isSameDay(cartProductList[0].LastModifiedDate.Date())){
                    accountCartWrapper.count = 5;
                    System.debug('--today--:'+accountCartWrapper.count);
                }
                System.debug('--accountCartWrapper--:'+accountCartWrapper);
                return accountCartWrapper;
            }else{
                System.debug('InElse-->'+cartProductList);
                return null;
            }
        } catch (Exception exp) {
            System.debug('cartProductLst : An unexpected error has occurred: ' + exp.getMessage());
        }
        return accountCartWrapper;
    }

    public class AccountCartWrapper{
        @AuraEnabled public String accountNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public String city;
        @AuraEnabled public String divisionName;
        @AuraEnabled public Integer count;
    }

    public class DataBlock{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String valueFontSize;
        @AuraEnabled public String ctaLabel;
        @AuraEnabled public String ctaUrl;
        @AuraEnabled public Boolean hasInnerComponent = false;
        @AuraEnabled public String innerComponentLabelOpen;
        @AuraEnabled public String innerComponentLabelClose;
        @AuraEnabled public String innerComponentName;
        @AuraEnabled public String iconType;
    }

    public class MyDashboardMetricWrapper{
        @AuraEnabled public Boolean isInvoiceVisible;
        @AuraEnabled public Boolean isOpenOrdersVisible;
        @AuraEnabled public Boolean isShipmentsVisible ;
        @AuraEnabled public Boolean isOpportunitiesVisible;
        @AuraEnabled public Boolean isOpenCasesVisible;
        @AuraEnabled public Boolean isOrderForPickupAndDeliveryVisible;
        @AuraEnabled public Boolean iscompletedOrderVisible;
        @AuraEnabled public Boolean isInventorySearchVisible;
        @AuraEnabled public Boolean isInventoryBrandedVisible;
        @AuraEnabled public Boolean isInventoryInstallationVisible;
        @AuraEnabled public Boolean isSalesLeadVisible;
        @AuraEnabled public Boolean isMyLeadsVisible;
        @AuraEnabled public Boolean isMyOpportunitiesVisible;
        @AuraEnabled public Integer distinvoiceCount;
        @AuraEnabled public Integer sscopenOrderCount;
        @AuraEnabled public Integer distopenOrderCount;
        @AuraEnabled public Integer distshipmentCount;
        @AuraEnabled public Integer opportunityCount;
        @AuraEnabled public Integer openCasesCount;
        @AuraEnabled public Integer sscorderForPickupAndDeliveryCount;
        @AuraEnabled public Integer ssccompletedOrderCount;
        @AuraEnabled public Integer sscinvoiceCount;
    }
  
}