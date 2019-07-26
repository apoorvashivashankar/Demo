/**
 * Created by 7Summits on 3/5/18
 */
public with sharing class Dal_ShipToAddressOverrideManager {

    /**
     * This Class works on Custom Object "DT_Shiptoaddress_Override__c".
     * @return List of Wrapper Class 'Dal_ShipToAddressWrapper'
     */

    public static list<Dal_ShipToAddressWrapper> shipToAddressList { get; set;}

    @AuraEnabled
    public static List<Dal_ShipToAddressWrapper> getShipToAddressWrappersForCurrentLocation(){
        List<Dal_ShipToAddressWrapper> returnAddressWrappers = new List<Dal_ShipToAddressWrapper>();


        Account currentAccount = Dal_BaseController.getUserSelectedLocation();
        if(currentAccount != null) {

            Dal_ShipToAddressWrapper primaryAddressWrapper = new Dal_ShipToAddressWrapper(currentAccount);
            primaryAddressWrapper.IsPrimaryLocation = true;

            returnAddressWrappers.add(primaryAddressWrapper);

            List<Dal_ShipToAddressWrapper> overrideAddressWrappers = getShipToOverridesByLocation(currentAccount.Id);

            if (overrideAddressWrappers != null) {
                returnAddressWrappers.addAll(overrideAddressWrappers);
            }
        }
        return returnAddressWrappers;

    }

    @AuraEnabled
    public static Dal_Address_Validation_Controller.ReturnAddress getValidatedAddress(String lineOne, String lineTwo, String stateProvince, String city, String code, String country){
        return Dal_Address_Validation_Controller.getValidatedAddress(lineOne, lineTwo, stateProvince, city, code, country);
    }

   //Get list of "DT_Shiptoaddress_Override__c" object on basis of "locationId" and create list of wrapper class
    @AuraEnabled
    public static List<Dal_ShipToAddressWrapper> getShipToOverridesByLocation(Id locationId){
	   shipToAddressList = new list<Dal_ShipToAddressWrapper>();
       if(locationId != null ) {
           System.debug('In>>'+locationId);
            	for(DT_Shiptoaddress_Override__c item : [Select Id, Name, Address_Line_1__c,
            				Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,City__c,
            				Country__c,Default__c,Postal_code__c,State__c, Care_Of__c, Accountname_c__c from DT_Shiptoaddress_Override__c
            				where Accountname_c__c =: locationId order by Name]){
                                System.debug('item--->'+item);
            				shipToAddressList.add(new Dal_ShipToAddressWrapper(item));
        		}
        }
        else{
        	return null;
        }
        System.debug('shipToAddressList'+shipToAddressList);
	   	return shipToAddressList;
    }

    //Get list of "DT_Shiptoaddress_Override__c" object on basis of "shipToOverrideId" and create list of wrapper class
    @AuraEnabled
    public static List<Dal_ShipToAddressWrapper> setShipToOverrideDefault(Id shipToOverrideId){
    	shipToAddressList = new list<Dal_ShipToAddressWrapper>();
		   if(shipToOverrideId != null ) {
		        	for(DT_Shiptoaddress_Override__c item : [Select Id, Name, Address_Line_1__c,
		        				Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,City__c,
		        				Country__c,Default__c,Postal_code__c,State__c, Care_Of__c, Accountname_c__c  from DT_Shiptoaddress_Override__c
		        				where Id =: shipToOverrideId]){
		        				shipToAddressList.add(new Dal_ShipToAddressWrapper(item));
		    		}
		    }
		    else{
		    	return null;
		    }
	   	return shipToAddressList;
	}

    //Get list of "DT_Shiptoaddress_Override__c" object on basis of "locationId" and create list of wrapper class
    @AuraEnabled
    public static List<Dal_ShipToAddressWrapper> deactivateAllShipToOverrides(Id locationId){

        shipToAddressList = new list<Dal_ShipToAddressWrapper>();
		   if(locationId != null ) {
		        	for(DT_Shiptoaddress_Override__c item : [Select Id, Name, Address_Line_1__c,
		        				Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,City__c,
		        				Country__c,Default__c,Postal_code__c,State__c, Care_Of__c, Accountname_c__c  from DT_Shiptoaddress_Override__c
		        				where Accountname_c__c =: locationId]){

		        				item.Default__c = false;
		        				shipToAddressList.add(new Dal_ShipToAddressWrapper(item));
		    		}
		    }
		    else{
		    	return null;
		    }
	   	return shipToAddressList;
    }

    //Insert "DT_Shiptoaddress_Override__c" object
    @AuraEnabled
        public static Dal_ShipToAddressWrapper createShipToOverride(String shipAddress){
        Dal_ShipToAddressWrapper wrapper = (Dal_ShipToAddressWrapper)JSON.deserialize(shipAddress, Dal_ShipToAddressWrapper.class);
		System.debug('Address Wrapper -->'+wrapper);
        if(wrapper.AccountId == null){
            Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
            if(selectedAccount != null){
                wrapper.AccountId = selectedAccount.Id;
            }
        }

        DT_Shiptoaddress_Override__c shipToAddress = wrapper.toShipToAddressObject();
            System.debug('shipToAddress Odata -->'+shipToAddress);
          if(shipToAddress != null) {
            try{
                upsert shipToAddress;
                return new Dal_ShipToAddressWrapper(shipToAddress);
            }
            catch(DmlException e){
                System.debug('Record not Created');
                return null;
            }
          }
        return null;
    }

    //Delete "DT_Shiptoaddress_Override__c" object
    @AuraEnabled
    public static Boolean deleteShipToOverride(String shipAddress){
        Dal_ShipToAddressWrapper wrapper = (Dal_ShipToAddressWrapper)JSON.deserialize(shipAddress, Dal_ShipToAddressWrapper.class);

        DT_Shiptoaddress_Override__c shipToAddress = wrapper.toShipToAddressObject();
        if(shipToAddress != null && shipToAddress.Id != null) {
            try {
                delete shipToAddress;
                return true;
            } catch (DmlException e) {
                System.debug('Record not deleted');
                return false;
            }
    	  }
        return false;
    }

    @AuraEnabled
    public static List<Dal_OrderSearchController.StatusOption> getCountries(){
         List<String> options = new List<String>();
        List<Dal_OrderSearchController.StatusOption> countryoptions = new List<Dal_OrderSearchController.StatusOption>();
        for (Country__c country : [Select Name FROM Country__c]){
            countryoptions.add(new Dal_OrderSearchController.StatusOption(country.Name,country.Name));
        }
        return countryoptions;
    }

    // Wrapper class
    public with sharing class Dal_ShipToAddressWrapper{

        @AuraEnabled
        public Boolean Isactive;

        @AuraEnabled
        public Boolean IsPrimaryLocation;

        @AuraEnabled
        public String ID;

        @AuraEnabled
        public String Name;

        @AuraEnabled
        public String CareOf;

        @AuraEnabled
        public String AccountId;

        @AuraEnabled
        public String Customer_name;

        @AuraEnabled
        public String Address1;

        @AuraEnabled
        public String Address2;

        @AuraEnabled
        public String Address3;

        @AuraEnabled
        public String Address4;

        @AuraEnabled
        public String City;

        @AuraEnabled
        public String State;

        @AuraEnabled
        public String PostalCode;

        @AuraEnabled
        public String Country;

        public Dal_ShipToAddressWrapper(){}

        public Dal_ShipToAddressWrapper(DT_Shiptoaddress_Override__c shipToAddressObj){

            this.ID = shipToAddressObj.Id;
            this.AccountId = shipToAddressObj.Accountname_c__c;
            this.Name = shipToAddressObj.Name;
            this.CareOf = shipToAddressObj.Care_Of__c;
            this.Address1 = shipToAddressObj.Address_Line_1__c;
            this.Address2 = shipToAddressObj.Address_Line_2__c;
            this.Address3 = shipToAddressObj.Address_Line_3__c;
            this.Address4 = shipToAddressObj.Address_Line_4__c;
            this.City = shipToAddressObj.City__c;
            this.State = shipToAddressObj.State__c;
            this.Isactive = shipToAddressObj.Default__c;
            this.PostalCode = shipToAddressObj.Postal_code__c;
            this.Country = shipToAddressObj.Country__c;
            this.IsPrimaryLocation = false;
        }

        public Dal_ShipToAddressWrapper(Account account){

            this.Name = account.Name;
            this.AccountId = account.Id;
            this.CareOf = null;
            this.Address1 = account.BillingStreet;
            this.City = account.BillingCity;
            this.State = account.BillingState;
            this.Isactive = true;
            this.IsPrimaryLocation = true;
            this.PostalCode = account.BillingPostalCode;
            this.Country = account.BillingCountry;
        }

        public DT_Shiptoaddress_Override__c toShipToAddressObject(){
            DT_Shiptoaddress_Override__c shipToAddress = new DT_Shiptoaddress_Override__c();
            shipToAddress.Id = ID;
            shipToAddress.Accountname_c__c = AccountId;
            shipToAddress.Name = Name;
            shipToAddress.Care_Of__c = CareOf;
            shipToAddress.Address_Line_1__c = Address1;
            shipToAddress.Address_Line_2__c = Address2;
            shipToAddress.Address_Line_3__c = Address3;
            shipToAddress.Address_Line_4__c = Address4;
            shipToAddress.City__c = City;
            shipToAddress.State__c = State;
            shipToAddress.Default__c = Isactive;
            shipToAddress.Postal_code__c = Postalcode;
            shipToAddress.Country__c = Country;
            shipToAddress.Default__c = false;

            return shipToAddress;
        }
    }
	//search for an Address
    @AuraEnabled
    public static List<Dal_ShipToAddressWrapper> searchAddressForCurrentLocation(String SearchText){
        List<Dal_ShipToAddressWrapper> returnAddressWrappers = new List<Dal_ShipToAddressWrapper>();
        Account currentAccount = Dal_BaseController.getUserSelectedLocation();
		String searchQuery= '%' + SearchText + '%'; 
        
        //search in current address
        List<Account> listAcc=[Select Id from Account where Id=:currentAccount.Id and (Name like: searchQuery or BillingCity like: searchQuery
                            or BillingStreet like: searchQuery or BillingState like: searchQuery or BillingPostalCode like: searchQuery
                                                                             or BillingCountry like: searchQuery)];
        if(listAcc!=null && listAcc.size()>0){
            Dal_ShipToAddressWrapper primaryAddressWrapper = new Dal_ShipToAddressWrapper(currentAccount);
            primaryAddressWrapper.IsPrimaryLocation = true;

            returnAddressWrappers.add(primaryAddressWrapper);
        }
        
        for(DT_Shiptoaddress_Override__c item : [Select Id, Name, Address_Line_1__c,
            				Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,City__c,
            				Country__c,Default__c,Postal_code__c,State__c, Care_Of__c, Accountname_c__c from DT_Shiptoaddress_Override__c
            				where Accountname_c__c =: currentAccount.Id and (Name like: searchQuery or City__c like: searchQuery
                            or State__c like: searchQuery or Postal_code__c like: searchQuery or 
                            Country__c like: searchQuery or Care_Of__c like: searchQuery or
                            Address_Line_1__c like: searchQuery or Address_Line_2__c like: searchQuery or Address_Line_3__c like: searchQuery or Address_Line_4__c like: searchQuery) order by Name]){
                                System.debug('item--->'+item);
                         returnAddressWrappers.add(new Dal_ShipToAddressWrapper(item));

        }
        
           
        return returnAddressWrappers;
    }
}