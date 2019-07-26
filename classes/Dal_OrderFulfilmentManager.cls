/**
* Created by 7Summits on 4/20/2018. 
*/
public class Dal_OrderFulfilmentManager {


    public static Dal_ScheduleOrderController.SchedulerWrapper scheduleWrapper;
    public static Boolean isSingle = true ;
    public static String fulfilmentWrapper ;
    public static String FirstName ;
    public static String LastName ;
    public static String Phone ;
    public static String TimeSelected ;
    public static String TypeOfSchedule ;
    public static String defaultAddress ;
    public static String deliverDate ;
    public static Boolean sendSMS ;

    public Dal_OrderFulfilmentManager(List<Dal_ScheduleOrderController.SchedulerWrapper> wrap,Dal_SchedulePickupJSON scheduledOrder){
        scheduleWrapper = wrap[0];
        isSingle = false;
        FirstName = scheduledOrder.pickupFirstName;
        LastName = scheduledOrder.pickupLastName;
        Phone = scheduledOrder.pickupPhone;
        String pickDate;
        if(scheduledOrder.pickupDate != null && scheduledOrder.pickupDate != ''){
            System.debug('pickDate-->'+scheduledOrder.pickupDate);
            pickDate =scheduledOrder.pickupDate;
           /* Integer i = pickDate.lastindexof('-');
            Integer j =  pickDate.length()-1;
            Integer z = j-i;
            if(z == 1){
                pickDate = pickDate.substring(0,i+1)+'0'+pickDate.substring(i+1,j+1);
            }*/
            pickDate = String.valueOf(Date.valueOf(pickDate)).removeEnd(' 00:00:00');
            System.debug('Modified--pickDate-->'+pickDate);

        }
        if(scheduledOrder.deliveryDate != null && scheduledOrder.deliveryDate != ''){
            System.debug('pickDate-->'+scheduledOrder.deliveryDate);
            deliverDate = scheduledOrder.deliveryDate;
            deliverDate = String.valueOf(Date.valueOf(deliverDate)).removeEnd(' 00:00:00');
            System.debug('Modified--deliverDate-->'+deliverDate);
        }
        String pickTime;
        if(scheduledOrder.pickupTimeSelected!= null && scheduledOrder.pickupTimeSelected != ''){
            System.debug('scheduledOrder.pickupTimeSelected-->'+scheduledOrder.pickupTimeSelected);
            pickTime = scheduledOrder.pickupTimeSelected;

            list<String> str1 = pickTime.split(':');

            if(Integer.valueOf(str1[0]) < 10){
                pickTime = '0'+pickTime;
            }
            System.debug('---pickTime---'+pickTime);
        }
        TimeSelected = pickDate+' '+pickTime;
        TypeOfSchedule = scheduledOrder.scheduleType;
        defaultAddress = scheduledOrder.sscLocation.name;
        sendSMS = scheduledOrder.pickupShouldSendTxt;
        System.debug('scheduleWrapper__In_constructor'+scheduledOrder);
    }

