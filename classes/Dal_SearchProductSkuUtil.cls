/**
* Created by 7Summits on 6/19/2018. 
  Modification History : Added "Product_Color__r.Code__c" field in in SOQL of searchProducts(-) by Daltile on 04/16/2019 
						 Defect# : 697
                         Updated search to include Product_Line__c instead of depricated field Product_Line_Description__r.Name
*/
public class Dal_SearchProductSkuUtil {

    @AuraEnabled
    public static List<Product2> searchProducts(String searchParameter){

        set<string> logSet = new Set<String>{'D','X','P','2'};
        set<string> brandcode = new Set<string>{'AO','DB'} ;
        set<string> tileSet = new Set<string>{'SAM','IP','SLB'};

        String division;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        division = selectedAccount.Division__c;
        System.debug('division--->'+division);
        System.debug('division--->'+division);

        if(Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c)){
            System.debug('division--->'+division);
            List<Product2> productList =new List<Product2>();
            searchParameter = '%'+ searchParameter + '%';

            if(selectedAccount.Division__c == '40')
            {
                System.debug('selectedAccount40--->'+selectedAccount);
                set<string> ssclogSet = new Set<String>{'D','X','C','2','O','E','N','M','9'};
                productList = [
                        SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,Product_Line_Team__c
                        FROM Product2
                        WHERE Brand__c = 'DB'
                        AND Log_Code__c NOT IN : ssclogSet
                        AND Tile_Type__c != 'SAM'
                        AND Product_Line_Team__c IN : Dal_Constants.SSC_TEAM_SET_40
                        AND (DW_ID__c LIKE :searchParameter  OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line__c LIKE :searchParameter)
                        LIMIT 1000
                ];

            }
            else if(selectedAccount.Division__c == '41')
            {
                System.debug('selectedAccount41--->'+division);
                set<string> ssclogSet = new Set<String>{'D','X','C','2','O','E','N','M','9'};

                productList = [
                        SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,Product_Line_Team__c
                        FROM Product2
                        WHERE
                        ((Brand__c IN ('AO','MZ')
                        AND Log_Code__c NOT IN : ssclogSet
                        AND Tile_Type__c != 'SAM'
                        AND Product_Line_Team__c IN : Dal_Constants.SSC_TEAM_SET_41)
                        OR
                        (Brand__c = 'DB'
                        AND Log_Code__c IN ('P','I')
                        AND Tile_Type__c != 'SAM'
                        AND Product_Line_Team__c =: Dal_Constants.SSC_ALLIED_PRODUCTS
                        )
                        OR
                        (Brand__c ='DB'
                        AND Log_Code__c ='P'
                        AND Tile_Type__c != 'SAM'
                        AND Product_Line_Team__c IN : Dal_Constants.SSC_TEAM_SET_41
                        ))
                        AND (DW_ID__c LIKE :searchParameter  OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line__c LIKE :searchParameter)
                ];

            }
            System.debug('productList41--->'+productList);
            return productList;
        }else if(selectedAccount.Division__c == '42'){
            System.debug('selectedAccount42--->'+division);
            searchParameter = '%'+ searchParameter + '%';
            List<Product2> productList = [
                    SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c
                    FROM Product2
                    WHERE Brand__c IN : brandcode
                    AND DOP_Ind__c =:'Y'
                    AND Log_Code__c NOT IN : logSet
                    AND Tile_Type__c NOT IN : tileSet
                    AND (DW_ID__c LIKE :searchParameter  OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line__c LIKE :searchParameter)
                    LIMIT 1000
            ];
            System.debug('productList-->'+productList);
            return productList;
        }else if(selectedAccount.Division__c == '43'){
            System.debug('selectedAccount43--->'+division);
            searchParameter = '%'+ searchParameter + '%';
            List<Product2> productList = [
                    SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c
                    FROM Product2
                    WHERE Brand__c =: 'MZ'
                    AND DOP_Ind__c =: 'Y'
                    AND Log_Code__c NOT IN : logSet
                    AND Tile_Type__c NOT IN : tileSet
                    AND(DW_ID__c LIKE :searchParameter OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line__c LIKE :searchParameter)
                    LIMIT 1000
            ];
            return productList;
        }else if(selectedAccount.Division__c == '44'){
            System.debug('selectedAccount44--->'+division);
            searchParameter = '%'+ searchParameter + '%';
            List<Product2> productList = [
                    SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c
                    FROM Product2
                    WHERE  Brand__c =: 'RG'
                    AND Log_Code__c NOT IN : logSet
                    AND Tile_Type__c NOT IN : tileSet
                    AND(DW_ID__c LIKE :searchParameter OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line__c LIKE :searchParameter)
                    LIMIT 1000
            ];
            return productList;
        }
        else{
            return null;
        }
    }

    //---------------------------For Sample Order ----------------------------------------------------------------------------------------
    @AuraEnabled
    public static List<Product2> searchSampleProducts(List<String> searchParameter) {

        List<Product2> productList = new List<Product2>();
        productList = [
                SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c,Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c
                FROM Product2
                WHERE Log_Code__c != 'D'
                AND Tile_Type__c  = 'SAM'
                AND Product_Color__r.Code__c LIKE: searchParameter
                LIMIT 1000
        ];
        if(productList.size() > 0)
        {
            System.debug('Product List-->'+ productList);
            return productList;
        }
        else{
            System.debug('Product List in else -->'+ productList);
            return null;
        }

    }

    //------------------------------------For Branded Page Search with Combination-------------------------------------------------

    /*
   * Method Name: searchProductsWithBrand
   * Description: To get list of Product on Quick Search on basis of Brand,Search parameteer And colorCode
   * @param: List<String> searchParameter,String brand,String searchParams
   * @return List<Product2>
   */
    @AuraEnabled
    public static List<Product2> searchProductsWithBrand(List<String> searchParameter,String brand,String searchParams) {
        System.debug('Params with ColorCode -->'+searchParameter+'-'+brand+'-'+searchParams);

        Integer listLimit = 1000;

        if(searchParams != null && searchParams != ''){
            searchParams = '%'+searchParams+'%';
        }

        List<Product2> productList = new List<Product2>();

        String query = 'SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name,'+
                'Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,VendorName__c,PiecesPerCarton__c,'+
                'SquarefeetPerCarton__c FROM Product2 WHERE SearchTags__c Like \''+ '%FASTMOVER%'+'\'';

        if(searchParameter.size() > 0){

            query += ' AND Product_Color__r.Code__c IN : searchParameter ' ;
        }
        if(searchParams != null && searchParams != ''){

            query += ' AND (DW_ID__c LIKE \''+searchParams+ '\' OR Product_Color__r.Name LIKE \''+searchParams+
                    '\' OR Description LIKE \''+searchParams+ '\' OR Product_Line_Description__r.Name LIKE \''+searchParams+'\')';

        }
        if(brand != null && brand != '' ){
            query += ' AND Brand__c = \'' + brand + '\'';
        }

        query += ' LIMIT ' + listLimit;
        System.debug('Query is--->'+query);
        productList = Database.query(query);

        if(productList.size() > 0)
        {
            System.debug('Product List-->'+ productList);
            return productList;
        }
        else{
            System.debug('Product List in else -->'+ productList);
            return null;
        }

    }

    /*
   * Method Name: quickSearchProductsWithBrand
   * Description: To get list of Product on Quick Search
   * @param: None
   * @return List<Product2>
   */
    @AuraEnabled
    public static List<Product2> quickSearchProductsWithBrand(String searchParameter) {
        System.debug('Params-->'+searchParameter);
        searchParameter = '%'+ searchParameter + '%';
        List<Product2> productList = new List<Product2>();

        productList = [
                SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,PiecesPerCarton__c,SquarefeetPerCarton__c
                FROM Product2
                WHERE (DW_ID__c LIKE :searchParameter  OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line_Description__r.Name LIKE :searchParameter)
                LIMIT 1000
        ];
        if(productList.size() > 0)
        {
            System.debug('Product List-->'+ productList);
            return productList;
        }
        else{
            System.debug('Product List in else -->'+ productList);
            return null;
        }

    }

    /*
  * Method Name: searchVendorNames
  * Description: To get list of Vendor Name for Drop Down
  * @param: None
  * @return List<Object>
  */
    @AuraEnabled
    public static List<Object> searchVendorNames() {

        List<Object> vendorList = new List<Object>();

        for(AggregateResult aggregateResult : [SELECT Count(Id), VendorName__c FROM Product2 WHERE Product_Line_Team__c = 'INSTALLATION PRODUCT (0005)' AND SearchTags__c LIKE '%FASTMOVER%' Group By VendorName__c ORDER BY VendorName__c ASC ]){

            vendorList.add(aggregateResult.get('VendorName__c'));
        }
        System.debug('vendorList-->'+vendorList);
        return vendorList;
    }

    /*
   * Method Name: searchSize
   * Description: To get list of Size for Drop Down
   * @param: None
   * @return List<Object>
   */
    @AuraEnabled
    public static List<Object> searchSize() {

        List<Object> sizeList = new List<Object>();

        for(AggregateResult aggregateResult : [SELECT Count(Id), Size__c  FROM Product2 Group By Size__c ORDER BY Size__c ASC ]){

            sizeList.add(aggregateResult.get('Size__c'));
        }
        System.debug('sizeList-->'+sizeList);
        return sizeList;
    }

    /*
   * Method Name: searchSizedProducts
   * Description: To get list of product no filter of colorCode,sizeValue,searchParameter AND brand
   * @param: List<String> colorCode,List<String> sizeValue,String searchParameter,String brand
   * @return List of Product2
   */
    @AuraEnabled
    public static List<Product2> searchSizedProducts(List<String> colorCode,List<String> sizeValue,String searchParameter,String brand) {
        searchParameter = searchParameter.trim();
        System.debug('Params-with-Size->'+colorCode+'----'+sizeValue+'-----'+searchParameter+'---'+brand);
        String ProductTeamType = 'INSTALLATION PRODUCT (0005)';
        Integer listLimit = 1000;
        //brand = brand.equalsIgnoreCase('Daltile') ? 'DB' : brand;

        if(searchParameter != null && searchParameter !='') {
            searchParameter = '%' + searchParameter + '%';
        }

        List<Product2> productList = new List<Product2>();
        String query = 'SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name,'+
                'Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,VendorName__c,PiecesPerCarton__c,'+
                'SquarefeetPerCarton__c FROM Product2 WHERE SearchTags__c Like \''+ '%FASTMOVER%'+'\'';

        System.debug('Query--->'+query);
        if(colorCode !=null && colorCode.size() > 0){

            query += ' AND Product_Color__r.Code__c IN : colorCode ' ;
        }
        System.debug('Querycode--->'+query);
        if( sizeValue != null && sizeValue.size() > 0 ){

            query += ' AND Size__c IN : sizeValue' ;
        }
        System.debug('Query size--->'+query);
        if(searchParameter != null && searchParameter != ''){

            query += ' AND (DW_ID__c LIKE \''+searchParameter+ '\' OR Product_Color__r.Name LIKE \''+searchParameter+
                    '\' OR Description LIKE \''+searchParameter+ '\' OR Product_Line_Description__r.Name LIKE \''+searchParameter+'\')';

        }

        if(brand != null && brand == 'AO' ){
            query += ' AND ( Brand__c = \'' + brand + '\' OR Brand__c = \'MZ\' OR Product_Line_Team__c = \'' + ProductTeamType + '\')';
        }else if(brand != null && brand == 'MZ'){
            query += ' AND ( Brand__c = \'' + brand + '\' OR Product_Line_Team__c = \'' + ProductTeamType + '\')';
        }else if(brand != null && brand == 'DB'){
            query += ' AND Brand__c = \'' + brand + '\'';
        }

        query += ' LIMIT ' + listLimit;
        System.debug('Query is--->'+query);
        productList = Database.query(query);

        /*productList = [
                SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name, Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,PiecesPerCarton__c,SquarefeetPerCarton__c
                FROM Product2
                WHERE *//*Brand__c =: brand Size__c =: size
                    AND*//* Size__c IN: size
                    AND Product_Color__r.Code__c IN: colorCode
                    AND (DW_ID__c LIKE :searchParameter  OR Product_Color__r.Name LIKE :searchParameter OR Description LIKE :searchParameter OR Product_Line_Description__r.Name LIKE :searchParameter)
                    LIMIT 1000
            ];*/

        if(productList.size() > 0)
        {
            System.debug('Product List-->'+ productList);
            return productList;
        }
        else{
            System.debug('Product List in else -->'+ productList);
            return null;
        }

    }

    /*
   * Method Name: searchVendorProducts
   * Description: To get searched Product with a combined search of vendor name And searchParameter.
   * @param: String searchParameter,String vendor
   * @return List of Product2
   */
    @AuraEnabled
    public static List<Product2> searchVendorProducts(String searchParameter,String vendor) {
        searchParameter = searchParameter.trim();
        Integer listLimit = 1000;
        System.debug('Params-->'+searchParameter+'--'+vendor);
        String ProductTeamType = 'INSTALLATION PRODUCT (0005)';
        if(searchParameter !=null && searchParameter != ''){
            searchParameter = '%'+ searchParameter + '%';
        }
        List<Product2> productList = new List<Product2>();
        String query = 'SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Product_Color__r.Code__c, Product_Color__r.Name,'+
                'Product_Line_Description__r.Name, Size__c, Tile_Type__c, Product_Line__c,VendorName__c,PiecesPerCarton__c,'+
                'SquarefeetPerCarton__c FROM Product2 WHERE Product_Line_Team__c = \''+ ProductTeamType +'\' AND SearchTags__c Like \''+ '%FASTMOVER%'+'\'';

        if(vendor != null && vendor != ''){

            query += ' AND VendorName__c =\'' + vendor + '\'';
        }
        if(searchParameter != null && searchParameter != ''){
            query += ' AND (DW_ID__c LIKE \''+searchParameter+ '\' OR Product_Color__r.Name LIKE \''+searchParameter+
                    '\' OR Description LIKE \''+searchParameter+ '\' OR Product_Line_Description__r.Name LIKE \''+searchParameter+'\')';

        }
        /*if(brand != null && brand != '' ){
            query += ' AND Brand__c = \'' + brand + '\'';
        }*/

        query += ' LIMIT ' + listLimit;
        System.debug('Query is--->'+query);
        productList = Database.query(query);

        if(productList.size() > 0)
        {
            System.debug('Product List-->'+ productList);
            return productList;
        }
        else{
            System.debug('Product List in else -->'+ productList);
            return null;
        }

    }

    /*
   * Method Name: getSeries
   * Description: To get Series filter on basis of Brand for Branded Product drop down search
   * @param: String brand
   * @return List of ProductSeries__c
   */
    @AuraEnabled
    public static  List<ProductSeries__c> getSeries(String brand){
        System.debug('brand---->'+brand);
        Set<Id> seriesSet = new Set<Id>();
        Set<Id> colorSet = new Set<Id>();
        List<ProductSeries__c> seriesList = new List<ProductSeries__c>();

        for(AggregateResult aggregateResult : [SELECT Count(Id), Product_Color__c FROM Product2 WHERE SearchTags__c LIKE '%FASTMOVER%' AND Brand__c =: brand Group By Product_Color__c]){
            if(aggregateResult != null && aggregateResult.get('Product_Color__c') != null ){
                colorSet.add(Id.valueOf(String.valueOf(aggregateResult.get('Product_Color__c'))));
            }
        }
        System.debug('colorSet--->'+colorSet.size());

        for(AggregateResult aggregateResultSeries : [SELECT Count(Id),Product_Series__c FROM ProductSeriesColor__c WHERE Product_Color__c IN : colorSet Group By Product_Series__c]){
            if(aggregateResultSeries != null){
                seriesSet.add(Id.valueOf(String.valueOf(aggregateResultSeries.get('Product_Series__c'))));
            }
        }
        System.debug('seriesSet--->'+seriesSet.size());

        seriesList = [SELECT Id, Name, Series__c FROM ProductSeries__c WHERE Id IN : seriesSet ORDER BY Name ASC ];

        System.debug('seriesList--->'+seriesList.size());

        return seriesList;
    }

    /*FOR CREATE ORDER
   * Method Name: getSeriesCreate
   * Description: To get Series filter on basis of Brand for Branded Product drop down search
   * @param: String brand
   * @return List of ProductSeries__c
   */
    @AuraEnabled
    public static Dal_SSC_CreateOrderJSON getSeriesCreate(String brand){
        System.debug('brand---->'+brand);
        Set<Id> seriesSet = new Set<Id>();
        Set<Id> colorSet = new Set<Id>();
        List<ProductSeries__c> seriesList = new List<ProductSeries__c>();

        for(AggregateResult aggregateResult : [SELECT Count(Id), Product_Color__c FROM Product2 WHERE SearchTags__c LIKE '%FASTMOVER%' AND Brand__c =: brand Group By Product_Color__c]){
            if(aggregateResult != null && aggregateResult.get('Product_Color__c')!=null){
                colorSet.add(Id.valueOf(String.valueOf(aggregateResult.get('Product_Color__c'))));
            }
        }
        System.debug('colorSet--->'+colorSet.size());

        for(AggregateResult aggregateResultSeries : [SELECT Count(Id),Product_Series__c FROM ProductSeriesColor__c WHERE Product_Color__c IN : colorSet Group By Product_Series__c]){
            if(aggregateResultSeries != null){
                seriesSet.add(Id.valueOf(String.valueOf(aggregateResultSeries.get('Product_Series__c'))));
            }
        }
        System.debug('seriesSet--->'+seriesSet.size());

        seriesList = [SELECT Id, Name, Series__c FROM ProductSeries__c WHERE Id IN : seriesSet ORDER BY Name ASC ];

        System.debug('seriesList--->'+seriesList.size());

        Dal_SSC_CreateOrderJSON createOrderJSON = new Dal_SSC_CreateOrderJSON();
        createOrderJSON.listOfSeries = [SELECT Id, Name, Series__c FROM ProductSeries__c WHERE Id IN : seriesSet ORDER BY Name ASC ];
        System.debug('createOrderJSON: ' + createOrderJSON);
        return createOrderJSON;
    }


    /*
   * Method Name: getColors
   * Description: to filter a list of color in branded product dropdown on basis of Brand
   * @param: String SeriesId,String brand
   * @return List of ColorCode
   */
    @AuraEnabled
    public static List<ColorCode> getColors(String SeriesId,String brand){

        System.debug('ColorCodeParams---->'+SeriesId+'---'+brand);
        Set<Id> colorSet = new Set<Id>();
        List<ColorCode> colorCodeList = new List<ColorCode>();
        List<String> colorCode = new List<String>();

        for (ProductSeriesColor__c productColor : [SELECT Id, Name,ExternalId__c,Product_Color__r.Name,Product_Color__r.Code__c FROM ProductSeriesColor__c where Product_Series__r.Id =: SeriesId ORDER BY Product_Color__r.Name ASC ]){
            colorCode.add(productColor.Product_Color__r.Code__c);
        }

        for(AggregateResult aggregateResult : [SELECT Count(Id), Product_Color__c FROM Product2 WHERE Product_Color__r.Code__c IN : colorCode AND SearchTags__c LIKE '%FASTMOVER%' AND Brand__c =: brand Group By Product_Color__c]){
            if(aggregateResult != null && aggregateResult.get('Product_Color__c') != null ){
                colorSet.add(Id.valueOf(String.valueOf(aggregateResult.get('Product_Color__c'))));
            }
        }
        System.debug('colorSet--->'+colorSet.size());

        for(Product_Color__c color : [SELECT Id, Name,Code__c FROM Product_Color__c  WHERE Id IN : colorSet ORDER BY Name ASC ]){
            ColorCode code =new ColorCode(color);
            colorCodeList.add(code);
        }

        if(colorCodeList.size()>0)
        {
            return colorCodeList;
        }
        else{
            return null;
        }


    }

    /*
   * Wrapper Class Name: ColorCode
   * Description: Color Code wrapper to return a color name with code
   * @param: None
   * @return None
   */
    public Class ColorCode{
        @AuraEnabled public  String colorName;
        @AuraEnabled public  String colorCode;

        public ColorCode(Product_Color__c seriesColor){
            this.colorName = seriesColor.Name;
            this.colorCode = seriesColor.Code__c;
        }
    }
}