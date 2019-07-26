/**
 * Created by 7Summits on 4/4/18.
 */
public class Dal_Address_Validation_Controller {

    @AuraEnabled
    public static ReturnAddress getValidatedAddress(String lineOne, String lineTwo, String stateProvince, String city, String code, String country){

        Dal_Address_Validation.Endpoint1 addressValidateRequest=new Dal_Address_Validation.Endpoint1();

        Dal_Address_Validation_Manager.Address address =new  Dal_Address_Validation_Manager.Address();
        address.Line1 = lineOne;
        address.Line2 = lineTwo;
        address.StateProvince = stateProvince;
        address.City = city;
        address.PostalCode = code;
        address.Country = country;

        Dal_Address_Validation_Manager.Request request =new Dal_Address_Validation_Manager.Request();
        request.Address = address;

        Dal_Address_Validation_Manager.Response reponse= addressValidateRequest.GetAddressValidation(request);
        System.debug('RESPONSE---->'+reponse);
        System.debug('RESPONSE STATUS---->'+reponse.Result.Status);
        System.debug('RESPONSE Address---->'+reponse.ResponseAddress.Line1);

        ReturnAddress returnAddress = new ReturnAddress();
        returnAddress.lineOne = reponse.ResponseAddress.Line1;
        returnAddress.lineTwo = reponse.ResponseAddress.Line2;
        returnAddress.stateProvince = reponse.ResponseAddress.StateProvince;
        returnAddress.city = reponse.ResponseAddress.City;
        returnAddress.PostalCode = reponse.ResponseAddress.PostalCode;
        returnAddress.country = reponse.ResponseAddress.Country;
        returnAddress.isValid = false;
        returnAddress.isValidWithUpdate = false;
        returnAddress.isError = false;

        if(reponse.Result.Status == 'ValidWithUpdate'){
            returnAddress.isValidWithUpdate = true;
        }else if(reponse.Result.Status == 'Invalid'){
            returnAddress.isValidWithUpdate = true;
        }else if(reponse.Result.Status == 'error'){
            returnAddress.isError = true;
        }        else if(reponse.Result.Status == 'Valid'){
            returnAddress.isValid = true;
        }

        return returnAddress;
    }
    public class ReturnAddress{
        @AuraEnabled public String lineOne {get; set;}
        @AuraEnabled public String lineTwo {get; set;}
        @AuraEnabled public String stateProvince {get; set;}
        @AuraEnabled public String city {get; set;}
        @AuraEnabled public String PostalCode {get; set;}
        @AuraEnabled public String country {get; set;}

        // if true, everything is good
        @AuraEnabled public Boolean isValid {get;set;}
        // if true, things are good but the returned address here will have the updated address
        @AuraEnabled public Boolean isValidWithUpdate {get;set;}
        // if true, an error occurred and the user should send better data
        @AuraEnabled public Boolean isError{get;set;}
        @AuraEnabled public String messageResponse {get;set;}
	}
}