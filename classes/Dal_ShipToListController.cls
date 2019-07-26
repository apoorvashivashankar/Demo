/**
 * Created by 7Summits on 3/5/18
 */
public class Dal_ShipToListController {
    /**
     * All the method present in this class will call methods of manager class "Dal_ShipToAddressOverrideManager".  
     * @return List of Dal_ShipToAddressOverrideManager wrapper class.  
     */
     
    //Return list of wrapper class by calling manager class method "" on basis of location Id. 		
   	@AuraEnabled
    public static List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> getShipToOverridesByLocation(String locationId){
    	 	Peak_Response response = new Peak_Response();
		    list<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipByLocation = Dal_ShipToAddressOverrideManager.getShipToOverridesByLocation(locationId);
		    return shipByLocation;
    }

	//Calling manager class method "setShipToOverrideDefault" with shipToOverrideId which returns List of Wrapper class
    @AuraEnabled
    public static List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> setShipToOverrideDefault(Id shipToOverrideId){
        	Peak_Response response = new Peak_Response();
		    list<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipByLocation = Dal_ShipToAddressOverrideManager.getShipToOverridesByLocation(shipToOverrideId);
		    return shipByLocation;
	}
    
    //Calling manager class method "setShipToOverrideDefault" with locationId which returns List of Wrapper class
    @AuraEnabled
    public static List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> deactivateAllShipToOverrides(Id locationId){
        	Peak_Response response = new Peak_Response();
		    list<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipByLocation = Dal_ShipToAddressOverrideManager.getShipToOverridesByLocation(locationId);
		    return shipByLocation;
    }

	//Calling manager class method "createShipToOverride" and send object of "DT_Shiptoaddress_Override__c" to create it
    @AuraEnabled
    public static void createShipToOverride(String shipAddress){
        	Dal_ShipToAddressOverrideManager.createShipToOverride(shipAddress);
    }  
    
    //Calling manager class method "deleteShipToOverride" and send object of "DT_Shiptoaddress_Override__c" to create it
    @AuraEnabled
    public static void deleteShipToOverride(String shipAddress){
        	Dal_ShipToAddressOverrideManager.deleteShipToOverride(shipAddress);
	}
}