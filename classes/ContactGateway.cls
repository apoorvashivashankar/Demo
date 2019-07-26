public without sharing class ContactGateway {

    public static void validate() {
        // System.debug('::::ContactGateway + validate...');   
        validateContact();
        validateAccount();
    }

    public static void validateContact() {
        // System.debug('::::ContactGateway + validateContact...'); 
        String varCustomerAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        Boolean checkReadyForAccountRequest;
        Set <String> setEmails = new Set <String>();
        Contact oldContact = new Contact();
        Contact newContact = new Contact();
        if (Trigger.isUpdate) {
            // System.debug('::::CaseGateway + createRepTask + Trigger.isUpdate...');
            for (SObject so : trigger.old) {
                oldContact = (Contact)so;
            }         
            for (SObject so : trigger.new) {
                newContact = (Contact)so;
            } 
            if (oldContact.Set_Up_As_Principal_ProExchange_User__c != true && newContact.Set_Up_As_Principal_ProExchange_User__c == true) {
                setEmails.add(newContact.email);
            }
            if (oldContact.Ready_for_ProExchange_User__c != true && newContact.Ready_for_ProExchange_User__c == true) {
                checkReadyForAccountRequest = true;
            }
        } else if (Trigger.isInsert) {
            for (SObject so : trigger.new) {
                newContact = (Contact)so;
            } 
            if (newContact.Set_Up_As_Principal_ProExchange_User__c == true) {
                setEmails.add(newContact.email);
            }
        }

        List <User> listUsers = new List <User>();
        if (!setEmails.isEmpty()) {
            listUsers = [SELECT ID, Name, Email, AccountID, Account.Name, Account.DW_ID__c, ContactID, Contact.Name, IsActive
                        FROM User
                        WHERE UserName IN : setEmails ];
        }
        // System.debug('::::ContactGateway + listUsers...' + listUsers); 
        for (SObject so : trigger.new) {
            Contact theContact = (Contact)so;
            if (theContact.MailingLatitude == null) {
                theContact.MailingStreet = theContact.MailingStreet + ' ';
            }
            // System.debug('::::ContactGateway + theContact.Set_Up_As_Principal_ProExchange_User__c...' + theContact.Set_Up_As_Principal_ProExchange_User__c);
            // System.debug('::::ContactGateway + theContact.ProExchange_User__c...' + theContact.ProExchange_User__c); 
            if (theContact.Set_Up_As_Principal_ProExchange_User__c == true && theContact.ProExchange_User__c != true) {
                // System.debug('::::ContactGateway + theContact.Account_Record_Type_ID__c...' + theContact.Account_Record_Type_ID__c); 
                // System.debug('::::ContactGateway + varCustomerAccountRecordType...' + varCustomerAccountRecordType); 
                // System.debug('::::ContactGateway + theContact.Account_Nbr__c...' + theContact.Account_Nbr__c); 
                // System.debug('::::ContactGateway + theContact.Account_Nbr__c...' + theContact.Account_Nbr__c); 
                // System.debug('::::ContactGateway + theContact.email...' + theContact.email); 
                if (String.isBlank(theContact.email)) {
                    theContact.addError(' Contact must have a valid email to create as ProExchange User.');
                } else {
                    Set <String> setInvalidEmail = new Set <String> {'daltile', 'americanolean', 'marazzitile', 'ao-marazzi', 'mohawkind', 'keysgranite' };
                    for (String s : setInvalidEmail) {
                        if (theContact.email.contains(s) ) {
                            theContact.addError(' Sorry, ProExchange is for Customers only, not employees.');
                        }                        
                    }
                    if (!listUsers.isEmpty()) {
                        for (User u : listUsers) {
                            System.debug('::::ContactGateway + u...' + u); 
                            if (u.IsActive == true) {
                                theContact.addError(' Sorry, it looks like we already have a ProExchange user setup with that information.  Contact: ' + u.Contact.Name + ', on Account:' + u.Account.Name + ' / ' + u.Account.DW_ID__c);
                            }
                        }
                    }
                }
                if (theContact.User__c != null && checkReadyForAccountRequest == true) {
                    theContact.addError(' Cant check Ready for ProExchange once a User has already been created.');
                }
                if (String.isBlank(theContact.FirstName)) {
                    theContact.addError(' Contact must have a valid First Name to create as ProExchange User.');
                } else if (theContact.FirstName.length() <= 1){
                    theContact.addError(' Contact must have a valid First Name to create as ProExchange User.');
                }
                if (theContact.LastName.length() <= 1){
                    theContact.addError(' Contact must have a valid Last Name to create as ProExchange User.');
                }
                if (theContact.FirstName == theContact.LastName) {
                    theContact.addError(' Contacts for ProExchange can not have the same First and Last Name.');
                }
                if (String.isBlank(theContact.Account_Nbr__c)) {
                    theContact.addError(' Sorry, ProExchange is for Contacts on Customer Accounts only.');
                } else if (theContact.Account_Nbr__c.contains('054100')) {
                    theContact.addError(' Sorry, ProExchange is for Contacts on Customer Accounts only, not 054100 Accounts.');
                }
            }
        }
    }
    
    public static void validateAccount() {
        // System.debug('::::ContactGateway + validateOwner...');          
        List<Contact> listContact = new List<Contact> ();
        Map<ID, Contact> mapAccountContact = new Map<ID, Contact>();
        Map<ID, Case> mapAccountCase = new Map<ID, Case>();
        Map<ID, Account> mapOwnerAccount = new Map<ID, Account>();
        Map<ID, Contact> mapCaseContact = new Map<ID, Contact>();
        
        for (SObject so : trigger.new) {
            Contact theContact = (Contact)so;
            listContact.add(theContact);
            mapAccountContact.put(theContact.AccountId, theContact);
            if (theContact.Case__c != null) {
                mapCaseContact.put(theContact.Case__c, theContact);
            }
        }
        // System.debug('::::ContactGateway + mapAccountContact:...' + mapAccountContact);
        // System.debug('::::ContactGateway + mapCaseContact:...' + mapCaseContact);
        
        List<Case> listCase = [SELECT Id, AccountID, ContactID, Status from Case where ID = : mapCaseContact.keySet()];
        for (Case c:listCase) {
            mapAccountCase.put(c.AccountID, c);
        }
        // System.debug('::::ContactGateway + listCase:...' + listCase);
        // System.debug('::::ContactGateway + mapAccountCase:...' + mapAccountCase);

        List<Account> listAccount = [SELECT Id, Name, OwnerId FROM Account WHERE Id = : mapAccountCase.keySet() ];
        for (Account a:listAccount) {
            mapOwnerAccount.put(a.OwnerId, a);
        }
        // System.debug('::::ContactGateway + listAccount:...' + listAccount);
        
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccount = defaultAccount.Default_Temp_Account_Id__c;  
        // System.debug('::::ContactGateway + varDefaultAccount:...' + varDefaultAccount);
        
        List<User> listUser = [SELECT Id, Name, IsActive FROM User WHERE Id = : mapOwnerAccount.keySet() ];
        
        for (Contact c : listContact) {
            // System.debug('::::ContactGateway + c:...' + c);        
            if (c.Case__c != null && c.AccountID == varDefaultAccount) {
                for (Case cs:listCase) {
                    // System.debug('::::ContactGateway + cs:...' + cs);        
                    for (Account a:listAccount) {
                        for (User u :listUser) {
                            // System.debug('::::ContactGateway + u:...' + u);
                            if (c.Case__c == cs.ID && cs.Status != 'Closed' && cs.AccountID != varDefaultAccount && c.AccountID == varDefaultAccount){
                                c.AccountId = cs.AccountID;
                            }
                            if (a.OwnerId == u.Id && u.IsActive == true) {
                                c.OwnerId = u.Id;
                            }
                        }
                    }
                }
            }
        }        
        
    }

    public static List<Case> createProExchContact (map<Id,SObject> newMap) {
        // System.debug('::::ContactGateway + createProExchContact: ' + newMap);          
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        Contact cnt = (Contact)newMap.get(idKeySet);
        List<Case> listCase = new List<Case>();
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;     
        
        if(cnt.Case__c != null) {
            if (cnt.AccountID == varDefaultAccountId) {
                listCase = setupCustomerRequest(cnt.Case__c);
            } else {
                listCase = updateCaseContact(cnt.Case__c, cnt.Id);
            }
        }
        
        return listCase;
    }

   public static List<Case> updateProExchContact (map<Id,SObject> newMap, map<Id,SObject> oldMap) {
          
        // System.debug('::::ContactGateway + updateProExchContact: ' + newMap);           
        // System.debug('::::ContactGateway + updateProExchContact: ' + oldMap);          
        
        Id oldIdKeySet = (new list<ID>(newMap.keySet())[0] );
        Id newIdKeySet = (new list<ID>(newMap.keySet())[0] );
        Contact oldCnt = (Contact)oldMap.get(oldIdKeySet);
        Contact newCnt = (Contact)newMap.get(newIdKeySet);

        Decimal oldMailingLongitude = oldCnt.MailingLongitude;
        Decimal oldMailingLatitude = oldCnt.MailingLatitude;
        Decimal newMailingLongitude = newCnt.MailingLongitude;
        Decimal newMailingLatitude = newCnt.MailingLatitude;
        Boolean newProExchangeReady = newCnt.Ready_for_ProExchange_User__c;
        Boolean oldProExchangeReady = oldCnt.Ready_for_ProExchange_User__c ;   
        Boolean newProExchangeSetup = newCnt.Set_Up_As_Principal_ProExchange_User__c;
        Boolean oldProExchangeSetup = oldCnt.Set_Up_As_Principal_ProExchange_User__c ;       

        // System.debug('::::ContactGateway + newMailingLongitude: ' + newMailingLongitude);           
        // System.debug('::::ContactGateway + newCnt.Case__c: ' + newCnt.Case__c);   
        // System.debug('::::ContactGateway + newProExchangeReady: ' + newProExchangeReady);           
        // System.debug('::::ContactGateway + oldProExchangeReady: ' + oldProExchangeReady);         
        
        List<Case> listCase = new List<Case>();
        if( newCnt.Case__c != null ) {
            if ( newProExchangeReady == true && oldProExchangeReady != true ) {
                if (newMailingLongitude != null) {
                    listCase = setupCustomerRequest(newCnt.Case__c);
                } else {
                    newCnt.addError('Can not geocode the Address, please double check and make sure it is valid.');
                }
            } else {
                if ( newProExchangeSetup != true && oldProExchangeSetup == true ) {
                  // undoing the checkbox, update for everything else.
                } else {
                   listCase =  updateCaseContact(newCnt.Case__c, newCnt.Id);
                }
            }
        }
        return listCase;
    }

    public static List<Case> setupCustomerRequest (String caseID){
        
        // System.debug('::::ContactGateway + setupCustomerRequest...: ');   

		List<Account> listCashAccount = new List<Account> ();
		List<Account> listSBUCashAccounts = new List<Account> ();                              
        Double contactLon;
        Double contactLat;
        Boolean accountSC;
        Boolean accountAS;
        List<Case> listCaseUpdates = new List<Case> ();
        List<Case> listCase = [SELECT Id
                                    , CaseNumber
                                    , ContactId
                                    , First_Name__c
                                    , Last_Name__c
                                    , Email_Address__c
                                    , Phone_Number__c
                                    , RecordTypeId
                                    , RecordType.Name
                                	, Address_Line_1__c	
                                	, City__c	
                                	, Country__c
                                	, State__c	
                                	, Zip__c	
                                FROM Case
                                WHERE Id = :caseID];
                                
        List<Contact> listContact = [Select Id
                                    , Case__c
                                    , MailingLongitude
                                    , MailingLatitude
                                    FROM Contact
                                    WHERE Case__c = :caseID
                                    LIMIT 1];
                                    
        for (Case cse : listCase) {
            for (Contact cnt : listContact) {
                contactLon = cnt.MailingLongitude;
                contactLat = cnt.MailingLatitude;
                if (cse.ContactId == null) {
                    listCaseUpdates = updateCaseContact(cse.Id, cnt.Id);
                }
                submitCustomerRequest (cse.Id, cnt.Id);
            }
        }
        // System.debug('::::ContactGateway + setupCustomerRequest + listCase...: ' + listCase);   
        return listCaseUpdates;
    }

    public static List<Case> updateCaseContact (String idCase, Id idContact) {
          
		// System.debug('::::ContactGateway + updateCaseContact + idCase: ' + idCase);
		// System.debug('::::ContactGateway + updateCaseContact + idContact: ' + idContact);
		List<Case> listCaseUpdates = new List<Case> ();
        List<Case> listCase = [Select ID
                                	, ContactId
                                	, AccountId
                                	, Add_New_Account__c
                                	, RecordType.Name
                                	, Status
                                    , RecordTypeId
                                	, ProExchange_Status__c
                                    , Type_of_change__c
                                FROM Case
                                WHERE Id = :idCase];
		// System.debug('::::ContactGateway + updateCaseContact + listCase: ' + listCase);
		
        List<Contact> listContact = [Select Id
                                        , User_Active__c
                                        , AccountId
                                        , MailingLongitude
                                        , MailingLatitude
                                        , Set_Up_As_Principal_ProExchange_User__c
                                        , User__c
                                    FROM Contact
                                    WHERE Id = :idContact
                                    LIMIT 1];
		// System.debug('::::ContactGateway + updateCaseContact + listContact: ' + listContact);
        
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;        
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        String varSupportCasesRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSC_Call_Center').getRecordTypeId(); 
        String varUserManagement = Schema.SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();
        Double contactLon; 
        Double contactLat;
        for (Case cs:listCase) {
            String varProStatus = cs.ProExchange_Status__c;
            for (Contact cnt:listContact) {
                // System.debug('::::ContactGateway + updateCaseContact + varProStatus: ' + varProStatus);
                // System.debug('::::ContactGateway + updateCaseContact + cs.RecordType.Name: ' + cs.RecordType.Name);
                // System.debug('::::ContactGateway + updateCaseContact + cnt.Set_Up_As_Principal_ProExchange_User__c: ' + cnt.Set_Up_As_Principal_ProExchange_User__c);
                if ((cs.RecordTypeId == varProExchangeRecordType) || (cs.RecordTypeId == varSupportCasesRecordType && cs.Type_of_change__c == 'Add Contact')) {
                    if (cs.ContactId == null) {
                        cs.ContactId = cnt.Id;
                    }
                    if (cs.RecordTypeId == varProExchangeRecordType && cs.Status != 'Closed') {
                        if (!cs.ProExchange_Status__c.contains('Review')) {
                            if (cnt.User__c == null) {
                                if ((cs.Add_New_Account__c == true && cnt.AccountId != varDefaultAccountId) || cnt.Set_Up_As_Principal_ProExchange_User__c) {
                                    cs.ProExchange_Status__c = 'Ready for ProExchange User';
                                } else {
                                    cs.ProExchange_Status__c = 'Contact Created';
                                }
                            } else {
                                if (cnt.User_Active__c == true) {
                                    cs.ProExchange_Status__c = 'Current ProExchange Member';
                                } else {
                                    cs.ProExchange_Status__c = 'Review - Previous ProExchange Member';
                                }
                            }
                        }
                        if (cnt.User__c != null && cnt.User_Active__c == true && (cs.ProExchange_Status__c == 'Contact Created' || cs.ProExchange_Status__c == 'Ready for ProExchange User')) {
                            cs.Status = 'Closed';
                            cs.ProExchange_Status__c = 'Completed';
                        } else if (cnt.User__c == null && cs.ProExchange_Status__c == 'Contact Created' && cnt.AccountId != varDefaultAccountId && cnt.AccountId != cs.AccountId) {
                            cs.AccountId = cnt.AccountId;
                        }
                    }
                    listCaseUpdates.add(cs);
                }
            }
        }
		// System.debug('::::ContactGateway + updateCaseContact + listContactUpdates: ' + listCaseUpdates);
        return listCaseUpdates;
    }    
    
    public static void submitCustomerRequest (String caseID, String contactID){
		// System.debug('::::ContactGateway + submitCustomerRequest + caseID / contactID: ' + caseID + ' / ' +contactID);

        List<Case> listCase = [SELECT Id
                                    , CaseNumber
                                    , ContactId
                                    , First_Name__c
                                    , Last_Name__c
                                    , Email_Address__c
                                    , Phone_Number__c
                                    , RecordTypeId
                                    , RecordType.Name
                                	, Address_Line_1__c	
                                	, City__c	
                                	, Country__c
                               		, ProExchange_Status__c
                                	, State__c	
                                	, Zip__c	
                                FROM Case
                                WHERE Id = :caseID];
        List<Contact> listContact = [Select Id
                                    , User_Active__c
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                    FROM Contact
                                    WHERE id = :contactID
                                    LIMIT 1];
		// System.debug('::::ContactGateway + submitCustomerRequest + listContact: ' + listContact);
		List<Account> listCashAccount = new List<Account> ();
		List<Account> listSBUCashAccounts = new List<Account> ();      
        Boolean accountSC;
        Boolean accountAS;      
        Double contactLon; 
        Double contactLat;
        Double accountLon; 
        Double accountLat;
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        Decimal varMaxDistance = defaultAccount.Maximum_SSC_Distance__c;        		
        
        String contactCountry;

        for (Contact cnt:listContact) {
            contactLon = cnt.MailingLongitude; 
            contactLat = cnt.MailingLatitude;
            contactCountry = cnt.MailingCountry;
        }
        
		// System.debug('::::ContactGateway + submitCustomerRequest + contactLon / contactLat: ' + contactLon + ' / ' +contactLat);
		if (contactLon != null && contactLat != null) {
            listCashAccount = findCashAccounts(contactLon,contactLat,contactCountry);                                
		}
		
		// System.debug('::::ContactGateway + submitCustomerRequest + listCashAccount: ' + listCashAccount);             
        for (Account ca : listCashAccount ) {
            accountLon = ca.BillingLongitude; 
            accountLat = ca.BillingLatitude;
            if (ca.SBU__c == 'SC' && accountSC != true) {
                accountSC = true;
                listSBUCashAccounts.add(ca);
            } else if (ca.SBU__c == 'AS' && accountAS != true) {
                Location contacttLocation = Location.newInstance(contactLat,contactLon);
                Location accountLocation = Location.newInstance(accountLat,accountLon);
                Double varLocationDistance = Location.getDistance(contacttLocation, accountLocation, 'mi');
        		// System.debug('::::ContactGateway + createProExchContact + contacttLocation: ' + contacttLocation);   
        		// System.debug('::::ContactGateway + createProExchContact + accountLocation: ' + accountLocation);   
        		// System.debug('::::ContactGateway + createProExchContact + varLocationDistance: ' + varLocationDistance);                   
                if (varLocationDistance < varMaxDistance ) {
                    accountAS = true;
                    listSBUCashAccounts.add(ca);
                }
            }
        }
		// System.debug('::::ContactGateway + submitCustomerRequest + listSBUCashAccounts: ' + listSBUCashAccounts);     
        Set<ID> setCaseId = new Set<ID> {caseID};
        String jsonCashAccounts = JSON.serialize(listSBUCashAccounts);
        createCustomerRequest (setCaseId, jsonCashAccounts);
    }    

    public static List<Account> findCashAccounts(Double contactLon,Double contactLat, String contactCountry) {
		
		// System.debug('::::ContactGateway + findCashAccounts + contactLon / contactLat: ' + contactLon + ' / ' +contactLat);
		// System.debug('::::ContactGateway + findCashAccounts + contactCountry: ' + contactCountry);
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        Decimal varMaxDistance = defaultAccount.Maximum_SSC_Distance__c;        		
		// System.debug('::::ContactGateway + findCashAccounts + varMaxDistance: ' + varMaxDistance);

        if (varMaxDistance == null) {
            varMaxDistance = 200;
        }

        return [SELECT ID
                	,NAME
                	,DBA_Name__c
                	,AccountNumber
                	,DW_ID__c
                	,Customer_Base__c
                	,Division_Name__r.Code__c
                	,Customer_Class__r.CustClass__c
                	,Customer_Type__r.Cust_Type__c 
                	,Region__r.DW_ID__c
                	,Salesman__r.DW_ID__c
                	,SSC__r.DW_ID__c
                	,Division_Name__c
                	,Customer_Class__c
                	,Customer_Type__c
                	,Region__c
                	,Salesman__c
                	,SSC__c	
                	,SSC__r.Select__c
                	,SSC__r.Loc_Type__c
                	,Customer_Suffix__c
                	,phone
                	,Fax
                	,BillingStreet
                	,BillingCity
                	,BillingState
                	,BillingPostalCode 
                	,BillingCountry
                	,BillingLatitude
                	,BillingLongitude
                	,ShippingStreet
                	,ShippingCity
                	,ShippingState
                	,ShippingPostalCode 
                	,ShippingCountry
                	,SBU__C
                	,Mark_For_Deletion__c
                FROM Account
                WHERE 
                    DW_ID__c LIKE '054100%'
                    AND SSC__r.Select__c = true
                    AND BillingCountry = :contactCountry
                    AND (NOT Name LIKE '%LOWES%')
                    AND (NOT Name LIKE '%HOME%')       
                    AND ((SSC__r.Loc_Type__c = 'SSC') OR (SSC__r.Loc_Type__c = 'SSC_SAT'))
                    // AND DISTANCE(BillingAddress, GEOLOCATION(:contactLat,:contactLon), 'mi') < :varMaxDistance
                ORDER BY 
                    DISTANCE(BillingAddress, GEOLOCATION(:contactLat,:contactLon), 'mi')
                LIMIT 50];
    }
    
    @future
    public static void createCustomerRequest (Set<Id> setCaseId, String jsonListAccount) {
		list <Account> listAccount = (list <Account>) JSON.deserialize(jsonListAccount, List<Account>.class);
		// System.debug('::::ContactGateway + createCustomerRequest + listAccount: ' + listAccount);
        List<Change_Request__c> listCustomerRequest = new List<Change_Request__c> ();
        List<Case> listCase = [Select ID
                                	, First_Name__c	
                                	, Email_Address__c	
                                	, Last_Name__c	
                                	, Phone_Number__c	
                                	, AccountName__c	
                                	, DBA__c	
                                	, Address_Line_1__c
                                	, Address_Line_2__c
                                	, City__c	
                                	, State__c	
                                	, Zip__c	
                                	, Country__c
                                	, RecordType.Name
                                FROM Case
                                WHERE Id = :setCaseId];
		// System.debug('::::ContactGateway + createCustomerRequest + listCase: ' + listCase);
        List<Contact> listContact = [Select Id
                                    , MailingLongitude
                                    , MailingLatitude
                                    FROM Contact
                                    WHERE Case__c = :setCaseId
                                    LIMIT 1];
        List<Change_Request__c> listCR = [Select Id
                                    FROM Change_Request__c
                                    WHERE Case__c = :setCaseId
                                    LIMIT 1];
		// System.debug('::::ContactGateway + createCustomerRequest + listContact: ' + listContact);
        
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;        
        if (listCR.isEmpty()){ 
            for (Case cs:listCase) {
                for (Account a:listAccount) {
                    Change_Request__c cr = new Change_Request__c();
                    cr.Customer_Name__c = cs.AccountName__c;
                    cr.DBA_Name__c = cs.DBA__c;
                    cr.Contact__c = cs.First_Name__c + ' ' + cs.Last_Name__c;
                    cr.Phone_N__c = cs.Phone_Number__c;
                    cr.Business_Reason__c = 'New ProExchange Customer';
                    cr.Billing_Street__c = cs.Address_Line_1__c;
                    cr.Billing_City__c = cs.City__c;
                    cr.Shipping_Zip_N__c = cs.Zip__c;
                    cr.Shipping_State_N2__c = cs.State__c;
                    cr.Billing_Street_N__c = cs.Address_Line_1__c;
                    cr.Address2__c = cs.Address_Line_2__c;
                    cr.Billing_City_N__c = cs.City__c;
                    cr.Billing_Zip_N__c = cs.Zip__c;
                    cr.Billing_State_N2__c = cs.State__c;
                    cr.Bill_Country_N__c = cs.Country__c;
                    cr.Case__c = cs.ID;
                    cr.RecordTypeId = Label.CR_New_Customer_RT;
                    cr.Region__c = a.Region__c;
                    cr.Sales_Representative__c = a.Salesman__c;
                    cr.SSC__c = a.SSC__c;
                    cr.Customer_Class__c = defaultAccount.Default_Customer_Class__c;
                    cr.Customer_Type__c = UserContactDefaults__c.getInstance().Default_Customer_Type__c;
                    cr.Skip_Customer_change_WF__c = true;
                    // cr.Bill_Country_N__c = cs.updateBillToCountryChange;
                    cr.Status__c = 'Submitted to Support Team';
                    listCustomerRequest.add(cr);
                }
            }
        }
		// System.debug('::::ContactGateway + createCustomerRequest + listCustomerRequest: ' + listCustomerRequest);
        insert listCustomerRequest;
    }        

    public static List<Case> handleProExchUserCases (List<Contact> newContact, List<Contact> oldContact) {
        // System.debug('::::ContactGateway + handleProExchUserCases: ');
        List <Case> listCases = new List <Case>();
        List <Contact> listNewContactCases = new List <Contact>();
        Boolean checkCreateCase;
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;       
        
        if (Trigger.isUpdate) {
            for (Contact theNewContact : newContact) {
                for (Contact theOldContact : oldContact) {
                    // System.debug('::::ContactGateway + handleProExchUserCases + theNewContact.Set_Up_As_Principal_ProExchange_User__c...: ' + theNewContact.Set_Up_As_Principal_ProExchange_User__c);
                    // System.debug('::::ContactGateway + handleProExchUserCases + theOldContact.Set_Up_As_Principal_ProExchange_User__c...: ' + theOldContact.Set_Up_As_Principal_ProExchange_User__c);
                    if (theNewContact.Set_Up_As_Principal_ProExchange_User__c != theOldContact.Set_Up_As_Principal_ProExchange_User__c 
                        && theNewContact.Set_Up_As_Principal_ProExchange_User__c == true 
                        && theNewContact.Case__c == null) {
                        checkCreateCase = true;
                        listNewContactCases.add(theNewContact);
                    }
                }   
            }
        } else if (Trigger.isInsert){
            for (Contact theNewContact : newContact ) {
                if (theNewContact.Set_Up_As_Principal_ProExchange_User__c == true
                    && theNewContact.Case__c == null) {
                    checkCreateCase = true;
                    listNewContactCases.add(theNewContact);
                }                    
            }   
        }
        
        for (Contact theContact : listNewContactCases) {
            if (checkCreateCase == true) {
                Case c = new Case();
                c.Subject = 'New ProExchange User Request';
                c.RecordTypeId = varProExchangeRecordType;
                c.First_Name__c = theContact.FirstName;
                c.Last_Name__c = theContact.LastName;         
                c.Email_Address__c = theContact.Email;
                c.Phone_Number__c = theContact.Phone;             
                c.ContactID = theContact.Id;
                c.AccountID = theContact.AccountId;
                if ( theContact.AccountId == varDefaultAccountId) {
                    c.ProExchange_Status__c = 'Ready for ProExchange User';
                } else {
                    c.ProExchange_Status__c = 'Contact Created';
                }
                c.AccountNumber__c = theContact.Account_Nbr__c;
                c.Origin = 'User Request';
                // System.debug('::::ContactGateway + handleProExchUserCases + adding c: ' + c);
                listCases.add(c);
            }          
        }
        // System.debug('::::ContactGateway + handleProExchUserCases + listCases: ' + listCases);
        return listCases;
    }
    
}