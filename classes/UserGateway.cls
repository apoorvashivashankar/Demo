public with sharing class UserGateway {

    public static void validate() {
        Boolean hasError;
        Boolean varNeedsAccountCheck;
        String varCustomerNumber;
        List <User> listUser = new List <User> ();
        
        for (SObject so : trigger.new) {
            User theUser = (User)so;  
            listUser.add(theUser);
        }   
        
        helperUpdateUserExternalID(listUser);
    }
	
    public static void helperUpdateUserExternalID (List <user> listUser) {
        if (!listUser.isEmpty() && listUser != null) {
            for (User u : listUser) {
                if (u.Email_WF__c != u.email) {
                	u.Email_WF__c = u.email;
                }
            }
        }
	}		

    public static List<Case> updateProExchCase (Set<Id> setUserIds) {   

        List <Case> listCase = new List <Case> ();
        List <Case> listCaseCheck = new List <Case> ();
        Set <ID> setCaseIds = new Set <ID> ();
        Boolean checkNeedsUpdate;        
        Boolean checkNeedsUpdateQueue;    
        Boolean checkIsFuture = System.isFuture();
        List<User> listUser = [SELECT ID
                                    , Name
                                    , Email
                                    , ContactId
                                    , Contact.Case__c
                                    , Contact.Set_Up_As_Principal_ProExchange_User__c
                                FROM User
                                WHERE Id IN : setUserIds];
        
        // System.debug('::::UserGateway + updateProExchCase + listUser: ' + listUser);
        for (User u : listUser) {
        	// System.debug('::::UserGateway + updateProExchCase + u.Name: ' + u.Name);
        	// System.debug('::::UserGateway + updateProExchCase + u.Contact.Set_Up_As_Principal_ProExchange_User__c: ' + u.Contact.Set_Up_As_Principal_ProExchange_User__c);
        	// System.debug('::::UserGateway + updateProExchCase + u.Contact.Case__c: ' + u.Contact.Case__c);
            if (checkIsFuture != true) {
                if (u.Contact.Case__c != null) {
                    if (u.Contact.Set_Up_As_Principal_ProExchange_User__c == true) {
                        setCaseIds.add(u.Contact.Case__c);
                        checkNeedsUpdate = true;
                    } 
                }
            } else {
                queueUpdateCase updateContact = new queueUpdateCase(listUser);
                ID jobID = System.enqueueJob(updateContact);                      
            }
        }

        // System.debug('::::UserGateway + updateProExchCase + setCaseIds: ' + setCaseIds);
        // System.debug('::::UserGateway + updateProExchCase + checkNeedsUpdate: ' + checkNeedsUpdate);
        
        if (checkNeedsUpdate == true) {
            listCaseCheck = [SELECT ID
                                , Status
                                , ProExchange_Status__c
                            FROM Case
                            WHERE ID in : setCaseIds];
        
            // System.debug('::::UserGateway + updateProExchCase + listCaseCheck: ' + listCaseCheck);
        
            for (Case c : listCaseCheck) {
                if (c.Status != 'Closed' || c.ProExchange_Status__c != 'Completed') {
                    c.Status = 'Closed';
                    c.ProExchange_Status__c = 'Completed';
                    c.Comments = 'ProExchange User Created';
                    listCase.add(c);
                }
            }
        }
        
        return listCase;
           
	}

    public class queueUpdateCase implements Queueable {
    	private List<User> usersNew;
    	
    	public queueUpdateCase (List<User> listNewUser) {
    		this.usersNew = listNewUser;
    	}
    	
    	public void execute(QueueableContext context) {
            List <Case> listCase = new List <Case> ();
            List <Case> listCaseCheck = new List <Case> ();
            Set <ID> setCaseIds = new Set <ID> ();
            Boolean checkNeedsUpdate;        
    		
            for (User u : usersNew) {
                if (u.Contact.Case__c != null) {
                    setCaseIds.add(u.Contact.Case__c);
                    checkNeedsUpdate = true;
                }
            }		
    		
            // System.debug('::::UserGateway + queueUpdateCase + setCaseIds: ' + setCaseIds);
            // System.debug('::::UserGateway + queueUpdateCase + checkNeedsUpdate: ' + checkNeedsUpdate);
            
            if (checkNeedsUpdate == true) {
                listCaseCheck = [SELECT ID
                                    , Status
                                    , ProExchange_Status__c
                                FROM Case
                                WHERE ID in : setCaseIds];
            
                // System.debug('::::UserGateway + queueUpdateCase + listCaseCheck: ' + listCaseCheck);
            
                for (Case c : listCaseCheck) {
                    if (c.Status != 'Closed' && c.ProExchange_Status__c != 'Completed') {
                        c.Status = 'Closed';
                        c.ProExchange_Status__c = 'Completed';
                        listCase.add(c);
                    }
                }
            }
            update listCase;
    	}
    }	
	
    public static List <User_to_Location__c> createUserToLocation (list <User> users){
        
        // System.debug('createUserToLocation...: ');
        
        Map <String, set<Id>> groupKeyToAccount = new Map <String, set<Id>>();
        Map <User, String> userToGroupKey = new Map <User, String>();
        set <String> allGroupKeys = new set <String>();
        String varDefaultAccountID;
        String varDefaultAccountNumber;
        list <AccountShare> sharesToInsert = new list <AccountShare>();
        List <Account> listAccountsByGroupKey = new List <Account>();
        List <User_to_Location__c> listRecordsToUpdate = new List <User_to_Location__c>();
        Boolean checkNeedsUpdateQueue;    
        Boolean checkIsFuture = System.isFuture();
        // System.debug('UserGateway + createUserToLocation  + checkIsFuture: ' + checkIsFuture);
        
        for (User us:users){
            if (checkIsFuture != true) {
                if (us.IsActive == true) {
                    // System.debug('UserGateway + createUserToLocation  + us.Primary_Account_Group_Key__c: ' + us.Primary_Account_Group_Key__c);
                    if (us.Share_All_Group_Accounts__c == true) {
                        userToGroupKey.put(us, us.Primary_Account_Group_Key__c);
                        allGroupKeys.add(us.Primary_Account_Group_Key__c);
                        varDefaultAccountNumber = us.Primary_Account_Number__c;
                    } else {
                        varDefaultAccountNumber = us.Primary_Account_Number__c;
                        varDefaultAccountID = us.AccountId;
                    }
                }
            }
        }

        // System.debug('UserGateway + createUserToLocation  + users: ' + users);
        // System.debug('UserGateway + createUserToLocation  + allGroupKeys: ' + allGroupKeys);
        // System.debug('UserGateway + createUserToLocation  + varDefaultAccountID: ' + varDefaultAccountID);
        // System.debug('UserGateway + createUserToLocation  + userToGroupKey.size(): ' + userToGroupKey.size());
        // System.debug('UserGateway + createUserToLocation  + userToGroupKey: ' + userToGroupKey);
        
        if (checkIsFuture == true || Test.isRunningTest()) {
            if(!userToGroupKey.isEmpty()) {
        
                listAccountsByGroupKey = [  Select Id 
                                                , GroupKey__c
                                            FROM Account
                                            WHERE GroupKey__c in :allGroupKeys
                                            AND GroupKey__c != null
                                            AND Mark_For_Deletion__c != true];                
                                            
                // System.debug('UserGateway + createUserToLocation  + listAccountsByGroupKey: ' + listAccountsByGroupKey);
                // System.debug('UserGateway + createUserToLocation  + listAccountsByGroupKey.size(): ' + listAccountsByGroupKey.size());

                for (Account acc: listAccountsByGroupKey){
                    if (groupKeyToAccount.containsKey(acc.GroupKey__c)) {
                        groupKeyToAccount.get(acc.GroupKey__c).add(acc.Id);
                    } else {
                        groupKeyToAccount.put(acc.GroupKey__c,new Set<Id>{acc.Id});
                    }
                }
    
                // System.debug('UserGateway + groupKeyToAccount: ' + groupKeyToAccount);
    
                for(User us:userToGroupKey.keySet()){
                    for (Id accId : groupKeyToAccount.get(us.Primary_Account_Group_Key__c)){
                        User_to_Location__c ul = new User_to_Location__c ();
                        ul.Account__c = accId;
                        ul.User__c = us.Id;
                        String varKey = us.Id + '.' + accId;
                        ul.User_to_Location_Key__c = varKey;
                        listRecordsToUpdate.add(ul);
                    }
                }
            } else if (varDefaultAccountID != null || varDefaultAccountID != '') {
                for (User us:users){
                    User_to_Location__c ul = new User_to_Location__c ();
                    ul.Account__c = varDefaultAccountID;
                    ul.User__c = us.Id;
                    String varKey = us.Id + '.' + varDefaultAccountID;
                    ul.User_to_Location_Key__c = varKey;
                    listRecordsToUpdate.add(ul);
                }
            } else {
                for (User us:users){
                    User_to_Location__c ul = new User_to_Location__c ();
                    ul.User__c = us.Id;
                    ul.Share_GroupKey__c = true;
                    ul.GroupKey__c = us.Primary_Account_Group_Key__c;
                    ul.User_to_Location_Key__c = us.Id + ':Setup';
            		// System.debug('UserGateway + createUserToLocation + ul: ' + ul);
                    listRecordsToUpdate.add(ul);
                }
            }
        } else {
            // System.debug('UserGateway + createUserToLocation + users: ' + users);
            queueCreateUserToLocation createUserToLocation = new queueCreateUserToLocation(users);
            ID jobID = System.enqueueJob(createUserToLocation);              
        }
        // System.debug('UserGateway + createUserToLocation + listRecordsToUpdate: ' + listRecordsToUpdate);
        return listRecordsToUpdate;
    }

    public class queueCreateUserToLocation implements Queueable {
    	private List<User> usersNew;
    	
    	public queueCreateUserToLocation (List<User> listNewUser) {
    		this.usersNew = listNewUser;
    	}
    	
    	public void execute(QueueableContext context) {
    
            Map <String, set<Id>> groupKeyToAccount = new Map <String, set<Id>>();
            Map <User, String> userToGroupKey = new Map <User, String>();
            set <String> allGroupKeys = new set <String>();
            String varDefaultAccountID;
            String varDefaultAccountNumber;
            list <AccountShare> sharesToInsert = new list <AccountShare>();
            List <Account> listAccountsByGroupKey = new List <Account>();
            List <User_to_Location__c> listRecordsToUpdate = new List <User_to_Location__c>();
            for (User us:usersNew){

                if (us.IsActive == true) {
                    if (us.Share_All_Group_Accounts__c == true) {
                        userToGroupKey.put(us, us.Primary_Account_Group_Key__c);
                        allGroupKeys.add(us.Primary_Account_Group_Key__c);
                        varDefaultAccountNumber = us.Primary_Account_Number__c;
                    } else {
                        varDefaultAccountNumber = us.Primary_Account_Number__c;
                        varDefaultAccountID = us.AccountId;
                    }
                }                
                
            }
    
            // System.debug('UserGateway + queueCreateUserToLocation  + usersNew: ' + usersNew);
            // System.debug('UserGateway + queueCreateUserToLocation  + allGroupKeys: ' + allGroupKeys);
            // System.debug('UserGateway + queueCreateUserToLocation + varDefaultAccountID: ' + varDefaultAccountID);
            
            listAccountsByGroupKey = [  Select Id 
                                            , GroupKey__c
                                        FROM Account
                                        WHERE GroupKey__c in :allGroupKeys
                                        AND GroupKey__c != null
                                        AND Mark_For_Deletion__c != true];
    
            // System.debug('UserGateway + queueCreateUserToLocation  + userToGroupKey.size(): ' + userToGroupKey.size());
            // System.debug('UserGateway + queueCreateUserToLocation  + userToGroupKey: ' + userToGroupKey);
            // System.debug('UserGateway + queueCreateUserToLocation  + listAccountsByGroupKey: ' + listAccountsByGroupKey);
            // System.debug('UserGateway + queueCreateUserToLocation  + listAccountsByGroupKey.size(): ' + listAccountsByGroupKey.size());
    
            if(!userToGroupKey.isEmpty() && !listAccountsByGroupKey.isEmpty() ) {
                
                for (Account acc: listAccountsByGroupKey){
                    if (groupKeyToAccount.containsKey(acc.GroupKey__c)) {
                        groupKeyToAccount.get(acc.GroupKey__c).add(acc.Id);
                    } else {
                        groupKeyToAccount.put(acc.GroupKey__c,new Set<Id>{acc.Id});
                    }
                }
    
                // System.debug('UserGateway + queueCreateUserToLocation + groupKeyToAccount: ' + groupKeyToAccount);
    
                for(User us:userToGroupKey.keySet()){
                    for (Id accId:groupKeyToAccount.get(us.Primary_Account_Group_Key__c)){
                        User_to_Location__c ul = new User_to_Location__c ();
                        ul.Account__c = accId;
                        ul.User__c = us.Id;
                        String varKey = us.Id + '.' + accId;
                        ul.User_to_Location_Key__c = varKey;
                        listRecordsToUpdate.add(ul);
                    }
                }
            } else if (varDefaultAccountID != null || varDefaultAccountID != '') {
                for (User us:usersNew){
                    User_to_Location__c ul = new User_to_Location__c ();
                    ul.Account__c = varDefaultAccountID;
                    ul.User__c = us.Id;
                    String varKey = us.Id + '.' + varDefaultAccountID;
                    ul.User_to_Location_Key__c = varKey;
                    listRecordsToUpdate.add(ul);
                }
            } else {
                for (User us:usersNew){
                    User_to_Location__c ul = new User_to_Location__c ();
                    ul.User__c = us.Id;
                    ul.Share_GroupKey__c = true;
                    ul.GroupKey__c = us.Primary_Account_Group_Key__c;
                    ul.User_to_Location_Key__c = us.Id + ':Setup';
            		// System.debug('UserGateway + createUserToLocation + ul: ' + ul);
                    listRecordsToUpdate.add(ul);
                }
            }
            // System.debug('UserGateway + queueCreateUserToLocation + listRecordsToUpdate: ' + listRecordsToUpdate);
            
            try {
                insert listRecordsToUpdate;
            } catch (Exception e) {
                // System.debug('UserGateway + queueCreateUserToLocation + Exception e: ' + e);
            }
            
    	}
    }

    public static List <Contact> updateUserContact (List<User> listNewUser, List<User> listOldUser) {   
        // System.debug('UserGateway + updateUserContact + listNewUser : ...: ' + listNewUser);
        // System.debug('UserGateway + updateUserContact + listOldUser : ...: ' + listOldUser);
		List <Contact> listContacts = new list<Contact>();  
		List <Contact> listContactUpdates = new list<Contact>();  
		List <Case> listCase = new list<Case>();  
        Set <Id> setUserId = new Set <Id>();
        Map <Id, User> mapContactUser = new Map <Id, User>();
        Boolean checkIsFuture = System.isFuture();
		
		for(User u : listNewUser) {
            // System.debug('UserGateway + updateUserContact + u ...: ' + u);
            // System.debug('UserGateway + updateUserContact + u.ContactId ...: ' + u.ContactId);
            mapContactUser.put(u.ContactId, u); 
            setUserId.add(u.id);
        }            
        
        if (!mapContactUser.isEmpty()) {
            listContacts = [SELECT Id
                                , FirstName
                                , LastName
                                , Email
                                , Phone
                                , MobilePhone 
                                , Contact_Type__c
                                , Set_Up_As_Principal_ProExchange_User__c
                                , Case__c
                                , User__c
                                , User__r.UserType
                                , User__r.FirstName
                                , User__r.LastName
                                , User__r.email
                                , User__r.AccountId
                                , User__r.Phone
                                , User__r.MobilePhone
                                , User__r.isActive
                            FROM Contact
                            WHERE Contact_Type__c != 'Service'
                            AND (Id IN : mapContactUser.keySet()
                           	OR User__c IN : setUserId)];

            listCase = [SELECT ID
                            , User__c
                            , ContactId
                            , First_Name__c
                            , Last_Name__c
                            , Email_Address__c
                            , Phone_Number__c
                        FROM Case
                        WHERE ContactId IN : mapContactUser.keySet()
                        AND ContactId != null
                        AND Status != 'Closed'
                        LIMIT 1];

			// System.debug('UserGateway + updateUserContact + listContacts...: ' + listContacts);
			// System.debug('UserGateway + updateUserContact + listCase...: ' + listCase);

			if (checkIsFuture == true || Test.isRunningTest()) {
				String varDefaultAccountID = UserContactDefaults__c.getInstance().Default_Account_Id__c;
                if (!listContacts.isEmpty()) {
					for(User u : listNewUser) {
						// System.debug('UserGateway + updateUserContact + u.UserType...: ' + u.UserType);
						for(Contact c : listContacts) {
							// System.debug('UserGateway + updateUserContact + c.FirstName...: ' + c.FirstName);
							// System.debug('UserGateway + updateUserContact + c.LastName...: ' + c.LastName);
							// System.debug('UserGateway + updateUserContact + c.Email...: ' + c.Email);
							// System.debug('UserGateway + updateUserContact + c.Phone...: ' + c.Phone);
							// System.debug('UserGateway + updateUserContact + c.MobilePhone...: ' + c.MobilePhone);
							if (u.UserType  == 'Standard' && u.Id == c.User__c && 
								((c.FirstName != u.FirstName) || (c.LastName != u.LastName) ||  (c.Email != u.Email) || (c.Phone != u.Phone) || (c.MobilePhone != u.MobilePhone))) {
								if (c.FirstName != u.FirstName) { 
									c.FirstName = u.FirstName;
								}
								if (c.LastName != u.LastName) {
									c.LastName = u.LastName;
								}
								if (c.Email != u.Email) {
									c.Email = u.Email;
								}
								if (c.Phone != u.Phone) {
									c.Phone = u.Phone;
								}
								if (c.MobilePhone != u.MobilePhone) {
									c.MobilePhone = u.MobilePhone;
								} 
								listContactUpdates.add(c);
							} else {
								// System.debug('UserGateway + updateUserContact + u.UserType...: ' + u.UserType);
								// System.debug('UserGateway + updateUserContact + c.User__c...: ' + c.User__c);
								if (c.User__c != u.id) {
									c.User__c = u.Id;
									listContactUpdates.add(c);
								}
								for(Case cs : listCase) {
									// System.debug('UserGateway + updateUserContact + cs.Email_Address__c...: ' + cs.Email_Address__c);
									// System.debug('UserGateway + updateUserContact + !String.IsBlank(cs.Email_Address__c)...: ' + !String.IsBlank(cs.Email_Address__c));
									if (c.email != cs.Email_Address__c && cs.Email_Address__c != null && cs.Email_Address__c != '' && !String.IsBlank(cs.Email_Address__c)){
										c.email = cs.Email_Address__c;
										if (listContactUpdates.isEmpty()) { listContactUpdates.add(c); } else {}
									}
									if (c.phone != cs.Phone_Number__c && !String.IsBlank(cs.Phone_Number__c)){
										c.phone = cs.Phone_Number__c;
										if (listContactUpdates.isEmpty()) { listContactUpdates.add(c); } else {}
									}
									if (listOldUser != null && !listOldUser.isEmpty()) {
    									for (User u1: listOldUser) {
    										// System.debug('UserGateway + updateUserContact + u1.IsActive...: ' + u1.IsActive);
    										// System.debug('UserGateway + updateUserContact + u.IsActive...: ' + u.IsActive);
    										// System.debug('UserGateway + updateUserContact + c.Set_Up_As_Principal_ProExchange_User__c...: ' + c.Set_Up_As_Principal_ProExchange_User__c);
    										if (u1.IsActive == true && u.IsActive == false) {
    											if (c.Set_Up_As_Principal_ProExchange_User__c == true) {
    												c.Set_Up_As_Principal_ProExchange_User__c = false;
    												c.Case__c = null;
    												if (listContactUpdates.isEmpty()) { listContactUpdates.add(c); } else {}
    											}
    										}
    									}
    								}
								}
							}
						}
					}
					// System.debug('UserGateway + updateUserContact listContactUpdates...: ' + listContactUpdates);
				} else {
					List <Account> accounts = new List <Account>();
					UserContactDefaults__c settingCheck = UserContactDefaults__c.getOrgDefaults();
					String MyUserTypeName = UserInfo.getUserType();
					List <user> listUser = listNewUser;
					if ( settingCheck != NULL ) {
						for(user u : listUser) {
							if (u.UserType  == 'Standard') {
								Contact c = new Contact(FirstName = u.FirstName
												 ,LastName = u.LastName
												 ,Email = u.email
												 ,Phone = u.Phone
												 ,MobilePhone = u.MobilePhone
												 ,AccountID = UserContactDefaults__c.getInstance().Default_Account_Id__c
												 ,RecordTypeID = UserContactDefaults__c.getInstance().Default_Contact_Record_Type_Id__c
												 ,User__c = u.Id 
												 );
								                                            
								listContactUpdates.add(c);
							} 
						}            
					}	    
					// System.debug('UserGateway + updateUserContact listContactUpdates...: ' + listContactUpdates); 
				}			
			} else {
			    // System.debug('UserGateway + updateUserContact sending to queueUpdateUserContact...: ' + listContacts + ' , ' + listCase + ' , ' + listNewUser + ' , ' + listOldUser); 
				queueUpdateUserContact updateContact = new queueUpdateUserContact(listContacts,listCase,listNewUser,listOldUser);
				ID jobID = System.enqueueJob(updateContact);    
				// System.debug('UserGateway + updateUserContact + jobID...: ' + jobID);
			} 			
        }
		return listContactUpdates;
	}

	
    public class queueUpdateUserContact implements Queueable {
        // System.debug('UserGateway + queueUpdateUserContact...: ');
        private List<Contact> contacts;
		private List <Case> cases;  
        private List<User> usersNew;
        private List<User> usersOld;
        
        public queueUpdateUserContact(List<Contact> listContacts, List <Case> listCase, List<User> listNewUser, List<User> listOldUser) {
            this.contacts = listContacts;
            this.cases = listCase;
            this.usersNew = listNewUser;
            this.usersOld = listOldUser;
        }
        
        public void execute(QueueableContext context) {
        
            // System.debug('UserGateway + queueUpdateUserContact...: ');
            List<Contact> contactUpdates = new List<Contact>();
            String varDefaultAccountID = UserContactDefaults__c.getInstance().Default_Account_Id__c;
			if (usersOld != null) {
    			for(User u : usersNew) {
    			    // System.debug('UserGateway + queueUpdateUserContact + u.UserType...: ' + u.UserType);
    				for(Contact c : contacts) {
                        // System.debug('UserGateway + queueUpdateUserContact + c.FirstName...: ' + c.FirstName);
                        // System.debug('UserGateway + queueUpdateUserContact + c.LastName...: ' + c.LastName);
                        // System.debug('UserGateway + queueUpdateUserContact + c.Email...: ' + c.Email);
                        // System.debug('UserGateway + queueUpdateUserContact + c.Phone...: ' + c.Phone);
                        // System.debug('UserGateway + queueUpdateUserContact + c.MobilePhone...: ' + c.MobilePhone);
                        if (u.UserType  == 'Standard' && u.Id == c.User__c && 
            		        ((c.FirstName != u.FirstName) || (c.LastName != u.LastName) ||  (c.Email != u.Email) || (c.Phone != u.Phone) || (c.MobilePhone != u.MobilePhone))) {
            			    if (c.FirstName != u.FirstName) { 
            			        c.FirstName = u.FirstName;
            			    }
            			    if (c.LastName != u.LastName) {
            			        c.LastName = u.LastName;
            			    }
            			    if (c.Email != u.Email) {
            			        c.Email = u.Email;
            			    }
            			    if (c.Phone != u.Phone) {
            			        c.Phone = u.Phone;
            			    }
            			    if (c.MobilePhone != u.MobilePhone) {
            			        c.MobilePhone = u.MobilePhone;
            			    } 
                            contactUpdates.add(c);
            			} else {
                            // System.debug('UserGateway + queueUpdateUserContact + u.UserType...: ' + u.UserType);
                            // System.debug('UserGateway + queueUpdateUserContact + c.User__c...: ' + c.User__c);
    						if (c.User__c != u.id) {
    							c.User__c = u.Id;
    							contactUpdates.add(c);
    						}
    						for(Case cs : cases) {
    						    // System.debug('UserGateway + queueUpdateUserContact + cs.Email_Address__c...: ' + cs.Email_Address__c);
    						    // System.debug('UserGateway + queueUpdateUserContact + !String.IsBlank(cs.Email_Address__c)...: ' + !String.IsBlank(cs.Email_Address__c));
    							if (c.email != cs.Email_Address__c && cs.Email_Address__c != null && cs.Email_Address__c != '' && !String.IsBlank(cs.Email_Address__c)){
    								c.email = cs.Email_Address__c;
                                    if (contactUpdates.isEmpty()) { contactUpdates.add(c); } else {}
    							}
    							if (c.phone != cs.Phone_Number__c && !String.IsBlank(cs.Phone_Number__c)){
    								c.phone = cs.Phone_Number__c;
    								if (contactUpdates.isEmpty()) { contactUpdates.add(c); } else {}
    							}
    							for (User u1: usersOld) {
                    			    // System.debug('UserGateway + queueUpdateUserContact + u1.IsActive...: ' + u1.IsActive);
                    			    // System.debug('UserGateway + queueUpdateUserContact + u.IsActive...: ' + u.IsActive);
                    			    // System.debug('UserGateway + queueUpdateUserContact + c.Set_Up_As_Principal_ProExchange_User__c...: ' + c.Set_Up_As_Principal_ProExchange_User__c);
        							if (u1.IsActive == true && u.IsActive == false) {
        								if (c.Set_Up_As_Principal_ProExchange_User__c == true) {
        									c.Set_Up_As_Principal_ProExchange_User__c = false;
        									c.Case__c = null;
            								if (contactUpdates.isEmpty()) { contactUpdates.add(c); } else {}
        								}
        							}
            					}
    						}
    					}
    				}
				}
                // System.debug('UserGateway + queueUpdateUserContact contacts...: ' + contacts);
                update contacts;
            } else {
        		List <Account> accounts = new List <Account>();
                UserContactDefaults__c settingCheck = UserContactDefaults__c.getOrgDefaults();
                String MyUserTypeName = UserInfo.getUserType();
                List <user> listUser = usersNew;
                if ( settingCheck != NULL ) {
            		for(user u : listUser) {
            		    if (u.UserType  == 'Standard') {
                			Contact c = new Contact(FirstName = u.FirstName
                                             ,LastName = u.LastName
                                             ,Email = u.email
                                             ,Phone = u.Phone
                                             ,MobilePhone = u.MobilePhone
                                             ,AccountID = UserContactDefaults__c.getInstance().Default_Account_Id__c
                                             ,RecordTypeID = UserContactDefaults__c.getInstance().Default_Contact_Record_Type_Id__c
                                             ,User__c = u.Id 
                                             );
                            // System.debug('UserGateway + queueUpdateUserContact c...: ' + c);                                             
                            contactUpdates.add(c);
            		    } 
                    }            
                }	    
                // System.debug('UserGateway + queueUpdateUserContact contacts...: ' + contacts); 
                insert contactUpdates;                
            }
        }            
    }
    
}