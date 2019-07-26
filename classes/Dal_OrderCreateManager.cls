/**
* Created by 7Summits on 4/20/2018. 
*/
public class Dal_OrderCreateManager {
    
    public List<DT_Order__c> orderheaderList ;
    public List<DT_Order_Product__c> orderLines ;
    
    // Constructor
    public Dal_OrderCreateManager(Id orderId)
    {
        orderheaderList = new List<DT_Order__c>();
        orderLines = new List<DT_Order_Product__c>();
        try{
            orderheaderList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                               LastModifiedById, SystemModstamp, LastActivityDate,
                               AccountName__c,AccountName__r.name,Address_Name__c,Address1__c, Address2__c, Address3__c, Address4__c, City__c, State__c, Brand__c, 
                               Contact_Name__c,Contact_Phone__c, Country__c, Postal_Code__c, Delegate_Pickup__c, Delegate_First_Name__c, 
                               Delegate_Last_Name__c, Delegate_Mobile_Phone__c, Freight_Terms__c, Carrier__c, Group_Key__c, 
                               JobName__c, OrderID_External__c, Order_Origin_Salesforce__c, Order_Status_Code__c, Price_Record__c, 
                               Purchase_Order__c, Requested_Ship_date__c, Ship_Complete__c, Shipto_Name_1__c, Shipto_Name2__c, 
                               Small_Package_Carrier__c, Small_Package__c, SSC__c, Tax_Exempt_Code__c, Total_Extended_Weight__c, 
                               Total_Order_Amount__c, Status__c, Submit_Date__c,Default_Requested_Ship_Date__c,IsOverrride__c  FROM DT_Order__c Where Id =: orderId ];
            
            System.debug('Order header-->'+orderheaderList[0]);
            
        } catch(Exception exp){
            System.debug('orderheaderList: An unexpected error has occurred: ' + exp.getMessage());
        }
        
