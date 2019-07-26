/**
 * Created by 7Summits on 2/13/18.
 */

//public with sharing class Dal_BaseController {
public with sharing class Dal_BaseController  {

    // constant that holds the field we want to query for while getting account information
    private static final String[] ACCOUNT_FIELDS = new String[]{
         'Id', 'Name', 'DW_ID__c','PayerAccount__c', 'DBA_Name__c','SAP_Account_Id__c', 'SBU__c', 'Division__c', 'SSC__c','PO_Required__c','Job_Name_Required__c',
            'ShippingStreet', 'ShippingCity','GroupKey__c', 'ShippingState', 'ShippingPostalCode', 'ShippingCountry', 'Division_Name__c',
            'Division_Name__r.Name','BillingStreet', 'BillingCity','BillingState', 'BillingPostalCode', 'BillingCountry', 'Freight_Term__c', 'Freight_Term__r.Code__c'

    };
        //previous String
      /*         'Id', 'Name', 'DW_ID__c','PayerAccount__c', 'DBA_Name__c','SAP_Account_Id__c', 'SBU__c', 'Division__c', 'SSC__c',
            'BillingStreet', 'BillingCity','GroupKey__c', 'BillingState', 'BillingPostalCode', 'BillingCountry', 'Division_Name__c',
            'Division_Name__r.Name'    */

    private static final String[] DIVISION_CODES_DIST = new String[]{'42', '43', '44'};
    private static final String[] DIVISION_CODES_SSC = new String[]{'40', '41'};

    // hold the user selected Account
    private static Account userSelectedAccount;

    /**
     * Return prefix of the community
     * @return String - Prefix of community
     */
    @AuraEnabled
    public static String getSitePrefix(){
        return Peak_Utils.getSitePrefix();
    }

    /**
     * Return whether the user is logged in or not
     * @return Boolean
     */
    @AuraEnabled
    public static Boolean isGuestUser() {
        return Peak_Utils.isGuestUser();
    }

    /**
     *  Returns the current logged in user
     * @return User
     */
    @AuraEnabled
    public static User getUser(){
        User user;

        // get the user
        List<User> userList = [
            SELECT Id, Selected_Location__c, ProfileId, Division_Code__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];


        // if the user was found set to the user attribute
        if (!Peak_Utils.isNullOrEmpty(userList)) {
            user = userList[0];
        }

        return user;
    }

    /**
     * Return the current users selected location, the selected location will
     * be stored in a class static variable, if that variable is null we will
     * have to query to get the selected location and set it to the static variable.
     *
     * @return Account
     */
    @AuraEnabled
    public static Account getUserSelectedLocation(){
        // check if userSelectedAccount is null, if it is
        // get the Selected_Location__c from the user object,
        // use that id to get the account, set the account
        // to userSelectedAccount and return it.
        if(userSelectedAccount == null) {
            // get the user's selected location
            User user = getUser();
			system.debug('user is '+user+'user.Selected_Location__c'+user.Selected_Location__c);
            // check if the user has a selected location
            if(!String.isBlank(user.Selected_Location__c)){
                userSelectedAccount = getAccountById(user.Selected_Location__c);
                system.debug('userSelectedAccount is '+userSelectedAccount);
            }
        }

        return userSelectedAccount;
    }

    /**
     *  Given a location id, will set that location id to the user object.
     * @param locationId - id of location the user has selected
     * @return Peak_Response
     */
    @AuraEnabled
    public static Peak_Response setUserSelectedLocation(String locationId){
        Peak_Response response = new Peak_Response();

        try {
            // check if locationId is empty
            if(String.isNotBlank(locationId)){
                User user = Dal_BaseController.getUser();
                user.Selected_Location__c = locationId;
                userSelectedAccount = getAccountById(user.Selected_Location__c);
                user.Division_Code__c = userSelectedAccount.Division__c;
                update user;
            } else {
                System.debug('Dal_BaseController: locationId is empty:');
                response.success = false;
                response.messages.add('locationId is empty');
            }

        } catch (Exception e){
            System.debug('Dal_BaseController: An unexpected error has occurred: ' + e.getMessage());
            response.success = false;
            response.messages.add(e.getMessage());
        }

        return response;
    }

    /**
     * Return a list of locations that lookup to this users account
     * @return Peak_Response
     */
    @AuraEnabled
    public static Peak_Response getUserLocations(String communityType){
        Peak_Response response = new Peak_Response();
        List<Account> userLocations = new  List<Account>();

        try {

            // hold division codes
            List<String> divisionCodes = new List<String>();

            // check if we are in the distributor or ssc community
            if(Dal_Constants.COMMUNITY_TYPE_DIST == communityType){
                divisionCodes.addAll(DIVISION_CODES_DIST);
            } else if (Dal_Constants.COMMUNITY_TYPE_SSC == communityType){
                divisionCodes.addAll(DIVISION_CODES_SSC);
            }

            // Use the group key to get all other account with that group key
            userLocations =  Database.query('SELECT ' + String.join(ACCOUNT_FIELDS, ',') + ' FROM Account WHERE Division__c IN :divisionCodes AND Mark_For_Deletion__c = false LIMIT 50000');

            // add all the accounts to the response
            response.results.addAll(userLocations);

        } catch(Exception e) {
            response.success = false;
            response.messages.add(e.getMessage());
        }

        return response;
    }

    /**
     * Return a list of account team member for the users selected location
     * @return Peak_Response
     */
    @AuraEnabled
    public static Peak_Response getAccountTeam(){
        //TODO read user's Selected_Location__c field and query its account team. Assign results list into Peak_Response.results
        Peak_Response response = new Peak_Response();
        return response;
    }

    /**
     * Return a list of account team member for the users selected location
     *
     * @param customSettingInstanceName - Dal_ThemeCustomSettings__c custom setting instance name
     *
     * @return
     */
    @AuraEnabled
    public static Peak_Response getThemeSettings(String customSettingInstanceName){
        Peak_Response response = new Peak_Response();

        try {

            // if we have an instance name return just that settings instance, if
            // not return all the setting instances.
            if(String.isNotBlank(customSettingInstanceName)){
                Dal_ThemeCustomSettings__c themeSetting = Dal_ThemeCustomSettings__c.getInstance(customSettingInstanceName);
                response.results.add(themeSetting);
            } else {
                List<Dal_ThemeCustomSettings__c> allThemeSetting = Dal_ThemeCustomSettings__c.getAll().values();
                response.results = allThemeSetting;
            }

        } catch(Exception e) {
            response.success = false;
            System.debug('Dal_BaseController: An unexpected error has occurred: ' + e.getMessage());
        }

        return response;
    }

    /**
     * Given an accountId will return the account, if not found will return null
     * @param accountId
     *
     * @return Account
     */
    private static Account getAccountById(Id accountId){
        List<Account> account = Database.query('SELECT ' + String.join(ACCOUNT_FIELDS, ',') + ' FROM Account WHERE Id=:accountId');

		system.debug('account is '+account);
        if(!Peak_Utils.isNullOrEmpty(account)){
            return account[0];
        }

        return null;
    }
    /**
     * Given an service name, this method will return the credentials
     * @param service Name
     *
     * @return DT_SYS_Authentication__mdt
     */
    public static DT_SYS_Authentication__mdt getCredentials(String servicename){

        try{
        DT_SYS_Authentication__mdt authentication = [SELECT DT_SYS_Password__c,DT_SYS_UserName__c,MasterLabel
                                                     FROM DT_SYS_Authentication__mdt
                                                   	 WHERE MasterLabel =: servicename];
                    return authentication;
        }
        catch(exception ex){
            system.debug('Exception occured'+ex.getMessage());
            return null; 
        }
    }



    /**
     * Given an orderplantID, will return the SSC Location, if not found will return null
     * @param orderplantID
     *
     * @return location
     */
    public static SSC__c getSSCLocation(String orderplantID){
        try{
            SSC__c location = [Select Name,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c from SSC__c where DW_ID__c =: orderplantID limit 1];
            if(location !=null){
                system.debug('orderplant '+location);
                return location;
            }
            return null;
        }
        catch(exception ex){
            system.debug('Exception occured'+ex.getMessage());
            return null;
        }

    }

     /**
     * Method name : getSessionOrder
     * Purpose to get Order stored in Session Cache.
     * @param Not Any
     * @return String having Order Id
     */
 	@AuraEnabled
    public static String getSessionOrder(){

    	return Dal_SessionController.getSessionOrder();
    }

     /**
     * Method name : setSessionOrder
     * Purpose to set Order in Session Cache.
     * @param Order Id
     * @return Not Any (Void)
     */
    @AuraEnabled
    public static void setSessionOrder(String sessionOrderId){

    	Dal_SessionController.setSessionOrder(sessionOrderId);
    }

    @AuraEnabled
    public static Boolean isValidList(List<SObject> sObjectList){

        if(sObjectList.size() > 0 ) //&& String.isNotBlank(sObjectList[0].id)
        {
            return true;
        }else
        {
            return false;
        }
    }

    @AuraEnabled
    public static boolean deleteDraftOrder(String draftOrderId){
        List<DT_Order__c> orderToDelete = Dal_OrderManager.getOrderById(draftOrderId);

        if(orderToDelete != null && orderToDelete.size() > 0) {
            Dal_OrderManager.cleanupDraftOrders(orderToDelete);
            return true;
        }

        return false;
    }

    @AuraEnabled
    public static String getAcccountCartDetail(String accountId){
        System.debug('accountId-->'+accountId);
        String UserId = UserInfo.getUserId();
        List<DT_Cart_Product__c> cartProductList = [Select Id, Name,Dt_Cart__r.Id,DT_Cart__c From DT_Cart_Product__c Where DT_Cart__r.User__c =: UserId ];
        if(cartProductList.size() > 0){
            System.debug('InIF-->'+cartProductList[0].DT_Cart__c);

            return cartProductList[0].Dt_Cart__r.Id;
        }else{
            System.debug('InElse-->'+cartProductList);
            return null;
        }
    }

    @AuraEnabled
    public static void deleteCart(String cartId){
        system.debug('cartId----'+cartId);
        if (!String.isEmpty(cartId)) {
            DT_Cart__c dtCart = [SELECT Id FROM DT_Cart__c WHERE Id =: cartId];
            if(dtCart != null){
                delete dtCart;
            }
        }
    }
  
}