public with sharing class ContactSharingController {
    
    public List<User_to_Location__c> listUserToLocation {get; set;}
    public List<AccountShare> listAccountShare {get; set;}
    public User_to_Location__c theUserToLocation {get;set;}
    public User theUser {get;set;}
    public Boolean showUserToLocation {get;set;}
    public Boolean showAccountShare {get;set;}
    public Contact theContact {get;set;}
    public PageReference linkContact {get;set;}
    public String redirectUrl {get;set;}
    public String theRecordId {get;set;}
    
    public ContactSharingController(ApexPages.StandardController stdController) {

        theRecordId =  String.valueof(stdController.getRecord().get('Id')); 
        System.debug('theRecordId...' + theRecordId);
        theContact = [Select Id, Name, User__c, AccountID, Account.Name, Account.DW_ID__c from Contact WHERE ID = : theRecordId ];
        
        System.debug('theContact.User__c...' + theContact.User__c);
        
        showUserToLocation = false;
        showAccountShare = false;
        
        if (theContact.User__c != null) {
            theUser = [Select Id, Name, Username, ContactID, AccountID, Primary_Account_Group_Key__c from User WHERE ID = : theContact.User__c];
            listUserToLocation = [  SELECT Account__c
                                        , Account__r.Name
                                        , Account__r.DW_ID__c
                                        , Account__r.GroupKey__c
                                        , User__c,Id
                                        , Account__r.Division_Name__r.Name
                                        , Account__r.ShippingCity
                                        , Account__r.Division_Name__r.Code__c 
                                    FROM User_to_Location__c 
                                    WHERE User__c = : theUser.Id 
                                    ORDER BY Account__r.DW_ID__c ASC NULLS LAST];
            
            System.debug('ContactSharingController + listUserToLocation...' + listUserToLocation);
            
            listAccountShare = [SELECT AccountAccessLevel
                                    , CaseAccessLevel
                                    , AccountId
                                    , Account.Name
                                    , Account.DW_ID__c
                                    , Account.GroupKey__c
                                    , UserOrGroupId
                                    , Account.ShippingCity
                                    , UserOrGroup.Name
                                    , RowCause,Id 
                                FROM AccountShare 
                                WHERE UserOrGroupId = : theUser.Id 
                                ORDER BY Account.DW_ID__c ASC NULLS LAST ];
        
            System.debug('ContactSharingController + listAccountShare...' + listAccountShare);                          

            if (listUserToLocation.isEmpty()) {
                showUserToLocation = false;
            } else {
                showUserToLocation = true;
            }
                                    
            if (listAccountShare.isEmpty()) {
                showAccountShare = false;
            } else {
                showAccountShare = true;
            }

        }
        
        System.debug('showUserToLocation...' + showUserToLocation);
        System.debug('showAccountShare...' + showAccountShare);
                                    
        theUserToLocation = new User_to_Location__c();
        linkContact = new PageReference('/' + theContact.Id);
        redirectUrl = ApexPages.currentPage().getHeaders().get('Host');

        System.debug('theRecordId...' + theRecordId);
        System.debug('theContact...' + theContact);
        System.debug('theUser...' + theUser);
        System.debug('listUserToLocation...' + listUserToLocation);
        System.debug('listAccountShare...' + listAccountShare);
        System.debug('linkContact...' + linkContact);
        System.debug('redirectUrl...' + redirectUrl);
    }
    
    public PageReference saveAccountShare() {

        if (theUserToLocation.Account__c != null && theUser != null) {
            String varKey = theUser.id + '.' + theUserToLocation.Account__c;
            User_to_Location__c ul = new User_to_Location__c (Account__c = theUserToLocation.Account__c, User__c = theUser.Id, User_to_Location_Key__c = varKey);

            try { upsert ul User_to_Location_Key__c;} catch(DmlException e) { System.debug('The following ul exception has occurred: ' + e.getMessage());}  

            PageReference pg = new PageReference('/' + theContact.Id);
            return pg;              
        } else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select an account, and make sure this Contact is setup for ProExchange' );
            ApexPages.addMessage(msg);
            return null;            
        }
    }
    

}