@istest
public class Dal_OpportunityOrderSearchTest {
    
    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c dtorder = new DT_Order__c();
            dtorder.Name = 'test-dtorder-name';
            dtorder.Delegate_First_Name__c = '123';
            dtorder.Requested_Ship_date__c = system.today();
            dtorder.Default_Requested_Ship_Date__c = system.today();
            dtorder.Carrier__c = '8ret';
            insert dtorder;
            
            DT_Order_Product__c dtorderproduct = new DT_Order_Product__c();
            dtorderproduct.Name = '0000';
            dtorderproduct.DT_Order_Id__c = dtorder.Id;
            insert dtorderproduct;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            account.Division__c = 'OASIS';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString(); 
            User newUser = new User(profileId = p.id,username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
            
            List<Opportunity> oList = new List<Opportunity>();
            Opportunity opp =  new Opportunity();
            opp.Name ='00New mAWS Deal';
            opp.AccountID =account.id;
            opp.StageName = 'Negotiations';
            opp.Amount = 3000;
            opp.CloseDate = System.today();
            oList.add(opp);
            Opportunity opp1 =  new Opportunity();         
            opp1.Name = '01mAWS Usage'; 
            opp1.AccountId = account.id;
            opp1.StageName = 'Negotiations';
            opp1.CloseDate = System.today();
            opp1.Type = 'New Business';
            opp1.Amount = 555888555;
            oList.add(opp1);
            insert oList;
            
        }
        
    }
    
    public static testMethod void getOpportunityOrder(){
        
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com' LIMIT 1];
        Opportunity  opp = [Select id,Name,StageName from Opportunity where name ='01mAWS Usage' Limit 1];
        
        DT_SYS_OrderList__x dtsys = new DT_SYS_OrderList__x(
                Customer__c = '123', HostSystem__c = 'SAP', jobName__c = 'test', OrderPlantName__c = 'test', 
                OrderPlant__c = 'test', SalesOrder__c = '123',StatusDesc__c = 'test' , Status__c = 'Open',
                CustomerPONo__c = 'test'
            );
            
        String OrderNumber = '0001234';
        String JobName = 'test';
        String usertype = 'New User';       
        String orderType = 'New Orders';
        String PurchaseOrder = 'max order';
        Datetime OrderDateFrom = date.newInstance(1983, 7, 15);
        Datetime OrderDateTo = date.newInstance(1983, 7, 15);
        String LineStatus = 'Valid';
        
        System.runAs(newUser){
            Dal_OpportunityOrderSearch.mockallOrderLineList.add(dtsys);
            Dal_OpportunityOrderSearch.searchOpportunityRelatedOrder(opp.Id);
            Dal_OpportunityOrderSearch.geAllOrderList(orderNumber, purchaseOrder, jobName, String.valueOf(date.today()), String.valueOf(date.today()), lineStatus, opp.Id, 10);
            Dal_OpportunityOrderSearch.geAllOrderList(orderNumber, purchaseOrder, jobName, null, String.valueOf(date.today()), lineStatus, opp.Id, 10);
            Dal_OpportunityOrderSearch.geAllOrderList(orderNumber, purchaseOrder, jobName, String.valueOf(date.today()), null, lineStatus, opp.Id, 10);
            Dal_OpportunityOrderSearch.geAllOrderList(orderNumber, purchaseOrder, jobName, null, null, lineStatus, opp.Id, 10);
        }
    }
}