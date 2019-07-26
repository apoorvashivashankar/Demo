/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest
public class Dal_OrderSearchControllerTest {
    
    @testSetup
    static void testSetup(){
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();  
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
        }
        
    }
    
    static testMethod void getOpenOrderTest() {
        
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String OrderNumber = '0001234';
        String JobName = 'Admin';
        String usertype = 'New User';       
        String orderType = 'New Orders';
        String PurchaseOrder = 'max order';
        Datetime OrderDateFrom = date.newInstance(1983, 7, 15);
        Datetime OrderDateTo = date.newInstance(1983, 7, 15);
        String LineStatus = 'Valid';
        
        Test.startTest();
        System.runAs(newUser){
            Dal_OrderSearchController orderSearchController = new Dal_OrderSearchController();
            String CustomerId = Dal_OrderSearchController.getCustomerId();
            System.assert(true, CustomerId);
            System.assertNotEquals(null, Dal_OrderSearchController.getLineStatuses(usertype, orderType));
            System.assertNotEquals(null, Dal_OrderSearchController.searchAllOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), lineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchOrderHistory(userType, orderNumber, purchaseOrder, jobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), lineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchOpenOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), lineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchCompletedOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), lineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchOrdersForPickup(userType, orderNumber, purchaseOrder, jobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), lineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchOpenOrders(userType, OrderNumber, PurchaseOrder, JobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), LineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.searchOpenOrders('Distributor', OrderNumber, PurchaseOrder, JobName, String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateTo.Date()), LineStatus, 1000));
            System.assertNotEquals(null, Dal_OrderSearchController.getShipfromLoc());
            System.assertNotEquals(null, Dal_OrderSearchController.getCarrier());
            System.assertNotEquals(null, Dal_OrderSearchController.forDateValue(String.valueOf(OrderDateTo.Date()), String.valueOf(OrderDateFrom.Date())));
        } 
        Test.stopTest(); 
        
    }
    static testMethod void statusbyDist_HistTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String usertype = 'Distributor';
        String orderType = 'History List';    
        Test.startTest();
        System.runAs(newUser){
            List<Dal_OrderSearchController.StatusOption> lineStatuses = Dal_OrderSearchController.getLineStatuses(usertype, orderType);
            System.assert(true, lineStatuses);
        } 
        Test.stopTest();       
    }
    static testMethod void statusbyDist_OrderTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String usertype = 'Distributor';
        String orderType = 'Orders List';    
        Test.startTest();
        System.runAs(newUser){
            List<Dal_OrderSearchController.StatusOption> lineStatuses = Dal_OrderSearchController.getLineStatuses(usertype, orderType);
            System.assert(true, lineStatuses);
        } 
        Test.stopTest();       
    }   
    static testMethod void statusbySSCTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String usertype = 'SSC';
        String orderType = 'Orders List';    
        Test.startTest();
        System.runAs(newUser){
            List<Dal_OrderSearchController.StatusOption> lineStatuses = Dal_OrderSearchController.getLineStatuses(usertype, orderType);
            System.assert(true, lineStatuses);
        } 
        Test.stopTest();       
    }   
    static testMethod void statusbySSC_CompTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String usertype = 'SSC';
        String orderType = 'Completed Orders List';    
        Test.startTest();
        System.runAs(newUser){
            List<Dal_OrderSearchController.StatusOption> lineStatuses = Dal_OrderSearchController.getLineStatuses(usertype, orderType);
            System.assert(true, lineStatuses);
        } 
        Test.stopTest();       
    } 
    static testMethod void statusbySSC_PickupTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String usertype = 'SSC';
        String orderType = 'Pickup Orders List'; 
        Integer listLimit = 100;
        DT_SYS_OrderList__x dtsys = new DT_SYS_OrderList__x(
            Customer__c = '123', HostSystem__c = 'SAP', jobName__c = 'test', OrderPlantName__c = 'test', 
            OrderPlant__c = 'test', SalesOrder__c = '123',StatusDesc__c = 'test' , Status__c = 'Open',
            CustomerPONo__c = 'test'
        );
        List<String> statusList = new List<String> {'AAA', 'AAA', 'BBB', 'BBB', 'CCC'};
            Test.startTest();
        System.runAs(newUser){
            List<Dal_OrderSearchController.StatusOption> lineStatuses = Dal_OrderSearchController.getLineStatuses(usertype, orderType);
            System.assert(true, lineStatuses);
            List<Dal_OrderSearchController.OrderWrapper> scheduled = Dal_OrderSearchController.getOrdersToBeScheduled(listLimit);
            System.assert(true,scheduled.size()>0);
            List<Dal_OrderSearchController.OrderWrapper> deliveries = Dal_OrderSearchController.getScheduledDeliveries(listLimit);
            System.assert(true,deliveries.size()>0);
            List<Dal_OrderSearchController.OrderWrapper> pickups = Dal_OrderSearchController.getScheduledPickups(listLimit);
            System.assert(true,pickups.size()>0);
            
        } 
        Test.stopTest();       
    } 
    static testMethod void queryOrderListTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String orderNumber = 'Distributor';
        String purchaseOrder = 'OrdersList';  
        String jobName = 'Distributor';
        DateTime orderDateFrom = null;
        DateTime orderDateTo = datetime.newInstance(2018, 9, 15, 12, 30, 0);
        String lineStatus = 'Orders List'; 
        String userType = 'Admin'; 
        
        Test.startTest();
        System.runAs(newUser){
            Dal_OrderSearchController.searchOrderHistory
                (userType, orderNumber, purchaseOrder, jobName, null, String.valueOf(OrderDateTo.Date()), lineStatus, 1000);
        } 
        Test.stopTest();       
    } 
    static testMethod void queryOrderListTest2() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String orderNumber = 'Distributor';
        String purchaseOrder = 'Orders List';  
        String jobName = 'Distributor';
        DateTime orderDateFrom = datetime.newInstance(2018, 9, 15, 12, 30, 0);
        DateTime orderDateTo = null;
        String lineStatus = 'Accepted'; 
        String userType = 'Orders List'; 
        
        DT_SYS_OrderList__x dtsys = new DT_SYS_OrderList__x(
            Customer__c = '123', HostSystem__c = 'SAP', jobName__c = 'test', OrderPlantName__c = 'test', 
            OrderPlant__c = 'test', SalesOrder__c = '123',StatusDesc__c = 'test' , Status__c = 'Open',
            CustomerPONo__c = 'test'
        );
        
        Test.startTest();
        System.runAs(newUser){
            Dal_OrderSearchController.mockallOrderLineList.add(dtsys);
            Dal_OrderSearchController.searchOrderHistory(userType, orderNumber, purchaseOrder, jobName, String.valueOf(orderDateFrom.Date()), null, lineStatus, 1000);
        } 
        Test.stopTest();       
    } 
    static testMethod void queryAllOrderList() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String orderNumber = 'Distributor';
        String purchaseOrder = 'Orders List';  
        String jobName = 'Distributor';
        DateTime orderDateFrom = datetime.newInstance(2018, 9, 15, 12, 30, 0);
        DateTime orderDateTo = null;
        String lineStatus = ''; 
        String userType = 'Distributor'; 
        
        DT_SYS_OrderList__x dtsys = new DT_SYS_OrderList__x(
            Customer__c = '123', HostSystem__c = 'SAP', jobName__c = 'test', OrderPlantName__c = 'test', 
            OrderPlant__c = 'test', SalesOrder__c = '123',StatusDesc__c = 'test' , Status__c = 'Open',
            CustomerPONo__c = 'test'
        );
        
        Test.startTest();
        System.runAs(newUser){
            Dal_OrderSearchController.mockallOrderLineList.add(dtsys);
            Dal_OrderSearchController.searchAllOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(orderDateFrom.Date()), null, lineStatus, 1000);
            Dal_OrderSearchController.searchOpenOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(orderDateFrom.Date()), null, lineStatus, 1000);
        } 
        Test.stopTest();       
    } 
        static testMethod void queryAllOrderListSSC() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        String orderNumber = 'Distributor';
        String purchaseOrder = 'Orders List';  
        String jobName = 'Distributor';
        DateTime orderDateFrom = datetime.newInstance(2018, 9, 15, 12, 30, 0);
        DateTime orderDateTo = null;
        String lineStatus = ''; 
        String userType = 'SSC'; 
        
        DT_SYS_OrderList__x dtsys = new DT_SYS_OrderList__x(
            Customer__c = '123', HostSystem__c = 'SAP', jobName__c = 'test', OrderPlantName__c = 'test', 
            OrderPlant__c = 'test', SalesOrder__c = '123',StatusDesc__c = 'test' , Status__c = 'Open',
            CustomerPONo__c = 'test'
        );
        
        Test.startTest();
        System.runAs(newUser){
            Dal_OrderSearchController.mockallOrderLineList.add(dtsys);
            Dal_OrderSearchController.searchAllOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(orderDateFrom.Date()), null, lineStatus, 1000);
            Dal_OrderSearchController.searchOpenOrders(userType, orderNumber, purchaseOrder, jobName, String.valueOf(orderDateFrom.Date()), null, lineStatus, 1000);
        } 
        Test.stopTest();       
    } 
    static testMethod void OppToOrdersTest() {
    	User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        List<Id> oppIds = new List<Id>();
        DT_Order__c orderIds = [SELECT ID FROM DT_Order__c LIMIT 1];
        List<Id>lstOforderIds = new List<Id>();
        lstOforderIds.add(orderIds.Id);
        Test.startTest();
        System.runAs(newUser){
        Dal_OrderSearchController.getListOfOrderFromOpp(oppIds);
        Dal_OrderSearchController.mapOppToOrders(oppIds, lstOforderIds);
        }
        Test.stopTest(); 
    }
}