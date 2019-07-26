/**
* Created by 7Summits on 3/27/18.
*
**/
public without sharing class Dal_ScheduleOrderController {
    
    public static final String HOST_SYS_OASIS = 'OASIS';
    public static final List<String> STATUS_LIST = new List<String> {'In Stock'};
    public static final List<String> RESCHEDULE_STATUS_LIST = new List<String> {'Scheduled for Delivery','Scheduled for Pick Up'};
            
    @TestVisible
    private static list<DT_SYS_OrderLine__x> mockallOrderLineList = new list<DT_SYS_OrderLine__x>();
    @TestVisible
    private static DT_SYS_OrderHeader__x mockallOrderHeader = new DT_SYS_OrderHeader__x();
    
    Public static List<DT_SYS_OrderLine__x> orderLine = new List<DT_SYS_OrderLine__x>();
    
    // SchedulerWrapper for Order header object
    public class SchedulerWrapper{
        @AuraEnabled public String OrderNumber;
        @AuraEnabled public String PurchaseOrder;
        @AuraEnabled public String JobName;
        @AuraEnabled public String SSCLocationName;
        @AuraEnabled public String SSCLocationStreet;
        @AuraEnabled public String SSCLocationCity;
        @AuraEnabled public String SSCLocationState;
        @AuraEnabled public String SSCLocationZIP;
        @AuraEnabled public String SSCLocationPhone;
        @AuraEnabled public String SSCLocationFax;
        @AuraEnabled public String FulfillmentMethod;
        @AuraEnabled public String SalesOrderKey;
        @AuraEnabled public Boolean cutoffcrossed;
        @AuraEnabled public String mfstarthours;
        @AuraEnabled public String mfendhours;
        @AuraEnabled public String satstarthours;
        @AuraEnabled public String satendhours;
        @AuraEnabled public String sunstarthours;
        @AuraEnabled public String sunendhours;
        @AuraEnabled public String mfAppointStartHours;
        @AuraEnabled public String mfAppointEndhours;
        @AuraEnabled public String satAppointStarthours = '0';
        @AuraEnabled public String satAppointEndhours = '0';
        @AuraEnabled public String sunAppointStarthours = '0';
        @AuraEnabled public String sunAppointEndhours = '0';
        @AuraEnabled public String pickupFirstName;
        @AuraEnabled public String pickupLastName;
        @AuraEnabled public String pickupPhone;
        @AuraEnabled public String pickupTimeSelected; // new
        @AuraEnabled public String FFLocationName;
        @AuraEnabled public String FFLocationName2;
        @AuraEnabled public String FFLocationline1;
        @AuraEnabled public String FFLocationline2;
        @AuraEnabled public String FFLocationline3;
        @AuraEnabled public String FFLocationCountry;
        @AuraEnabled public String FFLocationCity;
        @AuraEnabled public String FFLocationState;
        @AuraEnabled public String FFLocationZIP;
        @AuraEnabled public Boolean sendSMS; // new
        @AuraEnabled public List<OrderLineWrapper> OrderLineWrappers;
        
        //Parametrized Constructor of Wrapper which takes - DT_SYS_OrderHeader__x & List of OrderLineWrapper .
        public SchedulerWrapper(DT_SYS_OrderHeader__x orderHeader, List<OrderLineWrapper> orderLineWrapper){
            this.OrderNumber = orderHeader.SalesOrder__c;
            this.PurchaseOrder = orderHeader.CustomerPONo__c;
            this.JobName = orderHeader.JobName__c;
            this.FulfillmentMethod = orderHeader.Fulfilment_Method__c;
            this.SalesOrderKey = orderHeader.SalesOrderHeaderKey__c;
            //get contact info
            id userId = UserInfo.getUserId();
            try{
                User u = [select id, contactId from User where id = : userId];
                system.debug('contact id is '+u);
                Contact c = [select firstname, lastname, phone, email, Phone_Lookup__c from contact where id=:u.contactId];
                system.debug('contact is '+c);
                this.pickupFirstName = c.firstname;
                this.pickupLastName = c.lastname;
                this.pickupPhone = c.Phone_Lookup__c;
            }
            catch(Exception e){
                system.debug('error occured whiel fetching contact info'+e.getMessage());
            }
            //setting fullfillment address - used in delivery tab - ship to address
            
            if(orderHeader.Fulfilment_Method__c =='SHP'){
                this.FFLocationName = orderHeader.Fulfilment_ShipToAddress_Address_Name__c;
                this.FFLocationName2 = orderHeader.Fulfilment_ShipToAddress_Address_Name2__c;
                this.FFLocationline1 = orderHeader.Fulfilment_ShipToAddress_Address_Line1__c;
                this.FFLocationline2 = orderHeader.Fulfilment_ShipToAddress_Address_Line2__c;
                this.FFLocationline3 = orderHeader.Fulfilment_ShipToAddress_Address_Line3__c;
                this.FFLocationCountry = orderHeader.Fulfilment_ShipToAddress_Address_Country__c;
                this.FFLocationCity = orderHeader.Fulfilment_ShipToAddress_Address_City__c;
                this.FFLocationState = orderHeader.Fulfilment_ShipToAddress_Address_StatePr__c;
                this.FFLocationZIP = orderHeader.Fulfilment_ShipToAddress_Address_PostalC__c;
            }
            else if(orderHeader.Fulfilment_Method__c =='PICK')
            {
                this.FFLocationName = orderHeader.Account_Address_Name__c;
                this.FFLocationName2 = orderHeader.Account_Address_Name2__c;
                this.FFLocationline1 = orderHeader.Account_Address_Line1__c;
                this.FFLocationline2 = orderHeader.Account_Address_Line2__c;
                this.FFLocationline3 = orderHeader.Account_Address_Line3__c;
                this.FFLocationCountry = orderHeader.Account_Address_Country__c;
                this.FFLocationCity = orderHeader.Account_Address_City__c;
                this.FFLocationState = orderHeader.Account_Address_StateProvince__c;
                this.FFLocationZIP = orderHeader.Account_Address_PostalCode__c;
            }
            
            //check if the cut off of 2pm is crossed
            Time Currenttime = Datetime.now().time();
            system.debug('Current Time '+Currenttime);
            String timeValue = String.valueOf(Currenttime);
            List<String> timeitem = timeValue.split(':');
            system.debug('timeitem '+timeitem);
            System.debug('timeitem 0 '+timeitem[0]);
            System.debug('timeitem 1 '+timeitem[1]);
            if(timeitem[0] <= '13'){
                this.cutoffcrossed = false;
            }
            else{
                this.cutoffcrossed = true;
            }
            //get store address and hours
            if(orderHeader.OrderPlant__c !=null)
                System.debug('orderHeader.OrderPlant__c---->'+orderHeader.OrderPlant__c);
            try{
                SSC__c storeaddress = [select id,Name,Street_Address__c,City__c,State__c,Zip_Code__c,SSC_Phone_Number__c,SSC_Fax_Number__c from SSC__c where DW_ID__c=:orderHeader.OrderPlant__c];
                system.debug('storeaddress '+storeaddress);
                this.SSCLocationName = string.valueof(storeaddress.Name);
                this.SSCLocationStreet = storeaddress.Street_Address__c;
                this.SSCLocationCity = storeaddress.City__c;
                this.SSCLocationState = storeaddress.State__c;
                this.SSCLocationZip = storeaddress.Zip_Code__c;
                this.SSCLocationPhone = storeaddress.SSC_Phone_Number__c;
                this.SSCLocationFax = storeaddress.SSC_Fax_Number__c;
                list<Hours_Of_Operation__c> hours = [select Close_Time__c,Open_Time__c,Appointment_Start_Time__c,Appointment_End_Time__c,Name from Hours_Of_Operation__c where SSC__c =: storeaddress.Id];
                system.debug('Hours_Of_Operation__c---> '+hours);
                String weekdays ;
                for(Hours_Of_Operation__c hour :hours)
                {
                    if(hour.Name == 'Saturday')
                    {
                        this.satstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                        this.satendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute());
                        this.satAppointStarthours = String.valueof(hour.Appointment_Start_Time__c.hour())+':'+String.valueof(hour.Appointment_Start_Time__c.minute());
                        this.satAppointEndhours = String.valueof(hour.Appointment_End_Time__c.hour())+':'+String.valueof(hour.Appointment_End_Time__c.minute());
                    }
                    else if (hour.Name == 'Monday' || hour.Name == 'Tuesday' || hour.Name =='Wednesday' ||hour.Name =='Thursday' || hour.Name =='Friday'){
                        this.mfstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                        this.mfendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute());
                        this.mfAppointStartHours = String.valueof(hour.Appointment_Start_Time__c.hour())+':'+String.valueof(hour.Appointment_Start_Time__c.minute());
                        this.mfAppointEndhours = String.valueof(hour.Appointment_End_Time__c.hour())+':'+String.valueof(hour.Appointment_End_Time__c.minute());
                    }
                    else if(hour.Name == 'Sunday'){
                        this.sunstarthours = String.valueof(hour.Open_Time__c.hour())+':'+String.valueof(hour.Open_Time__c.minute());
                        this.sunendhours = String.valueof(hour.Close_Time__c.hour())+':'+String.valueof(hour.Close_Time__c.minute());
                        this.sunAppointStarthours = String.valueof(hour.Appointment_Start_Time__c.hour())+':'+String.valueof(hour.Appointment_Start_Time__c.minute());
                        this.sunAppointEndhours = String.valueof(hour.Appointment_End_Time__c.hour())+':'+String.valueof(hour.Appointment_End_Time__c.minute());
                    }
                    
                }
                System.debug('Above Line item');
                this.OrderLineWrappers = orderLineWrapper;
            }
            catch(Exception e){
                
            }
            
        }
        
        // Parameterzed Constructor which takes -- JOSN & List of LineWrapper . 
        public SchedulerWrapper(Dal_SchedulePickupJSON jsonData,List<OrderLineWrapper> orderLineWrapper){
            this.OrderNumber = jsonData.orderNumber;
            this.PurchaseOrder = jsonData.poNumber;
            this.JobName = jsonData.jobName;
            this.SalesOrderKey = jsonData.salesOrderKey;
            this.pickupFirstName = jsonData.pickupFirstName;
            this.pickupLastName =jsonData.pickupLastName;
            this.pickupPhone = jsonData.pickupPhone;
            System.debug('jsonData.scheduleType-->'+jsonData.scheduleType);
            this.FulfillmentMethod = jsonData.scheduleType;
            if(jsonData.scheduleType.equalsIgnoreCase('SHP')){
                this.pickupTimeSelected = jsonData.deliveryDate;
            }else{
                this.pickupTimeSelected = jsonData.pickupDate+' '+jsonData.pickupTimeSelected;
            }
            this.sendSMS = jsonData.pickupShouldSendTxt;
            this.OrderLineWrappers = orderLineWrapper;
            this.FFLocationName = jsonData.deliveryLocation.name;
            this.FFLocationline1 = jsonData.deliveryLocation.streetAddress1;
            this.FFLocationCountry = jsonData.deliveryLocation.country;
            this.FFLocationCity = jsonData.deliveryLocation.city;
            this.FFLocationState = jsonData.deliveryLocation.state;
            this.FFLocationZIP = jsonData.deliveryLocation.zipCode;
            
        }
        
    }
    
    // OrderLineWrapper for Order Line Item object
    public class OrderLineWrapper{
        @AuraEnabled public String SkuName;
        @AuraEnabled public String SkuNumber;
        @AuraEnabled public String Quantity;
        @AuraEnabled public String LineNumber;
        @AuraEnabled public String linekey;
        @AuraEnabled public String UOM;
        @AuraEnabled public String status;
        
        public OrderLineWrapper(DT_SYS_OrderLine__x OrderLine){
            this.SkuName = OrderLine.MaterialDesc__c;
            this.SkuNumber = OrderLine.Material__c;
            this.Quantity = OrderLine.QuantityInLegacyBaseUOM__c;
            this.LineNumber = OrderLine.SalesOrderLineNo__c;
            this.UOM = OrderLine.LegacyBaseUOM__c;
            this.status = OrderLine.StatusDesc2__c;
            this.linekey = OrderLine.SalesOrderLineKey__c;
            
        }
        
    }
    
    /*
    * Method Name: getScheduleinfo
    * Description: Method to get information of Order with all data that user wants to schedule
    * @param: List of Order Number
    * @return List of SchedulerWrapper
    */
    @AuraEnabled
    public static List<SchedulerWrapper> getScheduleinfo(List<String> orderNumberList){
        
        //store the list of orders in a set
        Set<String> orderNumber = new Set<String>(orderNumberList);
        
        //TODO used just to be able to provide data to FE, Dal service only allows a single order query currently
        String tempSingleOrderNumber = orderNumberList.get(0);
        
        system.debug('orderNumbers-- '+orderNumber);
        system.debug('tempSingleOrderNumber-- '+tempSingleOrderNumber);
        //Create orderwrapper to return to UI
        List<SchedulerWrapper> orderWrapperList = new List<SchedulerWrapper>();
        //Create orderLine list to be added into orderwrapper
        List<OrderLineWrapper> orderLineList = new List<OrderLineWrapper>();
        
        //Query order Header
        DT_SYS_OrderHeader__x orderHeader = new DT_SYS_OrderHeader__x();
        try{
            // get Order lines
            if(!Test.isRunningTest()){
                orderLine = [SELECT Id,SalesOrder__c,UOM__c,SalesOrderLineKey__c,StatusDesc2__c,
                             Fulfilment_Contact_Email__c,Fulfilment_Contact_FirstName__c,Fulfilment_ScheduleTime__c,
                             Fulfilment_SendMsgTextInd__c,Fulfilment_Contact_Phone__c,Material__c,Fulfilment_Contact_LastName__c,
                             MaterialDesc__c,Quantity__c,QuantityInLegacyBaseUOM__c,LegacyBaseUOM__c,SalesOrderLineNo__c,Status__c
                             FROM DT_SYS_OrderLine__x
                             WHERE StatusDesc2__c IN : STATUS_LIST
                             AND SalesOrder__c = : tempSingleOrderNumber
                             AND HostSystem__c =: HOST_SYS_OASIS];
            }
            else{
                orderLine.addAll(mockallOrderLineList);
            }
            
            System.debug('orderLine----->'+orderLine);
            
            //create a map of order and orderline
            Map<String, List<DT_SYS_OrderLine__x>> orderlinemap = new Map<String, List<DT_SYS_OrderLine__x>>();
            for(String order : orderNumber){
                List<DT_SYS_OrderLine__x> maporderline = new List<DT_SYS_OrderLine__x>();
                for(DT_SYS_OrderLine__x lineitems :orderLine){
                    system.debug('lineitems--'+lineitems);
                    if(order == lineitems.salesorder__C){
                        maporderline.add(lineitems);
                    }
                }
                orderlinemap.put(order,maporderline);
                
            }
            system.debug('orderlinemap--------> '+orderlinemap);
            
            //loop through all orders passed as input - Query the order header and initialise the wrapper header
            //if(!Test.isRunningTest())
            // {
            for(DT_SYS_OrderHeader__x salesorder : [SELECT Id,SalesOrder__c,SalesOrderHeaderKey__c,CustomerPONo__c,OrderPlant__c ,JobName__c,
                                                    Fulfilment_Method__c,Status__c,Account_Contact_Phone__c, Account_Contact_FirstName__c,
                                                    Account_Contact_LastName__c,Fulfilment_ShipToAddress_Address_City__c,Fulfilment_ShipToAddress_Address_Country__c,
                                                    Fulfilment_ShipToAddress_Address_Line1__c,Fulfilment_ShipToAddress_Address_Line2__c,Fulfilment_ShipToAddress_Address_Line3__c,
                                                    Fulfilment_ShipToAddress_Address_Name__c,Fulfilment_ShipToAddress_Address_PostalC__c,Fulfilment_ShipToAddress_Address_StatePr__c,
                                                    Account_Address_City__c, Account_Address_Country__c, Account_Address_Line1__c, Account_Address_Line2__c, Account_Address_Line3__c,
                                                    Account_Address_Name__c, Account_Address_PostalCode__c, Account_Address_StateProvince__c,
                                                    Account_Address_Name2__c, Fulfilment_ShipToAddress_Address_Name2__c
                                                    FROM DT_SYS_OrderHeader__x
                                                    WHERE SalesOrder__c = : tempSingleOrderNumber
                                                    AND HostSystem__c =: HOST_SYS_OASIS]){
                                                      
                                                        System.debug('OrderHeader--->'+salesorder);
                                                        //get all line items for a particular order from map
                                                        for(DT_SYS_OrderLine__x sysorderline : orderlinemap.get(salesorder.SalesOrder__c)){
                                                            orderLineList.add(new OrderLineWrapper(sysorderline));
                                                            system.debug('orderLineList '+orderLineList);
                                                        }
                                                        SchedulerWrapper orderWrp = new SchedulerWrapper(salesorder, orderLineList);
                                                        system.debug('orderWrp '+orderWrp);
                                                        orderWrapperList.add(orderWrp);
                                                        System.debug('orderWrapperList--->'+orderWrapperList);
                                           }
            
            
            if(Test.isRunningTest()){
                DT_SYS_OrderHeader__x salesorder = mockallOrderHeader;
                
                System.debug('OrderHeader--->'+salesorder);
                //get all line items for a particular order from map
                for(DT_SYS_OrderLine__x sysorderline : orderlinemap.get(salesorder.SalesOrder__c)){
                    orderLineList.add(new OrderLineWrapper(sysorderline));
                    system.debug('orderLineList '+orderLineList);
                }
                SchedulerWrapper orderWrp = new SchedulerWrapper(salesorder, orderLineList);
                system.debug('orderWrp '+orderWrp);
                orderWrapperList.add(orderWrp);
                System.debug('orderWrapperList--->'+orderWrapperList);
            }
            
        } catch(Exception exp){
            System.debug('Dal_ScheduleOrderController: An unexpected error has occurred: ' + exp.getMessage());
        }
        
        return orderWrapperList;
    }
    
    /*
    * Method Name: getReSecheduleData
    * Description: Method return Details of order that user wants to reschedule.
    * @param: List of String & String 
    * @return List of SchedulerWrapper
    */
    @AuraEnabled
    public static List<SchedulerWrapper> getReSecheduleData(List<String> orderNumberList,String lineNumber){

        System.debug('RescheduleLiine--->'+orderNumberList+'----'+lineNumber);
        //store the list of orders in a set
        Set<String> orderNumber = new Set<String>(orderNumberList);
        
        //TODO used just to be able to provide data to FE, Dal service only allows a single order query currently
        String tempSingleOrderNumber = orderNumberList.get(0);
        
        system.debug('orderNumbers-- '+orderNumber);
        system.debug('tempSingleOrderNumber-- '+tempSingleOrderNumber);
        //Create orderwrapper to return to UI
        List<SchedulerWrapper> orderWrapperList = new List<SchedulerWrapper>();
        //Create orderLine list to be added into orderwrapper
        List<OrderLineWrapper> orderLineList = new List<OrderLineWrapper>();

        if(lineNumber == '' || lineNumber == 'ALL'){
            lineNumber = 'ALL';
        }

        //Query order Header
        DT_SYS_OrderHeader__x orderHeader = new DT_SYS_OrderHeader__x();
        try{
            // get Order lines
            //if(!Test.isRunningTest()){
            if(lineNumber.contains('ALL')){
                orderLine = [SELECT Id,SalesOrder__c,UOM__c,SalesOrderLineKey__c,StatusDesc2__c,
                        Fulfilment_Contact_Email__c,Fulfilment_Contact_FirstName__c,Fulfilment_ScheduleTime__c,
                        Fulfilment_SendMsgTextInd__c,Fulfilment_Contact_Phone__c,Material__c,Fulfilment_Contact_LastName__c,
                        MaterialDesc__c,Quantity__c,QuantityInLegacyBaseUOM__c,LegacyBaseUOM__c,SalesOrderLineNo__c,Status__c
                FROM DT_SYS_OrderLine__x
                WHERE StatusDesc2__c IN : RESCHEDULE_STATUS_LIST
                AND SalesOrder__c = : tempSingleOrderNumber
                AND HostSystem__c =: HOST_SYS_OASIS];
                System.debug('OrderLineInIf-->'+orderLine);
            }else{
                Integer index = Integer.valueOf(lineNumber)+1;
                String line = String.valueOf(index);
                orderLine = [SELECT Id,SalesOrder__c,UOM__c,SalesOrderLineKey__c,StatusDesc2__c,
                        Fulfilment_Contact_Email__c,Fulfilment_Contact_FirstName__c,Fulfilment_ScheduleTime__c,
                        Fulfilment_SendMsgTextInd__c,Fulfilment_Contact_Phone__c,Material__c,Fulfilment_Contact_LastName__c,
                        MaterialDesc__c,Quantity__c,QuantityInLegacyBaseUOM__c,LegacyBaseUOM__c,SalesOrderLineNo__c,Status__c
                FROM DT_SYS_OrderLine__x
                WHERE StatusDesc2__c IN : RESCHEDULE_STATUS_LIST
                AND SalesOrderLineNo__c = : line
                AND SalesOrder__c = : tempSingleOrderNumber
                AND HostSystem__c =: HOST_SYS_OASIS];
                System.debug('OrderLineInElse-->'+orderLine);
            }

                       
            if(Test.isRunningTest()){
            	orderLine.addAll(mockallOrderLineList);
            }

            System.debug('orderLine----->'+orderLine);
            
            //create a map of order and orderline
            Map<String, List<DT_SYS_OrderLine__x>> orderlinemap = new Map<String, List<DT_SYS_OrderLine__x>>();
            for(String order : orderNumber){
                List<DT_SYS_OrderLine__x> maporderline = new List<DT_SYS_OrderLine__x>();
                for(DT_SYS_OrderLine__x lineitems :orderLine){
                    system.debug('lineitems--'+lineitems);
                    if(order == lineitems.salesorder__C){
                        maporderline.add(lineitems);
                    }
                }
                orderlinemap.put(order,maporderline);
                
            }
            system.debug('orderlinemap--------> '+orderlinemap);
            
            //loop through all orders passed as input - Query the order header and initialise the wrapper header
            //if(!Test.isRunningTest())
            // {
            for(DT_SYS_OrderHeader__x salesorder : [SELECT Id,SalesOrder__c,SalesOrderHeaderKey__c,CustomerPONo__c,OrderPlant__c ,JobName__c,
                                                    Fulfilment_Method__c,Status__c,Account_Contact_Phone__c, Account_Contact_FirstName__c,
                                                    Account_Contact_LastName__c,Fulfilment_ShipToAddress_Address_City__c,Fulfilment_ShipToAddress_Address_Country__c,
                                                    Fulfilment_ShipToAddress_Address_Line1__c,Fulfilment_ShipToAddress_Address_Line2__c,Fulfilment_ShipToAddress_Address_Line3__c,
                                                    Fulfilment_ShipToAddress_Address_Name__c,Fulfilment_ShipToAddress_Address_PostalC__c,Fulfilment_ShipToAddress_Address_StatePr__c,
                                                    Account_Address_City__c, Account_Address_Country__c, Account_Address_Line1__c, Account_Address_Line2__c, Account_Address_Line3__c,
                                                    Account_Address_Name__c, Account_Address_PostalCode__c, Account_Address_StateProvince__c,
                                                    Account_Address_Name2__c, Fulfilment_ShipToAddress_Address_Name2__c
                                                    FROM DT_SYS_OrderHeader__x
                                                    WHERE SalesOrder__c = : tempSingleOrderNumber
                                                    AND HostSystem__c =: HOST_SYS_OASIS]){
                                                        
                                                        
                                                        
                                                        System.debug('OrderHeader--->'+salesorder);
                                                        //get all line items for a particular order from map
                                                        for(DT_SYS_OrderLine__x sysorderline : orderlinemap.get(salesorder.SalesOrder__c)){
                                                            orderLineList.add(new OrderLineWrapper(sysorderline));
                                                            system.debug('orderLineList '+orderLineList);
                                                        }
                                                        SchedulerWrapper orderWrp = new SchedulerWrapper(salesorder, orderLineList);
                                                        system.debug('orderWrp '+orderWrp);
                                                        orderWrapperList.add(orderWrp);
                                                        System.debug('orderWrapperList--->'+orderWrapperList);
                                                    }
            
            
            if(Test.isRunningTest()){
                DT_SYS_OrderHeader__x salesorder = mockallOrderHeader;
                
                System.debug('OrderHeader--->'+salesorder);
                //get all line items for a particular order from map
                for(DT_SYS_OrderLine__x sysorderline : orderlinemap.get(salesorder.SalesOrder__c)){
                    orderLineList.add(new OrderLineWrapper(sysorderline));
                    system.debug('orderLineList '+orderLineList);
                }
                SchedulerWrapper orderWrp = new SchedulerWrapper(salesorder, orderLineList);
                system.debug('orderWrp '+orderWrp);
                orderWrapperList.add(orderWrp);
                System.debug('orderWrapperList--->'+orderWrapperList);
            }
            
        } catch(Exception exp){
            System.debug('Dal_ScheduleOrderController: An unexpected error has occurred: ' + exp.getMessage());
        }
        
        return orderWrapperList;
    }
    
    /*
    * Method Name: getNextBusinessDay
    * Description: TO caluclate Next business Day.
    * @param: None
    * @return Datetime
    */
    @AuraEnabled
    public static Datetime getNextBusinessDay(){
        Time Currenttime = Datetime.now().time();
        String timeValue = String.valueOf(Currenttime);
        List<String> parts = timeValue.split(':');
        System.debug('Parts'+parts[0]);
        System.debug('Parts'+parts[1]);
        
        if(parts[0] <= '14' && parts[1] == '0'){
            return System.now();
        }
        else{
            return System.now().addDays(1);
        }
    }
    
    
    /*
    * Method Name: getMultipleOrder
    * Description: To schedule mulitplte order in once and return its status
    * @param: String
    * @return  List of WebserviceResponse Wrapper
    */
    @AuraEnabled
    public static List<WebserviceResponse> getMultipleOrder(String salesOrderList){
        
        System.debug('salesOrderList:>> '+salesOrderList);
        List<Peak_Response> responseList = new List<Peak_Response>();
        List<WebserviceResponse> webResponseList = new List<WebserviceResponse>();
        Peak_Response response = new Peak_Response();
       
        List<Dal_SchedulePickupJSON> salesOrderjson = Dal_SchedulePickupJSON.parse(salesOrderList);
        List<OrderLineWrapper> skusItem = new List<OrderLineWrapper>();
        List<SchedulerWrapper> schedulerWrappersList = new List<SchedulerWrapper>();
        Dal_SchedulePickupJSON firstOrderData = new Dal_SchedulePickupJSON();
        Integer i = 0;
        for(Dal_SchedulePickupJSON schedule : salesOrderjson){
            
            if(i == 0) {
                i++;
                firstOrderData = schedule;
                System.debug('First_scheduled_Item----> '+schedule);
               
                if(!Test.isRunningTest()){
                    for(DT_SYS_OrderLine__x orderLine : [SELECT Id,SalesOrder__c,UOM__c,SalesOrderLineKey__c,StatusDesc2__c,
                                                         Fulfilment_Contact_Email__c,Fulfilment_Contact_FirstName__c,Fulfilment_ScheduleTime__c,
                                                         Fulfilment_SendMsgTextInd__c,Fulfilment_Contact_Phone__c,Material__c,Fulfilment_Contact_LastName__c,
                                                         MaterialDesc__c,Quantity__c,QuantityInLegacyBaseUOM__c,LegacyBaseUOM__c,SalesOrderLineNo__c,Status__c
                                                         FROM DT_SYS_OrderLine__x
                                                         WHERE StatusDesc2__c IN : STATUS_LIST
                                                         AND SalesOrder__c = : schedule.orderNumber
                                                         AND HostSystem__c =: HOST_SYS_OASIS]){
                                                             OrderLineWrapper lineWrapper = new OrderLineWrapper(orderLine);
                                                             skusItem.add(lineWrapper);
                                                         }
                }
                else{
                    //orderLine.addAll(mockallOrderLineList);
                    OrderLineWrapper lineWrapper = new OrderLineWrapper(mockallOrderLineList[0]);
                    skusItem.add(lineWrapper);
                }
                
                System.debug('First_Order_LineItmes----> '+skusItem);
                if(skusItem.size()>0) {
                    System.debug('Size in if--->'+skusItem.size());
                    SchedulerWrapper wrapper = new SchedulerWrapper(schedule, skusItem);
                    schedulerWrappersList.add(wrapper);
                    Dal_OrderFulfilmentManager fulfilmentwrapper = new Dal_OrderFulfilmentManager(schedulerWrappersList, firstOrderData);
                    
                    try {
                        response = Dal_OrderFulfilmentManager.getOrderFulfilment();
                        
                        WebserviceResponse webResponse = new WebserviceResponse(response,schedule.OrderNumber);
                        webResponseList.add(webResponse);
                        
                        System.debug('response_firstTime-->' + response);
                    } catch (Exception e) {
                        System.debug('Response_Exception for first--->' + e.getMessage());
                    }
                }else{
                    System.debug('Size in else-ZERO-->');
                    WebserviceResponse webResponse = new WebserviceResponse(response,schedule.OrderNumber);
                    webResponseList.add(webResponse);
                }
            }else{
                System.debug('Call For Fullfilment');
                System.debug('First_scheduled_Item----> '+firstOrderData);
                List<String> orderList = new List<String>();
                orderList.add(schedule.orderNumber);
                List<SchedulerWrapper> schedulerWrappers = getScheduleinfo(orderList);
                system.debug('---schedulerWrappers---yy-'+schedulerWrappers);
                if(schedulerWrappers[0].OrderLineWrappers.size() > 0 ){
                    System.debug('schedulerWrappers[0].OrderLineWrappers.size--->'+schedulerWrappers[0].OrderLineWrappers.size());
                    Dal_OrderFulfilmentManager fulfilwrapper = new Dal_OrderFulfilmentManager(schedulerWrappers,firstOrderData);
                    try {
                        response = Dal_OrderFulfilmentManager.getOrderFulfilment();
                        WebserviceResponse webResposne = new WebserviceResponse(response,schedule.orderNumber);
                        webResponseList.add(webResposne);
                        //  responseList.add(response);
                    }catch (Exception e){
                        System.debug('Response_Exception--->'+e.getMessage());
                    }
                }else{
                    System.debug('schedulerWrappers[0].OrderLineWrappers.size-ZERO-->');
                    response = null;
                    WebserviceResponse webResponse = new WebserviceResponse(response,schedule.orderNumber);
                    webResponseList.add(webResponse);
                    
                }
                
                
            }
            
        }
        System.debug('webResponseList--->'+webResponseList);
        return webResponseList ;
    }
    
    /*
    * Method Name: submitOrderForDelivery
    * Description: Submit order for Delivery
    * @param: String
    * @return Object
    */
    @AuraEnabled
    public static Peak_Response submitOrderForDelivery(string fulfilWrapper){
        system.debug('fulfilWrapper-------->in Schedule----> '+fulfilWrapper);
 
        Peak_Response response = new Peak_Response();
        Dal_OrderFulfilmentManager.setOrderFulFill(fulfilWrapper);
        response = Dal_OrderFulfilmentManager.getOrderFulfilment();
        return response ;
    }
    
  	/*
    * Method Name: getSkusData
    * Description: Method used to get Number of line items present in Order
    * @param: List of String
    * @return List of Wrapper
    */
    @AuraEnabled
    public static List<OrderWithSku> getSkusData(List<String> orderNumber){
        
        System.debug('OrderNumbers from Community-->'+orderNumber);
        List<OrderWithSku> salesOrderList = new List<OrderWithSku>();
        
        // TODO we are running this query in for loop because we are not allow to query with muliple sales order on External object.
        
        for(String salesOrder : orderNumber){
            
            List<DT_SYS_OrderLine__x> orderLines  = [Select Id, Quantity__c,Material__c,SalesOrder__c, UOM__c FROM DT_SYS_OrderLine__x
                                                     WHERE SalesOrder__c = :salesOrder AND HostSystem__c = 'OASIS' AND StatusDesc2__c =: STATUS_LIST ];
            
            OrderWithSku orderWithSku = new OrderWithSku(salesOrder,orderLines);
            salesOrderList.add(orderWithSku);
        }
        
        System.debug('salesOrderList-->'+salesOrderList);
        return salesOrderList;
    }
    
    /*
    * Method Name: getSkusReScheduleData
    * Description: Method used to get Number of line items present in Order which were rescheduled
    * @param: List of String
    * @return List of Wrapper
    */
    @AuraEnabled
    public static List<OrderWithSku> getSkusReScheduleData(List<String> orderNumber){
        
        System.debug('OrderNumbers from Community-->'+orderNumber);
        List<OrderWithSku> salesOrderList = new List<OrderWithSku>();
        
        // TODO we are running this query in for loop because we are not allow to query with muliple sales order on External object.
        
        for(String salesOrder : orderNumber){
            
            List<DT_SYS_OrderLine__x> orderLines  = [Select Id, Quantity__c,Material__c,SalesOrder__c, UOM__c FROM DT_SYS_OrderLine__x
                                                     WHERE SalesOrder__c = :salesOrder AND HostSystem__c = 'OASIS'];
            
            OrderWithSku orderWithSku = new OrderWithSku(salesOrder,orderLines);
            salesOrderList.add(orderWithSku);
        }
        
        System.debug('salesOrderList-->'+salesOrderList);
        return salesOrderList;
    }
    
    /*
    * Method Name: getSkusSingleData
    * Description: Method used to get Number of line items present in multipl Order which were scheduled
    * @param: List of String
    * @return List of Wrapper
    */
    @AuraEnabled
    public static List<OrderWithSku> getSkusSingleData(List<String> orderNumber){
        
        System.debug('OrderNumbers from Community-->'+orderNumber);
        List<OrderWithSku> salesOrderList = new List<OrderWithSku>();
        
        // TODO we are running this query in for loop because we are not allow to query with muliple sales order on External object.
        
        for(String salesOrder : orderNumber){
            
            List<DT_SYS_OrderLine__x> orderLines  = [Select Id, Quantity__c,Material__c,SalesOrder__c, UOM__c FROM DT_SYS_OrderLine__x
                                                     WHERE SalesOrder__c = :salesOrder AND HostSystem__c = 'OASIS'
                                                     AND (StatusDesc2__c = 'Scheduled for Delivery' OR StatusDesc2__c ='Scheduled for Pick Up')];
            
            OrderWithSku orderWithSku = new OrderWithSku(salesOrder,orderLines);
            salesOrderList.add(orderWithSku);
        }
        
        System.debug('salesOrderList-->'+salesOrderList);
        return salesOrderList;
    }
    
    /*
    * Method Name: removeOrderLine
    * Description: Method used to remove the order line time to get schedule.
    * @param: String , String
    * @return Object
    */
     @AuraEnabled
        public static Peak_Response removeOrderLine(String orderNumber,String orderLineNumber){

        System.debug('Remove Order orderLineDetail-->'+orderNumber+'-'+orderLineNumber);
        List<String> orderList = new List<String>();
        orderList.add(orderNumber);
        Peak_Response response = new Peak_Response();
        try {
        List<SchedulerWrapper> scheduleWrapperList = getReSecheduleData(orderList,orderLineNumber);
        Dal_OrderFulfilmentCancelManager orderFulfilmentCancelManager = new Dal_OrderFulfilmentCancelManager(scheduleWrapperList,orderLineNumber);
        response = orderFulfilmentCancelManager.cancelFulfilment();
        }catch (Exception e){
        System.debug('Cancel Webservice Resposne--->'+e.getMessage());
        }
        System.debug('salesOrderList-->'+response);
        return response;
     }

    
    
    // Wrapper to pass in webservice
    public class FulfilmentWrapper{
        @AuraEnabled public String SalesOrder;
        @AuraEnabled public String SalesOrderKey;
        @AuraEnabled public String FulfilmentMethod;
        @AuraEnabled public String ScheduleTime;
        @AuraEnabled public String ContactFirstName;
        @AuraEnabled public String ContactLastName;
        @AuraEnabled public String ContactPhMobile;
        @AuraEnabled public String ContactEmail;
        @AuraEnabled public String sendSMS;
        @AuraEnabled public String ShipToAddress_Name;
        @AuraEnabled public String ShipToAddress_Line1;
        @AuraEnabled public String ShipToAddress_Line2;
        @AuraEnabled public String ShipToAddress_Line3;
        @AuraEnabled public String ShipToAddress_City;
        @AuraEnabled public String ShipToAddress_StateProvince;
        @AuraEnabled public String ShipToAddress_PostalCode;
        @AuraEnabled public String ShipToAddress_Country;
        @AuraEnabled public FulfilmentLineWrapper lineWrapper;
    }
    // Wrapper of Line items to pass in webservice
    public class FulfilmentLineWrapper{
        @AuraEnabled public String Quantity;
        @AuraEnabled public String SalesOrderLine;
        @AuraEnabled public String SalesOrderLineKey;
    }
    
    //Wrapper to pass count of orderline with Ordernumber
    public class OrderWithSku{
        @AuraEnabled public String orderNumber;
        @AuraEnabled public Integer countOfSkus;
        @AuraEnabled public List<DT_SYS_OrderLine__x> skuswithData;
        OrderWithSku(String salesOrder,List<DT_SYS_OrderLine__x> skuLines){
            orderNumber = salesOrder;
            skuswithData = skuLines;
            countOfSkus = skuLines.size() > 0 ? skuLines.size() : 0;
        }
    }
    
    //Wrapper to pass response of webservice with order number
    public class WebserviceResponse{
        @AuraEnabled public String message;
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String orderNumber;
        
        public WebserviceResponse(Peak_Response response,String orderNumberVal){
            if(response.success){
                this.message = 'OK';
                this.isSuccess = response.success;
                this.orderNumber = orderNumberVal;
            }else{
                this.message = 'NOT OK';
                this.isSuccess = false;
                this.orderNumber = orderNumberVal;
            }
            
        }
    }
    
}