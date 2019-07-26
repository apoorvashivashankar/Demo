public class LeadGateway {

    // public static void catchDuplicates  (Set<Id> setLeadId) {
        

    // }
    
    public static List<Lead> assignDealerLead  (Set<Id> setLeadId) {
        List <User> listUserSearch = new List <User> ();
        List <Contact> listContactSearch = new List <Contact> ();
        List <Account> listAccountSearch = new List <Account> ();
        List <Account> listAccountGroupKeySearch = new List <Account> ();
        List <Lead> listLeadUpdates = new List<Lead>();
        Integer varNumberOfContacts;
        String varDealerEmail;
        String varDealerId;
        String varDealerGroupKey;
        String varLeadSource;
        
        ID varStatementsQueue = [SELECT ID FROM Group WHERE DeveloperName = 'Website_Leads'].Id;
        
        List<Lead> lList = [SELECT Id
                                , Name 
                                , Dealer_Email__c
                                , did__c
                                , LeadSource	
                            FROM Lead 
                            WHERE Id IN :setLeadId];  
                            
        for (Lead l: lList) {
            if (l.LeadSource == 'Website') {
                varDealerEmail = l.Dealer_Email__c;
                varDealerId = l.did__c;
            }
        }
        
        if (varDealerEmail != ''  && varDealerEmail != null) {
            listUserSearch = [ SELECT
                                    Id
                                    , Name
                                    , Email
                                FROM User
                                WHERE Email = : varDealerEmail
                                AND IsPortalEnabled = true
                                AND Profile.Name LIKE '%Statement%'
                                AND IsActive = true
                                LIMIT 1
            ];
            
            listContactSearch = [   SELECT
                                        Id
                                        , Name
                                        , User__c
                                        , Email
                                        , Account.DW_ID__c
                                        , User_Profile__c
                                    FROM Contact
                                    WHERE Email = : varDealerEmail
                                    LIMIT 1
            ];               
        }
        
        System.debug('::::LeadGateway + varDealerId' + varDealerId);       
        System.debug('::::LeadGateway + listContactSearch' + listContactSearch);       
        System.debug('::::LeadGateway + listUserSearch' + listUserSearch);       
        
        if (varDealerId != '' && varDealerId != null) {
            listAccountSearch = [    SELECT
                                        Id
                                        , Name
                                        , GroupKey__c
                                        , DW_ID__c
                                        , (SELECT Id 
                                            	, Name 
                                            	, Email
                                            	, User__c
                                            	, User__r.Name
                                            	, User__r.Profile.Name
                                            	, User__r.UserType
                                            	, User_Profile__c
                                            FROM  Contacts
                                            WHERE User__c != NULL)
                                            // AND  User__r.IsPortalEnabled = true
                                            // AND User__r.Profile.Name LIKE '%Statement%'
                                            // AND User__r.IsActive = true)
                                    FROM Account
                                    WHERE DW_ID__c = : varDealerId
                                    LIMIT 1
            ];        
            
            for (Account a : listAccountSearch) {
                varDealerGroupKey = a.GroupKey__c;
                varNumberOfContacts = a.Contacts.size();
                System.debug('::::LeadGateway + varDealerGroupKey' + varDealerGroupKey);
                System.debug('::::LeadGateway + varNumberOfContacts' + varNumberOfContacts);
            }
            
            // if (varNumberOfContacts == 0) {
                listAccountGroupKeySearch = [   SELECT
                                                    Id
                                                    , Name
                                                    , DW_ID__c
                                                    , GroupKey__c
                                                    , (SELECT Id 
                                                        	, Name 
                                                        	, Email
                                                        	, User__c
                                                        	, User__r.Name
                                                        	, User__r.Profile.Name
                                                        	, User__r.UserType
                                                        	, User_Profile__c
                                                        FROM  Contacts
                                                        WHERE User__c != NULL)
                                                        // AND  User__r.IsPortalEnabled = true
                                                        // AND User_Profile__c LIKE '%Statement%'
                                                        // AND User__r.IsActive = true)
                                                FROM Account
                                                WHERE GroupKey__c = : varDealerGroupKey
                ];        
            // }
        }
        
        System.debug('::::LeadGateway + listAccountSearch' + listAccountSearch);       
        System.debug('::::LeadGateway + listAccountGroupKeySearch' + listAccountGroupKeySearch);       
        
        for (Lead l: lList) {
            if (l.LeadSource == 'Website') {
                System.debug('::::LeadGateway + l' + l);  
                // Dealer Assignment here...
                /*
                
                1. we search  with Dealer Email
                    a) Find a match with a User 
                        Assign Lead to Communities User
                */
                if (l.Dealer_Email__c != '') {
                    System.debug('::::LeadGateway + listUserSearch:  ' + listUserSearch);

                    for (User u:listUserSearch) {
                        l.OwnerId = u.Id;
                        listLeadUpdates.add(l);
                    }
                    System.debug('::::LeadGateway + listLeadUpdates:  ' + listLeadUpdates);
                    if (listLeadUpdates.isEmpty()) {
                        for (Contact c:listContactSearch) {
                            if (c.User__c != NULL && c.User_Profile__c.contains('Statement')) {
                                l.OwnerId = c.User__c;
                                listLeadUpdates.add(l);
                            } else {
                                System.debug('::::LeadGateway didnt find an email match');
                            }
                        }
                    }
                    
                } 
                if (l.did__c != '' && listLeadUpdates.isEmpty()) {
                    for (Account a:listAccountGroupKeySearch) {
                        System.debug('::::LeadGateway now trying by account: ' + l.did__c);
                        /*
                        2. we have to search by account # (did__c)
                            a) Find a match with an Account 
                                Account 
                        */                        
                        System.debug('::::LeadGateway  + listAccountSearch: ' + listAccountSearch);
                        if (a.DW_ID__c == varDealerId) {
                            for (Contact ac:a.Contacts) {
                                System.debug('::::LeadGateway  + ac: ' + ac);
                                if (listLeadUpdates.isEmpty() && ac.User_Profile__c.contains('Statement')) {
                                    System.debug('::::LeadGateway  + new lead owner being assigned: ' + ac.User__r.Name);
                                    l.OwnerId = ac.User__c;
                                    listLeadUpdates.add(l);
                                } 
                            }
                        }
                        /*
                        2.5 we have to search by account groupkey (GroupKey__c)
                        */                        
                        if (listLeadUpdates.isEmpty()){
                            for (Contact ac:a.Contacts) {
                                System.debug('::::LeadGateway  + ac: ' + ac);
                                if (listLeadUpdates.isEmpty() && ac.User_Profile__c.contains('Statement')) {
                                    System.debug('::::LeadGateway  + new lead owner being assigned: ' + ac.User__r.Name);
                                    l.OwnerId = ac.User__c;
                                    listLeadUpdates.add(l);
                                } 
                            }
                        }
                    }
                }
                
                /*
                3. we cant get a match
                */
                
                if (listLeadUpdates.isEmpty()) {
                    // assign to a generic 
                    // future phase notifty to add a communities member for this dealer
                    l.OwnerId = varStatementsQueue;
                    listLeadUpdates.add(l);                    
                }
            }
        }       
        System.debug('::::LeadGateway + listLeadUpdates: ' + listLeadUpdates);
        return listLeadUpdates;
    }
}