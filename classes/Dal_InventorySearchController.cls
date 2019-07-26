/**
 * Created by preshit on 30-10-2018.
 */

public with sharing class Dal_InventorySearchController {

    public static final String STATUS_VALUE = 'Draft';
    public static final String FULLFILLMENT_TYPE = 'Delivery';
    // InventoryWrapper for Inventory header object
    public class InventoryWrapper {

        @AuraEnabled public String sku { get; set; }
        @AuraEnabled public String dateAtSupplyPlant { get; set; }
        @AuraEnabled public String dateAtSupplyPlantFinal { get; set; }
        @AuraEnabled public String supplyPlant { get; set; }
        @AuraEnabled public String supplyPlantId { get; set; }
        @AuraEnabled public String SOS { get; set; }
        @AuraEnabled public String availableQty { get; set; }
        @AuraEnabled public String onTimeFlag { get; set; }
        @AuraEnabled public String extendedWeight { get; set; }
        @AuraEnabled public String OnHandQty { get; set; }
        @AuraEnabled public String totalCartons { get; set; }
        @AuraEnabled public String pricingUOM;
        @AuraEnabled public Decimal pricingUOM_NetPrice;
        @AuraEnabled public Decimal pricingQuantity;
        @AuraEnabled public String accountCreditRiskCategory;
        @AuraEnabled public Decimal energySurCharge;
        @AuraEnabled public Boolean isStoreChanged;
        @AuraEnabled public Integer indexOfChangedStore;
        @AuraEnabled public List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper> milesWrapperList { get; set; }
        @AuraEnabled public List<DT_Cart_Product__c> cartProducts { get; set; }

        public InventoryWrapper() {

        }

    }

    /*
    * Method Name: getProduct
    * Description: Purpose to search for a list of Product2 records with their Product -
    * StockKeepingUnit,Description,and UOM
    * @return productList
    */
    @AuraEnabled
    public static List<Product2> getProduct(String searchParameter, String brand) {
        system.debug('searchParameter_brand' + searchParameter + '---' + brand);

        List<Product2> searchProduct = Dal_SearchProductSkuUtil.searchSizedProducts(null, null, searchParameter, brand);
        system.debug('searchProduct' + searchProduct);
        return searchProduct;
    }
    /*
    * Method Name: getInventoryRecord
    * Description: Method to get all the Inventory from Web Services.
    * @param: None
    * @return List of 'InventoryWrapper'
    */
    @AuraEnabled
    public static List<InventoryWrapper> getInventoryRecord(String data) {
        System.debug('DATA-->' + data);
        Set<String> skuSet = new Set<String>();
        Map<String, Dal_GetInventory_AvailabilityDate.AvailableDate_Wrapper> mapOfAvailabilityWrapper = new Map<String, Dal_GetInventory_AvailabilityDate.AvailableDate_Wrapper>();
        Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper> mapOfLocationWrapper = new Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper>();
        Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper> mapOfPriceWrapper = new Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper>();
        Map<String, List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper>> mapOfMilesWrapper = new Map<String, List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper>>();

        System.debug('DATABf-->' + data);
        List<Dal_InventorySearchJSON> inventoryJson = Dal_InventorySearchJSON.parse(data);
        List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
        cartProductList = getMyCartProducts();
        // for Store Address

        String StoreAddress = getSSCAddress();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        Account acc = [SELECT Id,SSC__r.SAP_Plant__c,CreditRiskCategory__c,CreditRiskCategory__r.RiskCategory__c, ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode FROM Account WHERE Id = :selectedAccount.Id];
        System.debug('CreditRiskCategory' + acc.CreditRiskCategory__c);
        System.debug('CreditRiskCategory' + acc.CreditRiskCategory__r.RiskCategory__c);
        //---------------------------

        for (Dal_InventorySearchJSON jsonData : inventoryJson) {
            skuSet.add(jsonData.sku);
        }

        List<InventoryWrapper> inventoryWrapperList = new List<InventoryWrapper>();
        System.debug('skuSet-->' + skuSet);

            Dal_GetInventory_AvailabilityDate AvailabilityManager = new Dal_GetInventory_AvailabilityDate(inventoryJson);
            List<Dal_GetInventory_AvailabilityDate.AvailableDate_Wrapper> availibilityWrapper = AvailabilityManager.getAvailibilityDate();
            System.debug('AvailibilityWrapperData-->' + availibilityWrapper);
            if (availibilityWrapper != null && availibilityWrapper.size() > 0) {
                for (Dal_GetInventory_AvailabilityDate.AvailableDate_Wrapper dateWrapper : availibilityWrapper) {
                    mapOfAvailabilityWrapper.put(dateWrapper.sku, dateWrapper);
                }
            }

            Dal_GetInventoryLocation locationManager = new Dal_GetInventoryLocation(inventoryJson);
            List<Dal_GetInventoryLocation.Inventory_Location_Wrapper> locationWrapper = locationManager.getLocationWithMaterial();
            System.debug('InventoryWrapperData-->' + locationWrapper);
            if (locationWrapper != null && locationWrapper.size() > 0) {
                for (Dal_GetInventoryLocation.Inventory_Location_Wrapper locateWrapper : locationWrapper) {
                    mapOfLocationWrapper.put(locateWrapper.SKU, locateWrapper);
                }
            }

            Dal_GetPriceManager getPriceManager = new Dal_GetPriceManager(inventoryJson);
            List<Dal_GetPriceManager.Dal_GetPriceWrapper> priceWrapper = getPriceManager.getPrice();
            System.debug('GetPriceWrapperData-->' + priceWrapper);
            if (priceWrapper != null && priceWrapper.size() > 0) {
                for (Dal_GetPriceManager.Dal_GetPriceWrapper priceWrap : priceWrapper) {
                    mapOfPriceWrapper.put(priceWrap.sku, priceWrap);
                }
            }


            Dal_GetInventory_Miles_Manager milesManager = new Dal_GetInventory_Miles_Manager(inventoryJson);
            List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper> milesWrapper = milesManager.getMilesRadius();
            System.debug('MilesWrapperData-->' + milesWrapper);
            List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper> milesInnerWrapper ;
            for (String sku : skuSet) {
                milesInnerWrapper = new List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper>();
                for (Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper mileWrap : milesWrapper) {
                    if (mileWrap.sku == sku) {
                        milesInnerWrapper.add(mileWrap);
                    }
                }
                mapOfMilesWrapper.put(sku, milesInnerWrapper);
            }
            System.debug('MilesWrapperMap-->' + mapOfMilesWrapper);

            /*if(milesWrapper !=null && milesWrapper.size()>0){
            for(Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper milesWrap : milesWrapper){
                mapOfMilesWrapper.put(milesWrap.sku,milesWrap);
            }
        }
*/


            for (String sku : skuSet) {
                System.debug('sku--->' + sku);
                System.debug('skuSet--->' + skuSet);


                InventoryWrapper inventoryWrapper = new InventoryWrapper();
                inventoryWrapper.sku = sku;
                inventoryWrapper.accountCreditRiskCategory = acc.CreditRiskCategory__r.RiskCategory__c;
                if (!mapOfAvailabilityWrapper.isEmpty()) {
                    if (mapOfAvailabilityWrapper.containsKey(sku)) {
                        System.debug('INdateset-->' + mapOfAvailabilityWrapper);
                        Dal_GetInventory_AvailabilityDate.AvailableDate_Wrapper dateWrapper = mapOfAvailabilityWrapper.get(sku);

                        Date dt = Date.valueOf(dateWrapper.dateAtSupplyPlant);
                        Date dt1 = addBussinessDays(dt, 2); //dt.addDays(2);
                        Date dt2 = addBussinessDays(dt1, 5);
                        String startDate = dt1.Year() + '-' + dt1.Month() + '-' + dt1.Day();
                        String finalDate = dt2.Year() + '-' + dt2.Month() + '-' + dt2.Day();
                        System.debug('final--->' + finalDate);
                        inventoryWrapper.dateAtSupplyPlant = startDate;
                        inventoryWrapper.dateAtSupplyPlantFinal = finalDate ;
                        //inventoryWrapper.supplyPlant = dateWrapper.supplyPlant;
                        inventoryWrapper.SOS = dateWrapper.SOS;
                        inventoryWrapper.onTimeFlag = dateWrapper.onTimeFlag ;

                        System.debug('dateWrapper-->' + dateWrapper);
                    }
                }
                if (!mapOfLocationWrapper.isEmpty()) {
                    if (mapOfLocationWrapper.containsKey(sku)) {
                        System.debug('InLocationSet-->' + mapOfLocationWrapper);
                        Dal_GetInventoryLocation.Inventory_Location_Wrapper locateWrapper = mapOfLocationWrapper.get(sku);
                        inventoryWrapper.totalCartons = locateWrapper.totalCartons;
                        inventoryWrapper.availableQty = locateWrapper.availableQty;
                        inventoryWrapper.supplyPlantId = locateWrapper.supplyplantID ;
                        System.debug('locateWrapperset-->' + locateWrapper);
                    }
                }
                if (!mapOfPriceWrapper.isEmpty()) {
                    if (mapOfPriceWrapper.containsKey(sku)) {
                        System.debug('InPriceSet-->' + mapOfPriceWrapper);
                        Dal_GetPriceManager.Dal_GetPriceWrapper priceWrap = mapOfPriceWrapper.get(sku);
                        inventoryWrapper.pricingUOM = priceWrap.pricingUOM;
                        inventoryWrapper.pricingUOM_NetPrice = priceWrap.pricingUOM_NetPrice;
                        inventoryWrapper.energySurCharge = priceWrap.ExtendedEnergySurCharge;
                        inventoryWrapper.pricingQuantity = priceWrap.quantity;
                        System.debug('priceWrapset-->' + priceWrap);
                    }
                }
                if (!mapOfMilesWrapper.isEmpty()) {
                    if (mapOfMilesWrapper.containsKey(sku)) {
                        System.debug('InMilesSet-->' + mapOfMilesWrapper);
                        inventoryWrapper.milesWrapperList = mapOfMilesWrapper.get(sku);
                    }
                }
                inventoryWrapper.supplyPlant = StoreAddress;
                inventoryWrapper.isStoreChanged = false;
                inventoryWrapper.indexOfChangedStore = 0;
                inventoryWrapper.cartProducts = cartProductList;
                inventoryWrapperList.add(inventoryWrapper);

            }
            System.debug('inventoryWrapperList-->' + inventoryWrapperList);

        return inventoryWrapperList;
    }
    /*
    * Method Name: getInventorySeries
    * Description: Method to get all the Series from Custom Object 'ProductSeriesDivision__c'.
    * @param: None
    * @return List of 'ProductSeriesDivision__c'
    */
    @AuraEnabled
    public static List<ProductSeries__c> getInventorySeries(String brand) {
        List<ProductSeries__c> productSeriesLst = Dal_SearchProductSkuUtil.getSeries(brand);
        return productSeriesLst;
    }

    /*
   * Method Name: getInventorySeriesCreate
   * Description: Method to get all the Series from Custom Object 'ProductSeriesDivision__c'.
   * @param: None
   * @return List of 'Dal_SSC_CreateOrderJSON'
   */
    @AuraEnabled
    public static Dal_SSC_CreateOrderJSON getInventorySeriesCreate(String brand) {
        Dal_SSC_CreateOrderJSON productSeries = Dal_SearchProductSkuUtil.getSeriesCreate(brand);
        System.debug('seriesCreate--->' + productSeries);
        return productSeries;
    }


    /*
    * Method Name: getInventoryColorCodes
    * Description: Method to get all the ProductColor from Custom Object 'ProductSeriesColor__c'.
    * @param: SeriesId came form above method 'getOrderSampleSeries' and brand.
    * @return List of 'ProductSeriesColor__c'
    */
    @AuraEnabled
    public static List<Dal_SearchProductSkuUtil.ColorCode> getInventoryColorCodes(String SeriesId, String brand) {
        System.debug('SeriesId--->' + SeriesId);
        List<Dal_SearchProductSkuUtil.ColorCode> colorCodes = Dal_SearchProductSkuUtil.getColors(SeriesId, brand);
        return colorCodes;
    }

    /*
    * Method Name: getProductList
    * Description: Method to get all the Product on basis of ColorCode,brand,quickSearch from Product Object
    * @param: List<String> ColorCode,String brand,String quickSearch
    * @return List of 'Product2'
    */
    @AuraEnabled
    public static List<Product2> getProductList(List<String> ColorCode, String brand, String quickSearch) {
        system.debug('ColorCode' + ColorCode);
        List<Product2> productslst = Dal_SearchProductSkuUtil.searchProductsWithBrand(ColorCode, brand, quickSearch);
        system.debug('productslst' + productslst);
        return productslst;
    }


    /*
    * Method Name: getConversionCalculation
    * Description: Method to get result of converted quuantities from webservice
    * @param: String Material, String ToUOM, String Quantity
    * @return List of 'Dal_ConversionCalculatorManager.CalculatorWrapper'
    */
    @AuraEnabled
    public static List<Dal_ConversionCalculatorManager.CalculatorWrapper> getConversionCalculation(String Material, String ToUOM, String Quantity) {
        Dal_ConversionCalculatorManager dalConversionCal = new Dal_ConversionCalculatorManager(Material, ToUOM, Quantity);
        List<Dal_ConversionCalculatorManager.CalculatorWrapper> calculatorWrappers = dalConversionCal.getConversionResult();
        return calculatorWrappers;
    }

    /*
    * Method Name: getDivision
    * Description: Method to get division number of logged in Contect Account
    * @param: None
    * @return 'String'
    */
    @AuraEnabled
    public static ProfileWrapper getDivision() {
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        System.debug('Division--->' + selectedAccount.Division__c);
        User user = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];

        ProfileWrapper wrapper = new ProfileWrapper(user.Profile.Name,selectedAccount.Division__c);
        return wrapper;

    }

    /*
    * Method Name: getVendors
    * Description: Method to get List of vendor for Installation Product
    * @param: None
    * @return List<Object>
    */
    @AuraEnabled
    public static List<Object> getVendors() {
        List<Object> objList = Dal_SearchProductSkuUtil.searchVendorNames();
        return objList;
    }

    /*
   * Method Name: getSize
   * Description: Method to get List of Size for Branded Product
   * @param: None
   * @return List<Object>
   */
    @AuraEnabled
    public static List<Object> getSize() {
        List<Object> objList = Dal_SearchProductSkuUtil.searchSize();
        return objList;
    }

    /*
  * Method Name: getCountries
  * Description: Method to get List of Country
  * @param: None
  * @return List<Object>
  */
    @AuraEnabled
    public static List<String> getCountries() {
        List<String> objList = new List<String>();
        for (Country__c country : [Select Name FROM Country__c]){
            objList.add(country.Name);
        }
        return objList;
    }

    /*
   * Method Name: vendorProducts
   * Description: Method to search for product combined with vendor and searchParameter.
   * @param: String searchParameter,String vendor
   * @return List of Product2
   */
    @AuraEnabled
    public static List<Product2> vendorProducts(String searchParameter, String vendor) {
        List<Product2> products = Dal_SearchProductSkuUtil.searchVendorProducts(searchParameter, vendor);
        return products;
    }

    /*
  * Method Name: sizedProducts
  * Description: Method to search for product combined with brand,series,color,size and searchParameter.
  * @param: List<String> searchParameter,List<String> size,String quickSearch,String brand
  * @return List of Product2
  */
    @AuraEnabled
    public static List<Product2> sizedProducts(List<String> searchParameter, List<String> size, String quickSearch, String brand) {
        List<Product2> products = Dal_SearchProductSkuUtil.searchSizedProducts(searchParameter, size, quickSearch, brand);
        return products;
    }

    /*
    * Method Name: getMiles
    * Description: Method to get result of inventory within particular miles.
    * @param: String sku, String UOM, String milesRadius
    * @return List of Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper
    */
    @AuraEnabled
    public static List<Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper> getMiles(String sku, String UOM, String milesRadius) {
        Dal_GetInventory_Miles_Manager miles = new Dal_GetInventory_Miles_Manager(sku, UOM, milesRadius);
        return miles.getMilesRadius();
    }

    @AuraEnabled
    public static CartWrapper addToCart(String cartValue) {

        System.debug('cartValue-->' + cartValue);
        List<Dal_SSC_OrderProductCartJSON> orderProduct = Dal_SSC_OrderProductCartJSON.parse(cartValue);
        System.debug('orderProductINt-->' + orderProduct);

        Set<String> plantId = new Set<String>();
        Set<String> Skus = new Set<String>();
        Set<String> supplyPlantIds = new Set<String>();
        Set<String> skusNotEntered = new Set<String>();
        Set<String> insertedIds = new Set<String>();

        Map<String, DT_Cart_Product__c> productSkuMap = new Map<String, DT_Cart_Product__c>();
        Map<String, Id> sscMap = new Map<String, Id>();
        Map<String, String> productIds = new Map<String, String>();
        Map<String, Dal_SSC_OrderProductCartJSON> productCartJSONMap = new Map<String, Dal_SSC_OrderProductCartJSON>();
        Map<String, Dal_SSC_OrderProductCartJSON> productCartSkuJSONMap = new Map<String, Dal_SSC_OrderProductCartJSON>();

        String UserId = UserInfo.getUserId();

        if (orderProduct.size() > 0) {
            for (Dal_SSC_OrderProductCartJSON cartProduct : orderProduct) {
                supplyPlantIds.add(cartProduct.supplyPlantId);
                Skus.add(cartProduct.sku);
                productCartJSONMap.put(cartProduct.supplyPlantId, cartProduct);
                productCartSkuJSONMap.put(cartProduct.sku, cartProduct);
            }
        }

        // Map created with key SKU
        for (Product2 product : [SELECT Id,DW_ID__c FROM Product2 WHERE DW_ID__c IN :Skus]) {
            productIds.put(product.DW_ID__c, product.Id);
        }
        System.debug('productIds-->' + productIds);

        System.debug('supplyPlantIdsFromCart-->' + supplyPlantIds);
        // SSC object record
        for (SSC__c ssc : [SELECT Id,SAP_Plant__c FROM SSC__c WHERE SAP_Plant__c IN :supplyPlantIds]) {
            sscMap.put(ssc.SAP_Plant__c, ssc.Id);
        }
        System.debug('sscMap-->' + sscMap);

        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        Account acc = [SELECT Id,Name,SSC__r.SAP_Plant__c,ShippingStreet,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,Phone FROM Account WHERE Id = :selectedAccount.Id];
        System.debug('SuppluPlantId' + acc.SSC__r.SAP_Plant__c);
        /*User user = [SELECT Id,ContactId FROM User WHERE Id =: UserId];
        Contact con = [SELECT Id,Name,User__c,Phone FROM Contact WHERE Id =:user.ContactId LIMIT 1];*/
        List<DT_Cart__c> cartList = new List<DT_Cart__c>();
        cartList = [SELECT Id,Cart_Account__c FROM DT_Cart__c WHERE User__c=: UserId AND Cart_Account__c =:selectedAccount.Id AND Status__c = :STATUS_VALUE];
        System.debug('cartList-->' + cartList);

        if (cartList.size() > 0 && supplyPlantIds.size() > 0) {

            Set<String> presentSku = new Set<String>();
            // Query on Cart product
            List<DT_Cart_Product__c> cartproductLst = [
                    SELECT Id,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c,Name, DT_Cart__c,DT_Cart__r.User__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,
                            Shipping_Name__c,Shipping_Country__c,Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c, Unit__c, Quantity__c,
                            Quantity_Measure__c,Energy_Surcharge__c,Available_UOM__c, Total_Amount__c,SSC__r.SSC_Phone_Number__c
                    FROM DT_Cart_Product__c
                    WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND DT_Cart__r.Cart_Account__c =:selectedAccount.Id
            ];
            if (cartproductLst.size() > 0) {
                for (DT_Cart_Product__c cartproduct : cartproductLst) {
                    presentSku.add(cartproduct.Product__r.DW_ID__c);
                    plantId.add(cartproduct.SSC__r.SAP_Plant__c);
                    productSkuMap.put(cartproduct.Product__r.DW_ID__c, cartproduct);
                }
                System.debug('productSkuMap-->' + productSkuMap);
                System.debug('plantId-->' + plantId);
            }


            List<DT_Cart_Product__c> productsList = new List<DT_Cart_Product__c>();

            for (Dal_SSC_OrderProductCartJSON cartJson : orderProduct) {

                if (plantId.size() == 2) {

                    System.debug('supplyPlantId-->' + cartJson.supplyPlantId);
                    if (plantId.contains(cartJson.supplyPlantId)) {
                        System.debug('size2');
                        DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
                        cartProduct.DT_Cart__c = cartList[0].Id;
                        cartProduct.Fulfillment_Method__c = FULLFILLMENT_TYPE;
                        cartProduct.Shipping_Name__c = acc.Name;
                        cartProduct.Shipping_Street__c = acc.ShippingStreet;
                        cartProduct.Shipping_City__c = acc.ShippingCity;
                        cartProduct.Shipping_State__c = acc.ShippingState;
                        cartProduct.Shipping_Country__c = acc.ShippingCountry;
                        cartProduct.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
                        cartProduct.Lift_gate__c = false;
                        cartProduct.Product__c = productIds.get(cartJson.sku);
                        cartProduct.Quantity__c = cartJson.updatedQuantity;
                        cartProduct.SSC__c = sscMap.get(cartJson.supplyPlantId);
                        cartProduct.Total_Amount__c = 1;
                        cartProduct.Unit__c = cartJson.pricingUOM_NetPrice;
                        cartProduct.UOM__c = cartJson.updatedBaseUOM;
                        cartProduct.Energy_Surcharge__c = cartJson.energySurCharge;
                        //  cartProduct.Quantity_Measure__c = cartJson.BaseUOM;
                        if (cartJson.uomList.size() > 0) {
                            for (String str : cartJson.uomList) {
                                cartProduct.Available_UOM__c += str + ',' ;
                            }
                            // remove last additional comma from string
                            cartProduct.Available_UOM__c = cartProduct.Available_UOM__c.subString(0, cartProduct.Available_UOM__c.length() - 1);
                        }
                        productsList.add(cartProduct);


                    } else {
                        skusNotEntered.add(cartJson.sku);
                    }
				
                } else {
                    System.debug('Notsize2');
                    DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
                    cartProduct.DT_Cart__c = cartList[0].Id;
                    cartProduct.Fulfillment_Method__c = FULLFILLMENT_TYPE;
                    cartProduct.Shipping_Name__c = acc.Name;
                    cartProduct.Shipping_Street__c = acc.ShippingStreet;
                    cartProduct.Shipping_City__c = acc.ShippingCity;
                    cartProduct.Shipping_State__c = acc.ShippingState;
                    cartProduct.Shipping_Country__c = acc.ShippingCountry;
                    cartProduct.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
                    cartProduct.Lift_gate__c = false;
                    cartProduct.Product__c = productIds.get(cartJson.sku);
                    cartProduct.Quantity__c = cartJson.updatedQuantity;
                    cartProduct.SSC__c = sscMap.get(cartJson.supplyPlantId);
                    cartProduct.Total_Amount__c = 1;
                    cartProduct.Unit__c = cartJson.pricingUOM_NetPrice;
                    cartProduct.UOM__c = cartJson.updatedBaseUOM;
                    cartProduct.Energy_Surcharge__c = cartJson.energySurCharge;
                    if (cartJson.uomList.size() > 0) {
                        for (String str : cartJson.uomList) {
                            cartProduct.Available_UOM__c += str + ',' ;
                        }
                        // remove last additional comma from string
                        cartProduct.Available_UOM__c = cartProduct.Available_UOM__c.subString(0, cartProduct.Available_UOM__c.length() - 1);
                    }
                    productsList.add(cartProduct);
                    plantId.add(cartJson.supplyPlantId);
                }

            }
            insert productsList;

            for (DT_Cart_Product__c cartProduct : productsList) {
                insertedIds.add(cartProduct.Id);
            }
            productsList = [
                    SELECT Id,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c,Name, DT_Cart__c,DT_Cart__r.User__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,
                            Shipping_Name__c,Shipping_Country__c,Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c, Unit__c, Quantity__c,
                            Quantity_Measure__c,Energy_Surcharge__c,Available_UOM__c, Total_Amount__c,SSC__r.SSC_Phone_Number__c
                    FROM DT_Cart_Product__c
                    WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND Id IN:insertedIds AND DT_Cart__r.Cart_Account__c =:selectedAccount.Id
            ];

            CartWrapper cartWrapper = new CartWrapper(productsList, skusNotEntered);
            System.debug('cartWrapper_inif---->' + cartWrapper);
            return cartWrapper;

        } else if (supplyPlantIds.size() > 0) {

            System.debug('NewRecordfromScracth-->');
            DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = '';
            cartObj.Contact_Number__c = '';
            cartObj.Job_Name__c = '';
            cartObj.Job_Name_Certificate_Id__c = '';
            cartObj.Job_Name_Expiration__c = System.now();
            cartObj.Cart_Account__c = acc.Id;
            cartObj.National_Account__c = null;
            cartObj.Special_Instructions__c = '';
            cartObj.Status__c = STATUS_VALUE;
            cartObj.User__c = UserId;
            insert cartObj;

            List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
            Set<String> intialPlantId = new Set<String>();
            Set<String> skusEntered = new Set<String>();
            for (Product2 product : [SELECT Id,DW_ID__c FROM Product2 WHERE DW_ID__c IN :Skus]) {

                if (intialPlantId.size() > 2) {
                    break;
                }
                System.debug('product_to_enter----->' + product);
                DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
                cartProduct.DT_Cart__c = cartObj.Id;
                cartProduct.Fulfillment_Method__c = FULLFILLMENT_TYPE;
                cartProduct.Shipping_Name__c = acc.Name;
                cartProduct.Shipping_Street__c = acc.ShippingStreet;
                cartProduct.Shipping_City__c = acc.ShippingCity;
                cartProduct.Shipping_State__c = acc.ShippingState;
                cartProduct.Shipping_Country__c = acc.ShippingCountry;
                cartProduct.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
                cartProduct.Lift_gate__c = false;
                cartProduct.Product__c = product.Id;
                cartProduct.Quantity__c = productCartSkuJSONMap.get(product.DW_ID__c).updatedQuantity;
                cartProduct.SSC__c = sscMap.get(productCartSkuJSONMap.get(product.DW_ID__c).supplyPlantId);
                cartProduct.Total_Amount__c = 1;
                cartProduct.Unit__c = productCartSkuJSONMap.get(product.DW_ID__c).pricingUOM_NetPrice;
                cartProduct.UOM__c = productCartSkuJSONMap.get(product.DW_ID__c).updatedBaseUOM;
                cartProduct.Energy_Surcharge__c = productCartSkuJSONMap.get(product.DW_ID__c).energySurCharge;

                if (productCartSkuJSONMap.get(product.DW_ID__c).uomList.size() > 0) {
                    for (String str : productCartSkuJSONMap.get(product.DW_ID__c).uomList) {
                        cartProduct.Available_UOM__c += str + ',' ;
                    }
                    // remove last additional comma from string
                    cartProduct.Available_UOM__c = cartProduct.Available_UOM__c.subString(0, cartProduct.Available_UOM__c.length() - 1);
                }


                cartProductList.add(cartProduct);
                intialPlantId.add(productCartSkuJSONMap.get(product.DW_ID__c).supplyPlantId);
                skusEntered.add(product.DW_ID__c);

            }
            insert cartProductList;

            for (String s : Skus) {
                if (!skusEntered.contains(s)) {
                    skusNotEntered.add(s);
                }
            }

            for (DT_Cart_Product__c cartProduct : cartProductList) {
                insertedIds.add(cartProduct.Id);
            }
            cartProductList = [
                    SELECT Id,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c,Name, DT_Cart__c,DT_Cart__r.User__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,
                            Shipping_Name__c,Shipping_Country__c,Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c, Unit__c, Quantity__c,
                            Quantity_Measure__c,Energy_Surcharge__c,Available_UOM__c, Total_Amount__c,SSC__r.SSC_Phone_Number__c
                    FROM DT_Cart_Product__c
                    WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND Id IN:insertedIds AND DT_Cart__r.Cart_Account__c =:selectedAccount.Id
            ];

            CartWrapper cartWrapper = new CartWrapper(cartProductList, skusNotEntered);
            System.debug('cartWrapper_inelse----->' + cartWrapper);
            return cartWrapper;
        } else {
            CartWrapper cartWrapper = new CartWrapper();
            return cartWrapper;
        }


    }

    /*
    * Method Name: addBussinessDays
    * Description: Customize formulla to get buisness days with below two more methods holidays() and checkifItisWorkingDay()
    * @param: Date startDate, Integer iDays
    * @return List of Dal_GetInventory_Miles_Manager.Inventory_Miles_Wrapper
    */
    public static Date addBussinessDays(Date startDate, Integer iDays) {
        Integer businessDaysAdded = 0;
        Date currentDate = startDate;
        while (businessDaysAdded < iDays) {
            currentDate = currentDate.addDays(1);
            Datetime d = datetime.newInstance(currentDate.year(), currentDate.month(), currentDate.day());

            if (d.format('E') != 'Sat' && d.format('E') != 'Sun' && checkifItisWorkingDay(currentDate)) {
                // it's a business day, so add 1 to the counter that works towards the amount of days to add
                businessDaysAdded = businessDaysAdded + 1;
            }
        }
        return currentDate;
    }

    public static List<Holiday> holidays {
        get {
            if (holidays == null)
                holidays = [Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
            return holidays;
        }
        private set;
    }

    public static boolean checkifItisWorkingDay(Date currentDate) {
        Date weekStart = currentDate.toStartofWeek();
        for (Holiday hDay : holidays) {
            if (currentDate.daysBetween(hDay.ActivityDate) == 0) {
                return false;
            }
        }
        if (weekStart.daysBetween(currentDate) == 0 || weekStart.daysBetween(currentDate) == 6) {
            return false;
        } else
                return true;
    }

    public static String getSSCAddress() {
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        Account acc = [SELECT Id,SSC__r.SAP_Plant__c FROM Account WHERE Id = :selectedAccount.Id];
        System.debug('acc--availibility-' + acc.SSC__r.SAP_Plant__c);
        String StoreAddress;
        List<SSC__c> ssc = [
                SELECT Name,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c,SAP_Plant__c
                FROM SSC__c
                WHERE SAP_Plant__c = :acc.SSC__r.SAP_Plant__c
        ];
        if (ssc.size() > 0) {
            StoreAddress = ssc[0].Name != null ? ssc[0].Name : '' + ' ' + ssc[0].Street_Address__c != null ? ssc[0].Street_Address__c : '' + ' ' + ssc[0].City__c != null ? ssc[0].City__c : '' + ' ' + ssc[0].State__c != null ? ssc[0].State__c : '' + ' ' + ssc[0].Country__c != null ? ssc[0].Country__c : '' + ' ' + ssc[0].Zip_Code__c != null ? ssc[0].Zip_Code__c : '' ;
        } else {
            StoreAddress = null;
        }
        return StoreAddress;
    }

    @AuraEnabled
    public static CartDetailWrapper getCartProducts() {
        List<DT_Cart__c> cartList = new List<DT_Cart__c>();
        List<DT_Cart_Product__c> cartProductLst = new List<DT_Cart_Product__c>();
        Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper> inventorySkuMap = new Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper>();
        Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper> priceSkuMap = new Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper>();
        Set<String> unavailavbleSkus = new Set<String>();
        List<CartReviewWrapper> cartReviewWrapperlist = new List<CartReviewWrapper>();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        try {
            String UserId = UserInfo.getUserId();
            cartList = [
                    SELECT Id, Name, User__c, Special_Instructions__c, Job_Name__c,National_Account__c,
                            Contact_Name__c, Contact_Number__c, Status__c,Cart_Account__c
                    FROM DT_Cart__c
                    WHERE Status__c = :STATUS_VALUE AND User__c = :UserId AND Cart_Account__c =:selectedAccount.Id
            ];
            if (cartList.size() > 0) {

                cartProductLst = [
                        SELECT Id,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c,Name, DT_Cart__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,
                                Shipping_Name__c,Shipping_Country__c,Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c,
                                Unit__c, Quantity__c,Energy_Surcharge__c,Available_UOM__c, Quantity_Measure__c, Total_Amount__c,SSC__r.SSC_Phone_Number__c
                        FROM DT_Cart_Product__c
                        WHERE DT_Cart__c = :cartList[0].Id
                ];


                if (cartProductLst.size() > 0) {

                    //Inventory API Call and map created with key SKU
                    Dal_GetInventoryLocation inventory = new Dal_GetInventoryLocation(cartproductLst);
                    List<Dal_GetInventoryLocation.Inventory_Location_Wrapper> inventoryLocationWrappers = inventory.getLocationWithMaterial();
                    if (inventoryLocationWrappers.size() > 0) {
                        for (Dal_GetInventoryLocation.Inventory_Location_Wrapper loactionWrap : inventoryLocationWrappers) {
                            inventorySkuMap.put(loactionWrap.SKU, loactionWrap);
                        }
                        System.debug('inventorySkuMap-->' + inventorySkuMap);
                    }

                    // Get Price Call
                    Dal_GetPriceManager getPriceManager = new Dal_GetPriceManager(cartproductLst);
                    List<Dal_GetPriceManager.Dal_GetPriceWrapper> priceWrapper = getPriceManager.getPrice();
                    System.debug('GetPriceWrapperData-->' + priceWrapper);
                    if (priceWrapper.size() > 0) {
                        for (Dal_GetPriceManager.Dal_GetPriceWrapper priceWrap : priceWrapper) {
                            priceSkuMap.put(priceWrap.sku, priceWrap);
                        }
                        System.debug('priceSkuMap-->' + priceSkuMap);
                    }

                    for (DT_Cart_Product__c cartproduct : cartproductLst) {
                        CartReviewWrapper cartReviewWrapper = new CartReviewWrapper(cartproduct, cartList, inventorySkuMap,priceSkuMap);
                        cartReviewWrapperlist.add(cartReviewWrapper);
                    }
                }
            }
        } catch (Exception exp) {
            System.debug('cartProductLst : An unexpected error has occurred: ' + exp.getMessage());
        }
        CartDetailWrapper cartDetailWrapper = new CartDetailWrapper(cartReviewWrapperlist);
        System.debug('cartDetailWrapper-->' + cartDetailWrapper);
        return cartDetailWrapper;
    }

    @AuraEnabled
    public static List<DT_Cart_Product__c> getMyCartProducts() {
        List<DT_Cart_Product__c> cartProductLst = new List<DT_Cart_Product__c>();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        try {
            String UserId = UserInfo.getUserId();
            cartProductLst = [
                    SELECT Id,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c, Name, DT_Cart__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,
                            Shipping_Name__c,Shipping_Country__c,Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c,
                            Unit__c, Quantity__c,Energy_Surcharge__c,Available_UOM__c, Quantity_Measure__c, Total_Amount__c,SSC__r.SSC_Phone_Number__c
                    FROM DT_Cart_Product__c
                    WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND DT_Cart__r.Cart_Account__c =:selectedAccount.Id
            ];
        } catch (Exception exp) {
            System.debug('cartProductLst : An unexpected error has occurred: ' + exp.getMessage());
        }
        System.debug('getMyCartProducts-->' + cartProductLst);
        return cartProductLst;
    }


    @AuraEnabled
    public static void deleteProduct(String productId) {
        
        String UserId = UserInfo.getUserId();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        
        if (!String.isEmpty(productId)) {
            DT_Cart_Product__c cartProduct = [SELECT Id FROM DT_Cart_Product__c WHERE Id = :productId];
            if (cartProduct != null){
                delete cartProduct;
            }

        }
        DT_Cart__c cart = [SELECT Id,Cart_Account__c FROM DT_Cart__c WHERE User__c =: UserId AND Cart_Account__c =: selectedAccount.Id];
        Integer cartCount = [SELECT Count() FROM DT_Cart_Product__c WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND DT_Cart__r.Cart_Account__c =: selectedAccount.Id];
        if(cartCount < 1){
            delete cart;
        }
    }

  

    @AuraEnabled
    public static Dal_Address_Validation_Controller.ReturnAddress getAddress(String companyName, String lineOne, String state, String city, String country, String code) {
        String lineTwo;
        Dal_Address_Validation_Controller.ReturnAddress orderAddress = Dal_ShipToAddressOverrideManager.getValidatedAddress(lineOne, lineTwo, state, city, code, country);
        return orderAddress;
    }

    @AuraEnabled
    public static List<Dal_TaxExemptionManager.TaxExemption_Wrapper> getTaxExemption() {
        //getting customer id from utility class 'Dal_BaseController'
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        String customerId = selectedAccount.DW_ID__c;
        //String customerId = '207305001';
        system.debug('--customerId--' + customerId);
        Dal_TaxExemptionManager taxManager = new Dal_TaxExemptionManager(customerId);
        List<Dal_TaxExemptionManager.TaxExemption_Wrapper> taxExemptionWrapperList = taxManager.getTaxExemption();
        System.debug('--taxExemptionWrapperList---' + taxExemptionWrapperList);
        return taxExemptionWrapperList;
    }
    @AuraEnabled
    public static DT_Cart__c saveCheckoutDetail(String checkoutDetail) {
        System.debug('---checkoutDetail--' + checkoutDetail);

        Dal_SSC_UpdatedCartJSON updateCart = Dal_SSC_UpdatedCartJSON.parse(checkoutDetail);
        List<DT_Cart__c> dtCartList = new List<DT_Cart__c>();
        List<DT_Cart__c> cartList = [
                SELECT Id, Name, User__c, Special_Instructions__c, Job_Name__c,National_Account__c,
                        Contact_Name__c, Contact_Number__c,Tax_Exempt__c, Status__c
                FROM DT_Cart__c
                WHERE Status__c = :STATUS_VALUE AND ID = :updateCart.ID
        ];
        System.debug('cartList---' + cartList);
        if (cartList.size() > 0) {
            for (DT_Cart__c dtCart : cartList) {
                dtCart.Job_Name__c = updateCart.jobName;
                if(updateCart.nationalAccountIdNew != null && updateCart.nationalAccountIdNew != ''){
                    dtCart.National_Account__c = updateCart.nationalAccountIdNew;
                }else{
                    dtCart.National_Account__c = null;
                }
                //dtCart.National_Account__c = updateCart.nationalAccountIdNew;
                dtCart.Contact_Name__c = updateCart.contactName;
                dtCart.Tax_Exempt__c = updateCart.taxExempt;
                dtCart.Contact_Number__c = updateCart.contactNumber;
                dtCart.Special_Instructions__c = updateCart.specialInstruction;
                dtCart.PO__c = updateCart.po;
                dtCart.Job_Name_Certificate_Id__c = updateCart.certificateId ;
                dtCart.Job_Name_Expiration__c = updateCart.expirationDate ;
                dtCartList.add(dtCart);
            }
        }
        System.debug('dtCartList---' + dtCartList);
        if (dtCartList.size() > 0) {
            update dtCartList;
        }
        return dtCartList[0];
    }

    @AuraEnabled
    public static CartWrapper getCheckoutCart(String updateCartDetail) {
        System.debug('---updateCartDetail--' + updateCartDetail);

        List<Dal_SSC_UpdatedCartProductJSON> updateCartProductList = Dal_SSC_UpdatedCartProductJSON.parse(updateCartDetail);
        Set<Id> cartProductIds = new Set<Id>();
        List<DT_Cart_Product__c>cartProductList = new List<DT_Cart_Product__c>();
        Map<String, Dal_SSC_UpdatedCartProductJSON> cartProductJSONMap = new Map<String, Dal_SSC_UpdatedCartProductJSON>();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        CartWrapper cartWrapper;
        if (updateCartProductList.size() > 0) {
            for (Dal_SSC_UpdatedCartProductJSON cartProduct : updateCartProductList) {
                cartProductIds.add(cartProduct.productId);
                cartProductJSONMap.put(cartProduct.productId, cartProduct);
            }
        }
        System.debug('updateCartProductList---' + updateCartProductList);
        System.debug('cartProductIds---' + cartProductIds);
        System.debug('cartProductJSONMap---' + cartProductJSONMap);

        try {
            for (DT_Cart_Product__c cartProduct : [
                    SELECT Id,Fulfillment_Method__c, Lift_gate__c, UOM__c, Unit__c, Quantity__c,Energy_Surcharge__c, Quantity_Measure__c, Total_Amount__c
                    FROM DT_Cart_Product__c
                    WHERE Id IN :cartProductIds
            ]) {
                cartProduct.Quantity__c = Decimal.valueOf(cartProductJSONMap.get(cartProduct.Id).updatedQuantity);
                cartProduct.UOM__c = cartProductJSONMap.get(cartProduct.Id).UOM;
                cartProduct.Fulfillment_Method__c = cartProductJSONMap.get(cartProduct.Id).fulfillmentType;
                cartProduct.Lift_gate__c = cartProductJSONMap.get(cartProduct.Id).liftGate;
                cartProduct.Shipping_Name__c = cartProductJSONMap.get(cartProduct.Id).shippingName;
                cartProduct.Shipping_City__c = cartProductJSONMap.get(cartProduct.Id).shippingCity;
                cartProduct.Shipping_State__c = cartProductJSONMap.get(cartProduct.Id).shippingState;
                cartProduct.Shipping_Street__c = cartProductJSONMap.get(cartProduct.Id).shippingStreet;
                cartProduct.Shipping_Country__c = cartProductJSONMap.get(cartProduct.Id).shippingCountry;
                cartProduct.Shipping_ZIP_Code__c = cartProductJSONMap.get(cartProduct.Id).shippingZIPCode;
                cartProductList.add(cartProduct);
            }
            System.debug('cartProductList---' + cartProductList);
            if (cartProductList.size() > 0) {
                update cartProductList;
            }


            String UserId = UserInfo.getUserId();
            List<DT_Cart__c> cartList = [
                    SELECT Id, Name, User__c, Special_Instructions__c, Job_Name__c,National_Account__c,National_Account__r.Name,
                            Contact_Name__c, Contact_Number__c,Tax_Exempt__c, Status__c,PO__c
                    FROM DT_Cart__c
                    WHERE Status__c = :STATUS_VALUE AND User__c = :UserId AND Cart_Account__c =:selectedAccount.Id
            ];
            RecordType rt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'National_Account'];

            cartWrapper = new CartWrapper(cartList[0], rt.Id,selectedAccount);

            System.debug('cartList----' + cartList);
            System.debug('cartWrapper----' + cartWrapper);
        } catch (Exception exp) {
            System.debug('cartWrapper : An unexpected error has occurred: ' + exp.getMessage());
        }
        return cartWrapper;
    }

    @AuraEnabled
    public static Account getAccountName(String accountId){
        try{
            Account acc = [SELECT Id,Name FROM Account WHERE Id = :accountId];
            if(acc != null){
                System.debug('Account '+acc);
                return acc;
            }
            return null;
        }
        catch(Exception ex){
            System.debug('Exception occured'+ex.getMessage());
            return null;
        }
    }


    @AuraEnabled
    public static List<Peak_Response> placeOrder() {

        String UserId = UserInfo.getUserId();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        system.debug('selectedAccount--'+selectedAccount);
        DT_Cart__c cart = [SELECT Id FROM DT_Cart__c WHERE Status__c = :STATUS_VALUE AND User__c = :UserId AND Cart_Account__c =:selectedAccount.Id LIMIT 1];
        DAl_SSC_OrderCreateManager sscOrderCreate = new DAl_SSC_OrderCreateManager(cart.Id);
        List<Peak_Response> response = sscOrderCreate.getOrderCreate();
        //System.debug('--'+response[0].Dal_OrderCreateDataContract.Result())
        if(!Test.isRunningTest()){
            if(response[0].success == true ){
                delete cart;
            }
        }
        return response;
    }

    @AuraEnabled
    public static List<Dal_GetPriceManager.Dal_GetPriceWrapper> getMyCartPriceData(String material,String pricedQuantity,String pricedQuantityUOM,String supplyPlant){
        System.debug('material---'+material);
        String pricerecord='';
        Dal_GetPriceManager priceManager;
        List<Dal_GetPriceManager.Dal_GetPriceWrapper> priceWrapper;
        try{
            if(pricedQuantity == '0'){
                pricedQuantity = '1';
            }
             priceManager = new Dal_GetPriceManager(material,pricedQuantity,pricedQuantityUOM,supplyPlant,pricerecord);
             priceWrapper = priceManager.getPrice();
             System.debug('GetPriceWrapperData-->' + priceWrapper);
            if (priceWrapper != null && priceWrapper.size() > 0) {
                return priceWrapper;
            }
        }catch (Exception exp) {
            System.debug('GetPriceWrapperData : An unexpected error has occurred: ' + exp.getMessage());
        }

        return priceWrapper;

    }


    public class CartWrapper {
        @AuraEnabled public List<DT_Cart_Product__c> cartproductLst;
        @AuraEnabled public List<String> notEntered;

        @AuraEnabled public String Id;
        @AuraEnabled public String contactName;
        @AuraEnabled public String contactNumber;
        @AuraEnabled public String jobName;
        @AuraEnabled public String specialInstruction;
        @AuraEnabled public Boolean taxExempt;
        @AuraEnabled public String nationalAccountId;
        @AuraEnabled public String nationalAccountName;
        @AuraEnabled public String nationalAccountIdNew;
        @AuraEnabled public String nationalAccountNameNew;
        @AuraEnabled public String status;
        @AuraEnabled public String po;
        @AuraEnabled public Id recordTypeId;
        @AuraEnabled public Boolean isPoRequired;
        @AuraEnabled public Boolean isJobNameRequired;


        public CartWrapper() {

        }
        public CartWrapper(DT_Cart__c dtCart, Id AccountRecordTypeId, Account selectedAccount) {

            this.Id = dtCart.Id;
            this.contactName = dtCart.Contact_Name__c;
            this.contactNumber = dtCart.Contact_Number__c;
            this.jobName = dtCart.Job_Name__c;
            this.taxExempt = dtCart.Tax_Exempt__c;
            this.status = dtCart.Status__c;
            this.po = dtCart.PO__c;
            this.specialInstruction = dtCart.Special_Instructions__c;
            this.nationalAccountName = dtCart.National_Account__r.Name;
            this.nationalAccountNameNew = dtCart.National_Account__r.Name;
            this.nationalAccountId = dtCart.National_Account__c;
            this.nationalAccountIdNew = dtCart.National_Account__c;
            this.recordTypeId = AccountRecordTypeId;
            this.isJobNameRequired = selectedAccount.Job_Name_Required__c;
            this.isPoRequired = selectedAccount.PO_Required__c;
        }
        public CartWrapper(List<DT_Cart_Product__c> cartproductLst, Set<String> notEntered) {

            this.notEntered = new List<String>();
            this.cartproductLst = cartproductLst;

            if (notEntered.size() > 0) {
                this.notEntered.addAll(notEntered);
            }

        }
    }

    public class CartDetailWrapper {
        @AuraEnabled public List<CartReviewWrapper> cartReviewWrapperlist;
        @AuraEnabled public Boolean isDelivery;
        @AuraEnabled public Boolean isPickUp;
        @AuraEnabled public Boolean isLiftGateRequired;
        @AuraEnabled public String updatedDeliveryLocation ;

        public CartDetailWrapper(List<CartReviewWrapper> cartReviewWrapperlist) {
            this.cartReviewWrapperlist = cartReviewWrapperlist;
            isDelivery = true;
            isPickUp = false;
            isLiftGateRequired = true;
            updatedDeliveryLocation = '';
        }
    }

    public class CartReviewWrapper {

        @AuraEnabled public List<DT_Cart__c> cartLst;
        @AuraEnabled public String productId;
        @AuraEnabled public String supplyPlantId;
        @AuraEnabled public String supplyPlantName;
        @AuraEnabled public String supplyPlantStreet_Address;
        @AuraEnabled public String supplyPlantState;
        @AuraEnabled public String supplyPlantCity;
        @AuraEnabled public String supplyPlantCountry;
        @AuraEnabled public String supplyPlantZip_Code;
        @AuraEnabled public String Name;
        @AuraEnabled public String productName;
        @AuraEnabled public String productSKU;
        @AuraEnabled public String baseUOM;
        @AuraEnabled public String availableUOM;
        @AuraEnabled public String shippingName;
        @AuraEnabled public String shippingStreet;
        @AuraEnabled public String shippingCity;
        @AuraEnabled public String shippingState;
        @AuraEnabled public String shippingCountry;
        @AuraEnabled public String shippingZIPCode;
        @AuraEnabled public String cartId;
        @AuraEnabled public String fulfillmentType;
        @AuraEnabled public Boolean liftGate;
        @AuraEnabled public String UOM;
        @AuraEnabled public String totalCarton;
        @AuraEnabled public Decimal unit;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public String availableQuantity;
        @AuraEnabled public Decimal energySurcharge;
        @AuraEnabled public Boolean isDelivery = true;
        @AuraEnabled public Boolean isPickUp = false;
        @AuraEnabled public Decimal totalSingleLineQuantity;
        @AuraEnabled public String supplyPlantPhone;


        public CartReviewWrapper(DT_Cart_Product__c cartproduct, List<DT_Cart__c> cartLst, Map<String, Dal_GetInventoryLocation.Inventory_Location_Wrapper> inventorySkuMap,Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper> priceSkuMap) {

            this.cartLst = cartLst;
            if (inventorySkuMap.containsKey(cartproduct.Product__r.DW_ID__c)) {
                Dal_GetInventoryLocation.Inventory_Location_Wrapper wrap = inventorySkuMap.get(cartproduct.Product__r.DW_ID__c);
                availableQuantity = wrap.availableQty;
                totalCarton = wrap.totalCartons;
            } else {
                availableQuantity = '';
                totalCarton = '';
            }
            productId = String.isEmpty(cartproduct.Id) ? '' : cartproduct.Id;
            supplyPlantId = String.isEmpty(cartproduct.SSC__r.SAP_Plant__c) ? '' : cartproduct.SSC__r.SAP_Plant__c;
            supplyPlantName = String.isEmpty(cartproduct.SSC__r.Name) ? '' : cartproduct.SSC__r.Name;
            supplyPlantStreet_Address = String.isEmpty(cartproduct.SSC__r.Street_Address__c) ? '' : cartproduct.SSC__r.Street_Address__c;
            supplyPlantState = String.isEmpty(cartproduct.SSC__r.State__c) ? '' : cartproduct.SSC__r.State__c ;
            supplyPlantCity = String.isEmpty(cartproduct.SSC__r.City__c) ? '' : cartproduct.SSC__r.City__c;
            supplyPlantCountry = String.isEmpty(cartproduct.SSC__r.Country__c) ? '' : cartproduct.SSC__r.Country__c;
            supplyPlantZip_Code = String.isEmpty(cartproduct.SSC__r.Zip_Code__c) ? '' : cartproduct.SSC__r.Zip_Code__c;
            supplyPlantPhone = String.isEmpty(cartproduct.SSC__r.SSC_Phone_Number__c) ? '' : cartproduct.SSC__r.SSC_Phone_Number__c;
            productName = String.isEmpty(cartproduct.Product__r.Name) ? '' : cartproduct.Product__r.Name;
            productSKU = String.isEmpty(cartproduct.Product__r.DW_ID__c) ? '' : cartproduct.Product__r.DW_ID__c;
            baseUOM = String.isEmpty(cartproduct.Product__r.Base_UoM__c) ? '' : cartproduct.Product__r.Base_UoM__c;
            availableUOM = String.isEmpty(cartproduct.Available_UOM__c) ? '' : cartproduct.Available_UOM__c;
            shippingName = String.isEmpty(cartproduct.Shipping_Name__c) ? '' : cartproduct.Shipping_Name__c;
            shippingStreet = String.isEmpty(cartproduct.Shipping_Street__c) ? '' : cartproduct.Shipping_Street__c;
            shippingCity = String.isEmpty(cartproduct.Shipping_City__c) ? '' : cartproduct.Shipping_City__c;
            shippingState = String.isEmpty(cartproduct.Shipping_State__c) ? '' : cartproduct.Shipping_State__c;
            shippingZIPCode = String.isEmpty(cartproduct.Shipping_ZIP_Code__c) ? '' : cartproduct.Shipping_ZIP_Code__c;
            shippingCountry = String.isEmpty(cartproduct.Shipping_Country__c) ? '' : cartproduct.Shipping_Country__c;
            cartId = cartLst[0].Id;
            fulfillmentType = String.isEmpty(cartproduct.Fulfillment_Method__c) ? '' : cartproduct.Fulfillment_Method__c;
            liftGate = cartproduct.Lift_gate__c;
            UOM = String.isEmpty(cartproduct.UOM__c) ? '' : cartproduct.UOM__c;
            unit = cartproduct.Unit__c;

            if (priceSkuMap.containsKey(cartproduct.Product__r.DW_ID__c)) {
                Dal_GetPriceManager.Dal_GetPriceWrapper wrap = priceSkuMap.get(cartproduct.Product__r.DW_ID__c);
                totalSingleLineQuantity = wrap.extendedNetPrice;
                energySurcharge = wrap.ExtendedEnergySurCharge;
            } else {
                totalSingleLineQuantity = 0;
                energySurcharge = 0;
            }

            quantity = cartproduct.Quantity__c;
            if (fulfillmentType.equalsIgnoreCase(FULLFILLMENT_TYPE)) {
                isDelivery = true;
                isPickUp = false;
            } else {
                isDelivery = false;
                isPickUp = true;
            }


            /*  Testing that already added products were still availble in Inventor or not
              and return those product sku which are not available

             for(String val : presentSku){
                 if(!inventorySkuMap.containsKey(val)){
                     unavailavbleSkus.add(val);
                 }
                 if(inventorySkuMap.containsKey(val) && productSkuMap.containsKey(val)){
                     Dal_GetInventoryLocation.Inventory_Location_Wrapper inventoryData = inventorySkuMap.get(val);
                     DT_Cart_Product__c productCart = productSkuMap.get(val);
                     if(Decimal.valueOf(inventoryData.availableQty) < productCart.Quantity__c){
                         unavailavbleSkus.add(val);
                     }
                 }
             }*/
        }


    }

    public class ProfileWrapper{
        @AuraEnabled public String profileName;
        @AuraEnabled public String division;

        public ProfileWrapper(String profile,String div){
            this.profileName = profile;
            this.division = div;
        }

    }


}