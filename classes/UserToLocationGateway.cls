public class UserToLocationGateway {
    
    public static List <AccountShare> createAccountShare (map<Id,SObject> newMap) {
        // System.debug('::::UserToLocationGateway + createAccountShare: ' + newMap);      
        List<AccountShare> listAccountShare = new List<AccountShare>();
        
        for (Id idKey : newMap.keyset()) {
            User_to_Location__c u2l = (User_to_Location__c)newMap.get(idKey);        
            if(u2l.User__c != null && u2l.Account__c != null && !u2l.User_Profile__c.contains('Gallery')) {
                AccountShare a = new AccountShare (UserOrGroupId = u2l.User__c, AccountID = u2l.Account__c, accountaccesslevel='Read', OpportunityAccessLevel='Read');
                listAccountShare.add(a);
            }
        }
        
        return listAccountShare;
    }    
    
    public static List <User_to_Location__c> createGroupKeySharing (map<Id,SObject> newMap) {
        // System.debug('::::UserToLocationGateway + createGroupKeySharing: ' + newMap);          
        List < User_to_Location__c > listUserToLocation = new List<User_to_Location__c> ();
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        User_to_Location__c u2l = (User_to_Location__c)newMap.get(idKeySet);
        List<AccountShare> listAccountShare = new List<AccountShare>();
        
        if(u2l.User__c != null && u2l.Account__c == null && u2l.Share_GroupKey__c == true && !String.isBlank(u2l.GroupKey__c) ) {
            // System.debug('::::UserToLocationGateway + createGroupKeySharing + u2l: ' + u2l);       
            List <Account> listGroupKeyAccounts = [SELECT ID
                                                        , Name
                                                        , GroupKey__c
                                                    From Account
                                                    WHERE GroupKey__c = : u2l.GroupKey__c
                                                    LIMIT 100];
            for (Account a : listGroupKeyAccounts) {
                User_to_Location__c ul = new User_to_Location__c ();
                ul.Account__c = a.Id;
                ul.User__c = u2l.User__c;
                String varKey = u2l.User__c + '.' + a.Id;
                ul.User_to_Location_Key__c = varKey;
    
                listUserToLocation.add(ul);
            }
        }
        // System.debug('::::UserToLocationGateway + createGroupKeySharing + listUserToLocation: ' + listUserToLocation); 
        return listUserToLocation;
    }    
    
    public static List <Account> updateProExchangeAccount (map<Id,SObject> newMap) {
        // System.debug('::::UserToLocationGateway + updateProExchangeAccount: ' + newMap);          
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        User_to_Location__c u2l = (User_to_Location__c)newMap.get(idKeySet);
        List<Account> listAccounts= new List<Account>();
        List<Account> listAccountsForUpdate = new List<Account>();
        
        List <User> listUsers = new List <User> ();
        String varGroupKey;
        
        listUsers = [SELECT ID, Primary_Account_Group_Key__c FROM User WHERE ID = : u2l.User__c];
        for (User u : listUsers) {
            varGroupKey = u.Primary_Account_Group_Key__c;
        }
        
        if(u2l.User__c != null && u2l.Account__c != null && !u2l.User_Profile__c.contains('Gallery')) {
            listAccounts = [SELECT ID, Communities_Member__c, GroupKey__c
                                    FROM Account
                                    WHERE GroupKey__c = : varGroupKey
                                    AND Communities_Member__c != true
                                    AND GroupKey__c != null
                                    LIMIT 100];
            for (Account a: listAccounts) {
                a.Communities_Member__c = true;
                listAccountsForUpdate.add(a);
            }
        }

        // System.debug('::::UserToLocationGateway + updateProExchangeAccount + listAccountsForUpdate...: ' + listAccountsForUpdate);   
        return listAccountsForUpdate;
    }        
    
    public static List <Contact> updateProExchangeContact (map<Id,SObject> newMap) {
        // System.debug('::::UserToLocationGateway + updateProExchangeContact: ' + newMap);          
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        User_to_Location__c u2l = (User_to_Location__c)newMap.get(idKeySet);
        List<Contact> listContacts= new List<Contact>();
        List<Contact> listContactsForUpdate = new List<Contact>();
        
        List <User> listUsers = new List <User> ();
        String varContactId;
        Boolean varHasPrimary = false;
        
        listUsers = [SELECT ID, Primary_Account_Group_Key__c, Primary_Account_Number__c	, ContactId, Contact.Primary__c FROM User WHERE Primary_Account_Number__c = : u2l.Users_Account_Number__c];
        for (User u : listUsers) {
            if (u.ID == u2l.User__c) {
                varContactId = u.ContactId;
            }
            if (u.Contact.Primary__c == true){
                varHasPrimary = true;
            }
        }
        
        // System.debug('::::UserToLocationGateway + updateProExchangeContact + listUsers: ' + listUsers);   
        if(u2l.User__c != null && u2l.Account__c != null && !u2l.User_Profile__c.contains('Gallery')) {
            listContacts = [SELECT ID, User__c, email
                                    FROM Contact
                                    WHERE Id = : varContactId
                                    LIMIT 1];
            // System.debug('::::UserToLocationGateway + updateProExchangeContact + listContacts: ' + listContacts);   
            for (Contact c: listContacts) {
                if (c.User__c == null) {
                    c.User__c = u2l.User__c;
                }
                if (varHasPrimary != true ){
                    c.Primary__c = true;
                }
                
                listContactsForUpdate.add(c);
            }
        }

        // System.debug('::::UserToLocationGateway + updateProExchangeContact + listContactsForUpdate...: ' + listContactsForUpdate);   
        return listContactsForUpdate;
    } 
    
    public static List <AccountShare> deleteSharing() {
        // System.debug('::::UserToLocationGateway + deleteSharing + trigger.old...' + trigger.old);          

        List < User_to_Location__c > listUserToLocation = new List<User_to_Location__c> ();
        List < AccountShare > listRecordsDelete = new List < AccountShare > ();
        
        for (SObject so : trigger.old) {
            User_to_Location__c theUserToLocation = (User_to_Location__c)so;
            listUserToLocation.add(theUserToLocation);
        }
        // System.debug('::::UserToLocationGateway + deleteSharing + listUserToLocation...' + listUserToLocation);    
        listRecordsDelete = searchAccountShare(listUserToLocation);
        return listRecordsDelete;
    }
    
    public static List<AccountShare> searchAccountShare(List < User_to_Location__c > listUserToLocation){
        
        List < AccountShare > listAccountShareSearch = new List < AccountShare > ();
        List < AccountShare > listAccountShareReturn = new List < AccountShare > ();
        Map < String, User_to_Location__c > mapUserToLocation = new Map < String, User_to_Location__c > ();
        
        for (User_to_Location__c u2l : listUserToLocation) {
            if (u2l.User__c != null) {
                mapUserToLocation.put(u2l.User__c,u2l);
            }
        }
        
        listAccountShareSearch = [SELECT AccountId
                            	,Account.DW_ID__c
                            	,UserOrGroupId
                            	,Id
                            FROM AccountShare
                            WHERE UserOrGroupId IN : mapUserToLocation.keySet()
                            ];
        // System.debug('::::UserToLocationGateway + searchAccountShare + listAccountShareSearch...' + listAccountShareSearch);    

        for (AccountShare s : listAccountShareSearch) {
            for (User_to_Location__c u2l : listUserToLocation) {
                if (s.AccountId == u2l.Account__c && s.UserOrGroupId == u2l.User__c) {
                    listAccountShareReturn.add(s);
                }
            }
        }
        
        return listAccountShareReturn;
    }
    
}