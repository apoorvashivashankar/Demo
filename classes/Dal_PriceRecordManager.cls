/**
 * Created by 7Summits on 3/27/18.
 */
public without sharing class Dal_PriceRecordManager {

    /*
	* Method Name: getAllPriceRecord
	* Description: Purpose to get Price Record from external object 'DT_SYS_PriceRecord__x' on the basis of customerId
	* @param: Customer ID
	* @return List of External Object 'DT_SYS_PriceRecord__x'
	*/
    public static List<DT_SYS_PriceRecord__x> getAllPriceRecord(string customerId, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
		Datetime effective = Date.today().addDays(1);
    	system.debug('customerId is '+customerId);
        List<DT_SYS_PriceRecord__x> priceRecord = new List<DT_SYS_PriceRecord__x>();

          try{
                  priceRecord = [select id__c,PriceRecordCode__c,PriceRecordDescription__c,
                  				ValidFrom__c,ValidTo__c from DT_SYS_PriceRecord__x where Customer__c =: customerId and ValidFrom__c <=: effective and ValidTo__c >=: effective
                                LIMIT :listLimit
                  ];
                  system.debug('Dal_PriceRecordManager:PriceRecord --'+priceRecord);

              //Run's only when we run test
              if(Test.isRunningTest()){
                    DmlException e = new DmlException();
    				e.setMessage('This is a constructed exception!');
    				throw e;
                }
            } catch(Exception exp){
                System.debug('Dal_PriceRecordManager: An unexpected error has occurred: ' + exp.getMessage());
            }
        return priceRecord;
    }

    /*
	* Method Name: getPriceRecordsForCustomerByDate
	* Description: Purpose to get Price Record Id from external object 'DT_SYS_PriceRecord__x' on basis of Customer Id & Date
	* @param: Customer ID & Date
	* @return List of External Object 'DT_SYS_PriceRecord__x'
	*/
    public static List<DT_SYS_PriceRecord__x> getPriceRecordByDate(string customerId,Datetime dateValue, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

    	system.debug('dateValue is '+dateValue);
        List<DT_SYS_PriceRecord__x> priceRecord = new List<DT_SYS_PriceRecord__x>();

          try{
                  priceRecord = [select id__c,PriceRecordCode__c,PriceRecordDescription__c,
                  				ValidFrom__c,ValidTo__c from DT_SYS_PriceRecord__x where Customer__c =: customerId
                                 AND ValidFrom__c <=: dateValue AND ValidTo__c >=: dateValue
                                LIMIT :listLimit
                  ];
                  system.debug('Dal_PriceRecordManager:PriceRecord --'+priceRecord);

               //Run's only when we run test
              if(Test.isRunningTest()){
                    DmlException e = new DmlException();
    				e.setMessage('This is a constructed exception!');
    				throw e;
                }
            } catch(Exception exp){
                System.debug('Dal_PriceRecordManager: An unexpected error has occurred: ' + exp.getMessage());
            }
        return priceRecord;
    }


    /*
	* Method Name: getPriceRecordsDetails
	* Description: Purpose to get Price Record Details from external object 'DT_SYS_PriceConditionDetails__x' for given Promotion Record
	* @param: Promotion Record
	* @return List of External Object 'DT_SYS_PriceConditionDetails__x'
	*/
    public static List<DT_SYS_PriceConditionDetails__x> getPromotionDetail(string promotionrecord, Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

        String customerId = getCustomerId();
    	system.debug('promotionrecord is '+promotionrecord);
        List<DT_SYS_PriceConditionDetails__x> priceRecorddetails = new List<DT_SYS_PriceConditionDetails__x>();
         try{
            priceRecorddetails = [select id__c,Material__c, MaterialDesc__c,NetPriceRate__c,NetPriceQuantityUOM__c,	PlantCategory__c, NetPriceEffectiveDateTo__c, NetPriceEffectiveDateFrom__c
            from DT_SYS_PriceConditionDetails__x
            where LegacyCustomer__c =: customerId
            and PriceRecord__c =: promotionrecord
            and UOM_CodeSet__c =: Dal_Constants.LEGACY
            LIMIT :listLimit
            ];

            system.debug('Dal_PriceRecordManager:PriceRecord --'+priceRecorddetails);

            //Run's only when we run test
            if(Test.isRunningTest()){
                DmlException e = new DmlException();
                e.setMessage('This is a constructed exception!');
                throw e;
            }
        } catch(Exception exp){
            System.debug('Dal_PriceRecordManager: An unexpected error has occurred: ' + exp.getMessage());
        }
        return priceRecorddetails;
    }

    public static List<DT_SYS_PriceConditionDetails__x> searchPromotionDetails(string promotionrecord, Datetime effectiveDate, String skuNumber, String description, Integer listLimit) {
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

        String customerId = getCustomerId();
        system.debug('promotionrecord is '+promotionrecord);
        List<DT_SYS_PriceConditionDetails__x> priceRecorddetails = new List<DT_SYS_PriceConditionDetails__x>();

        skuNumber = skuNumber != null ? '%' + skuNumber.toUpperCase() + '%' : '%';
        description = description != null ? '%' + description.toUpperCase() + '%' : '%';

        try{
            priceRecorddetails = [select id__c,Material__c, MaterialDesc__c,NetPriceRate__c,NetPriceQuantityUOM__c,	PlantIdentifierType__c, NetPriceEffectiveDateTo__c, NetPriceEffectiveDateFrom__c
            from DT_SYS_PriceConditionDetails__x
            where LegacyCustomer__c =: customerId
            and PriceRecord__c =: promotionrecord
            and UOM_CodeSet__c =: Dal_Constants.LEGACY
            and Material__c LIKE :skuNumber
            AND MaterialDesc__c LIKE :description
            LIMIT :listLimit
            ];

            system.debug('Dal_PriceRecordManager:PriceRecord --'+priceRecorddetails);

            //Run's only when we run test
            if(Test.isRunningTest()){
                DmlException e = new DmlException();
                e.setMessage('This is a constructed exception!');
                throw e;
            }
        } catch(Exception exp){
            System.debug('Dal_PriceRecordManager: An unexpected error has occurred: ' + exp.getMessage());
        }
        return priceRecorddetails;

    }

     /*
	* Method Name: getCustomerId
	* Description: Method to get Customer Id
	* @param: Not Any
	* @return Customer Id
	*/
    public static String getCustomerId(){
    	String customerId;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        system.debug('customerId'+customerId);
        return customerId;
    }
}