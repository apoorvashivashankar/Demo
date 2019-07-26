/**
* Created by 7Summits on 3/27/18.
*/
public class Dal_OrderHeaderManager {

	public static String customerId; 
    
    /*
	* Method Name: Dal_OrderHeaderManager
	* Description: Constructor to get logged in user account.
	* @param: Not Any
	* @return Not Any (Void)
	*/
    public Dal_OrderHeaderManager(){
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
    }
	
    /*
	* Method Name: getOrderHeaderByCustomer
	* Description: Constructor to get logged in user account.
	* @param: Not Any
	* @return Not Any (Void)
	*/
    public static List<DT_SYS_OrderHeader__x> getOrderHeaderByCustomer(Id customerId){
        
        List<DT_SYS_OrderHeader__x> orderHeader = new List<DT_SYS_OrderHeader__x>();
        try{
        	orderHeader = [SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c, Account_Address_Line1__c,
        	               Account_Address_Line2__c, Account_Address_Line3__c, Account_Address_Name__c, Account_Address_PostalCode__c,
        	               Total_Materials__c, Total_TaxAmt_City__c, Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c,
        	               Total_TaxRate_City__c, Total_TaxRate_County__c, Total_TaxRate_District__c, Total_TaxRate_State__c, Total_TaxRate__c,
        	               Total_Tax__c, Total_Total__c, Total_Weight__c, id__c FROM DT_SYS_OrderHeader__x WHERE SalesOrder__c =: customerId ];


        } catch(Exception exp){
            System.debug('getOrderHeaderByCustomer: An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderHeader;
    }
    
    /*
	* Method Name: getOrderHeaderByStatus
	* Description: Purpose to get data from external object 'DT_SYS_OrderHeader__x' on basis of Status field.
	* @param: Status__c
	* @return List of Order Header
	*/
    public static List<DT_SYS_OrderHeader__x> getOrderHeaderByStatus(String statusValue){
        
        List<DT_SYS_OrderHeader__x> orderHeader = new List<DT_SYS_OrderHeader__x>();
        try{
        	orderHeader = [SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c,Status__c, Account_Address_Line1__c,
        	               Account_Address_Line2__c, Account_Address_Line3__c, Account_Address_Name__c, Account_Address_PostalCode__c,
        	               Total_Materials__c, Total_TaxAmt_City__c, Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c,
        	               Total_TaxRate_City__c, Total_TaxRate_County__c, Total_TaxRate_District__c, Total_TaxRate_State__c, Total_TaxRate__c,
        	               Total_Tax__c, Total_Total__c, Total_Weight__c, id__c FROM DT_SYS_OrderHeader__x WHERE SalesOrder__c =: customerId AND Status__c =: statusValue ];


        } catch(Exception exp){
            System.debug('getOrderHeaderByStatus: An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderHeader;
    }
	
    /*
	* Method Name: getOrderHeaderByOrderNo
	* Description: Purpose to get data from external object 'DT_SYS_OrderHeader__x' on basis of Order N umber field.
	* @param: orderNo
	* @return  List of Order Header
	*/
    public static List<DT_SYS_OrderHeader__x> getOrderHeaderByOrderNo(Id orderNo){
        
        List<DT_SYS_OrderHeader__x> orderHeader = new List<DT_SYS_OrderHeader__x>();
        try{
        	orderHeader = [SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c,Status__c, Account_Address_Line1__c,
        	               Account_Address_Line2__c, Account_Address_Line3__c, Account_Address_Name__c, Account_Address_PostalCode__c,
        	               Total_Materials__c, Total_TaxAmt_City__c, Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c,
        	               Total_TaxRate_City__c, Total_TaxRate_County__c, Total_TaxRate_District__c, Total_TaxRate_State__c, Total_TaxRate__c,
        	               Total_Tax__c, Total_Total__c, Total_Weight__c, id__c FROM DT_SYS_OrderHeader__x WHERE ExternalId =: customerId AND  Id =: orderNo];


        } catch(Exception exp){
            System.debug('getOrderHeaderByOrderNo: An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderHeader;
    }
    

}