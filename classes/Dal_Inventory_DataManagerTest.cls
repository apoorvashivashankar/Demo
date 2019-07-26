@isTest
public class Dal_Inventory_DataManagerTest {
    
    public static testMethod void testPubEndpoint(){
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new Dal_ATPDataControllerMock());
        Dal_Inventory_DataManager.PubEndpoint dalInventoryPub = new Dal_Inventory_DataManager.PubEndpoint();
        
        Dal_Inventory_DataController.InventoryRequest cntRequest = new Dal_Inventory_DataController.InventoryRequest();
		dalInventoryPub.GetInventoryAtSourcesOfSupply(cntRequest);     
        
        Dal_Inventory_DataController.ServiceContext cntContext = new Dal_Inventory_DataController.ServiceContext();
        
        Dal_Inventory_DataContract.MyServiceFault service = new Dal_Inventory_DataContract.MyServiceFault();
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_TimePhased(cntRequest);  
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_TimePhased_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtLocation_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtLocation(cntRequest);
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price(cntRequest);
            
        dalInventoryPub.GetInventoryAtLocation_AvailabilityDate_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtLocation_TimePhased_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtLocation_ByShade_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtLocation_AvailabilityDate(cntRequest);
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtSourcesOfSupply_AvailabilityDate(cntRequest);
        
        dalInventoryPub.GetInventoryAtLocation_ByShade(cntRequest);
        
        dalInventoryPub.GetInventoryAtLocation_TimePhased(cntRequest);
        
        dalInventoryPub.GetInventoryAtNearbySSCS_ctx(cntRequest, cntContext);
        
        dalInventoryPub.GetInventoryAtNearbySSCS(cntRequest);
        
        //dalInventoryPub.GetInventoryAtNearbySSCS_ByMileRadius_ctx(cntRequest, cntContext);
        //dalInventoryPub.GetSourcesOfSupply_ctx(cntRequest, cntContext);
        dalInventoryPub.GetInventoryAtNearbySSCS_ByMileRadius(cntRequest);
        dalInventoryPub.GetSourcesOfSupply(cntRequest);
        
        
        test.stopTest();
    }

}