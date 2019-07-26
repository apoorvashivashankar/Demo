/**
 * Created by 7Summits on 4/5/18. 
 */
public  without sharing class Dal_PriceBook {

	public String customer {get; set;}
      public string username {get;set;}
    public string password {get;set;}
    public string theme {get;set;}
    Public string BrandName{get;set;}
    public Dal_PriceBook(){
         
         BrandName = ApexPages.currentPage().getParameters().get('brandName')!=null? ApexPages.currentPage().getParameters().get('brandName'):'';
         system.debug('BrandName'+BrandName);
        	 	Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
	      	theme = Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c)? 'red':'blue';
        system.debug('Theme '+theme);         
        system.debug('selectedAccount '+selectedAccount);
        		customer = selectedAccount.DW_ID__c;
        system.debug('customer'+customer);
        DT_SYS_Authentication__mdt auth = Dal_BaseController.getCredentials('AllServices');
        try{
            username = auth.DT_SYS_UserName__c;
            password = auth.DT_SYS_Password__c;
        }Catch(Exception e)
        {
            
        }
        
    } 
     
}