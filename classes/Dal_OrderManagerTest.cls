/**
 * This class contains unit tests for validating the behavior of Apex classes
**/
@isTest
private class Dal_OrderManagerTest {

    @testSetup
    static void testSetup(){
          UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();
        Freight_Term__c tempTerm = new Freight_Term__c(Code__c = '435545', Name = 'Test');
        insert tempTerm;
        
        DT_Order__c  order = new DT_Order__c ();
        order.Name = 'FirstOrder';
        insert order;

        Account account = new Account();
        account.Id = con.AccountId;
        account.DW_ID__c = '008082001';
        account.Division__c = '40';
        account.Freight_Term__c = tempTerm.Id;
        update account;

        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
    }
    }
    static testMethod void orderManagerTest() {

        List<DT_Order__c> orderListToDelete = new List<DT_Order__c>();
        DT_Order__c  orders = new DT_Order__c ();
        orders.Name = 'SecondOrder';
        orderListToDelete.add(orders);
        insert orderListToDelete;

        DT_Order__c  getOrder = [SELECT Id FROM DT_Order__c LIMIT 1];
        
        DT_SYS_SSC_OrderStatusCount__x dtsys = new DT_SYS_SSC_OrderStatusCount__x(
            OrderCountCompletedOrder__c = 1.0,OrderCountWithLinesOpen__c=1.0,Customer__c = '12456'
        );
        

        List<DT_Order_Product__c> orderProductList = new List<DT_Order_Product__c>();
        DT_Order_Product__c orderProduct = new DT_Order_Product__c(DT_Order_Id__c = getOrder.Id,Name= 'First Product');
        orderProductList.add(orderProduct);
        DT_Order_Product__c orderProduct1 = new DT_Order_Product__c(DT_Order_Id__c = getOrder.Id,Name= 'Second Product');
        orderProductList.add(orderProduct1);
        insert orderProductList;

        DT_Order_Product__c orderProductdelete = new DT_Order_Product__c();
        Test.StartTest();

        List<DT_Order__c> orderById = Dal_OrderManager.getOrderById(getOrder.Id);
        System.assert(true, orderById.size()>0);

        List<DT_SYS_OrderHeader__x> cloneOrde = Dal_OrderManager.cloneOrder(getOrder.Id);
        System.assert(true, cloneOrde.size()>0);

        Dal_OrderManager.saveCurrentOrder(getOrder, orderProductList);
        Dal_OrderManager.submitCurrentOrder(getOrder, orderProductList);
        Dal_OrderManager.deleteOrderLineItem(orderProductdelete);
        Dal_OrderManager.cleanupDraftOrders(orderListToDelete);

        Dal_OrderManager.deleteOrderAndOrderProduct();
        Dal_OrderManager.createNewOrder();
        Dal_OrderManager.getDraftedOrders(100);
      
        Dal_OrderManager.setCurrentOrderInSession(orders.Id);
        
        Test.StopTest();
    }
    static testMethod void getSessionOrderTest() {

        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
       UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id,DW_ID__c FROM Account];
        String poNumber = 'PNO';
        String jobName = 'dev';
        DateTime createDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
         String uniqueName = Dal_TestUtils.getUserString(); 
        DT_SYS_SSC_OrderStatusCount__x dtsys = new DT_SYS_SSC_OrderStatusCount__x(
            OrderCountCompletedOrder__c = 1.0,OrderCountWithLinesOpen__c=1.0,Customer__c = '12456'
        );
        
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;

        Test.startTest();
        System.runAs(newUser){
            Dal_SessionController.sessionOrderName = Dal_Constants.SESSION_ORDER_NAME;
            Dal_OrderManager.getCurrentOrder();
            Dal_OrderManager.mockallOrderStatusCount = dtsys;
            Dal_OrderManager.getOrderStatusCount();
            Dal_OrderManager.createNewOrder();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'ThirdOrder';
            order.AccountName__c = account.Id;
            order.Status__c = 'Draft';
            order.Purchase_Order__c = '3434';
            insert order;
            
            System.assert(Dal_OrderManager.getDraftedOrders(100) <> null);
        }
        Test.stopTest();

    }
    
    static testMethod void getSessionOrderTest1() {
        Profile portalProfile;
        Profile adminProfile;
        
        for(Profile p : [select Id,name from Profile where name IN ('Customer Community Plus Login User', 'System Administrator')]){
            if(p.Name == 'Customer Community Plus Login User'){
                portalProfile = p;
            }else{
                adminProfile = p;
            }
        }
        
        List<Account> accList = new List<Account>();
        Account account;
        
        for(Account acc : [SELECT Id, Division__c, DW_ID__c FROM Account]){
            acc.Division__c = '21';
            accList.add(acc);
            
            account = acc;
        }
        
        Contact contact = [SELECT Id FROM Contact];
        String poNumber = 'PNO';
        String jobName = 'dev';
        
        
        
        DateTime createDate = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        
        DT_SYS_SSC_OrderStatusCount__x dtsys = new DT_SYS_SSC_OrderStatusCount__x(
            OrderCountCompletedOrder__c = 1.0,OrderCountWithLinesOpen__c=1.0,Customer__c = '12456'
        );
        
        List<User> newUsers = new List<User>();
        
        String uniqueName = Dal_TestUtils.getUserString(); 
        User tempUser = new User(profileId = adminProfile.id, username = uniqueName + '@test.org', email = 'pb1@ff.com',
                                 emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                 timezonesidkey = 'America/Los_Angeles', alias='nuser1', lastname='1lastname');
        newUsers.add(tempUser);

        User tempUser1 = new User(profileId = portalProfile.id, username = 'User' + Math.random()*100 + '@test.com', email = 'pb3@ff.com',
                            emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                            timezonesidkey = 'America/Los_Angeles', alias='user3', lastname='3lastname',
                            Selected_Location__c = account.Id, contactId = contact.id);
        newUsers.add(tempUser1);
        insert newUsers;
        
        System.runAs(newUsers[0]){
            update accList;
        }
        
        Test.startTest();
        System.runAs(newUsers[1]){
            System.assert(Dal_OrderManager.getOrderStatusCount() <> null);
        }
        Test.stopTest();

    }    
}