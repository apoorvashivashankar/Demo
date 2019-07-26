/**
* Created by 7Summits on 6/9/18.
**/
public class Dal_NavigationController {

    /*
    * Method Name: getNavigationMenuVisibilities
    * Description: Method used to set navigation menu visibility
    * @param: None
    * @return Map<String,Boolean>
    */
    @TestVisible
    public static String profileName ='' ;
    @TestVisible
    public static String communityName = '';

    @AuraEnabled
    public static Map<String, Boolean> fetchNavMenuVisibilty(){
        Map<String, Boolean> navigationMap = new Map<String, Boolean>();

        try{
            // For Profile
            if(test.isRunningTest()){
            }
            else{
                profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
                communityName = [Select Id,Name from Network where Id=:Network.getNetworkId()].Name;
            }
        }
        catch(Exception e)
        {
            System.debug('IN Catch Exception--->'+e.getMessage());
        }
        //String profileName = Dal_Constants.SSC_SALES_REP;
        //String communityName = Dal_Constants.SSC_COMMUNITY;
        if(profileName == Dal_Constants.DIST_CUST_SERVICE && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            navigationMap.put('Start An Order', false);
            navigationMap.put('Quick Order (SKU)',false);
            navigationMap.put('Order Samples', false) ;
            navigationMap.put('Retrieve Saved Draft Order',true);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',false);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',false);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.DIST_PURCHASER && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            navigationMap.put('Start An Order', true);
            navigationMap.put('Quick Order (SKU)',true);
            navigationMap.put('Order Samples', true) ;
            navigationMap.put('Retrieve Saved Draft Order',true);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',true);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',false);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.DIST_ACCOUNTING && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){

            navigationMap.put('Start An Order', false);
            navigationMap.put('Quick Order (SKU)',false);
            navigationMap.put('Order Samples', false) ;
            navigationMap.put('Retrieve Saved Draft Order',false);
            navigationMap.put('Check Product Availability',false);
            navigationMap.put('Check My Pricing',true);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',false);
            navigationMap.put('My Account',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',false);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.DIST_SALES_REP && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            navigationMap.put('Start An Order', true);
            navigationMap.put('Quick Order (SKU)',false);
            navigationMap.put('Order Samples', true) ;
            navigationMap.put('Retrieve Saved Draft Order',false);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',false);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',true);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.DIST_SALES_REP_1 && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            navigationMap.put('Start An Order', true);
            navigationMap.put('Quick Order (SKU)',false);
            navigationMap.put('Order Samples', true) ;
            navigationMap.put('Retrieve Saved Draft Order',false);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',false);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',false);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.DIST_LEADER_PRINCIPLE && communityName == Dal_Constants.DISTRIBUTOR_COMMUNITY){
            navigationMap.put('Start An Order', true);
            navigationMap.put('Quick Order (SKU)',true);
            navigationMap.put('Order Samples', true) ;
            navigationMap.put('Retrieve Saved Draft Order',true);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',true);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',true);
            navigationMap.put('Leads',false);
            navigationMap.put('New menu item',true);

        }else if(profileName == Dal_Constants.SSC_CUST_SERVICE && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_PURCHASER  && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_PURCHASER_II  && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_ACCOUNTING && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',false);
            navigationMap.put('My Account',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_SALES_REP && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_LEADER_PRINCILPLE && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Sales Leads',false);
            navigationMap.put('My Leads',false);
            navigationMap.put('My Opportunities',false);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_DEALER_SALES_REP && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',false);
            navigationMap.put('My Account Overview',false);
            navigationMap.put('Accounts',false);
            navigationMap.put('Contacts',false);
            navigationMap.put('Credits',false);
            navigationMap.put('Invoices',false);
            navigationMap.put('Pricing',false);
            navigationMap.put('Statements',false);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Leads',true);
            navigationMap.put('Sales Leads',true);
            navigationMap.put('My Leads',true);
            navigationMap.put('My Opportunities',true);
            navigationMap.put('Products',true);

        }else if(profileName == Dal_Constants.SSC_DEALER_LEADER_PRINCILPLE && communityName == Dal_Constants.SSC_COMMUNITY){
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Leads',true);
            navigationMap.put('Sales Leads',true);
            navigationMap.put('My Leads',true);
            navigationMap.put('My Opportunities',true);
            navigationMap.put('Products',true);
        }else{

            navigationMap.put('Start An Order', true);
            navigationMap.put('Quick Order (SKU)',true);
            navigationMap.put('Order Samples', true) ;
            navigationMap.put('Retrieve Saved Draft Order',true);
            navigationMap.put('Check Product Availability',true);
            navigationMap.put('Check My Pricing',true);
            navigationMap.put('My Dashboard',true);
            navigationMap.put('My Orders',true);
            navigationMap.put('My Account',true);
            navigationMap.put('Support',true);
            navigationMap.put('Support Overview',true);
            navigationMap.put('Knowledge & FAQs',true);
            navigationMap.put('Opportunities',true);
            navigationMap.put('Leads',true);
            navigationMap.put('New menu item',true);
            navigationMap.put('My Account Overview',true);
            navigationMap.put('Accounts',true);
            navigationMap.put('Contacts',true);
            navigationMap.put('Credits',true);
            navigationMap.put('Invoices',true);
            navigationMap.put('Pricing',true);
            navigationMap.put('Statements',true);
            navigationMap.put('Sales Leads',true);
            navigationMap.put('My Leads',true);
            navigationMap.put('My Opportunities',true);
            navigationMap.put('Products',true);
        }
        navigationMap.put('Home', false);

        return navigationMap;
    }
}