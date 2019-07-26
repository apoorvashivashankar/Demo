/**
 * Created by Preshit on 31-01-2019.
 */
@isTest
global class WebServiceMock_SSC_OrderCreate implements WebServiceMock {

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        Test.setMock(WebServiceMock.class, new WebServiceMockDalTaxExemption());

        Dal_OrderCreateDataContract.Contact contact = new Dal_OrderCreateDataContract.Contact();
        contact.EMail = 'test';
        contact.Fax = 'test';
        contact.FirstName = 'test';
        contact.LastName = 'test';
        contact.Phone = '21335456';

        Dal_OrderCreateDataContract.Address address =  new Dal_OrderCreateDataContract.Address();
        address.Name = 'test';
        address.City = 'New York';
        address.StateProvince = 'New York';
        address.Country = 'US';
        address.Line1 = '123 Test';
        address.PostalCode ='12134';

        Dal_OrderCreateDataContract.Account account = new Dal_OrderCreateDataContract.Account();
        account.Address = address;
        account.Contact = contact;
        account.Division ='test';
        account.LegacyCustomer ='test';
        account.SAP_Customer = 'tst';
        account.SalesOrganization ='test';

        Dal_OrderCreateDataContract.ShipToAddress shipToAddress = new Dal_OrderCreateDataContract.ShipToAddress();
        shipToAddress.Address = address;
        shipToAddress.Contact = contact;
        shipToAddress.SameAsAccount = 'test';

        Dal_OrderCreateDataContract.Carrier carrier = new Dal_OrderCreateDataContract.Carrier();
        carrier.CustomerAccountWithCarrier = 'test';
        carrier.SCAC = 'scac';

        Dal_OrderCreateDataContract.Fulfilment fulfilment = new Dal_OrderCreateDataContract.Fulfilment();
        fulfilment.Carrier = carrier;
        fulfilment.ShipToAddress = shipToAddress;
        fulfilment.FreightTerms = 'test';

        Dal_OrderCreateDataContract.Tracking tracking = new Dal_OrderCreateDataContract.Tracking();
        tracking.LastDelivery = 'test';
        tracking.LastShipment = 'test';
        tracking.LastShipment_CarrierSCAC = 'scac';
        tracking.LastTrackingNo = 'lastTest';

        List<Dal_OrderCreateDataContract.Total>totalList = new List<Dal_OrderCreateDataContract.Total>();
        Dal_OrderCreateDataContract.Total total = new Dal_OrderCreateDataContract.Total();
        total.Name = 'test';
        total.Charges = 10;
        total.Collection = 12;
        totalList.add(total);

        Dal_OrderCreateDataContract.ArrayOfTotal arrayOfTotal = new Dal_OrderCreateDataContract.ArrayOfTotal();
        arrayOfTotal.Total = totalList;

        Dal_OrderCreateDataContract.Result result = new Dal_OrderCreateDataContract.Result();
        result.Status = 'OK';
        result.StatusDesc = 'tesst';

        List<Dal_OrderCreateDataContract.Charge> chargeList = new List<Dal_OrderCreateDataContract.Charge>();
        Dal_OrderCreateDataContract.Charge charge = new Dal_OrderCreateDataContract.Charge();
        charge.ChargeDirective = 'test';
        charge.ChargeId = 'test';
        charge.ChargeRate = 23;
        charge.ChargeValue = 12;
        chargeList.add(charge);

        Dal_OrderCreateDataContract.ArrayOfCharge arrayOfCharge = new Dal_OrderCreateDataContract.ArrayOfCharge();
        arrayOfCharge.Charge = chargeList;

        Dal_OrderCreateDataContract.DocumentOptions documentOptions = new Dal_OrderCreateDataContract.DocumentOptions();
        documentOptions.PlantIdentifierType = 'test';
        documentOptions.UOM_CodeSet = 'test';

        Dal_OrderCreateDataContract.Price price = new Dal_OrderCreateDataContract.Price();
        price.DiscountCode = '34';
        price.DiscountCodeApplied = 'etest';
        price.DiscountFactor = 13;
        price.PricingUOM = 'SF';
        price.PriceList_UnitPricingUOM = 13;
        price.PriceNet_Extended = 33;
        price.PriceNet_UnitPricingUOM = 23;

        List<Dal_OrderCreateDataContract.Reference> referenceList = new List<Dal_OrderCreateDataContract.Reference>();
        Dal_OrderCreateDataContract.Reference reference = new Dal_OrderCreateDataContract.Reference();
        reference.Qualifier = 'test';
        reference.Value = 'test';
        reference.ValueLine = 'test';
        reference.ValueText = 'test';
        referenceList.add(reference);

        Dal_OrderCreateDataContract.ArrayOfReference arrayOfReference = new Dal_OrderCreateDataContract.ArrayOfReference();
        arrayOfReference.Reference = referenceList;

        List<Dal_OrderCreateDataContract.ErrorDetail> errorDetailList = new List<Dal_OrderCreateDataContract.ErrorDetail>();
        Dal_OrderCreateDataContract.ErrorDetail errorDetail = new Dal_OrderCreateDataContract.ErrorDetail();
        errorDetail.Qualifier = 'test';
        errorDetail.Sequence = 1;
        errorDetail.Text = 'test';
        errorDetailList.add(errorDetail);

        Dal_OrderCreateDataContract.ArrayOfErrorDetail arrayOfErrorDetail = new Dal_OrderCreateDataContract.ArrayOfErrorDetail();
        arrayOfErrorDetail.ErrorDetail = errorDetailList;

        List<Dal_OrderCreateDataContract.Note>noteList = new List<Dal_OrderCreateDataContract.Note>();
        Dal_OrderCreateDataContract.Note note = new Dal_OrderCreateDataContract.Note();
        note.Qualifier = 'test';
        note.Sequence = 12;
        note.Text = 'text';
        noteList.add(note);

        Dal_OrderCreateDataContract.ArrayOfNote arrayOfNote = new Dal_OrderCreateDataContract.ArrayOfNote();
        arrayOfNote.Note = noteList;

        List<Dal_OrderCreateDataContract.SalesOrderLine> salesOrderLineList = new List<Dal_OrderCreateDataContract.SalesOrderLine>();
        Dal_OrderCreateDataContract.SalesOrderLine salesOrderLine = new Dal_OrderCreateDataContract.SalesOrderLine();
        salesOrderLine.Status = 'OK';
        salesOrderLine.CostExtended = 12;
        salesOrderLine.Fulfilment = fulfilment;
        salesOrderLine.Notes = arrayOfNote;
        salesOrderLine.Price = price;
        salesOrderLine.References =arrayOfReference;
        salesOrderLine.UOM ='SF';
        salesOrderLine.SupplyPlant = '1234';
        salesOrderLine.Status = 'OK';
        salesOrderLine.WeightExtended = 12;
        salesOrderLineList.add(salesOrderLine);

        Dal_OrderCreateDataContract.ArrayOfSalesOrderLine arrayOfSalesOrderLine = new Dal_OrderCreateDataContract.ArrayOfSalesOrderLine();
        arrayOfSalesOrderLine.SalesOrderLine = salesOrderLineList;

        Dal_OrderCreateDataContract.SalesOrderHeader salesOrderHeader = new Dal_OrderCreateDataContract.SalesOrderHeader();
        salesOrderHeader.Account = account;
        salesOrderLine.Charges = arrayOfCharge;
        salesOrderLine.References = arrayOfReference;
        salesOrderHeader.DocumentOptions = documentOptions;
        salesOrderHeader.Fulfilment = fulfilment;
        salesOrderHeader.HostSystem = 'QASIS';
        salesOrderHeader.Notes = arrayOfNote;
        salesOrderHeader.EmailOrder = 'email';
        salesOrderHeader.JobName = 'jobName';

        Dal_OrderCreateDataContract.DalTileSalesOrder dalTileSalesOrder = new Dal_OrderCreateDataContract.DalTileSalesOrder();
        dalTileSalesOrder.SalesOrderHeader = salesOrderHeader;
        dalTileSalesOrder.SalesOrderLines = arrayOfSalesOrderLine;
        dalTileSalesOrder.Totals = arrayOfTotal;

        List<Dal_OrderCreateDataContract.ResponseItem> responseItemList = new List<Dal_OrderCreateDataContract.ResponseItem>();
        Dal_OrderCreateDataContract.ResponseItem responseItem = new Dal_OrderCreateDataContract.ResponseItem();
        responseItem.DalTileSalesOrder = dalTileSalesOrder;
        responseItemList.add(responseItem);

        Dal_OrderCreateDataContract.ArrayOfResponseItem arrayOfResponseItem = new Dal_OrderCreateDataContract.ArrayOfResponseItem();
        arrayOfResponseItem.ResponseItem = responseItemList;

        Dal_OrderCreateDataContract.Response response_x = new Dal_OrderCreateDataContract.Response();
        response_x.ErrorDetails = arrayOfErrorDetail;
        response_x.ResponseItems = arrayOfResponseItem;
        response_x.Result = result;

        Dal_OrderCreateContext.CreateSalesOrderResponse_element responseElement = new Dal_OrderCreateContext.CreateSalesOrderResponse_element();
        responseElement.CreateSalesOrderResult = response_x;

        response.put('response_x',responseElement);


    }

}