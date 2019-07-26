@isTest
public class Dal_Address_ValidationTest {
	 private static testMethod void testPubEndpoint(){

        test.startTest();
        Test.setMock(WebServiceMock.class, new Dal_AddressDataControllerMock());
        Dal_Address_Validation.Endpoint1 dalAddress = new Dal_Address_Validation.Endpoint1();

        Dal_Address_Validation_Manager.Request request = new Dal_Address_Validation_Manager.Request();

		dalAddress.GetAddressValidation(request);

        /*Dal_Address_Validation_Manager.ServiceContext context = new Dal_Address_Validation_Manager.ServiceContext();

        dalAddress.GetAddressValidation_ctx(request, context); */

        test.stopTest();
    }
}