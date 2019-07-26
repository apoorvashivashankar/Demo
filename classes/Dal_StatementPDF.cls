public with sharing class Dal_StatementPDF {
    
    public string payer {get;set;}
    public string salesorg {get;set;}
    public string sdate {get;set;}
    public string username {get;set;}
    public string password {get;set;}
    public string theme {get;set;}
    
    public Dal_StatementPDF(){  

        String filename = Apexpages.currentpage().getparameters().get('filename');
        sdate = Apexpages.currentpage().getparameters().get('sdate');
        System.debug('filename--from URl---'+filename);   
        List<String> pdfparams = filename.split('_');
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
      	theme = Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c)? 'red':'blue';
        system.debug('Theme '+theme);
        DT_SYS_Authentication__mdt auth = Dal_BaseController.getCredentials('AllServices');
        username = auth.DT_SYS_UserName__c;
        password = auth.DT_SYS_Password__c;
        
   		System.debug('selectedAccount.GroupKey__c---->'+selectedAccount.GroupKey__c);
        //Throw error
        if(pdfparams[0].contains(selectedAccount.SAP_Account_Id__c)){
            //account and the statement payer are matched - user has access.
            //success scenario - Autneticated user
            payer = pdfparams[0];
            salesorg = pdfparams[1];
            system.debug('sdate'+sdate+'payer is '+payer);
        }else{
            //throw error in vf page - say Not Authorised to view this page.
            //Apex.set errormessage
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You dont have access to this Statement'));
            System.debug('Group Key Not Found');
        }     
    }  
   
}