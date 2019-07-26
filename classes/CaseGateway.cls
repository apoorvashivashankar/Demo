public without sharing class CaseGateway {

    public static boolean checkFirstRun = true;
    public static boolean checkContactCreated = false;
    public static boolean checkUserCreated = false;

    public static void validate() {
        Boolean hasError;
        Boolean varNeedsAccountCheck;
        String varCustomerNumber;
        List <Case> listCase = new List <Case> ();
        
        for (SObject so : trigger.new) {
            Case theCase = (Case)so;
            listCase.add(theCase);
        }   
        
        // Apply Validations
        validateProExchange(listCase);
        validateTitleCase(listCase);
        validateCaseContact(listCase);
        validateDescription(listCase);

    }
    
    // Check the account # entered in for a pro exchange case, and populate the Account lookup field
    public static void validateProExchange(List <Case> listCase) {
        // System.debug('::::CaseGateway + validateProExchange...: ');
        Id varProExchangeRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ProExchange').getRecordTypeId(); 
        Id varUserManagementRecordType = SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();      
        
        for (Case c : listCase) {
            // check to make sure the record is a pro exchange case
            if (c.RecordTypeId == varProExchangeRecordType) {
                helperProExchangeAccount(c, c.AccountNumber__c, c.AccountId);
            }
            
            if (c.ContactId != null) {
                // System.debug('::::CaseGateway + validateProExchange + ContactId != null...: ');
                checkContactCreated = true;
            }
        }   
    }
    
    public static void helperProExchangeAccount(Case c, String varCustomerNumber, String varAccountId) {
        
        Id varProExchangeRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ProExchange').getRecordTypeId();      
        Map <String, Case> mapAccountToCase = new Map <String, Case> ();
        Map <String, Account> mapOwnerToAccount = new Map <String, Account> ();
        List <Account> listCustomerAccounts = new List <Account> ();         
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;                        
        String varAccountOwnerId;
        Boolean foundAccount;                 
        Boolean hasError;
        // System.debug('::::CaseGateway + helperProExchangeAccount + varCustomerNumber: ' + varCustomerNumber + ' / varAccountId: ' + varAccountId);
        if ( varAccountId != null || varCustomerNumber != null) {
            If(String.isBlank(varCustomerNumber) == true) {
                varCustomerNumber = 'BLANK';
            }
            String varCleanCustomerNumber = varCustomerNumber.replaceAll('[^a-zA-Z0-9]', '') ; 
            // System.debug('::::CaseGateway + helperProExchangeAccount + varCleanCustomerNumber: ' + varCleanCustomerNumber);
            listCustomerAccounts = [ SELECT Id
                                        , DW_ID__C
                                        , OwnerId
                                        , User_Active__c
                                        FROM Account
                                        WHERE (ID != : varDefaultAccountId
                                        AND ID = :  varAccountId)
                                        OR (DW_ID__C = : varCleanCustomerNumber
                                        AND (NOT DW_ID__C LIKE '054100%'))
                                        LIMIT 1];
        } 
        
        // System.debug('::::CaseGateway + helperProExchangeAccount + listCustomerAccounts: ' + listCustomerAccounts);

        if (!listCustomerAccounts.isEmpty()) {
            for (Account a : listCustomerAccounts) {
                if (a.Id != varDefaultAccountId) {
                    c.AccountID = a.Id;
                    foundAccount = true;
                    if (a.User_Active__c == 'Active') {
                        c.User__c = a.OwnerId; 
                    }
                }
            }
        } else if (c.AccountId == null && c.Add_New_Account__c != true && c.Select_An_Issue__c == '-') {
            hasError = true;
            c.addError('Account not found, please enter a new Account.');
        }
    }

    public static void validateTitleCase(List <Case> listCase) {
        for (Case c : listCase) {
            if ( c.First_Name__c != null) {
                c.First_Name__c = helperTitleCase(c.First_Name__c);
            }
            if ( c.Last_Name__c != null) {
                c.Last_Name__c = helperTitleCase(c.Last_Name__c);
            }
            if ( c.Title__c != null) {
                c.Title__c = helperTitleCase(c.Title__c);
            }
            if ( c.Subject != null) {
                c.Subject = helperTitleCase(c.Subject);
            }
        }        
    }
    
    public static String helperTitleCase(String name){
        name = name.toLowerCase();
        name = name.remove('.');
        name = name.remove(',');
        // System.debug('Name = '+ name);
        List<String> nameGroup = name.split(' ');
        String newName = '';
        for (String part : nameGroup){
            if(part.length() == 1 ){
                part = part.toUpperCase()+ ' ';
                newName += part;
            }
            else if (part.length() >= 2){
                // System.debug(part);
                newName += part.subString(0,1).toUpperCase()+part.subString(1,part.length())+ ' ';
            }
        }
        return newName; 
    } 

    // Check the email from salesfore support and see if you can find a matching user / contact
    public static void validateCaseContact(List <Case> listCase) {
        // System.debug('::::CaseGateway + validateCaseContact ...');  
        //Check to see if this is email to case or hand entered case
        boolean isEmailToCase = false;
        boolean isSupportEmail = false;
        
        Id varSupportCasesRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cases').getRecordTypeId(); 
        // System.debug('::::CaseGateway + validateCaseContact + varSupportCasesRecordType:...' + varSupportCasesRecordType);  

        for (Case c : listCase) {
            // System.debug('::::CaseGateway + validateCaseContact + c.SuppliedEmail: ' + c.SuppliedEmail);  
            // System.debug('::::CaseGateway + validateCaseContact + c.RecordTypeId: ' + c.RecordTypeId);  
            if(c.RecordTypeId == varSupportCasesRecordType) {
                isSupportEmail = true;
            } else if ( c.Origin == 'Email' ) {
                isEmailToCase = true;
                // System.debug('**** Is an Email To Case *****');
                // break;
            }
        }
        // System.debug('::::CaseGateway + validateCaseContact + isSupportEmail: ' + isSupportEmail);  
        // System.debug('::::CaseGateway + validateCaseContact + isEmailToCase: ' + isEmailToCase);  
        if (isEmailToCase) {
            //Load Custom Metadata Type
            Set<String> caseQueuesService = new Set<String>();
            Case_Queues_Standard_Contact_Type__mdt[] caseServiceTypeQueues = [SELECT MasterLabel FROM Case_Queues_Standard_Contact_Type__mdt];
            for (Case_Queues_Standard_Contact_Type__mdt queue : caseServiceTypeQueues ) {
                caseQueuesService.add(queue.MasterLabel);
            }

            //Load Queues
            Map<Id, Group> queues = new Map<Id, Group>( [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'] );
            Set<Id>     caseIDs    = new Set<Id>();
            Set<String> caseEmails = new Set<String>();
            
            //Get case ID's and Emails that should be processed
            for(Case currentCase : listCase) {
                // System.debug('**** Adding cases to process *****');
                String caseOwnderId = currentCase.OwnerId;
                if (currentCase.ContactId == Null && currentCase.SuppliedEmail <> Null && caseOwnderId.left(3) == '00G' && caseQueuesService.contains( queues.get( caseOwnderId ).DeveloperName ) ) {
                    caseIDs.add ( currentCase.Id );
                    caseEmails.add ( currentCase.SuppliedEmail );
                    // System.debug('**** Added Case '+currentCase.Id +' *****');
                }
            }
            
            //If no casedID's have been added, no cases to process, exit;
            if ( caseIDs.Size() == 0 ) {
                return;
            }
        
            //Check for contact Id's that should be used
            Map<String, Contact> contactsToUse = new Map<String, Contact>();
            Set<String>          dupeEmails    = new Set<String>();
        
            for (Contact contactsToCheck: [ SELECT Id, Email FROM Contact WHERE Email IN :caseEmails AND contact_type__c = 'Service' ORDER BY Email ]) {
                // System.debug('**** Adding contacts to uses *****');
                if ( dupeEmails.Size() > 0 && dupeEmails.contains('contactsToCheck.Email')  ) {
                    // System.debug('**** Dup email already do nothing *****');
                    continue;
                }else if ( contactsToUse.containsKey( contactsToCheck.Email ) ) {
                    // System.debug('**** Dup email removing add as dup *****');
                    contactsToUse.remove( contactsToCheck.Email );
                    dupeEmails.add( contactsToCheck.Email );
                    continue;
                }else{
                    // System.debug('**** Good contact to use *****');
                    contactsToUse.put( contactsToCheck.Email, contactsToCheck );
                }                          
            }
        
            //If no contacts to use have been added, nothing to process, exit
            if ( contactsToUse.Size() == 0 ) { 
                return;
            }
            
            for(Case currentCase : (List<Case>) trigger.new) {
                if ( contactsToUse.containsKey( currentCase.SuppliedEmail ) ) {
                    if ( contactsToUse.get( currentCase.SuppliedEmail ).Id <> currentCase.ContactId ) {
                        currentCase.ContactId = contactsToUse.get( currentCase.SuppliedEmail ).Id;
                    }
                }
            }
        } else if (isSupportEmail) {
        
            //Set of User Names
            Map<String,ID> userName = new Map<String,ID>(); 
            Map<String,ID> contactName = new Map<String,ID>();     
            List<Contact> listContacts = new List<Contact> ();     
            List<User> listUsers = new List<User> ();
            String varEmailMatch = '';
            Boolean foundEmailMatch = false;
        
            listContacts = [SELECT   
                                id
                                , Name
                                , email
                                , User__c
                                , User__r.email
                                , User__r.Name
                                , Account.Name
                            FROM Contact 
                            WHERE Account.Name = 'Daltile Internal Communications' 
                            AND User__r.IsActive = TRUE  
                            ] ;
                            
            // System.debug('::::CaseGateway + validateCaseContact + listContacts: ' + listContacts);                        
        
            for (Case c : listCase) {
                for(Contact ct: listContacts) {
                    if(c.SuppliedName != NULL  && c.User__C == null) {
                        if(c.SuppliedEmail == 'salesforce@daltile.com') {
                            if (c.Description != null) {
                                Pattern emailPattern = Pattern.compile('(?i)^([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4})$');
                                for (String bit: c.Description.split(' ')) {
                                    Matcher emailMatcher = emailPattern.matcher(bit);
                                    if (emailMatcher.matches()) {
                                        foundEmailMatch = true;
                                        varEmailMatch = bit;
                                    }
                                }
                            }
                        } else if (c.SuppliedEmail != null) {
                            varEmailMatch = c.SuppliedEmail;
                        }
                        if (ct.User__r.email == varEmailMatch || ct.User__r.Name == c.SuppliedName){
                            c.User__c = ct.User__c;
                            c.ContactID = ct.Id;
                            c.DescriptionEmail__c = varEmailMatch;
                        }
                    }
                }
            }
        }        
    }

    public static void validateDescription (List <Case> listCase) {
        for (Case c : listCase) {
            if (String.isBlank(c.Description) && !String.isBlank(c.Details__c)) {
                c.Description = c.Details__c;
            }
        }
    }

    public static List<Task> createRepTask (Set<Id> setCaseId) {
        
        Case oldCase = new Case();
        Case newCase = new Case();
        List<Task> listRepTask = new List<Task> ();
        Boolean trueSendTask;
        if (Trigger.isUpdate) {
            // System.debug('::::CaseGateway + createRepTask + Trigger.isUpdate...');
            for (SObject so : trigger.old) {
                oldCase = (Case)so;
            }         
            for (SObject so : trigger.new) {
                newCase = (Case)so;
            } 
            if (oldCase.Status != 'Closed' && newCase.Status == 'Closed') {
                trueSendTask = true;
            }
        } else if (Trigger.isInsert) {
            // System.debug('::::CaseGateway + createRepTask + Trigger.isInsert...');
            trueSendTask = true;
        }
            // System.debug('::::CaseGateway + trueSendTask:...' + trueSendTask);
        
        if (trueSendTask == true) {
            String stringDateTime = String.valueOf(System.now()); 
            DateTime dt = DateTime.valueOfGmt(stringDateTime);
            DateTime tomorrow = dt.addDays(1);
            DateTime nextMonth = dt.addMonths(1);
            DateTime anniversary = dt.addYears(1);
            String formattedDateTime = dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');        
            Profile pAdm = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];  
            
            UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
            ID defaultAccountID = defaultAccount.Default_Account_Id__c;        
            
            List<Case> listCase = [SELECT Id
                                        , AccountId
                                        , Account.OwnerId
                                        , Account.Owner.ProfileId
                                        , Account.Name
                                        , Description
                                        , ContactID
                                        , Type
                                        , Status
                                    FROM Case
                                    WHERE Id = :setCaseId
                                    AND Status = 'Closed'
                                    AND AccountId != :defaultAccountID
                                    AND Account.Owner.IsActive = TRUE];
            for (Case c:listCase) {
                // System.debug('::::CaseGateway + c: ' + c);
                if (c.Type == 'Check Pricing') {
                    // System.debug('::::CaseGateway + createRepTask...');
                    Task t = new Task();
                    t.ActivityDate = System.Today();
                    t.Description = 'Customer called in for pricing check, providing task for follow up. ' + c.Description;
                    t.IsReminderSet = true;
                    t.OwnerId = c.Account.OwnerId;
                    t.Priority = 'High';
                    t.ReminderDateTime = tomorrow;
                    t.Status = 'Not Started';
                    t.Subject = 'Service Center Price Check';
                    t.Type = 'Phone Call';
                    t.WhatId = c.AccountId;
                    t.WhoId = c.ContactId;
                    listRepTask.add(t);
                }
            }
        }
        return listRepTask;
    }

    public static List<Case> updateCaseAssignment (Set<Id> setCaseId) {
        // System.debug('::::updateCaseAssignment: ' + setCaseId);      

        List<Case> listCasesToUpdate = new List<Case> ();
        List<Case> listCase = [SELECT Id
                                FROM Case
                                WHERE Id = :setCaseId
                                AND (RecordType.Name = 'Account Management'
                                OR RecordType.Name = 'User Management'
                                OR RecordType.Name = 'Order Issue'
                                OR RecordType.Name = 'ProExchange')];
        
        String us = userinfo.getUserType(); 
                                
        for (Case c:listCase) {
            // System.debug('::::CaseGateway + c: ' + c);            
            listCasesToUpdate.add(new Case(id = c.id));
        }
        
        // System.debug('::::CaseGateway + listCasesToUpdate: ' + listCasesToUpdate);
        return listCasesToUpdate;
    }
    
    public static List<Contact> checkCurrentContacts (String varFirstName, String varLastName, String varEmail, String varPhone, String varAccountId, String varAccountGroupKey) {

        List<Contact> listContacts = new List<Contact>();
        String varCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        String varContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        String varShortCustomerRecordType = varCustomerRecordType.left(15);
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultTempAccountId = defaultAccount.Default_Temp_Account_Id__c;        
        // System.debug('::::CaseGateway + checkCurrentContacts + varFirstName: ' + varFirstName);
        // System.debug('::::CaseGateway + checkCurrentContacts + varLastName: ' + varLastName);
        // System.debug('::::CaseGateway + checkCurrentContacts + varEmail: ' + varEmail);
        // System.debug('::::CaseGateway + checkCurrentContacts + varPhone: ' + varPhone);
        // System.debug('::::CaseGateway + checkCurrentContacts + varAccountId: ' + varAccountId);
        // System.debug('::::CaseGateway + checkCurrentContacts + varAccountGroupKey: ' + varAccountGroupKey);
        // System.debug('::::CaseGateway + checkCurrentContacts + varCustomerRecordType: ' + varCustomerRecordType);
        // System.debug('::::CaseGateway + checkCurrentContacts + varShortCustomerRecordType: ' + varShortCustomerRecordType);
        
        // System.debug('::::CaseGateway + checkCurrentContacts + varContactRecordType: ' + varContactRecordType);
        listContacts = [SELECT Id
                            ,Name
                            ,FirstName
                            ,LastName
                            ,Email
                            ,Phone
                            ,AccountId
                            ,Account.Name
                            ,Account.GroupKey__c
                            ,Account.DW_ID__C
                            ,Account_Nbr__c
                            ,Account_Record_Type_ID__c
                            ,User__c
                            ,User__r.Email
                            ,User_Active__c
                        FROM Contact
                        WHERE   (   
                                    (
                                        (
                                            (
                                                (
                                                FirstName = : varFirstName
                                                AND LastName = : varLastName
                                                )
                                            OR (
                                                Email = : varEmail
                                                AND Email != ''
                                                )
                                            )
                                        AND (
                                            Account.GroupKey__c = : varAccountGroupKey
                                            OR AccountId = : varAccountId
                                            )
                                        )
                                    OR (
                                        User_Active__c = true
                                        AND Email = : varEmail
                                        AND Email != ''
                                        )
                                    )
                                AND (
                                        (
                                            Account_Nbr__c != ''
                                            AND Liquid_ID__c != 'XXX'
                                            AND (NOT Account_Nbr__c LIKE '054100%')
                                            AND (NOT Account_Nbr__c LIKE '212500001%')
                                            AND RecordTypeId = : varContactRecordType
                                            AND Account_Record_Type_ID__c = : varShortCustomerRecordType
                                        )
                                    OR (
                                        AccountId = : varDefaultTempAccountId)
                                    ) 
                                ) LIMIT 10];
                        	
                        // 	AND (NOT Account_Nbr__c LIKE '054100%') 
        
        return listContacts;
        
    }

    public static List<Contact> createContact (map<Id,SObject> newMap) {
        
        // System.debug('::::CaseGateway + createContact: ' + newMap); 
        
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultTempAccountId = defaultAccount.Default_Temp_Account_Id__c;        
        ID varDefaultCSCAccountId = defaultAccount.Default_CSC_Account_Id__c;    
        ID varDefaultAccountId;    
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        Case cs = (Case)newMap.get(idKeySet);
        
        Contact currentContact = new Contact();
        Boolean varHasError;
        String varErrorMessage;
        String varContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        String varUserManagementRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();
        String varSupportCasesRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSC_Call_Center').getRecordTypeId(); 
        String varGroupKey;
        Integer varNumberOfDupes = 0;
        Boolean varHasSameName;
        Boolean varHasSameEmail;
        Boolean varHasSameAccount;
        Boolean varHasNoEmailError;
        Boolean varCurrentProExchange;
        Boolean varPreviousProExchange;
        String varFieldError;
        String varLeadSource;
            
        // System.debug('::::CaseGateway + createContact + cs.Status : ' + cs.Status );
        // System.debug('::::CaseGateway + createContact + cs.ProExchange_Status__c : ' + cs.ProExchange_Status__c );
        
        List<Contact> listDupeContacts = new List<Contact>();
        List<Account> listAccount = new List<Account> ();
        List<Contact> listContacts = new List<Contact> ();
        List<Contact> listContactCheck = new List<Contact> ();
        if ((cs.RecordTypeId == varProExchangeRecordType && cs.Last_Name__c != '' && cs.Last_Name__c != null )
        || (cs.RecordTypeId == varUserManagementRecordType && cs.Type_of_change__c == 'Add User')
        || (cs.RecordTypeId == varSupportCasesRecordType && cs.Type_of_change__c == 'Add Contact')) {

            listContactCheck = checkCurrentContacts(cs.First_Name__c, cs.Last_Name__c, cs.Email_Address__c, cs.Phone_Number__c, cs.AccountID, cs.Account.GroupKey__c);

            // System.debug('::::CaseGateway + createContact + listContactCheck : ' + listContactCheck );
            
            varGroupKey = cs.Account.GroupKey__c;
    
            listAccount = [ SELECT Id, Name, OwnerId 
                            FROM Account 
                            WHERE Id = : varGroupKey];
            
            for (Contact ct : listContactCheck) {
                // System.debug('::::CaseGateway + DupeContactsCheck + ct.FirstName : ' + ct.FirstName );
                // System.debug('::::CaseGateway + DupeContactsCheck + cs.First_Name__c : ' + cs.First_Name__c );
                // System.debug('::::CaseGateway + DupeContactsCheck + ct.LastName : ' + ct.LastName );
                // System.debug('::::CaseGateway + DupeContactsCheck + cs.Last_Name__c : ' + cs.Last_Name__c );
                // System.debug('::::CaseGateway + DupeContactsCheck + ct.Email : ' + ct.Email );
                // System.debug('::::CaseGateway + DupeContactsCheck + cs.Email_Address__c : ' + cs.Email_Address__c );
                if ((ct.FirstName == cs.First_Name__c && ct.LastName == cs.Last_Name__c) || (ct.Email == cs.Email_Address__c )) {
                    if (ct.User__c != null) {
                        if (ct.User_Active__c == true) {
                            varCurrentProExchange = true;
                        } else {
                            varPreviousProExchange = true;
                        }
                        currentContact = ct;
                    }
                    if (ct.FirstName == cs.First_Name__c && ct.LastName == cs.Last_Name__c){
                        varHasSameName = true;
                    } 
                    if (ct.Email == cs.Email_Address__c){
                        varHasSameEmail = true;
                    } 
                    if (String.isBlank(ct.Email)  == true){
                        varHasNoEmailError = true;
                    } 
                    if (ct.AccountId == cs.AccountId) {
                        varHasSameAccount = true;
                    }
                    varNumberOfDupes = varNumberOfDupes + 1;
                    varHasError = true;
                    Contact emptyContact = new Contact ();
                    if (currentContact == emptyContact ) {
                        currentContact = ct;
                    }
                    listDupeContacts.add(ct);
                }
                // System.debug('::::CaseGateway + DupeContactsCheck + currentContact : ' + currentContact );
            }
            
            if ( cs.RecordTypeId != varSupportCasesRecordType ) {
                varLeadSource = 'Customer Website Request';
                varDefaultAccountId = varDefaultTempAccountId;
            } else {
                varLeadSource = 'Service Cloud Request';
                varDefaultAccountId = varDefaultCSCAccountId;
            }

            // System.debug('::::CaseGateway + DupeContactsCheck + varNumberOfDupes : ' + varNumberOfDupes );
            
            if (varNumberOfDupes != 0) {
                varErrorMessage = 'We have found ' + varNumberOfDupes + ' possible duplicates...';
                if (varNumberOfDupes > 1) {
                    Set<String> varDuplicateContacts = new Set<String>() ;
                    for (Contact cd:listDupeContacts) {
                        varDuplicateContacts.add(cd.Id);
                    }
                    varErrorMessage = varErrorMessage + 'Multiple Contacts with Record Id:...' + varDuplicateContacts + '.  Please review and merge. ';  
                } 
                String varErrorDetails;
                if (varHasSameName == true) {
                    varErrorDetails = 'the same Name ';
                    if (varHasSameEmail == true) {
                        varErrorDetails = varErrorDetails + ', and the same Email';                        
                    } else if (varHasSameEmail != true) {
                        varErrorDetails = varErrorDetails + ', but not the same Email';
                    } else if (varHasNoEmailError == true) {
                        varErrorDetails = varErrorDetails + ', but does not have an Email address which is required for ProExchange users';

                    }  
                } else if (varHasSameEmail == true) {
                    varErrorDetails = 'the same Email';
                    if (varHasSameName != true) {
                        varErrorDetails = varErrorDetails + ', but not the same Name';
                    }    
                }
                varErrorMessage =  'Current Contact:...' + currentContact.Name + ' was found as a match with ' +  varErrorDetails + ', and has been added as the Contact to the Case';          
                if (varCurrentProExchange == true) {
                    varErrorMessage = varErrorMessage + '...and is already a ProExchange Member.';                                  
                } else if (varPreviousProExchange == true) {
                    varErrorMessage = varErrorMessage + '...and was a previous ProExchange User.';
                }else if (varHasSameEmail == true && varHasNoEmailError != true) {
                    varErrorMessage = varErrorMessage + '...and ready for ProExchange.';
                }
                // System.debug('::::CaseGateway + DupeContactsCheck + currentContact.Name: ' + currentContact.Name + ', + varErrorDetails : ' + varErrorDetails );
                
                try {
                    if (cs.RecordTypeId == varProExchangeRecordType) {
                        // System.debug('::::CaseGateway + helperUpdateCaseContact + cs: ' + cs + ', + varErrorMessage: ' + varErrorMessage + ', + currentContact: ' + currentContact);
                        helperUpdateCaseContact(cs.Id, varErrorMessage, currentContact.Id);        
                    }
                } catch(Exception e) {
                    // System.debug('The following exception has occurred: ' + e.getMessage());    
                }
            } else {
                // System.debug('::::CaseGateway + createContact + cs.AccountID : ' + cs.AccountID );
                Contact c = new Contact();
                c.RecordTypeId = varContactRecordType;
                c.FirstName = cs.First_Name__c;
                c.LastName = cs.Last_Name__c;
                c.Email = cs.Email_Address__c;
                c.Phone = cs.Phone_Number__c;
                c.Description = cs.CaseNumber;
                c.Title = cs.Title__c;
                c.Case__c = cs.Id;
                // c.Set_Up_As_Principle_ProExchange_User__c = true;
                c.MailingCity = cs.City__c;
                c.MailingState = cs.State__c;
                c.MailingStreet = cs.Address_Line_1__c;
                c.MailingPostalCode = cs.Zip__c;
                c.MailingCountry = cs.Country__c;
                c.LeadSource = varLeadSource;
                c.Company_Name__c = cs.AccountName__c;
                
                if (cs.AccountID == null) {
                    c.AccountID = varDefaultAccountId;
                } else {
                    c.AccountID = cs.AccountID;
                    for (Account a:listAccount) {
                        if (cs.AccountId == a.Id && a.User_Active__c == 'Active') {
                            c.OwnerId = a.OwnerId;
                        }                        
                    }
                }
                listContacts.add(c);
            }
        }

        // System.debug('::::CaseGateway + createContact + listContacts: ' + listContacts);
        return listContacts;
    }
    
    @future 
    public static void helperUpdateCaseContact (String idCase, String errorMessage, String varContactID) {
        
        // System.debug('::::CaseGateway + helperUpdateCaseContact + idCase: ' + idCase);
        // System.debug('::::CaseGateway + helperUpdateCaseContact + errorMessage: ' + errorMessage);
        // System.debug('::::CaseGateway + helperUpdateCaseContact + varContactID: ' + varContactID);
        
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;               
        
        List<Case> listCaseUpdates = new List<Case> ();
        List<Case> listCase = [Select ID
                                    , ContactId
                                    , Description
                                    , ProExchange_Status__c
                                FROM Case
                                WHERE Id = :idCase];
                
        // System.debug('::::CaseGateway + helperUpdateCaseContact + listCase: ' + listCase);

        for (Case cs:listCase) {
            if (errorMessage != null && cs.ProExchange_Status__c != 'Completed') {
                if (errorMessage.contains('ready for ProExchange')) {
                    cs.Comments = errorMessage;
                    cs.ProExchange_Status__c = 'Ready for ProExchange User';
                    cs.ContactId = varContactID;
                } else if (errorMessage.contains('is already a ProExchange Member')) {
                    cs.Comments = errorMessage;
                    cs.ProExchange_Status__c = 'Current ProExchange Member';
                    cs.ContactId = varContactID;
                    if (errorMessage.contains('same Name') && !errorMessage.contains('same Email')) {  
                        cs.ProExchange_Status__c = 'Review - Potential Duplicate';
                    }                    
                } else if (errorMessage.contains('previous ProExchange User')) {
                    cs.Comments = errorMessage;
                    cs.ProExchange_Status__c = 'Review - Previous ProExchange Member	';
                    cs.ContactId = varContactID;     
                } else if (errorMessage.contains('Multiple Contacts')) {    
                    cs.Comments = errorMessage;
                    cs.ProExchange_Status__c = 'Review - Duplicate Contact';   
                } else if (errorMessage.contains('same name and the same email')) {  
                    cs.Comments = errorMessage;
                    cs.ContactId = varContactID;
                    cs.ProExchange_Status__c = 'Review - Duplicate Contact';
                } else if (errorMessage.contains('same Name')) {  
                    cs.Comments = errorMessage;
                    cs.ContactId = varContactID;
                    cs.ProExchange_Status__c = 'Review - Potential Duplicate';
                } else {
                    cs.Comments = errorMessage;
                    cs.ProExchange_Status__c = 'Review - Duplicate Contact';
                }
            } else {  
                if (cs.ProExchange_Status__c != 'Completed') {
                    cs.Comments = 'Contact created.  Please review and setup ProExchange User.';
                    if ( cs.AccountId != varDefaultAccountId) {
                        cs.ProExchange_Status__c = 'Ready for ProExchange User';
                    } else {
                        cs.ProExchange_Status__c = 'Contact Created';
                    }
                    if (varContactID != null) {
                        cs.ContactId = varContactID;
                    }
                }
            }
            listCaseUpdates.add(cs);
        }

        if(listCaseUpdates.size()>0){
            try {
                // System.debug('::::CaseGateway + helperUpdateCaseContact + listCaseUpdates: ' + listCaseUpdates);
                update listCaseUpdates;
            } catch(DmlException e) {
                // System.debug('It looks like there was an issue...: ' + e.getMessage());
            }         
        }        
    }    
    
    public static List<Contact> updateContactAccount (Set<Id> setCaseId) {
    
        // System.debug('::::CaseGateway + updateContactAccount + setCaseId: ' + setCaseId);
        
        Id varProExchangeRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ProExchange').getRecordTypeId(); 
        Id varUserManagementRecordType = SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();      

        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;        
        
        Map<Id, Case> mapAccountCase = new Map<Id, Case> ();
        Map<Id, Case> mapContactCase = new Map<Id, Case> ();
                                
        List<Contact> listContactUpdates = new List<Contact> ();
        Map<Id,Contact> mapIdToContact = new Map<Id,Contact> ();
        
        List<Case> listCase = [SELECT Id
                                    , AccountID
                                    , ContactId
                                    , RecordTypeId
                                    , ProExchange_Status__c
                                    , Email_Address__c
                                    , Status
                                FROM Case
                                WHERE Id = :setCaseId];        

        // System.debug('::::CaseGateway + updateContactAccount + listCase: ' + listCase);
        if (!listCase.isEmpty()) {
            for (Case theCase : listCase) {
                if (theCase.ContactId != null)  {
                    Case oldCase = (Case)Trigger.oldMap.get(theCase.Id);
                    mapContactCase.put(theCase.ContactId, theCase);
                    mapAccountCase.put(theCase.AccountId, theCase);
                }
            }   
    
            List<Contact> listContact = [Select ID
                                        , AccountId
                                        , Case__c
                                        , MailingLatitude
                                        , Set_Up_As_Principal_ProExchange_User__c
                                        , User__c
                                        , Email
                                    FROM Contact
                                    WHERE Id = :mapContactCase.keySet()];
            // System.debug('::::CaseGateway + updateContactAccount + listContact: ' + listContact);
                                    
            List<Account> listAccount = [Select ID
                                    FROM Account
                                    WHERE Id = :mapAccountCase.keySet()];     
    
            for (Case theCase : listCase) {
            // System.debug('::::CaseGateway + updateContactAccount + theCase.Status : ' + theCase.Status );
            // System.debug('::::CaseGateway + updateContactAccount + theCase.ProExchange_Status__c : ' + theCase.ProExchange_Status__c );
                if (theCase.ProExchange_Status__c != null) {
                    if (!theCase.ProExchange_Status__c.contains('Review') || !theCase.ProExchange_Status__c.contains('Closed')) {
                        for (Account a : listAccount) {
                            for (Contact c : listContact) {
                                if (theCase.ContactId != null && (theCase.RecordTypeId == varProExchangeRecordType || theCase.RecordTypeId == varUserManagementRecordType))  {
                                	// System.debug('::::CaseGateway + updateContactAccount + c: ' + c);
                                	if (c.AccountId != a.ID) {
                                		if (theCase.ProExchange_Status__c != 'Contact Created' && theCase.Status != 'Closed' && c.AccountID == varDefaultAccountId) {
                                			c.AccountId = a.ID;
                                			c.Set_Up_As_Principal_ProExchange_User__c = true;
                                			if (c.Case__c == null) {
                                				c.Case__c = theCase.id;
                                			}                        
                                			mapIdToContact.put(c.Id,c);
                                		}    
                                	} else {
                                	    // System.debug('::::CaseGateway + updateContactAccount + theCase.Email_Address__c: ' + theCase.Email_Address__c);
                                		if (theCase.Email_Address__c == c.Email && c.AccountID != varDefaultAccountId && c.Set_Up_As_Principal_ProExchange_User__c != true && theCase.Status != 'Closed') {
                                			c.Set_Up_As_Principal_ProExchange_User__c = true;
                                			mapIdToContact.put(c.Id,c);
                                		}
                                		if (c.Case__c == null) {
                                			c.Case__c = theCase.id;
                                			if (listContactUpdates.isEmpty() == true) {
                                			    mapIdToContact.put(c.Id,c);
                                			}
                                		}                        
                                	} 
                                	// System.debug('::::CaseGateway + updateContactAccount + listContactUpdates:...' + listContactUpdates);
                                	// System.debug('::::CaseGateway + updateContactAccount + c.Case__c: ' + c.Case__c);
                                }
                            }
                        }
                    }
                }  
            }
    
            // System.debug('::::CaseGateway + updateContactAccount + mapIdToContact: ' + mapIdToContact);
            for (Id varId : mapIdToContact.keySet()) {
                 Contact cnt = new Contact();
                 cnt = mapIdToContact.get(varId);
                 listContactUpdates.add(cnt);
            }
            // System.debug('::::CaseGateway + updateContactAccount + listContactUpdates: ' + listContactUpdates);
        }
        return listContactUpdates;
    }

    public static String checkUserTimezone (String contactState) {
        String varTimeZone;

        Set <String> setEasternStates = new Set <String>{'CT','DC','DE','FL','GA','IN','ME','MD','MA','MI','NH','NJ','NY','NC','OH','PA','RI','SC','VT','VA','WV','ON','QC','NB','NS','NL','PE'};
        Set <String> setCentralStates = new Set <String>{'AL','AR','IL','IA','KS','KY','LA','MN','MS','MO','NE','ND','OK','SD','TN','TX','WI','SK','MB','NU'};
        Set <String> setMountainStates = new Set <String>{'AZ','CO','ID','MT','NM','UT','WY','AB','NT'};
        Set <String> setPacificStates = new Set <String>{'CA','NV','OR','WA','BC','YT'};
        Set <String> setAlaskaStates = new Set <String>{'AK'};
        Set <String> setHawaiiStates = new Set <String>{'HI'};

        if (setEasternStates.contains(contactState)) {
            varTimeZone = 'America/New_York';
        } else if (setCentralStates.contains(contactState)) {
            varTimeZone = 'America/Chicago';
        } else if (setMountainStates.contains(contactState)) {
            varTimeZone = 'America/Denver';
        } else if (setPacificStates.contains(contactState)) {
            varTimeZone = 'America/Los_Angeles';
        } else if (setAlaskaStates.contains(contactState)) {
            varTimeZone = 'America/Anchorage';
        } else if (setHawaiiStates.contains(contactState)) {
            varTimeZone = 'Pacific/Honolulu';
        }
        
        return varTimeZone;
    }
 
    public static List <User> createProExchUser (List<Case> listNewCase, List<Case> listOldCase) {
 
        // System.debug('::::CaseGateway + createProExchUser :...' );     
        // System.debug('::::CaseGateway + createProExchUser + listNewCase :...' + listNewCase );     
        // System.debug('::::CaseGateway + createProExchUser + listOldCase :...' + listOldCase);     
        Case oldCase = new Case();
        Case newCase = new Case();
        List <User> listUsers = new List <User> ();
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        String varUserManagement = Schema.SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();
        if (Trigger.isUpdate) {
            // System.debug('::::CaseGateway + createProExchUser + isUpdate :...' );     
            for (SObject so : trigger.old) {
                oldCase = (Case)so;
            }         
            for (SObject so : trigger.new) {
                newCase = (Case)so;
            } 
            if (newCase.RecordTypeId == varProExchangeRecordType || newCase.RecordTypeId == varUserManagement) {
                listUsers = handleProExchUser(listNewCase,listOldCase);
            }
        } else if (Trigger.isInsert) {
            for (Case so : listNewCase) {
                newCase = so;
            } 
            // System.debug('::::CaseGateway + createProExchUser + isInsert :...' );     
            // System.debug('::::CaseGateway + createProExchUser + newCase.RecordTypeId :...'  + newCase.RecordTypeId);     
            // System.debug('::::CaseGateway + createProExchUser + varProExchangeRecordType :...'  + varProExchangeRecordType);     
            // System.debug('::::CaseGateway + createProExchUser + varUserManagement :...'  + varUserManagement);     
            if (newCase.RecordTypeId == varProExchangeRecordType || newCase.RecordTypeId == varUserManagement) {
                // System.debug('::::CaseGateway + createProExchUser + isInsert made it:...' );     
                listUsers = handleProExchUser(listNewCase,listOldCase);
            } else {
                // System.debug('::::CaseGateway + createProExchUser + isInsert sorry:...' );     
            }
        }

        return listUsers;

    }

    public static List <User> handleProExchUser (List<Case> newCase, List<Case> oldCase) {
 
        Set <ID> setContactId = new Set <ID>();
        Set <String> setEmails = new Set <String>();
        List <User> listUsers = new List <User> ();
        UserContactDefaults__c settingDefaults = UserContactDefaults__c.getOrgDefaults();
        ID varProExchangeProfileID = settingDefaults.Default_SSC_Community_Profile__c;  
        UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
        ID varDefaultAccountId = defaultAccount.Default_Temp_Account_Id__c;            
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        String varUserManagement = Schema.SObjectType.Case.getRecordTypeInfosByName().get('User Management').getRecordTypeId();

        String oldSetup;
        String newSetup;

        List<Contact> listContact = new List<Contact>();
        
        for (Case cs : newCase) {
            setContactId.add(cs.ContactID);
            setEmails.add(cs.Email_Address__c);
        }
        
        List <User> listUserCheck = [   SELECT Id
                                            , ContactId
                                            , Contact.Name
                                            , AccountId
                                            , Account.Name
                                            , Email
                                        FROM User
                                        WHERE ContactId IN : setContactId ];
                                        
        for (User u : listUserCheck) {
            setContactId.add(u.ContactId);
        }                                        
        
        // System.debug('::::CaseGateway + handleProExchUser + setContactId: ' + setContactId);   
        // System.debug('::::CaseGateway + handleProExchUser + setEmails: ' + setEmails);   
        
        List <Contact> listContactCheck = new List <Contact>();
        listContactCheck = [SELECT ID
                                                , Name
                                                , firstName
                                                , lastname
                                                , email
                                                , phone
                                                , Account_Nbr__c
                                                , MailingState
                                                , Account.ShippingState
                                                , Account_Region_Division__c
                                                , User__c
                                                , User__r.Email
                                                , User__r.UserName
                                                , User_Active__c
                                                , AccountID 
                                            FROM Contact 
                                            WHERE Email != null
                                            AND (ID IN : setContactId
                                            OR (User__r.Email IN : setEmails
                                            AND User__c != null))
                                            LIMIT 5];
                                            
        // System.debug('::::CaseGateway + handleProExchUser + listContactCheck: ' + listContactCheck);                                              
        String errorMessage;
        String caseId;
        String contactId;
        if (Trigger.isUpdate) {
            for (Case theNewCase : newCase) {
                for (Case theOldCase : oldCase) {
                    // System.debug('::::CaseGateway + handleProExchUser + theNewCase.ProExchange_Status__c: ' + theNewCase.ProExchange_Status__c);                                              
                    if ((theNewCase.RecordTypeId == varProExchangeRecordType 
                        && (theNewCase.ProExchange_Status__c == 'Ready for ProExchange User' 
                        || theNewCase.ProExchange_Status__c == 'Customer Account Created' 
                        || theNewCase.ProExchange_Status__c == 'Review - Duplicate Contact'
                        || theNewCase.ProExchange_Status__c == 'Review - Potential Duplicate'))
                        || (theNewCase.RecordTypeId == varUserManagement && theNewCase.ProExchange_Status__c == 'Contact Created' )) {
                        for (Contact c : listContactCheck) {
                            if (c.Account_Region_Division__c.contains('40') || c.Account_Region_Division__c.contains('41')){
                            // System.debug('::::CaseGateway + handleProExchUser + c: ' + c);                                              
                            // if (c.Set_Up_As_Principal_ProExchange_User__c == true) {
                                if (c.User_Active__c != true && c.AccountId != varDefaultAccountId) {
                                    if (listContact.isEmpty()) {
                                        if (theNewCase.ContactId == null) {
                                            listContact.add(c);
                                        } 
                                        if (c.Id == theNewCase.ContactId) {
                                            listContact.add(c);
                                        }                                        
                                    }
                                } else if (c.User_Active__c != true && c.User__c != null) {
                                    errorMessage = 'This was a previous ProExchange User that was de-activated';
                                    caseId = theNewCase.Id;
                                    contactId = c.Id;
                                }
                            }
                        }                        
                    }                    
                }
            }
        } else if (Trigger.isInsert){
            for (Case theCase : newCase ) { 
                if (theCase.ProExchange_Status__c == 'Ready for ProExchange User') {
                    for (Contact c : listContactCheck) {
                        if (c.Account_Region_Division__c.contains('40') || c.Account_Region_Division__c.contains('41')){
                            if (c.User_Active__c != true && c.AccountId != varDefaultAccountId) {
                                listContact.add(c);
                            }
                        }
                    }  
                }
            }
        }
        
        // System.debug('::::CaseGateway + handleProExchUser + listContact: ' + listContact);   
        
        if (!listContact.isEmpty()) {
            for (Contact c : listContactCheck) {
                String varUserTimeZone;
                if (String.isBlank(c.MailingState) != true){
                    varUserTimeZone = checkUserTimezone(c.MailingState);
                } else if (String.isBlank(c.Account.ShippingState) != true){
                    varUserTimeZone = checkUserTimezone(c.Account.ShippingState);
                } else {
                    varUserTimeZone = 'America/Chicago';
                }
                String varAliasName = c.firstName.left(1) + c.lastname.left(4);
                String varNickName = c.firstName.left(1) + c.lastname + '.' + c.Account_Nbr__c.substring(2, 3);
                User theUser = new User(alias = varAliasName
                                        , email = c.email
                                        , emailencodingkey = 'UTF-8'
                                     	, firstName = c.firstName
                                        , lastname = c.lastname
                                        // , CommunityNickname = varNickName
                                        , languagelocalekey = 'en_US'
                                        , localesidkey = 'en_US'
                                        , profileid = varProExchangeProfileID
                                        , country = 'United States'
                                        , ContactId = c.Id
                                        , isActive = true
                                        , timezonesidkey = varUserTimeZone
                                        , Share_All_Group_Accounts__c = true
                                        , username = c.email);
                                        
                // System.debug('::::CaseGateway + handleProExchUser + theUser: ' + theUser); 
                listUsers.add(theUser);     
                checkUserCreated = true;
            }
        } else {
            checkContactCreated = false;
            // helperUpdateCaseContact (caseId, errorMessage, contactId);
        }
            
        // System.debug('::::CaseGateway + handleProExchUser + listUsers: ' + listUsers);
        return listUsers;
    }

}