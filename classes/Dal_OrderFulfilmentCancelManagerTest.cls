/**
* Created by Preshit on 22-02-2019.
*/

@isTest
public class Dal_OrderFulfilmentCancelManagerTest {
    @TestSetup
    static void datasetup() {
        User Objuser = [Select id from user where profile.name = 'System Administrator' AND Isactive = true AND Userroleid != null limit 1];
        System.runAs(Objuser) {
            Contact con = Dal_TestUtils.createTestContact();
            con.Email = 'newUser@yahoo.com';
            update con;

            DT_Order__c order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;

            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            update account;

            SSC__c ssc = new SSC__c(Closed__c = false
                    , DW_ID__c = '123'
                    , Loc_Type__c = 'SSC'
                    ,SAP_Plant__c = '4185'
                    , Manager__c = UserInfo.getUserId()
                    , Sales_Region__c = '04'
                    , SBU__c = 'DI'
                    , Select__c = true
                    , SSC_Fax_Number__c = '123-345-5567'
                    , SSC_Phone_Number__c = '123-345-5567'
                    , State__c = 'TX'
                    , Street_Address__c = '12345 1st street'
                    , Zip_Code__c = '12345');
            insert ssc;

            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;

            Profile p = [select Id,name from Profile where name = 'Customer Community Plus Login User'];

            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles', alias = 'nuser', lastname = 'lastname',
                    Selected_Location__c = con.accountId, contactId = con.id
            );
            insert newUser;
        }
    }
    public static testMethod void cancelFulfilmentTest() {
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        System.runAs(newUser){
            DT_SYS_OrderLine__x orderLine = new DT_SYS_OrderLine__x(Quantity__c=10.00,UOM__c='10',RequestedShipDate__c=String.valueOf(System.today()),
                    MaterialDesc_Size__c='test',MaterialDesc_Color__c='test',
                    MaterialDesc_Trim__c='test',Quantity_Invoiced__c=10.00,
                    Quantity_Cancelled__c=10.00,WeightExtended__c=10.00,
                    Price_PriceNet_Extended__c=10,SalesOrder__c='124578144',SalesOrderLineKey__c = '1',
                    MaterialDesc__c = 'test',Material__c='123456789',QuantityInLegacyBaseUOM__c ='10',
                    SalesOrderLineNo__c = '1',LegacyBaseUOM__c = 'SF',StatusDesc2__c = 'test');


            DT_SYS_OrderHeader__x orderHeader = new DT_SYS_OrderHeader__x( SalesOrder__c = '124578144' ,SalesOrderHeaderKey__c = 'key',
                    CustomerPONo__c = 'Po',OrderPlant__c ='123',JobName__c = 'job',
                    Fulfilment_Method__c = 'PICK',Status__c = 'status',Account_Contact_Phone__c = 'phone', Account_Contact_FirstName__c = 'first',
                    Account_Contact_LastName__c = 'last',Fulfilment_ShipToAddress_Address_City__c = 'city',Fulfilment_ShipToAddress_Address_Country__c = 'US',
                    Fulfilment_ShipToAddress_Address_Line1__c = 'addressOne' ,Fulfilment_ShipToAddress_Address_Line2__c = 'Address2',
                    Fulfilment_ShipToAddress_Address_Line3__c = 'Address3', Fulfilment_ShipToAddress_Address_Name__c ='ship',
                    Fulfilment_ShipToAddress_Address_PostalC__c='123',Fulfilment_ShipToAddress_Address_StatePr__c = 'state',
                    Account_Address_City__c = 'city', Account_Address_Country__c = 'country', Account_Address_Line1__c = 'line1',
                    Account_Address_Line2__c = 'line2', Account_Address_Line3__c = 'line3',Account_Address_Name__c = 'Name',
                    Account_Address_PostalCode__c = '123', Account_Address_StateProvince__c = 'State');

            Dal_ScheduleOrderController.OrderLineWrapper orderWrap = new Dal_ScheduleOrderController.OrderLineWrapper(orderLine);
            List<Dal_ScheduleOrderController.OrderLineWrapper> orderLineWrapper = new List<Dal_ScheduleOrderController.OrderLineWrapper>();
            orderLineWrapper.add(orderWrap);

            Dal_ScheduleOrderController.SchedulerWrapper scheduleOrderWrapper = new Dal_ScheduleOrderController.SchedulerWrapper(orderHeader,orderLineWrapper);

            List<Dal_ScheduleOrderController.SchedulerWrapper> wrap = new List<Dal_ScheduleOrderController.SchedulerWrapper>();
            wrap.add(scheduleOrderWrapper);
            Test.setMock(WebServiceMock.class, new Dal_OrderFulfilmentCancel_Mock());
            test.startTest();
            Dal_OrderFulfilmentCancelManager CancelManager = new Dal_OrderFulfilmentCancelManager(wrap,'5');
            CancelManager.cancelFulfilment();
            test.stopTest();
        }
    }
}