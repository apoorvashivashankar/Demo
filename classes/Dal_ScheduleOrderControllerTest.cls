/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest
public class Dal_ScheduleOrderControllerTest {
    
    @TestSetup
    static void datasetup(){
        
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
            
            SSC__c storeaddress = new SSC__c();
            storeaddress.Name = 'Test';
            storeaddress.Street_Address__c = 'Test';
            storeaddress.City__c = 'Test';   
            storeaddress.State__c = 'US';
            storeaddress.Zip_Code__c = 'Test';
            storeaddress.SSC_Phone_Number__c = '123456789';
            storeaddress.SSC_Fax_Number__c = 'Test';
            storeaddress.DW_ID__c = '123';
            insert storeaddress;
            
            List<SSC__c> sscList = new List<SSC__c>();
            SSC__c ssc = new SSC__c();
            ssc.Name = 'SSC Account';
            sscList.add(ssc);
            insert sscList;
            
            Datetime cDT = System.now();
            List<Hours_Of_Operation__c> hoursList = new List<Hours_Of_Operation__c>();
            Hours_Of_Operation__c hours = new Hours_Of_Operation__c();
            hours.Open_Time__c = cDT.time();
            hours.Close_Time__c = cDT.time();
            hours.Appointment_Start_Time__c = cDT.time();
            hours.Appointment_End_Time__c = cDT.time();
            hours.Name = 'Monday';
            hours.SSC__c = storeaddress.Id;
            hoursList.add(hours);
            Hours_Of_Operation__c hoursOne = new Hours_Of_Operation__c();
            hoursOne.Open_Time__c = cDT.time();
            hoursOne.Close_Time__c = cDT.time();
            hoursOne.Name = 'Sunday';
            hoursOne.Appointment_Start_Time__c = cDT.time();
            hoursOne.Appointment_End_Time__c = cDT.time();
            hoursOne.SSC__c = storeaddress.Id;
            hoursList.add(hoursOne);
            Hours_Of_Operation__c hoursTwo = new Hours_Of_Operation__c();
            hoursTwo.Open_Time__c = cDT.time();
            hoursTwo.Close_Time__c = cDT.time();
            hoursTwo.Name = 'Saturday';
            hoursTwo.Appointment_Start_Time__c = cDT.time();
            hoursTwo.Appointment_End_Time__c = cDT.time();
            hoursTwo.SSC__c = storeaddress.Id;
            hoursList.add(hoursTwo);
            
            insert hoursList;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
        }
    }
    
    static testMethod void getAllOrdersToSchedule(){
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        String uniqueName = Dal_TestUtils.getUserString();
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id,DW_ID__c FROM Account];
        
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        System.runAs(newUser){
            DT_SYS_OrderLine__x orderLine = new DT_SYS_OrderLine__x(Quantity__c=10,UOM__c='10',RequestedShipDate__c=String.valueOf(System.today()),
                                                                    MaterialDesc_Size__c='test',MaterialDesc_Color__c='test',
                                                                    MaterialDesc_Trim__c='test',Quantity_Invoiced__c=10.00,
                                                                    Quantity_Cancelled__c=10.00,WeightExtended__c=10.00,
                                                                    Price_PriceNet_Extended__c=10,SalesOrder__c='124578144');
            
            DT_SYS_OrderHeader__x orderHeader = new DT_SYS_OrderHeader__x( SalesOrder__c = '124578144' ,SalesOrderHeaderKey__c = 'key',
                                                                          CustomerPONo__c = 'Po',OrderPlant__c ='123',JobName__c = 'job',
                                                                          Fulfilment_Method__c = 'SHP',Status__c = 'status',Account_Contact_Phone__c = 'phone', Account_Contact_FirstName__c = 'first', 
                                                                          Account_Contact_LastName__c = 'last',Fulfilment_ShipToAddress_Address_City__c = 'city',Fulfilment_ShipToAddress_Address_Country__c = 'US',
                                                                          Fulfilment_ShipToAddress_Address_Line1__c = 'addressOne' ,Fulfilment_ShipToAddress_Address_Line2__c = 'Address2',
                                                                          Fulfilment_ShipToAddress_Address_Line3__c = 'Address3', Fulfilment_ShipToAddress_Address_Name__c ='ship',
                                                                          Fulfilment_ShipToAddress_Address_PostalC__c='123',Fulfilment_ShipToAddress_Address_StatePr__c = 'state',
                                                                          Account_Address_City__c = 'city', Account_Address_Country__c = 'country', Account_Address_Line1__c = 'line1',
                                                                          Account_Address_Line2__c = 'line2', Account_Address_Line3__c = 'line3',Account_Address_Name__c = 'Name', 
                                                                          Account_Address_PostalCode__c = '123', Account_Address_StateProvince__c = 'State');
            
            list<String> orderNumberList = new list<String>();
            orderNumberList.add('124578144');
            //       Dal_ScheduleOrderController.OrderWrapper orderWrapper;
            //String salesOrderList = '[{\"submitted\":false,\"orderNumber\":\"Y121674430\",\"scheduleType\":\"SHP\",\"salesOrderKey\":\"201809210529461273291003\",\"jobName\":\"TEST\",\"skus\":[{\"lineNumber\":\"1\",\"lineKey\":\"201809210529461273291004\",\"Quantity\":\"6.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false},{\"lineNumber\":\"2\",\"lineKey\":\"201809210529461273291005\",\"quantity\":\"5.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false}],\"sscLocation\":{\"name\":\"SAT Honolulu, HI\",\"mfStartHour\":\"7AM\",\"mfEndHour\":\"4PM\"},\"mfstarthours\":\"7:0\",\"mfendhours\":\"16:30\",\"mfAppointStartHours\":\"8:0\",\"mfAppointEndhours\":\"15:0\",\"satAppointStarthours\":\"0\",\"satAppointEndhours\":\"0\",\"sunAppointStarthours\":\"0\",\"sunAppointEndhours\":\"0\",\"pickupDate\":\"2018-12-6\",\"pickupDateEarliestDate\":\"2018-12-05T18:30:00.000Z\",\"pickupTimesAvailable\":[{\"label\":\"8:00 AM\",\"labelHour\":\"8AM\",\"value\":\"8:00\",\"disabled\":true},{\"label\":\"9:00 AM\",\"labelHour\":\"9AM\",\"value\":\"9:00\",\"disabled\":true},{\"label\":\"10:00 AM\",\"labelHour\":\"10AM\",\"value\":\"10:00\",\"disabled\":true},{\"label\":\"11:00 AM\",\"labelHour\":\"11AM\",\"value\":\"11:00\",\"disabled\":true},{\"label\":\"12:00 PM\",\"labelHour\":\"12PM\",\"value\":\"12:00\",\"disabled\":false},{\"label\":\"1:00 PM\",\"labelHour\":\"1PM\",\"value\":\"13:00\",\"disabled\":false},{\"label\":\"2:00 PM\",\"labelHour\":\"2PM\",\"value\":\"14:00\",\"disabled\":false},{\"label\":\"3:00 PM\",\"labelHour\":\"3PM\",\"value\":\"15:00\",\"disabled\":false}],\"pickupTimeSelected\":\"12:00\",\"pickupWhoWill\":\"me\",\"pickupFirstName\":\"Ray\",\"pickupLastName\":\"Test SSC\",\"pickupPhone\":\"3213213213\",\"pickupShouldSendTxt\":false,\"deliveryDate\":\"2018-12-7\",\"deliveryDateEarliestDate\":\"2018-12-06T18:30:00.000Z\",\"deliveryLocation\":{\"name\":\"SUNSET TILE & MARBLE\",\"streetAddress1\":\"131 E MILLER RD\",\"city\":\"MIO\",\"state\":\"MI\",\"zipCode\":\"48647\",\"country\":\"US\"},\"scheduleByItemPackages\":[],\"scheduleByItemActiveTab\":\"selectItems\",\"scheduleByItemType\":\"pickup\"},{\"orderNumber\":\"124578144",\"isPlaceHolder\":true,\"hasLoadingError\":false}]';
            String salesOrderList = '[{\"submitted\":false,\"orderNumber\":\"Y121674430\",\"scheduleType\":\"SHP\",\"salesOrderKey\":\"201809210529461273291003\",\"jobName\":\"TEST\",\"skus\":[{\"lineNumber\":\"1\",\"lineKey\":\"201809210529461273291004\",\"quantity\":\"6.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false},{\"lineNumber\":\"2\",\"lineKey\":\"201809210529461273291005\",\"quantity\":\"5.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false}],\"sscLocation\":{\"name\":\"SAT Honolulu, HI\",\"mfStartHour\":\"7AM\",\"mfEndHour\":\"4PM\"},\"mfstarthours\":\"7:0\",\"mfendhours\":\"16:30\",\"mfAppointStartHours\":\"8:0\",\"mfAppointEndhours\":\"15:0\",\"satAppointStarthours\":\"0\",\"satAppointEndhours\":\"0\",\"sunAppointStarthours\":\"0\",\"sunAppointEndhours\":\"0\",\"pickupDate\":\"2018-12-6\",\"pickupDateEarliestDate\":\"2018-12-05T18:30:00.000Z\",\"pickupTimesAvailable\":[{\"label\":\"8:00 AM\",\"labelHour\":\"8AM\",\"value\":\"8:00\",\"disabled\":true},{\"label\":\"9:00 AM\",\"labelHour\":\"9AM\",\"value\":\"9:00\",\"disabled\":true},{\"label\":\"10:00 AM\",\"labelHour\":\"10AM\",\"value\":\"10:00\",\"disabled\":true},{\"label\":\"11:00 AM\",\"labelHour\":\"11AM\",\"value\":\"11:00\",\"disabled\":true},{\"label\":\"12:00 PM\",\"labelHour\":\"12PM\",\"value\":\"12:00\",\"disabled\":false},{\"label\":\"1:00 PM\",\"labelHour\":\"1PM\",\"value\":\"13:00\",\"disabled\":false},{\"label\":\"2:00 PM\",\"labelHour\":\"2PM\",\"value\":\"14:00\",\"disabled\":false},{\"label\":\"3:00 PM\",\"labelHour\":\"3PM\",\"value\":\"15:00\",\"disabled\":false}],\"pickupTimeSelected\":\"12:00\",\"pickupWhoWill\":\"me\",\"pickupFirstName\":\"Ray\",\"pickupLastName\":\"Test SSC\",\"pickupPhone\":\"3213213213\",\"pickupShouldSendTxt\":false,\"deliveryDate\":\"2018-12-7\",\"deliveryDateEarliestDate\":\"2018-12-06T18:30:00.000Z\",\"deliveryLocation\":{\"name\":\"SUNSET TILE & MARBLE\",\"streetAddress1\":\"131 E MILLER RD\",\"city\":\"MIO\",\"state\":\"MI\",\"zipCode\":\"48647\",\"country\":\"US\"},\"scheduleByItemPackages\":[],\"scheduleByItemActiveTab\":\"selectItems\",\"scheduleByItemType\":\"pickup\"},{\"orderNumber\":\"124578144",\"isPlaceHolder\":true,\"hasLoadingError\":false}]';
            Dal_ScheduleOrderController.mockallOrderLineList.add(orderLine);
            Dal_ScheduleOrderController.mockallOrderHeader =  orderHeader;
            
            Test.startTest();
            Test.setMock(WebServiceMock.class, new Dal_OrderFulfilmentMock());
            Dal_ScheduleOrderController.mockallOrderLineList.add(orderLine);
            String lineNumber = '12145';
            String orderNumber = 'S123';
            Peak_Response peakResponse = new Peak_Response();
            peakResponse.success = true;
            
            Peak_Response peakResponse1 = new Peak_Response();
            peakResponse1.success = false;
            
            Dal_ScheduleOrderController.WebserviceResponse  webserviceResponse = new Dal_ScheduleOrderController.WebserviceResponse(peakResponse,'test');
            Dal_ScheduleOrderController.WebserviceResponse  webserviceResponse1 = new Dal_ScheduleOrderController.WebserviceResponse(peakResponse1,'test');
            //     List<Dal_ScheduleOrderController.OrderWrapper> getAllOrdersToSchedule = Dal_ScheduleOrderController.getAllOrdersToSchedule(orderNumberList);
            Dal_ScheduleOrderController.getNextBusinessDay();
            Dal_ScheduleOrderController.getReSecheduleData(orderNumberList,lineNumber);
            Dal_ScheduleOrderController.getSkusData(orderNumberList);
            Dal_ScheduleOrderController.getReSecheduleData(orderNumberList,'ALL');
            Dal_ScheduleOrderController.getSkusReScheduleData(orderNumberList);
            Dal_ScheduleOrderController.getSkusSingleData(orderNumberList);
            Dal_ScheduleOrderController.getMultipleOrder(salesOrderList); 
            Dal_ScheduleOrderController.removeOrderLine(orderNumber,lineNumber);
            Dal_ScheduleOrderController.OrderLineWrapper orderLineWrapper = new Dal_ScheduleOrderController.OrderLineWrapper(orderLine);
            List<Dal_ScheduleOrderController.SchedulerWrapper> scheduleWrapper = Dal_ScheduleOrderController.getScheduleinfo(orderNumberList);
            try{
                Peak_Response response = Dal_ScheduleOrderController.submitOrderForDelivery(JSON.serialize(scheduleWrapper));
            }catch(Exception e){}
            Test.stopTest();
        }
    }
    static testMethod void getAllOrdersToScheduleForPick(){
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
        
        list<String> orderNumberList = new list<String>();
        orderNumberList.add('124578144');
        String salesOrderList = '[{\"submitted\":false,\"orderNumber\":\"Y121674430\",\"scheduleType\":\"SHP\",\"salesOrderKey\":\"201809210529461273291003\",\"jobName\":\"TEST\",\"skus\":[{\"lineNumber\":\"1\",\"lineKey\":\"201809210529461273291004\",\"quantity\":\"6.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false},{\"lineNumber\":\"2\",\"lineKey\":\"201809210529461273291005\",\"quantity\":\"5.0\",\"description\":\"4X4        0100 WHITE       STD\",\"sku\":\"0100441P4\",\"uom\":\"SF\",\"status\":\"In Stock\",\"selected\":false}],\"sscLocation\":{\"name\":\"SAT Honolulu, HI\",\"mfStartHour\":\"7AM\",\"mfEndHour\":\"4PM\"},\"mfstarthours\":\"7:0\",\"mfendhours\":\"16:30\",\"mfAppointStartHours\":\"8:0\",\"mfAppointEndhours\":\"15:0\",\"satAppointStarthours\":\"0\",\"satAppointEndhours\":\"0\",\"sunAppointStarthours\":\"0\",\"sunAppointEndhours\":\"0\",\"pickupDate\":\"2018-12-6\",\"pickupDateEarliestDate\":\"2018-12-05T18:30:00.000Z\",\"pickupTimesAvailable\":[{\"label\":\"8:00 AM\",\"labelHour\":\"8AM\",\"value\":\"8:00\",\"disabled\":true},{\"label\":\"9:00 AM\",\"labelHour\":\"9AM\",\"value\":\"9:00\",\"disabled\":true},{\"label\":\"10:00 AM\",\"labelHour\":\"10AM\",\"value\":\"10:00\",\"disabled\":true},{\"label\":\"11:00 AM\",\"labelHour\":\"11AM\",\"value\":\"11:00\",\"disabled\":true},{\"label\":\"12:00 PM\",\"labelHour\":\"12PM\",\"value\":\"12:00\",\"disabled\":false},{\"label\":\"1:00 PM\",\"labelHour\":\"1PM\",\"value\":\"13:00\",\"disabled\":false},{\"label\":\"2:00 PM\",\"labelHour\":\"2PM\",\"value\":\"14:00\",\"disabled\":false},{\"label\":\"3:00 PM\",\"labelHour\":\"3PM\",\"value\":\"15:00\",\"disabled\":false}],\"pickupTimeSelected\":\"12:00\",\"pickupWhoWill\":\"me\",\"pickupFirstName\":\"Ray\",\"pickupLastName\":\"Test SSC\",\"pickupPhone\":\"3213213213\",\"pickupShouldSendTxt\":false,\"deliveryDate\":\"2018-12-7\",\"deliveryDateEarliestDate\":\"2018-12-06T18:30:00.000Z\",\"deliveryLocation\":{\"name\":\"SUNSET TILE & MARBLE\",\"streetAddress1\":\"131 E MILLER RD\",\"city\":\"MIO\",\"state\":\"MI\",\"zipCode\":\"48647\",\"country\":\"US\"},\"scheduleByItemPackages\":[],\"scheduleByItemActiveTab\":\"selectItems\",\"scheduleByItemType\":\"pickup\"},{\"orderNumber\":\"Y121674420\",\"isPlaceHolder\":true,\"hasLoadingError\":false}]';
        //       Dal_ScheduleOrderController.OrderWrapper orderWrapper;
        
        Dal_ScheduleOrderController.mockallOrderLineList.add(orderLine);
        Dal_ScheduleOrderController.mockallOrderHeader =  orderHeader;
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new Dal_OrderFulfilmentMock());
        Dal_ScheduleOrderController.mockallOrderLineList.add(orderLine);
        //     List<Dal_ScheduleOrderController.OrderWrapper> getAllOrdersToSchedule = Dal_ScheduleOrderController.getAllOrdersToSchedule(orderNumberList);
        Dal_ScheduleOrderController.getNextBusinessDay();
       // Dal_ScheduleOrderController.getMultipleOrder(salesOrderList);
        Dal_ScheduleOrderController.OrderLineWrapper orderLineWrapper = new Dal_ScheduleOrderController.OrderLineWrapper(orderLine);
        List<Dal_ScheduleOrderController.SchedulerWrapper> scheduleWrapper = Dal_ScheduleOrderController.getScheduleinfo(orderNumberList);
        //Peak_Response response = Dal_ScheduleOrderController.submitOrderForDelivery('ABC');
        Test.stopTest(); 
    }
    
}