    public static void setOrderFulFill(String fulfilmentWrapperStr){
        fulfilmentWrapper = fulfilmentWrapperStr;
        isSingle = true;
        System.debug('scheduleWrapper__In_constructor_withh'+scheduleWrapper);
    }
    /*
    * Method Name: getOrderFulfilment
    * Description: Purpose to get Order Fulfilment data from webservice .
    * @param: Not Any
    * @return List of Wrapper Class object. 
    */
    public static Peak_Response getOrderFulfilment(){

        //Setting Endpoint
        Dal_OrderFulfilmentService.Endpoint1 orderFulfil = new Dal_OrderFulfilmentService.Endpoint1();
        //Setting Order set for request
        Dal_OrderFulfilmentContext.Order order = new Dal_OrderFulfilmentContext.Order();
        List<Dal_OrderFulfilmentContext.Schedule> schedulelist = new List<Dal_OrderFulfilmentContext.Schedule>();


        if(isSingle){
        System.debug('fulfilmentWrapper------> in webservice---->'+fulfilmentWrapper);
        List<WillCall> wlist = new List<WillCall>();
        // Parse entire JSON response.
        JSONParser parser = JSON.createParser(fulfilmentWrapper);
        system.assert(true,parser);
        while (parser.nextToken() != null) {
            // Start at the array of willcall.
            system.debug(parser.getCurrentToken()+' ------before aray');
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next willcall  object.
                    system.debug(parser.getCurrentToken()+' ------  '+JSONToken.START_OBJECT);
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire willcall object, including its array of line items.
                        WillCall inv = (WillCall)parser.readValueAs(WillCall.class);
                        system.debug('WillCall array: ' + inv.ScheduleTime);
                        //system.debug('Size of list items: ' + inv.lineWrapperList);
                        // For debugging purposes, serialize again to verify what was parsed.
                        //WillCall s = JSON.deserialize(inv);
                        //system.debug('Serialized invoice: ' + s);
                        //wlist.add(s);
                        wlist.add(inv);
                        // Skip the child start array and start object markers.
                        parser.skipChildren();
                    }
                }
            }
            else{
                system.debug(parser.getCurrentToken()+' ------before');
                
                // Advance to the start object marker to
                //  find next willcall  object.
                system.debug(parser.getCurrentToken()+' ------  '+JSONToken.START_OBJECT);
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire willcall object, including its array of line items.
                    WillCall inv = (WillCall)parser.readValueAs(WillCall.class);
                    system.debug('WillCall not array : ' + inv);
                    //system.debug('Size of list items: ' + inv.lineWrapperList);
                    // For debugging purposes, serialize again to verify what was parsed.
                    //WillCall s = JSON.deserialize(inv);
                    //system.debug('Serialized invoice: ' + s);
                    //wlist.add(s);
                    wlist.add(inv);
                    // Skip the child start array and start object markers.
                    parser.skipChildren();
                }
                
                
            }
            
        }



            order.HostSystem = Dal_Constants.FULFILMENT_HOST_TYPE;
            order.SalesOrder = wlist[0].SalesOrder;
            order.SalesOrderKey = wlist[0].SalesOrderKey;

        //    List<Dal_OrderFulfilmentContext.Schedule> schedulelist = new List<Dal_OrderFulfilmentContext.Schedule>();

            for (WillCall wrap : wlist) {

                System.debug('wrap---->' + wrap);
                //create schedule for each loop
                Dal_OrderFulfilmentContext.Schedule schedule = new Dal_OrderFulfilmentContext.Schedule();
                if (wrap.FulfilmentMethod == 'pickup') {
                    schedule.FulfilmentMethod = 'PICK';
                }
                if (wrap.FulfilmentMethod == 'delivery') {
                    schedule.FulfilmentMethod = 'SHP';
                }
                system.debug('ScheduleTime ' + wrap.ScheduleTime);
                schedule.ScheduleTime = wrap.ScheduleTime;
                schedule.ContactFirstName = wrap.ContactFirstName;
                schedule.ContactLastName = wrap.ContactLastName;
                schedule.ContactPhMobile = wrap.ContactPhMobile;
                //get user - contact email
                id userId = UserInfo.getUserId();
                try {
                    User u = [select id, Email from User where id = :userId];
                    system.debug('contact id is ' + u);
                    //Contact c = [select firstname, lastname, phone, email from contact where id=:u.contactId];
                    //system.debug('contact is '+c);
                    schedule.ContactEmail = u.Email;
                } catch (Exception e) {

                }
                if (wrap.sendSMS == 'false') {
                    schedule.SendTextMsgInd = 'Y';
                }
                if (wrap.sendSMS == 'true') {
                    schedule.SendTextMsgInd = 'N';
                }

                schedule.ShipToAddress_Name = wrap.ShipToAddress_Name;
                schedule.ShipToAddress_Name2 = wrap.ShipToAddress_Line3;
                schedule.ShipToAddress_Line1 = wrap.ShipToAddress_Line1;
                schedule.ShipToAddress_City = wrap.ShipToAddress_City;
                schedule.ShipToAddress_StateProvince = wrap.ShipToAddress_StateProvince;
                schedule.ShipToAddress_PostalCode = wrap.ShipToAddress_PostalCode;
                schedule.ShipToAddress_Country = wrap.ShipToAddress_Country;
                //create lines for each schedule
                //For List of line item
                List<Dal_OrderFulfilmentContext.Line> lineList = new List<Dal_OrderFulfilmentContext.Line>();

                for (LineWrapperList lwraplist : wrap.lineWrapperList) {

                    // Setting line items for "Lines"
                    Dal_OrderFulfilmentContext.Line line = new Dal_OrderFulfilmentContext.Line();
                    line.SalesOrderLine = lwraplist.SalesOrderLine;
                    line.SalesOrderLineKey = lwraplist.SalesOrderLineKey;
                    line.Quantity = Decimal.valueOf(lwraplist.Quantity);

                    // adding line item to list
                    lineList.add(line);
                }
                //Setting "Lines" for request by adding Line in "Lines"
                Dal_OrderFulfilmentContext.ArrayOfLine lines = new Dal_OrderFulfilmentContext.ArrayOfLine();
                lines.Line = lineList;
                schedule.Lines = lines;
                //add each schedule to schedule list
                schedulelist.add(schedule);
            }
            System.debug('schedulelist__In_IF ' + schedulelist);
        }else{
            //Setting Order set for request

            order.HostSystem = Dal_Constants.FULFILMENT_HOST_TYPE;
            order.SalesOrder = scheduleWrapper.OrderNumber;
            order.SalesOrderKey =scheduleWrapper.SalesOrderKey;

            System.debug('order---------->'+order);
            System.debug('schedule---------->'+TimeSelected+''+FirstName+''+LastName+''+Phone);
            Dal_OrderFulfilmentContext.Schedule schedule = new Dal_OrderFulfilmentContext.Schedule();
            if(TypeOfSchedule.equalsIgnoreCase('SHP')){
                schedule.ScheduleTime = deliverDate;
            }else{
                schedule.ScheduleTime = TimeSelected;
            }

            schedule.ContactFirstName = FirstName;
            schedule.ContactLastName = LastName;
            schedule.ContactPhMobile = Phone;
            schedule.FulfilmentMethod = TypeOfSchedule;
            System.debug('schedule---------->'+schedule);
            try {
                //get user - contact email
                Id userId = UserInfo.getUserId();

                User u = [Select Id, Email FROM User WHERE Id = :userId];
                System.debug('contact id is ' + u);
                //Contact c = [select firstname, lastname, phone, email from contact where id=:u.contactId];
                //system.debug('contact is '+c);
                schedule.ContactEmail = u.Email;

            }
            catch (Exception e){
                System.debug('Exception_At_Email_insert'+e.getMessage());
            }
            if (sendSMS) {
                schedule.SendTextMsgInd = 'N';
            }
            else{
                schedule.SendTextMsgInd = 'Y';
            }
            //schedule.SendTextMsgInd ='Y';

            if(TypeOfSchedule.equalsIgnoreCase('SHP')){
                schedule.ShipToAddress_Name = scheduleWrapper.FFLocationName;
                schedule.ShipToAddress_Name2 = scheduleWrapper.FFLocationline3;
                schedule.ShipToAddress_Line1 = scheduleWrapper.FFLocationline1;
                schedule.ShipToAddress_City = scheduleWrapper.FFLocationCity;
                schedule.ShipToAddress_StateProvince = scheduleWrapper.FFLocationState;
                schedule.ShipToAddress_PostalCode = scheduleWrapper.FFLocationZIP;
                schedule.ShipToAddress_Country = scheduleWrapper.FFLocationCountry;
            }else{
                schedule.ShipToAddress_Name = defaultAddress;
            }

            List<Dal_OrderFulfilmentContext.Line> lineList = new List<Dal_OrderFulfilmentContext.Line>();
            System.debug('scheduleWrapper.OrderLineWrappers---->'+scheduleWrapper.OrderLineWrappers);
            for (Dal_ScheduleOrderController.OrderLineWrapper lineWrappers : scheduleWrapper.OrderLineWrappers) {

                // Setting line items for "Lines"
                Dal_OrderFulfilmentContext.Line line = new Dal_OrderFulfilmentContext.Line();
                line.SalesOrderLine = lineWrappers.LineNumber;
                line.SalesOrderLineKey = lineWrappers.linekey;
                line.Quantity = Decimal.valueOf(lineWrappers.Quantity);

                // adding line item to list
                lineList.add(line);
            }
            //Setting "Lines" for request by adding Line in "Lines"
            Dal_OrderFulfilmentContext.ArrayOfLine lines = new Dal_OrderFulfilmentContext.ArrayOfLine();
            lines.Line = lineList;
            schedule.Lines = lines;
            //add each schedule to schedule list
            schedulelist.add(schedule);
            System.debug('schedulelist__In_Else'+schedulelist);
        }
        // Setting "Schedules" for request by adding all "Schedule" to it.
        Dal_OrderFulfilmentContext.ArrayOfSchedule schedules = new Dal_OrderFulfilmentContext.ArrayOfSchedule();
        schedules.Schedule = schedulelist;
        
        // Getting request object .
        Dal_OrderFulfilmentContext.OrderFulfilmentSchedule request = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule();
        request.Order = order;
        request.Schedules = schedules;
        System.debug('Requested Data------->'+request);
        
        //Getting response from web-service
        Dal_OrderFulfilmentDatacontract.Response response = orderFulfil.CreateOrderFulfilmentSchedule(request);
        System.debug('Resonse Data------->'+response);
        
        //creating peak response
        Peak_Response peakResponse = new Peak_Response();
        if(response.Result.Status == 'Ok' )
        {
            peakResponse.success = true;
            peakResponse.messages.add(response.Result.StatusDesc);
        }
        else
        {
            peakResponse.success = false;
        }
        
        System.debug('Status------->'+ peakResponse.success);
        System.debug('Status------->'+ peakResponse.messages);
        return peakResponse;

        
    }
    
    public class WillCall {     
        
        public String SalesOrder;
        public List<lineWrapperList> lineWrapperList;
        public String SalesOrderKey;
        public String FulfilmentMethod;// pickup  - PICK and delivery - SHP
        public String ShipToAddress_Name;
        public String ShipToAddress_Line1;
		public String ShipToAddress_Line3;
        public String ShipToAddress_City;
        public String ShipToAddress_StateProvince;
        public String ShipToAddress_PostalCode;
        public String ShipToAddress_Country;
        public String ContactFirstName;
        public string ContactLastName;
        public String ContactPhMobile;
        public String sendSMS;
        public String PickTime;
        public String ScheduleTime; //one field if PICK date + time. if SHP only date
    }
    
    public class lineWrapperList {
        public String Quantity;
        public String SalesOrderLine;
        public String SalesOrderLineKey;
        
    }
    
}