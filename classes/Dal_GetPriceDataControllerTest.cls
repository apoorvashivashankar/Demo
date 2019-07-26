@isTest
public class Dal_GetPriceDataControllerTest {

    @isTest
    static void webserviceOrderTwoTest() {
        Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
    }
}