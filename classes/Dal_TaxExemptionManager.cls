/**
 * Created by Preshit on 15-01-2019.
 */

public with sharing class Dal_TaxExemptionManager {

    //Global Variables
    public String Customer;
    /*
	* Method Name: Dal_TaxExemptionManager (Constructor)
	* Description: Purpose to set values to global variables
	* @param: Customer
	* @return Not Any
	*/
    public Dal_TaxExemptionManager(String Customer){
        this.Customer = Customer;
    }

    /*
	* Method Name: getTaxExemption
	* Description: Purpose to get data from webservice by Tax Exemption.
	* @param: Not Any
	* @return Object of Wrapper Class.
	*/
    public List<TaxExemption_Wrapper> getTaxExemption(){

        //Setting endpoint
        Dal_TaxExemptionService.Endpoint1 taxExemptionManager = new Dal_TaxExemptionService.Endpoint1();
        //Setting request item for calling webservice
        Dal_TaxExemptionContract.CustomerTaxExemptionsReq request = new Dal_TaxExemptionContract.CustomerTaxExemptionsReq();
        request.Customer = Customer;
        System.debug('--request---'+request);
        Dal_TaxExemptionContract.CustomerTaxExemptionsRecords response = new Dal_TaxExemptionContract.CustomerTaxExemptionsRecords();
        response = taxExemptionManager.GetCustomerTaxExemptions(request);
        System.debug('Response------>'+response);
        List<TaxExemption_Wrapper> taxWrapperList = new List<TaxExemption_Wrapper>();
        try{
            //parse the response and initialise a wrapper obj to return to lightning controller
            Dal_TaxExemptionContract.ArrayOfCustomerTaxExemptions resList = response.CustomerTaxExemptionsList;
            String dateFormatString = 'MM-DD-YYYY';
            if(resList.CustomerTaxExemptions.size() > 0){
                for(Dal_TaxExemptionContract.CustomerTaxExemptions res: resList.CustomerTaxExemptions){
                    TaxExemption_Wrapper taxWrapper = new TaxExemption_Wrapper();
                    taxWrapper.taxExemption = res.TaxExemption;
                    taxWrapper.taxExemptionDesc = res.TaxExemptionDesc; 
                    system.debug('---------'+res.TaxExemptionExpDate);
                    system.debug('---------'+String.valueOfGmt(res.TaxExemptionExpDate));
                    system.debug('-year---'+String.valueOfGmt(res.TaxExemptionExpDate).substring(0,4)+'---month--'+String.valueOfGmt(res.TaxExemptionExpDate).substring(5,7)+'--day--'+String.valueOfGmt(res.TaxExemptionExpDate).substring(8,10));

                    taxWrapper.expDate = String.valueOfGmt(res.TaxExemptionExpDate).substring(5,7) +'-'+String.valueOfGmt(res.TaxExemptionExpDate).substring(8,10) +'-'+String.valueOfGmt(res.TaxExemptionExpDate).substring(0,4);
                    taxWrapper.expirationDate = res.TaxExemptionExpDate;
                    //taxWrapper.expDate = res.TaxExemptionExpDate.month() +'-'+res.TaxExemptionExpDate.Day() +'-'+res.TaxExemptionExpDate.year();
                    //taxWrapper.expDate = Date.valueOf(res.TaxExemptionExpDate);
                    taxWrapper.effectiveDate = String.valueOfGmt(res.TaxExemptionEffectiveDate).substring(5,7) +'-'+String.valueOfGmt(res.TaxExemptionEffectiveDate).substring(8,10) +'-'+String.valueOfGmt(res.TaxExemptionEffectiveDate).substring(0,4);
                    //taxWrapper.effectiveDate = res.TaxExemptionEffectiveDate.month() +'-'+res.TaxExemptionEffectiveDate.Day() +'-'+res.TaxExemptionEffectiveDate.year();
                    //taxWrapper.effectiveDate = Date.valueOf(res.TaxExemptionEffectiveDate);
                    taxWrapper.taxExemptionState = res.TaxExemptionState;
                    taxWrapper.certKey = res.TaxExemptionCertKey;
                    taxWrapperList.add(taxWrapper);
                }
            }
        }catch(Exception e) {
            System.debug('Exception::: '+e);
        }

        System.debug('taxWrapperList------>'+taxWrapperList);
        return taxWrapperList;
    }

    //use the wrapper defenition in this class, remove from other process controller class
    public class TaxExemption_Wrapper{

        @AuraEnabled public String taxExemption{get;set;}
        @AuraEnabled public String taxExemptionDesc{get;set;}
        @AuraEnabled public String expDate{get;set;}
        @AuraEnabled public Datetime expirationDate{get;set;}
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled public String taxExemptionState{get;set;}
        @AuraEnabled public String certKey{get;set;}

    }

}