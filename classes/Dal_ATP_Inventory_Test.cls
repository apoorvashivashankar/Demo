@IsTest
private with sharing class Dal_ATP_Inventory_Test
{
    private static testMethod void coverMethods()
    {
        Test.setMock(WebServiceMock.class, new Dal_ATP_Inventory_Manager_Test.WebServiceMockImpl());
        Dal_ATP_Inventory_Manager.PubEndpoint pub = new Dal_ATP_Inventory_Manager.PubEndpoint();
        pub.GetInventoryAtSourcesOfSupply(null);
        pub.GetInventoryAtSourcesOfSupply_ctx(null,null);
        pub.GetInventoryAtSourcesOfSupply_TimePhased(null);
        pub.GetInventoryAtSourcesOfSupply_TimePhased_ctx(null,null);   
        
    }
    private static testMethod void coverMethods1()
    {
        Dal_ATP_Inventory_Controller.InventoryRequest inv = new Dal_ATP_Inventory_Controller.InventoryRequest();
        
        Test.setMock(WebServiceMock.class, new Dal_ATP_Inventory_Manager_Test.WebServiceMockImpl());
        Dal_ATP_Inventory_Manager.PubEndpoint pub = new Dal_ATP_Inventory_Manager.PubEndpoint();
        pub.GetInventoryAtLocation_ctx(null, null); 
        pub.GetInventoryAtLocation(null);
        pub.GetInventoryAtLocation_ByShade(null);
        pub.GetInventoryAtNearbySSCS(null);
        pub.GetInventoryAtNearbySSCS_ctx(null,null);
        pub.GetInventoryAtLocation_TimePhased(null);    
        pub.GetInventoryAtLocation_AvailabilityDate_ctx(null,null);
        pub.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price(null);  
        pub.GetInventoryAtLocation_TimePhased_ctx(null,null);
        pub.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price(null);
        pub.GetInventoryAtLocation_TimePhased_ctx(null,null);
        pub.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctx(null, null);         
        pub.GetInventoryAtSourcesOfSupply_AvailabilityDate(null);
        pub.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctx(null,null);
        pub.GetInventoryAtLocation_AvailabilityDate(null);
        pub.GetInventoryAtLocation_ByShade_ctx(null,null);
    }    
}