@isTest
global class Dal_AddressDataControllerMock implements WebServiceMock{

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
            if(request instanceof Dal_Address_Validation_Manager.GetAddressValidationRequestBody){
                Dal_Address_Validation_Manager.GetAddressValidationResponseBody respElement = new Dal_Address_Validation_Manager.GetAddressValidationResponseBody();

                response.put('response_x', respElement);
            }
           /* if(request instanceof Dal_Address_Validation_Manager.GetAddressValidation_ctxRequestBody){

                Dal_Address_Validation_Manager.GetAddressValidation_ctxResponseBody respContext = new Dal_Address_Validation_Manager.GetAddressValidation_ctxResponseBody();
                response.put('response_x', respContext);
            }*/
        }
}