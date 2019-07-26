/**
 * Created by Yadav on 8/23/2018.
 */

public with sharing class Dal_OrderSampleCreateManager {

            /*
        * Method Name: getSampleOrderCreate
        * Description: Purpose to get Sample Order create data from webservice .
        * @param: Not Any
        * @return List of Wrapper Class object.
        */
        public static Peak_Response getSampleOrderCreate(Dal_OrderSampleJSON orderJson){
            System.debug('orderJson---->'+orderJson);

            List<Dal_OrderSampleJSON.productOrderLines> orderLines = new List<Dal_OrderSampleJSON.productOrderLines>();
            orderLines = orderJson.productOrderLines;
            System.debug('orderJsonDetail---->'+orderJson.orderDetails);
            System.debug('orderLines---->'+orderLines);
            String carrierCode;
            String customerId;
            Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
            customerId = selectedAccount.DW_ID__c;

            List<Dal_OrderSearchController.StatusOption> carrierOption = Dal_OrderSearchController.getCarrier();

            for(Dal_OrderSearchController.StatusOption carrier : carrierOption)
            {
                if(carrier.label == orderJson.orderDetails.carrier)
                {
                    carrierCode = carrier.value;
                }
            }

            System.debug('carrierCode---->'+carrierCode);

            Dal_OrderCreateService.Endpoint1 orderCreate = new Dal_OrderCreateService.Endpoint1();

            // For ShipToAddress & Account
            Dal_OrderCreateDataContract.Address address = new Dal_OrderCreateDataContract.Address();
            address.City = orderJson.orderDetails.selectedAddress.city;
            address.Name = orderJson.orderDetails.selectedAddress.name;
            address.Country = orderJson.orderDetails.selectedAddress.country;
            address.Line1 = orderJson.orderDetails.selectedAddress.street1;
            address.Line2 = '';
            address.Line3 = '';
            address.Name2 = orderJson.orderDetails.selectedAddress.careOf; // get the saved address name from DT order
            address.PostalCode = orderJson.orderDetails.selectedAddress.zipcode;
            address.StateProvince = orderJson.orderDetails.selectedAddress.state ;

            // For ShipToAddress & Account
            Dal_OrderCreateDataContract.Contact contact = new Dal_OrderCreateDataContract.Contact();
            contact.EMail = '';
            contact.FirstName = '';
            contact.LastName = '';
            contact.Phone = '';

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

            if(orderJson.orderDetails.selectedAddress.isPrimary){
                shipToAddress.SameAsAccount = 'Y';
            }
            else{
                shipToAddress.SameAsAccount = 'N';
            }

            // For SalesOrderHeader
            Dal_OrderCreateDataContract.Fulfilment fulfilment = new Dal_OrderCreateDataContract.Fulfilment();
            fulfilment.Carrier = carrier;

            if(orderJson.orderDetails.freightTerms == 'Prepaid')
            {
                fulfilment.FreightTerms = Dal_Constants.FRIEGHTTERMS.get('Prepaid');
            }
            
            System.debug('Frieght term-->'+fulfilment.FreightTerms);
        //    System.debug('in----orderHeader.Small_Package__c'+orderWrapper.isSmallPackage);

            if(orderJson.orderDetails.isSmallPackage.equals('yes'))
            {
                fulfilment.ShipMode = 'SPC';
                System.debug(' fulfilment.ShipMode --->'+'SPC');
            }else{
                fulfilment.ShipMode = 'TL';
                System.debug(' fulfilment.ShipMode --->'+'TL');
            }

            fulfilment.ShipComplete = 'N';
            fulfilment.ShipToAddress = shipToAddress;

            // For List of reference
            Dal_OrderCreateDataContract.Reference reference = new Dal_OrderCreateDataContract.Reference();
            reference.Qualifier = 'CustomerPONo';
            reference.Value = orderJson.orderDetails.poNumber ;
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
            salesOrderHeader.CreatedTime = System.now();
            salesOrderHeader.CreatedVia = '';
            salesOrderHeader.DocumentOptions = documentOptions;
            salesOrderHeader.Fulfilment = fulfilment;
            salesOrderHeader.HostSystem = 'SAP';
            salesOrderHeader.JobName = orderJson.orderDetails.jobName;
            //salesOrderHeader.Notes = notes;
            //salesOrderHeader.OrderPlant = '4101';
            salesOrderHeader.References = references;
            salesOrderHeader.RequestedShipDate = System.now() ;
            SalesOrderHeader.SalesOrderType = 'ZSAM';
            //salesOrderHeader.SalesOrderHeaderKey = '';
            //salesOrderHeader.Status = orderheader.Status__c;
            //salesOrderHeader.UpdatedByUser = '';
            //salesOrderHeader.UpdatedByUser_Id_Type = '';
            salesOrderHeader.UpdatedTime = System.now();



            // For ArrayOfSalesOrderLine
            List<Dal_OrderCreateDataContract.SalesOrderLine> salesOrderLineList = new List<Dal_OrderCreateDataContract.SalesOrderLine>();
            Integer count = 1;
            if(orderLines.size()!=null)
            {
                for(Dal_OrderSampleJSON.ProductOrderLines orderLine: orderLines)
                {
                    // For SalesOrderLine
                    Dal_OrderCreateDataContract.Price price = new Dal_OrderCreateDataContract.Price();
                    price.PriceNet_Extended = 10;

                    // For List of SalesOrderLine
                    Dal_OrderCreateDataContract.SalesOrderLine salesOrderLine = new Dal_OrderCreateDataContract.SalesOrderLine();
                    salesOrderLine.CostExtended = 10;
                    salesOrderLine.LastActualShipDate = System.now();
                    salesOrderLine.Material = orderLine.sku;
                    salesOrderLine.Price = price;
                    salesOrderLine.PromisedShipDate = System.now();
                    salesOrderLine.Quantity = orderLine.selectedQuantity;
           //       system.debug('orderline.Requested_Ship_Date__c--'+orderline.Requested_Ship_Date__c);
                    salesOrderLine.RequestedShipDate = System.now();
                    system.debug('salesOrderLine.RequestedShipDate '+salesOrderLine.RequestedShipDate);
                    salesOrderLine.SalesOrderLineNo = count++;
                    // salesOrderLine.SalesOrderLineNo = Integer.valueof(orderLine.productName);
                    //salesOrderLine.SupplyPlant = '4'+locationmap.get(orderline.Source_of_Supply__c);
                    salesOrderLine.SupplyPlant = orderLine.SAP_Plant;//orderline.Source_of_Supply_Number__c;
                    System.debug('Supply plant-->'+orderline.SAP_Plant);
                    salesOrderLine.UOM = orderLine.BaseUOM;
                    salesOrderLine.WeightExtended = orderLine.ExtendedWeight;
                    salesOrderLine.PriceRecord = '';//orderLine.Price_Record__c;
                    //salesOrderLine.WeightUOM = '';

                    salesOrderLineList.add(salesOrderLine);
                    System.debug('salesOrderLine------>'+salesOrderLine);
                }

            }

            Decimal totalWeight = 0;
            totalWeight = Decimal.valueOf(orderJson.cumulativeOrderWeight);

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
            Dal_OrderCreateDataContract.Response response = orderCreate.CreateSalesOrder(request);
            System.debug('RESPONSE ---->'+response);
            System.debug('RESPONSE STATUS---->'+response.Result.Status);
            System.debug('RESPONSE StatusDesc---->'+response.Result.StatusDesc);
            //System.debug('RESPONSE sales Order Number--->'+response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);

            Peak_Response peakResponse = new Peak_Response();

            if(response.Result.Status == 'OK' )
            {
                peakResponse.success = true;
                peakResponse.messages.add(response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);
            }
            else
            {
                peakResponse.success = false;
            }

            System.debug('Status------->'+ peakResponse.success);
            System.debug('Message------->'+ peakResponse.messages);
            return peakResponse;

        }

        // Method to convert a date into required fromat for sending request to webservice
        public static String convertToFormat(Datetime dtValue){
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