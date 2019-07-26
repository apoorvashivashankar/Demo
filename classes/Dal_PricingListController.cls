/**
 * Created by 7Summits on 4/4/18.
 */
public class Dal_PricingListController {

    /*
	* Method Name: getAllPriceRecord
	* Description: Purpose to get Price Record Id from external object 'DT_SYS_PriceRecord__x' on basis of Customer Id
	* @param: Customer ID
	* @return List of Ecternal Object 'DT_SYS_PriceRecord__x'
	*/
  	@AuraEnabled
    public static List<DT_SYS_PriceRecord__x> getAllPriceRecord(String customer, Integer listLimit){
        if(customer == null) {
            Account currentSelectedAccount = Dal_BaseController.getUserSelectedLocation();
            customer = currentSelectedAccount.DW_ID__c;
        }
       	List<DT_SYS_PriceRecord__x> priceRecordList =  Dal_PriceRecordManager.getAllPriceRecord(customer, listLimit);
        return priceRecordList;
    }

    /*
	* Method Name: getPriceRecordsForCustomerByDate
	* Description: Purpose to get Price Record Id from external object 'DT_SYS_PriceRecord__x' on basis of Customer Id & Date
	* @param: Customer ID & Date
	* @return List of Ecternal Object 'DT_SYS_PriceRecord__x'
	*/
    @AuraEnabled
    public static List<DT_SYS_PriceRecord__x> getPriceRecordsForCustomerByDate(String customer, Datetime dateVal, Integer listLimit){
        if(customer == null) {
            Account currentSelectedAccount = Dal_BaseController.getUserSelectedLocation();
            customer = currentSelectedAccount.DW_ID__c;
        }
        if(dateVal == null){
            dateVal = Datetime.now();
        }
       	List<DT_SYS_PriceRecord__x> priceRecordList =  Dal_PriceRecordManager.getPriceRecordByDate(customer,dateVal, listLimit);
        return priceRecordList;
    }

    /*
	* Method Name: getPromotion
	* Description: Purpose to retrieve the Promotion records for the user's selected account & Price Record.
	* @param: promotionrecord
	* @return List of PriceConditionList__x
	*/

    @AuraEnabled
    public static List<DT_SYS_PriceConditionDetails__x> getMaterialRecordsByDate(String promotionrecord, Datetime effectiveDate, Integer listLimit){
        List<DT_SYS_PriceConditionDetails__x> priceList = Dal_PriceRecordManager.getPromotionDetail(promotionrecord, listLimit);
        return priceList;
    }
 
    @AuraEnabled
    public static List<DT_SYS_PriceConditionDetails__x> searchMaterialRecords(String promotionrecord, Datetime effectiveDate, String skuNumber, String description, Integer listLimit){
        List<DT_SYS_PriceConditionDetails__x> priceList = Dal_PriceRecordManager.searchPromotionDetails(promotionrecord, effectiveDate, skuNumber, description, listLimit);
        return priceList;
    }
    /* 
     * added by daltile 5\6\19
    * Method Name: getDivision
    * Description: Method to get division number of logged in Contect Account
    * @param: None
    * @return 'String'
    */ 
    @AuraEnabled
    public static String getDivision() {
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        System.debug('Division--->' + selectedAccount.Division__c);
        
        return selectedAccount.Division__c;

    }
}