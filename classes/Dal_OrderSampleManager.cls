/**
* Created by 7Summits on 8/8/18.
**/
public without sharing class Dal_OrderSampleManager{


    /*
    * Method Name: getOrderSampleSeries
    * Description: Method to get all the Series from Custom Object 'ProductSeriesDivision__c'.
    * @param: None
    * @return List of 'ProductSeriesDivision__c'
    */
    @AuraEnabled
    public static List<ProductSeriesDivision__c> getOrderSampleSeries(){
        System.debug('IN APEX METHOD');
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();

        List<ProductSeriesDivision__c> productSeriesLst = [Select Id,Series__r.Id,Series__r.Name from ProductSeriesDivision__c where Division__r.Code__c  =: selectedAccount.Division__c ORDER BY Series__r.Name ASC ];
        System.debug('productSeriesLst-->'+productSeriesLst);

        if(productSeriesLst.size() > 0) {
            return productSeriesLst;
        }
        else{
            return null;
        }

    }

    /*
    * Method Name: getOrderSampleSeriesProduct
    * Description: Method to get all the ProductColor from Custom Object 'ProductSeriesColor__c'.
    * @param: SeriesId came form above method 'getOrderSampleSeries'.
    * @return List of 'ProductSeriesColor__c'
    */
    @AuraEnabled
    public static List<ColorCode> getOrderSampleSeriesProduct(String SeriesId){

        List<ProductSeriesColor__c> productColor ;
        List<ColorCode> colorCode = new List<ColorCode>();
        if (SeriesId != null) {

            productColor = [SELECT Id, Name,ExternalId__c,Product_Color__r.Name,Product_Color__r.Code__c FROM ProductSeriesColor__c where Product_Series__r.Id =: SeriesId ORDER BY Product_Color__r.Name ASC ];
            for(ProductSeriesColor__c seriesColor : productColor ){
                ColorCode code =new ColorCode(seriesColor);
                colorCode.add(code);
            }
            System.debug('productColor-->'+productColor);
            System.debug('ColorCodeOBJ-->'+colorCode);

        }
        if(productColor.size()>0)
        {
            return colorCode;
        }
        else{
            return null;
        }

    }

    /*
    * Method Name: getProduct
    * Description: Method to get all the Products from Custom Object 'Product2' and send them to front end in Wrapper.
    * @param: List of ColorCode came form above method 'getOrderSampleSeriesProduct'.
    * @return List of Wrapper 'OrderLocationWrapper'
    */
    @AuraEnabled
    public static List<OrderLocationWrapper> getProduct(List<String> ColorCode){

        System.debug('ColorCode-->'+ColorCode);
        // Calling method to get list fo products
        List<Product2> productslst = Dal_SearchProductSkuUtil.searchSampleProducts(ColorCode);

        List<OrderLocationWrapper> orderLocationLst = new List<Dal_OrderSampleManager.OrderLocationWrapper>();
        List<OrderLocationWrapper> orderLocationReturnLst = new List<Dal_OrderSampleManager.OrderLocationWrapper>();
        Set<String> ProductIds = new Set<String>();
        Set<String> Skus = new Set<String>();

        if(productslst != null && productslst.size() > 0 ) {
            for (Product2 products : productslst) {
                ProductIds.add(products.Id);
            }
            System.debug('ProductIds-------->'+ProductIds);

            //Getting Sample Stocking location on tha basis of Product Searched.
            for(SampleStockingLocation__c stockingLocation : [SELECT Id,  Name,  ExternalId__c, Location__c,Location__r.Name,Location__r.Street_Address__c,
                    Location__r.Zip_Code__c,Location__r.Country__c,Location__r.SAP_Plant__c,Product__c,Product__r.Name,Product__r.UOM__c,
                    Product__r.DW_ID__c,Product__r.Base_UoM__c,Product__r.Product_Line__c,Product__r.Color__c,Product__r.Size__c FROM SampleStockingLocation__c where Product__c IN: ProductIds]){



                OrderLocationWrapper locationWrapper = new OrderLocationWrapper(stockingLocation);
                orderLocationLst.add(locationWrapper);

            }
            System.debug('orderLocationLst-------->'+orderLocationLst);

 
            // Calling webservice to get Quantity available
            Dal_GetInventoryLocation getInventory = new Dal_GetInventoryLocation(orderLocationLst);
            List<Dal_GetInventoryLocation.Inventory_Location_Wrapper> inventoryWrapper= getInventory.getLocationWithMaterial();
			System.debug('inventoryWrapper-------->'+inventoryWrapper);
            Set<String> SKUSet = new Set<String>();
            Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper> SKUtoWrapperMap = new map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper>();
            if(inventoryWrapper !=null && inventoryWrapper.size() > 0){
                for(Dal_GetInventoryLocation.Inventory_Location_Wrapper  responseWrapper: inventoryWrapper)
                {
                    SKUtoWrapperMap.put(responseWrapper.SKU, responseWrapper);

                }
                System.debug('Ids---->'+SKUtoWrapperMap.keySet());
                List<String> skusValues = new List<String>(SKUtoWrapperMap.keySet());
                Map<String, Decimal> productConversationFactorMap = getConversationFactor(skusValues);

                for( SampleStockingLocation__c stockingLocation : [SELECT Id,  Name,  ExternalId__c, Location__c,Location__r.Name,Location__r.Street_Address__c,
                        Location__r.Zip_Code__c,Location__r.Country__c,Location__r.SAP_Plant__c,Product__c,Product__r.Name,
                        Product__r.DW_ID__c,Product__r.Color__c,Product__r.Weight__c,Product__r.Base_UoM__c,Product__r.UOM__c,Product__r.Product_Line__c,Product__r.Size__c
                        FROM SampleStockingLocation__c
                        WHERE Product__r.DW_ID__c IN: SKUtoWrapperMap.keySet()
                        ORDER BY Product__r.Color__c,Product__r.Name]){

                    OrderLocationWrapper wrap = new OrderLocationWrapper(stockingLocation,SKUtoWrapperMap.get(stockingLocation.Product__r.DW_ID__c),productConversationFactorMap.get(stockingLocation.Product__r.DW_ID__c));
                    orderLocationReturnLst.add(wrap);

                }

            }
            System.debug('orderLocationReturnLst-- >'+orderLocationReturnLst);
        //    orderLocationReturnLst = sortPrductLst(orderLocationReturnLst);
            return orderLocationReturnLst;
        }
        else{
            return null;
        }

    }

    private static Map<String, Decimal> getConversationFactor(List<String> productSKUs) {
        System.debug('productSKUs' + productSKUs);
        String toUOM;
        String fromUOM;
        Decimal fromFactor;
        Decimal toFactor;
        Decimal conversationFactor;
        Map<String, Decimal> conversionMap = new Map<String, Decimal>();
        for (Product2 product : [
                SELECT Id,Base_UoM__c,UOM__c,Weight__c,DW_ID__c, (Select Id,Name, Denominator__c,Nominator__c from Available_UOMs__r)
                FROM Product2
                where DW_ID__c IN:productSKUs]) {

            List<Available_UOM__c> avaial = new List<Available_UOM__c>(product.Available_UOMs__r);
            if (avaial.size() > 0) {
                System.debug('inif-->');
                toUOM = product.Base_UoM__c;
                if (String.isNotBlank(product.UOM__c)) {
                    if (product.UOM__c.containsIgnoreCase(product.Base_UoM__c)) {
                        fromUOM = product.Base_UoM__c;
                    } else {
                        fromUOM = product.UOM__c.split(';').get(0);
                    }
                }

                for (Available_UOM__c uom : product.Available_UOMs__r) {
                    System.debug('uom.Nominator__c ' + uom.Nominator__c);
                    System.debug('uom.Name ' + uom.Name);
                    System.debug('uom.Denominator__c ' + uom.Denominator__c);
                    if (uom.Name.endsWithIgnoreCase(toUOM)) {
                        toFactor = (uom.Nominator__c / uom.Denominator__c);
                    }

                    if (uom.Name.endsWithIgnoreCase(fromUOM)) {
                        fromFactor = (uom.Nominator__c / uom.Denominator__c);
                    }

                }
                conversationFactor = (fromFactor / toFactor) * product.Weight__c;
                conversionMap.put(product.DW_ID__c, conversationFactor);
            }

        }
        return conversionMap;
    }
    /*
    * Method Name: createSampleOrder
    * Description: Method to get create a Products by deserialize a JSON coming from front end and passingit to webservice class al_OrderSampleCreateManager.
    * @param: JSON data from front end
    * @return OrderWrapper from Dal_OrderProcessController class.
    */
    @AuraEnabled
    public static Dal_OrderProcessController.OrderWrapper createSampleOrder(String wrapperDataForOrder){

        String SalesOrderNumber;
        System.debug('wrapperDataForOrder------------->'+wrapperDataForOrder);
        Dal_OrderSampleJSON orderJson = Dal_OrderSampleJSON.parse(wrapperDataForOrder);

        Peak_Response pr = new Peak_Response();
        pr = Dal_OrderSampleCreateManager.getSampleOrderCreate(orderJson);
        System.debug('order-meassage->'+pr.messages);

        if(pr.messages.size() > 0)
        {
            SalesOrderNumber = pr.messages[0];
        }
        else{
            SalesOrderNumber = null;
        }

        /*System.debug('SalesOrderNumber without trim->'+SalesOrderNumber);
        SalesOrderNumber = (SalesOrderNumber.substring(1, SalesOrderNumber.length()-1));
        System.debug('SalesOrderNumber -->'+SalesOrderNumber);*/
        Dal_OrderProcessController.OrderWrapper Owrapper = Dal_OrderProcessController.getSubmittedOrder(SalesOrderNumber);
        System.debug('Owrapper->'+Owrapper);
        return Owrapper;

    }

    // Wrapper
    public class OrderLocationWrapper {

        @AuraEnabled public  String sourceOfSupply;
        @AuraEnabled public  String Zip;
        @AuraEnabled public  String Country;
        @AuraEnabled public  String SAP_Plant;
        @AuraEnabled public  String productId;
        @AuraEnabled public  String productName;
        @AuraEnabled public  String sku;
        @AuraEnabled public  String availableQty;
        @AuraEnabled public  String OnHandQty;
        @AuraEnabled public  String BaseUOM;
        @AuraEnabled public  List<String> UOM;
        @AuraEnabled public  String color;
        @AuraEnabled public  String ProductLine;
        @AuraEnabled public  Decimal ExtendedWeight;
        @AuraEnabled public  Decimal selectedQuantity;
        @AuraEnabled public  Boolean isAdded;
        @AuraEnabled public  List<Integer> quantityLst;
        @AuraEnabled public  Decimal totalQuantity;
        @AuraEnabled public  Decimal commulativeWeight;
        @AuraEnabled public  String size;


        public OrderLocationWrapper(){

        }

        public OrderLocationWrapper(SampleStockingLocation__c stockingLocation){
            this.sourceOfSupply = stockingLocation.Location__r.Name;
            this.Zip = stockingLocation.Location__r.Zip_Code__c;
            this.Country = stockingLocation.Location__r.Country__c;
            this.SAP_Plant = stockingLocation.Location__r.SAP_Plant__c;
            this.productId = stockingLocation.Product__c;
            this.productName = stockingLocation.Product__r.Name;
            this.sku = stockingLocation.Product__r.DW_ID__c;
            this.BaseUOM = getUOM(stockingLocation);

        }
        public OrderLocationWrapper(SampleStockingLocation__c stockingLocation,Dal_GetInventoryLocation.Inventory_Location_Wrapper  responseWrapper,Decimal productConversationFactor) {
            this.sourceOfSupply = stockingLocation.Location__r.Name;
            this.Zip = stockingLocation.Location__r.Zip_Code__c;
            this.Country = stockingLocation.Location__r.Country__c;
            this.SAP_Plant = responseWrapper.supplyplantID ;
            this.productId = stockingLocation.Product__c;
            this.productName = stockingLocation.Product__r.Name;
            this.sku = responseWrapper.SKU;
            if(Integer.valueOf(Decimal.valueOf(responseWrapper.availableQty)) > 5 ){
                this.quantityLst = new List<Integer>{1,2,3,4,5};
            }
            else{
                List<Integer> val = new List<Integer>();
                for(integer i=1;i<=Integer.valueOf(Decimal.valueOf(responseWrapper.availableQty));i++){
                    val.add(i);
                }
                this.quantityLst = val;
            }
            this.availableQty = responseWrapper.availableQty;
            this.OnHandQty = responseWrapper.OnHandQty;
            this.color = stockingLocation.Product__r.Color__c;
            this.size = stockingLocation.Product__r.Size__c;
            this.BaseUOM = getUOM(stockingLocation);
            this.ExtendedWeight = productConversationFactor;
            this.ProductLine = stockingLocation.Product__r.Product_Line__c;
            this.selectedQuantity = 1;
            this.totalQuantity = 0;
            this.isAdded = false;
        }
    }

    // Getting UOM on basis of SampleStockingLocation
    public static String getUOM(SampleStockingLocation__c stockingLocation )
    {
        String UOM;
            if(String.isNotBlank(stockingLocation.Product__r.UOM__c)) {
                if(stockingLocation.Product__r.UOM__c.containsIgnoreCase(stockingLocation.Product__r.Base_UoM__c)) {
                    UOM = stockingLocation.Product__r.Base_UoM__c;
                } else {
                    UOM = stockingLocation.Product__r.UOM__c.split(';').get(0);
                }
            }
        return UOM;
    }


    public Class ColorCode{
        @AuraEnabled public  String colorName;
        @AuraEnabled public  String colorCode;

        public ColorCode(ProductSeriesColor__c seriesColor){
            this.colorName = seriesColor.Product_Color__r.Name;
            this.colorCode = seriesColor.Product_Color__r.Code__c;
        }
    }



}