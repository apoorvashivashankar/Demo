@isTest
global class WebServiceMockDalImplAddValidation implements WebServiceMock {

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
		 
		Dal_Address_Validation_Manager.Result result = new Dal_Address_Validation_Manager.Result();
		result.Status = 'Valid';
		result.StatusDesc = 'Arng';
				
		Dal_Address_Validation_Manager.Address address = new Dal_Address_Validation_Manager.Address();		
		address.Line1 = 'ABC';
		address.Line2 = '54';
		address.StateProvince = 'NY';
		address.City = 'NY';
		address.PostalCode = '5445';
		address.Country = 'US';
	
		Dal_Address_Validation_Manager.Response res = new Dal_Address_Validation_Manager.Response();
		res.Result = result;
		res.RequestAddress = address;
		res.ResponseAddress = address;
		res.AddressStatus = address;
		
		Dal_Address_Validation_Manager.GetAddressValidationResponseBody response_x = new Dal_Address_Validation_Manager.GetAddressValidationResponseBody();
		response_x.Response = res;
        //response_x.Response = response;
		response.put('response_x',response_x);
		
	}
}