        try{
            orderLines = [SELECT Id, IsDeleted, Name,SKU_Number__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                          LastActivityDate, DT_Order_Id__c, Brand__c, Division_code__c,
                          Orderline_status__c, Order_Number_ext__c, Product_name__c, RDC_number__c, Product_Sku__c, 
                          Order_Line_Status__c, Quantity__c, Unit_of_Measure__c, product_description__c, Requested_Ship_Date__c, 
                          Price_Record__c, Source_of_Supply__c, QTY_of_UOM__c, Price_per_UOM__c, Extended_Price__c, 
                          Source_of_Supply_Number__c, Unit_Weight__c, Extended_Weight__c, Freight_Terms__c, Carrier__c, SSC_Name__c,
                          Small_Packagecd__c, Small_Package_Carrier__c, Delivery_Preference__c, Shipment_line_status__c, 
                          Override_shipcode_add__c, DT_Shiptoaddress_Override__c, Receiver_Company_name__c, Override_Name2__c, 
                          Override_Shipto_Address1__c, Override_Shipto_Address2__c, Override_Shipto_City__c, 
                          Override_Shipto_State__c, Override_Postal_Code__c, Color__c FROM DT_Order_Product__c 
                          where DT_Order_Id__c =: orderId ] ;
            
            System.debug('Order Lines-->'+orderLines[0]);
            
        } catch(Exception exp){
            System.debug('orderLines: An unexpected error has occurred: ' + exp.getMessage());
        }
    }
    
    /*
* Method Name: getOrderFulfilment
* Description: Purpose to get Order create data from webservice .
* @param: Not Any
* @return List of Wrapper Class object. 
*/
    public Peak_Response getOrderCreate(){
        
        
        String carrierCode;
        String customerId; 
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        
       	DT_Order__c orderHeader =new DT_Order__c();
        
        if(orderheaderList.size()!=null && !String.isBlank(orderheaderList[0].Id))
        {
            orderHeader = orderheaderList[0];
        }
        
        System.debug('orderHeader.requestDate----->'+orderHeader.Requested_Ship_date__c);
        System.debug('orderHeader.DefaultReq.----->'+orderHeader.Default_Requested_Ship_Date__c);
        System.debug('orderHeader.Carrier__c----->'+orderHeader.Carrier__c);
        List<Dal_OrderSearchController.StatusOption> carrierOption = Dal_OrderSearchController.getCarrier();
        for(Dal_OrderSearchController.StatusOption carrier : carrierOption)
        {
            if(carrier.label == orderHeader.Carrier__c)
            {
                carrierCode = carrier.value;
            }
        }
        System.debug('carrierCode---->'+carrierCode);
        
        Dal_OrderCreateService.Endpoint1 orderCreate = new Dal_OrderCreateService.Endpoint1();
        
        // For ShipToAddress & Account
        Dal_OrderCreateDataContract.Address address = new Dal_OrderCreateDataContract.Address();
        address.City = orderHeader.City__c;
        address.Name = orderHeader.Address_Name__c;
        address.Country = orderHeader.Country__c;
        address.Line1 = orderHeader.Address2__c;
        address.Line2 = orderHeader.Address3__c;
        address.Line3 = orderHeader.Address4__c;
        address.Name2 = orderHeader.Address1__c; // get the saved address name from DT order
        address.PostalCode =orderHeader.Postal_Code__c; 
        address.StateProvince =orderHeader.State__c ;
        address.Country = orderHeader.Country__c;
        
        // For ShipToAddress & Account
        Dal_OrderCreateDataContract.Contact contact = new Dal_OrderCreateDataContract.Contact();
        contact.EMail = '';
        contact.FirstName = orderHeader.Contact_Name__c;
        contact.LastName = '';
        contact.Phone = orderHeader.Contact_Phone__c;
        
        // For Request
        Dal_OrderCreateDataContract.DocumentOptions documentOptions = new Dal_OrderCreateDataContract.DocumentOptions();
        //  documentOptions.PlantIdentifierType = 'LegacyLoc';
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;
        
        // For Account Detail
        Dal_OrderCreateDataContract.Account account = new Dal_OrderCreateDataContract.Account();        
        account.Address = address;
        account.Contact = contact;
        //account.Division = '42';
        account.LegacyCustomer = customerId;
        //account.SAP_Customer = '';
        //account.SalesOrganization = '8055';
        System.debug('CustomerId----> '+ customerId);
        
        // For Fulfilment
        Dal_OrderCreateDataContract.Carrier carrier = new Dal_OrderCreateDataContract.Carrier();
        carrier.CustomerAccountWithCarrier = '';
        //store the mapping in Dal constatnd and then send the code instead of pick list value
        carrier.SCAC = carrierCode;
        
        
        // For Fulfilment
        Dal_OrderCreateDataContract.ShipToAddress shipToAddress = new Dal_OrderCreateDataContract.ShipToAddress();
        shipToAddress.Address = address;
        //shipToAddress.Contact = contact;
        if(orderHeader.IsOverrride__c){
        shipToAddress.SameAsAccount = 'N';
        }
        else{
            shipToAddress.SameAsAccount = 'Y';
        }
        
        // For SalesOrderHeader
        Dal_OrderCreateDataContract.Fulfilment fulfilment = new Dal_OrderCreateDataContract.Fulfilment();
        fulfilment.Carrier = carrier;
        fulfilment.FreightTerms = orderHeader.Freight_Terms__c;
        System.debug('in----orderHeader.Small_Package__c'+orderHeader.Small_Package__c);
        if(orderHeader.Small_Package__c)
        {
            System.debug('in----orderHeader.Small_Package__c'+orderHeader.Small_Package__c);
            fulfilment.ShipMode = 'SPC';
        }else{
            fulfilment.ShipMode = 'TL';
        }
        System.debug('Ship_Complete---->'+orderHeader.Ship_Complete__c);
        if(orderHeader.Ship_Complete__c)
        {
            fulfilment.ShipComplete = 'Y';
            System.debug('Ship_Complete---->'+'Y');
        }
        else{
            fulfilment.ShipComplete = 'N';
            System.debug('Ship_Complete---->'+'N');
        }
        
        fulfilment.ShipToAddress = shipToAddress;
        
        
        // For List of Note
        /*Dal_OrderCreateDataContract.Note note = new Dal_OrderCreateDataContract.Note();
        note.Qualifier = 'Qual'; 
        note.Sequence = 1;
        note.Text = '1';*/
        
        // For ArrayOfNote
       /* List<Dal_OrderCreateDataContract.Note> noteList = new List<Dal_OrderCreateDataContract.Note>();
        noteList.add(note);
        
        
        Dal_OrderCreateDataContract.ArrayOfNote notes = new Dal_OrderCreateDataContract.ArrayOfNote();
        notes.Note = noteList;*/
        
        // For List of reference
        Dal_OrderCreateDataContract.Reference reference = new Dal_OrderCreateDataContract.Reference();
        reference.Qualifier = 'CustomerPONo';
        reference.Value = orderHeader.Purchase_Order__c ;
        //    reference.ValueLine = 'Line Value';
        //    reference.ValueText = 'Value Text';
        
        // For ArrayOfReference
        List<Dal_OrderCreateDataContract.Reference> referenceList = new List<Dal_OrderCreateDataContract.Reference>();
        referenceList.add(reference);       

        // For SalesOrderHeader
        Dal_OrderCreateDataContract.ArrayOfReference references = new Dal_OrderCreateDataContract.ArrayOfReference();
        references.Reference = referenceList; 
        
        // For DalTileSalesOrder
        Dal_OrderCreateDataContract.SalesOrderHeader salesOrderHeader =  new Dal_OrderCreateDataContract.SalesOrderHeader();
        salesOrderHeader.Account = account;
        //salesOrderHeader.CreatedByUser = '';
        //salesOrderHeader.CreatedByUser_Id_Type = '';
        salesOrderHeader.CreatedTime = orderHeader.CreatedDate;
        salesOrderHeader.CreatedVia = 'DT Pro-Exchange';
        salesOrderHeader.DocumentOptions = documentOptions;
        salesOrderHeader.Fulfilment = fulfilment;
        salesOrderHeader.HostSystem = 'SAP';
        salesOrderHeader.JobName = orderHeader.JobName__c;
        //salesOrderHeader.Notes = notes;
        //salesOrderHeader.OrderPlant = '4101';
        salesOrderHeader.References = references;
        salesOrderHeader.RequestedShipDate = orderheader.Default_Requested_Ship_Date__c ;
        SalesOrderHeader.SalesOrderType = 'ZOR';
        //salesOrderHeader.SalesOrderHeaderKey = '';
        //salesOrderHeader.Status = orderheader.Status__c;
        //salesOrderHeader.UpdatedByUser = '';
        //salesOrderHeader.UpdatedByUser_Id_Type = '';
        salesOrderHeader.UpdatedTime = orderheader.LastModifiedDate;
        
        Decimal totalWeight = 0;
        
        // For ArrayOfSalesOrderLine
        List<Dal_OrderCreateDataContract.SalesOrderLine> salesOrderLineList = new List<Dal_OrderCreateDataContract.SalesOrderLine>();  
       
        if(orderLines.size()!=null && String.isNotBlank(orderLines[0].Id))
        {
            
        //Getting SSC Location for all queried line items
        Set<String> locationset = new Set<String>();
         for(DT_Order_Product__c orderLine : orderLines){
         	locationset.add(orderLine.Source_of_Supply__c);
         }
        system.debug('locationset '+locationset);
        //creating map to store locationid and name
        Map<string, string> locationmap = new Map<string, string>();
        for(SSC__c location : [Select DW_ID__c,Name from SSC__c where Name in: locationset]){
            locationmap.put(location.Name,location.DW_ID__c);
        }
         system.debug('locationmap' +locationmap);
            for(DT_Order_Product__c orderline : orderLines)
            {
               	System.debug('REquested date line-->'+orderline.Requested_Ship_Date__c);
                if(orderline.Unit_Weight__c != null)
                {
                    totalWeight = totalWeight+ orderline.Unit_Weight__c;
                    System.debug('Total_Weight with unit weight---->'+totalWeight);
                }
                if(orderline.Extended_Weight__c != null)
                {
                    totalWeight = totalWeight+ orderline.Extended_Weight__c;
                    System.debug('Total_Weight with extended  weight---->'+totalWeight);
                }

                // For SalesOrderLine
                Dal_OrderCreateDataContract.Price price = new Dal_OrderCreateDataContract.Price();
                price.PriceNet_Extended = orderline.Extended_Price__c;                
                
                // For List of SalesOrderLine
                Dal_OrderCreateDataContract.SalesOrderLine salesOrderLine = new Dal_OrderCreateDataContract.SalesOrderLine();
                salesOrderLine.CostExtended = orderline.Extended_Price__c;
                salesOrderLine.LastActualShipDate = System.now();
                salesOrderLine.Material = orderline.SKU_Number__c;
                salesOrderLine.Price = price;
                salesOrderLine.PromisedShipDate = System.now();
                salesOrderLine.Quantity = orderline.Quantity__c;
                system.debug('orderline.Requested_Ship_Date__c--'+orderline.Requested_Ship_Date__c);
                salesOrderLine.RequestedShipDate = orderline.Requested_Ship_Date__c;
                system.debug('salesOrderLine.RequestedShipDate '+salesOrderLine.RequestedShipDate);
                //salesOrderLine.SalesOrderLineNo = 1;
                salesOrderLine.SalesOrderLineNo = Integer.valueof(orderline.Name);
                //salesOrderLine.SupplyPlant = '4'+locationmap.get(orderline.Source_of_Supply__c);
                salesOrderLine.SupplyPlant = orderline.Source_of_Supply_Number__c;
                System.debug('Supply plant-->'+orderline.Source_of_Supply_Number__c);
                salesOrderLine.UOM = orderline.Unit_of_Measure__c;
                salesOrderLine.WeightExtended = orderline.Extended_Weight__c;
                salesOrderLine.PriceRecord = orderline.Price_Record__c;
                //salesOrderLine.WeightUOM = '';
                
                salesOrderLineList.add(salesOrderLine);
                System.debug('salesOrderLine------>'+salesOrderLine);
            }
            
        }
        
        Dal_OrderCreateDataContract.Total total = new  Dal_OrderCreateDataContract.Total();
        total.Weight = totalWeight;
            
        List<Dal_OrderCreateDataContract.Total> totalList = new List<Dal_OrderCreateDataContract.Total>();
        totalList.add(total);
            
        Dal_OrderCreateDataContract.ArrayOfTotal totals= new Dal_OrderCreateDataContract.ArrayOfTotal();
        totals.Total = totalList;
        
        
        // For Request
        Dal_OrderCreateDataContract.ArrayOfSalesOrderLine salesOrderLines = new Dal_OrderCreateDataContract.ArrayOfSalesOrderLine();
        salesOrderLines.SalesOrderLine = salesOrderLineList;
        
       
        // For RequestItem
        Dal_OrderCreateDataContract.DalTileSalesOrder dalTileSalesOrder = new Dal_OrderCreateDataContract.DalTileSalesOrder();
        dalTileSalesOrder.SalesOrderHeader = salesOrderHeader;
        dalTileSalesOrder.SalesOrderLines = salesOrderLines;
       // dalTileSalesOrder.Totals = totals;
        
        // For List of RequestItem
        Dal_OrderCreateDataContract.RequestItem requestItem = new Dal_OrderCreateDataContract.RequestItem();
        requestItem.DalTileSalesOrder = dalTileSalesOrder;
        
        // For ArrayOfRequestItem
        List<Dal_OrderCreateDataContract.RequestItem> requestItemList = new List<Dal_OrderCreateDataContract.RequestItem>();
        requestItemList.add(requestItem); 
        
        // For Request
        Dal_OrderCreateDataContract.ArrayOfRequestItem requestItems = new Dal_OrderCreateDataContract.ArrayOfRequestItem();
        requestItems.RequestItem = requestItemList;
        
        
        // Main Request
        Dal_OrderCreateDataContract.Request request = new Dal_OrderCreateDataContract.Request();
        request.DocumentOptions = documentOptions ;
        
        request.RequestItems = requestItems;
        
        system.debug('Request is '+request);
        Peak_Response peakResponse = new Peak_Response();
        try {
            Dal_OrderCreateDataContract.Response response = orderCreate.CreateSalesOrder(request);
            System.debug('RESPONSE ---->' + response);
            System.debug('RESPONSE STATUS---->' + response.Result.Status);
            System.debug('RESPONSE StatusDesc---->' + response.Result.StatusDesc);
            //System.debug('RESPONSE sales Order Number--->'+response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);



            if (response.Result.Status == 'OK') {
                peakResponse.success = true;
                peakResponse.messages.add(response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);
            } else {
                peakResponse.success = false;
            }

            System.debug('Status------->' + peakResponse.success);
            System.debug('Message------->' + peakResponse.messages);
        }
        catch (Exception e){
            System.debug('Exception Occurs--->'+e.getMessage());
        }
        return peakResponse;
      
    }
   
    // Method to convert a date into required fromat for sending request to webservice
     public String convertToFormat(Datetime dtValue){
        System.debug('-----Date Value----'+dtValue);
         String str;
         if(!Test.isRunningTest()){                     
            Datetime dateValue = dtValue.date();
            System.debug('-----dateValue----'+dateValue);
            str = String.valueOf(dtValue.date());
            if(dateValue == dtValue)
            {
                str = str+'T00:00:00';
            }
            else{
                Date ddValues = date.newinstance(dateValue.year(), dateValue.month(), dateValue.day());
                Date inc = ddValues.addDays(2);
                System.debug('-----date----'+inc);
                str = String.valueOf(inc)+'T00:00:00';    
            }
         }else{
             Str = '';
         }
        System.debug('-----str----'+str);
        return str ;
    }
    
}