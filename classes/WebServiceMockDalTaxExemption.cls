/**
 * Created by Preshit on 31-01-2019.
 */
@isTest
global class WebServiceMockDalTaxExemption implements WebServiceMock {

    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){

        List<Dal_TaxExemptionContract.CustomerTaxExemptions> customerTaxExemptionList = new List<Dal_TaxExemptionContract.CustomerTaxExemptions>();
        Dal_TaxExemptionContract.CustomerTaxExemptions customerTaxExemptions = new Dal_TaxExemptionContract.CustomerTaxExemptions();
        customerTaxExemptions.TaxExemption = 'test';
        customerTaxExemptions.TaxExemptionDesc = 'test';
        customerTaxExemptions.TaxExemptionExpDate = System.now();
        customerTaxExemptions.TaxExemptionEffectiveDate = System.now();
        customerTaxExemptions.TaxExemptionState = 'Test';
        customerTaxExemptions.TaxExemptionCertKey = 'test';
        customerTaxExemptionList.add(customerTaxExemptions);

        Dal_TaxExemptionContract.ArrayOfCustomerTaxExemptions arrayOfCustomerTaxExemptions = new Dal_TaxExemptionContract.ArrayOfCustomerTaxExemptions();
        arrayOfCustomerTaxExemptions.CustomerTaxExemptions = customerTaxExemptionList;

        Dal_TaxExemptionContract.CustomerTaxExemptionsRecords customerTaxExemptionsRecords = new Dal_TaxExemptionContract.CustomerTaxExemptionsRecords();
        customerTaxExemptionsRecords.CustomerTaxExemptionsList = arrayOfCustomerTaxExemptions;

        Dal_TaxExemptionContract.GetCustomerTaxExemptionsResponseBody response_x = new Dal_TaxExemptionContract.GetCustomerTaxExemptionsResponseBody();
        response_x.GetCustomerTaxExemptionsResult = customerTaxExemptionsRecords;
        response.put('response_x',response_x);
    }
}