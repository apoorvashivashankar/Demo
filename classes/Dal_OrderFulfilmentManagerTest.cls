/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_OrderFulfilmentManagerTest {
    
    @TestSetup
    static void datasetup(){
        User Objuser = [Select id from user where profile.name='System Administrator' AND Isactive=true AND Userroleid!=null limit 1];
        System.runAs(Objuser) {
            Contact con = Dal_TestUtils.createTestContact();  
            con.Email  = 'newUser@yahoo.com';
            update con;
            
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
            
            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
            
            
        }
    }
    
    static testMethod void getOrdersFullFilment(){ 
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
            
             SSC__c storeaddress = new SSC__c(Name = '123',Street_Address__c ='123',City__c='123',State__c='IN',Zip_Code__c='132',
                                              SSC_Phone_Number__c='123',SSC_Fax_Number__c='123',DW_ID__c = '123');
             insert storeaddress;
            test.startTest();
            
            Dal_ScheduleOrderController.OrderLineWrapper orderWrap = new Dal_ScheduleOrderController.OrderLineWrapper(orderLine);
            List<Dal_ScheduleOrderController.OrderLineWrapper> orderLineWrapper = new List<Dal_ScheduleOrderController.OrderLineWrapper>();
            orderLineWrapper.add(orderWrap);
            System.debug('IntestorderLineWrapper--->'+orderLineWrapper);
            //Dal_OrderFulfilmentManager.WillCall testObj = new Dal_OrderFulfilmentManager.WillCall();
            //testObj.lineWrapperList = new List<Dal_OrderFulfilmentManager.lineWrapperList>();
            //Dal_OrderFulfilmentManager.setOrderFulFill(JSON.serialize(testObj));
            String salesOrder = '[{\"submitted\":false,\"orderNumber\":\"Y121674430\",\"scheduleType\":\"SHP\",\"salesOrderKey\":\"201809210529461273291003\",\"jobName\":\"TEST\",\"skus\":[{\"lineNumber\":\"1\",\"lineKey\":\"201809210529461273291004\",\"quantity\":\"6.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false},{\"lineNumber\":\"2\",\"lineKey\":\"201809210529461273291005\",\"quantity\":\"5.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false}],\"sscLocation\":{\"name\":\"SAT Honolulu, HI\",\"mfStartHour\":\"7AM\",\"mfEndHour\":\"4PM\"},\"mfstarthours\":\"7:0\",\"mfendhours\":\"16:30\",\"mfAppointStartHours\":\"8:0\",\"mfAppointEndhours\":\"15:0\",\"satAppointStarthours\":\"0\",\"satAppointEndhours\":\"0\",\"sunAppointStarthours\":\"0\",\"sunAppointEndhours\":\"0\",\"pickupDate\":\"2018-12-6\",\"pickupDateEarliestDate\":\"2018-12-05T18:30:00.000Z\",\"pickupTimesAvailable\":[{\"label\":\"8:00 AM\",\"labelHour\":\"8AM\",\"value\":\"8:00\",\"disabled\":true},{\"label\":\"9:00 AM\",\"labelHour\":\"9AM\",\"value\":\"9:00\",\"disabled\":true},{\"label\":\"10:00 AM\",\"labelHour\":\"10AM\",\"value\":\"10:00\",\"disabled\":true},{\"label\":\"11:00 AM\",\"labelHour\":\"11AM\",\"value\":\"11:00\",\"disabled\":true},{\"label\":\"12:00 PM\",\"labelHour\":\"12PM\",\"value\":\"12:00\",\"disabled\":false},{\"label\":\"1:00 PM\",\"labelHour\":\"1PM\",\"value\":\"13:00\",\"disabled\":false},{\"label\":\"2:00 PM\",\"labelHour\":\"2PM\",\"value\":\"14:00\",\"disabled\":false},{\"label\":\"3:00 PM\",\"labelHour\":\"3PM\",\"value\":\"15:00\",\"disabled\":false}],\"pickupTimeSelected\":\"12:00\",\"pickupWhoWill\":\"me\",\"pickupFirstName\":\"Ray\",\"pickupLastName\":\"Test SSC\",\"pickupPhone\":\"3213213213\",\"pickupShouldSendTxt\":false,\"deliveryDate\":\"2018-12-7\",\"deliveryDateEarliestDate\":\"2018-12-06T18:30:00.000Z\",\"deliveryLocation\":{\"name\":\"SUNSET TILE & MARBLE\",\"streetAddress1\":\"131 E MILLER RD\",\"city\":\"MIO\",\"state\":\"MI\",\"zipCode\":\"48647\",\"country\":\"US\"},\"scheduleByItemPackages\":[],\"scheduleByItemActiveTab\":\"selectItems\",\"scheduleByItemType\":\"pickup\"},{\"orderNumber\":\"124578144",\"isPlaceHolder\":true,\"hasLoadingError\":false}]';
            List<Dal_SchedulePickupJSON> salesOrderjson = Dal_SchedulePickupJSON.parse(salesOrder);
            Test.setMock(WebServiceMock.class, new Dal_OrderFulfilment_Mock());
            
            Dal_ScheduleOrderController.SchedulerWrapper scheduleOrderWrapper = new Dal_ScheduleOrderController.SchedulerWrapper(orderHeader,orderLineWrapper);
            System.debug('IntestscheduleOrderWrapper--->'+scheduleOrderWrapper);
            //Dal_ScheduleOrderController.SchedulerWrapper sc = new Dal_ScheduleOrderController.SchedulerWrapper(salesOrderjson,orderLineWrapper);
            List<Dal_ScheduleOrderController.SchedulerWrapper> wrap = new List<Dal_ScheduleOrderController.SchedulerWrapper>();
            wrap.add(scheduleOrderWrapper);
            
            Dal_OrderFulfilmentManager orderManager = new Dal_OrderFulfilmentManager(wrap,salesOrderjson[0]);
            Dal_OrderFulfilmentManager.getOrderFulfilment();
            
            //Dal_OrderFulfilmentManager.getOrderFulfilment(JSON.serialize(testObj));
            test.stopTest();
        }
    }    
    
    static testMethod void getOrdersFullFilment1(){ 
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        System.runAs(newUser){    
            DT_SYS_OrderLine__x orderLine = new DT_SYS_OrderLine__x(Quantity__c=10.00,UOM__c='10',RequestedShipDate__c=String.valueOf(System.today()),
                                                                    MaterialDesc_Size__c='test',MaterialDesc_Color__c='test',
                                                                    MaterialDesc_Trim__c='test',Quantity_Invoiced__c=10.00,
                                                                    Quantity_Cancelled__c=10.00,WeightExtended__c=10.00,
                                                                    Price_PriceNet_Extended__c=10,SalesOrder__c='124578144');
            
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
            
            
            test.startTest();
            Test.setMock(WebServiceMock.class, new Dal_OrderFulfilment_Mock());
            Dal_OrderFulfilmentManager.WillCall testObj = new Dal_OrderFulfilmentManager.WillCall();
            testObj.lineWrapperList = new List<Dal_OrderFulfilmentManager.lineWrapperList>();
            Dal_OrderFulfilmentManager.setOrderFulFill(JSON.serialize(testObj));
            Dal_OrderFulfilmentManager.getOrderFulfilment();
            
            
            //Dal_OrderFulfilmentManager.getOrderFulfilment(JSON.serialize(testObj));
            test.stopTest();
        }
    }    
    static testMethod void getOrdersFullFilment2(){ 
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
            
             SSC__c storeaddress = new SSC__c(Name = '123',Street_Address__c ='123',City__c='123',State__c='IN',Zip_Code__c='132',
                                              SSC_Phone_Number__c='123',SSC_Fax_Number__c='123',DW_ID__c = '123');
             insert storeaddress;
            test.startTest();
            
            Dal_ScheduleOrderController.OrderLineWrapper orderWrap = new Dal_ScheduleOrderController.OrderLineWrapper(orderLine);
            List<Dal_ScheduleOrderController.OrderLineWrapper> orderLineWrapper = new List<Dal_ScheduleOrderController.OrderLineWrapper>();
            orderLineWrapper.add(orderWrap);
            System.debug('IntestorderLineWrapper--->'+orderLineWrapper);
            //Dal_OrderFulfilmentManager.WillCall testObj = new Dal_OrderFulfilmentManager.WillCall();
            //testObj.lineWrapperList = new List<Dal_OrderFulfilmentManager.lineWrapperList>();
            //Dal_OrderFulfilmentManager.setOrderFulFill(JSON.serialize(testObj));
            String salesOrder = '[{\"submitted\":false,\"orderNumber\":\"Y121674430\",\"scheduleType\":\"PICK\",\"salesOrderKey\":\"201809210529461273291003\",\"jobName\":\"TEST\",\"skus\":[{\"lineNumber\":\"1\",\"lineKey\":\"201809210529461273291004\",\"quantity\":\"6.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false},{\"lineNumber\":\"2\",\"lineKey\":\"201809210529461273291005\",\"quantity\":\"5.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false}],\"sscLocation\":{\"name\":\"SAT Honolulu, HI\",\"mfStartHour\":\"7AM\",\"mfEndHour\":\"4PM\"},\"mfstarthours\":\"7:0\",\"mfendhours\":\"16:30\",\"mfAppointStartHours\":\"8:0\",\"mfAppointEndhours\":\"15:0\",\"satAppointStarthours\":\"0\",\"satAppointEndhours\":\"0\",\"sunAppointStarthours\":\"0\",\"sunAppointEndhours\":\"0\",\"pickupDate\":\"2018-12-6\",\"pickupDateEarliestDate\":\"2018-12-05T18:30:00.000Z\",\"pickupTimesAvailable\":[{\"label\":\"8:00 AM\",\"labelHour\":\"8AM\",\"value\":\"8:00\",\"disabled\":true},{\"label\":\"9:00 AM\",\"labelHour\":\"9AM\",\"value\":\"9:00\",\"disabled\":true},{\"label\":\"10:00 AM\",\"labelHour\":\"10AM\",\"value\":\"10:00\",\"disabled\":true},{\"label\":\"11:00 AM\",\"labelHour\":\"11AM\",\"value\":\"11:00\",\"disabled\":true},{\"label\":\"12:00 PM\",\"labelHour\":\"12PM\",\"value\":\"12:00\",\"disabled\":false},{\"label\":\"1:00 PM\",\"labelHour\":\"1PM\",\"value\":\"13:00\",\"disabled\":false},{\"label\":\"2:00 PM\",\"labelHour\":\"2PM\",\"value\":\"14:00\",\"disabled\":false},{\"label\":\"3:00 PM\",\"labelHour\":\"3PM\",\"value\":\"15:00\",\"disabled\":false}],\"pickupTimeSelected\":\"12:00\",\"pickupWhoWill\":\"me\",\"pickupFirstName\":\"Ray\",\"pickupLastName\":\"Test SSC\",\"pickupPhone\":\"3213213213\",\"pickupShouldSendTxt\":false,\"deliveryDate\":\"2018-12-7\",\"deliveryDateEarliestDate\":\"2018-12-06T18:30:00.000Z\",\"deliveryLocation\":{\"name\":\"SUNSET TILE & MARBLE\",\"streetAddress1\":\"131 E MILLER RD\",\"city\":\"MIO\",\"state\":\"MI\",\"zipCode\":\"48647\",\"country\":\"US\"},\"scheduleByItemPackages\":[],\"scheduleByItemActiveTab\":\"selectItems\",\"scheduleByItemType\":\"pickup\"},{\"orderNumber\":\"124578144",\"isPlaceHolder\":true,\"hasLoadingError\":false}]';
            List<Dal_SchedulePickupJSON> salesOrderjson = Dal_SchedulePickupJSON.parse(salesOrder);
            Test.setMock(WebServiceMock.class, new Dal_OrderFulfilment_Mock());
            
            Dal_ScheduleOrderController.SchedulerWrapper scheduleOrderWrapper = new Dal_ScheduleOrderController.SchedulerWrapper(orderHeader,orderLineWrapper);
            System.debug('IntestscheduleOrderWrapper--->'+scheduleOrderWrapper);
            //Dal_ScheduleOrderController.SchedulerWrapper sc = new Dal_ScheduleOrderController.SchedulerWrapper(salesOrderjson,orderLineWrapper);
            List<Dal_ScheduleOrderController.SchedulerWrapper> wrap = new List<Dal_ScheduleOrderController.SchedulerWrapper>();
            wrap.add(scheduleOrderWrapper);
            
            Dal_OrderFulfilmentManager orderManager = new Dal_OrderFulfilmentManager(wrap,salesOrderjson[0]);
            Dal_OrderFulfilmentManager.getOrderFulfilment();
            
            //Dal_OrderFulfilmentManager.getOrderFulfilment(JSON.serialize(testObj));
            test.stopTest();
        }
    }
}