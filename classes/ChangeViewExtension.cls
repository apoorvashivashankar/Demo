public with sharing class ChangeViewExtension {
    
    public Change_Request__c[] oList{ get; set;}
    
    public ChangeViewExtension(ApexPages.StandardSetController controller) {
        list<Id> changeIds = new list<Id>();
        if(ApexPages.currentPage().getParameters().get('chIds') != null)
            changeIds = ((String)ApexPages.currentPage().getParameters().get('chIds')).split(',');
        
        oList =  [SELECT Id
                  , Name
                  , Customer_Name_Change__c 
                  , Rep_Change_Complete__c 
                  , Suffix_N__c 
                  , SSC_N__c 
                  , Customer_Type_N__c 
                  , Customer_Class_N__c 
                  , Region_n__c 
                  , Phone_N__c 
                  , Fax_N__c 
                  , SBU_N2__c
                  , Billing_Street_N__c 
                  , Shipping_street__c 
                  FROM Change_Request__c 
                  WHERE Id in :changeIds
                  ORDER BY RecordType.Name DESC
                  LIMIT 95];
    }
    
    public PageReference setPrinted()
    {
        id Profile1 = userinfo.getProfileId();
        profile SupportProfile = [select id from profile where name = 'Support']; 
        profile AdminProfile = [select id from profile where name = 'System Administrator']; 
//        profile RVPadminProfile = [select id from profile where name = 'RVP Admin']; 
        for(Change_Request__c c : oList)
        {
            System.debug(':.:.:.:>: Profile making update...=' + Profile1 + ', It can check the sales rep update box if it is this one ='+ SupportProfile);
            If((Profile1 == SupportProfile.id) || (Profile1 == AdminProfile.id)){ 		
              c.Print_Complete__c = TRUE;
              c.Status__c = 'Source System Updated';  
            }
        }
        if(oList.size() > 0)
        {
            try{
                
                update oList;
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: ['+e.getMessage()+']'));
            }
        }
        
        return null;
    }
}