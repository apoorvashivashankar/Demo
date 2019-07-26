/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest
public class Dal_Shade_ManagerTest {
    
    
    static testMethod void getSessionOrderTest() {
        String SKU = 'demo1';
        String UOM= 'demo1';
        String Quantity= '1245';
        String SOS= 'demo1';
        String ReqShipDate= string.valueof(datetime.newInstance(2014, 9, 15, 12, 30, 0));
        String PriceRecord= 'demo1';
        String SupplyPlant = 'demo';
        Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
        Dal_Shade_Manager shade_Manager = new Dal_Shade_Manager(SKU, Quantity, UOM, SOS, ReqShipDate, PriceRecord,SupplyPlant);
		shade_Manager.getByShade();
    }
}