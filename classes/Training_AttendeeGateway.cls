public with sharing class Training_AttendeeGateway {
	public static List<User> newUserTrainingUpdates (Set<Id> setLogId) {

		List<Training_Attendee__c> aList = [SELECT Id,Attendee__c,Training__c
        							FROM Training_Attendee__c 
                                    WHERE Id IN :setLogId];   
		Map<Id, List<Training_Attendee__c>> theAttendees = new Map<Id, List<Training_Attendee__c>>();
		Map<Id, List<Training_Attendee__c>> theTrainingAttendees = new Map<Id, List<Training_Attendee__c>>();
		for (Training_Attendee__c a: aList) {
		  List<Training_Attendee__c> atendees = theAttendees.get(a.Id);
		  if (atendees == null)
		  {	
			atendees = new List<Training_Attendee__c>();
			theAttendees.put(a.Attendee__c, atendees);
			theTrainingAttendees.put(a.Training__c, atendees);
		  }
		  atendees.add(a);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + aList' + aList); 

        List<Training_Log__c> lList = [SELECT Id,Name,Notes__c,Group__c, Group__r.Name, Trainer__r.Name,Trainer__c,Training_Course__r.Name,Training_Course__c,Training_Date__c,Training_Outline__c,Training_Type__c 
        							FROM Training_Log__c 
                                    WHERE Id IN :theTrainingAttendees.Keyset()];   

        Map<Id, List<Training_Log__c>> listToGroup = new Map<Id, List<Training_Log__c>>();    
        Map<Id, List<Training_Log__c>> listToCourse = new Map<Id, List<Training_Log__c>>();   
        Map<Datetime , List<Training_Log__c>> listToDate = new Map<Datetime, List<Training_Log__c>>(); 
        Map<Id, List<Training_Log__c>> thelist = new Map<Id, List<Training_Log__c>>();    
        for (Training_Log__c o: lList) {
            List<Training_Log__c> lists = listToGroup.get(o.Id);
            if (lists == null)
            {
                lists = new List<Training_Log__c>();
                listToGroup.put(o.Group__c, lists);
                listToCourse.put(o.Training_Course__c, lists);
                listToDate.put(o.Training_Date__c, lists);
                thelist.put(o.Id, lists);
            }
        }      
        System.debug('====Training_AttendeeGateway + newGroupEvents + lList' + lList); 

		List<Group__c> gList =  [SELECT Id, Name FROM Group__c Where Id IN :listToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + gList' + gList); 

		List<User_Group_Member__c> ugmList =  [SELECT Id, Name, Group_Member__c, Group_Members__c FROM User_Group_Member__c Where Group_Members__c IN :thegroup.Keyset()];
		Map<Id, List<User_Group_Member__c>> usergroupmem = new Map<Id, List<User_Group_Member__c>>();
		Map<Id, List<User_Group_Member__c>> groupMemFromGroup = new Map<Id, List<User_Group_Member__c>>();
		for (User_Group_Member__c ugm: ugmList) {
		  List<User_Group_Member__c> usergroupmems = usergroupmem.get(ugm.Group_Member__c);
		  if (usergroupmems == null)
		  {
			usergroupmems = new List<User_Group_Member__c>();
			usergroupmem.put(ugm.Group_Member__c, usergroupmems);
			groupMemFromGroup.put(ugm.Group_Members__c, usergroupmems);
		  }
		  usergroupmems.add(ugm);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + ugmList' + ugmList); 

		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c FROM Contact Where Id IN :usergroupmem.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		Map<Id, List<Contact>> groupToContact = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = groupToContact.get(c.Id);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
			groupToContact.put(c.Id, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + cList' + cList); 

		List<Event> eList =  [SELECT WhatId, Training_Course__c,OwnerId,StartDateTime,WhoId 
								FROM Event  
								WHERE WhatId IN :thelist.Keyset() 
								AND WhoId IN :groupToContact.Keyset()
								AND Training_Course__c IN :listToCourse.Keyset()
								AND StartDateTime IN :listToDate.Keyset()
								AND OwnerId IN :contactToUser.Keyset()];
		Map<Id, List<Event>> theEvents = new Map<Id, List<Event>>();
		for (Event e: eList) {
		  List<Event> groups = theEvents.get(e.Id);
		  if (groups == null)
		  {	
			groups = new List<Event>();
			theEvents.put(e.OwnerId, groups);
		  }
		  groups.add(e);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + eList' + eList); 

		List <User> userUpdateList = new list <User>();
		
		List<User> uList = [SELECT Id, IsActive 
							FROM User 
							WHERE Id IN :contactToUser.Keyset() 
							AND Id NOT IN :theEvents.Keyset()
							AND IsActive = TRUE];
		Map<Id, List<User>> user = new Map<Id, List<User>>();
		for (User u: uList)	{
			for (Training_Log__c tl: lList) {
				List<User> usersTrainingUpdate = user.get(u.Id);
				u.Trained__c = TRUE;
				u.Date_Trained__c = tl.Training_Date__c.date();
				userUpdateList.add(u);
				System.debug('====Training_AttendeeGateway + newGroupEvents + u' + u); 
			}
		  }
		return userUpdateList;
	}

	public static List<User> delUserTrainingFlag (Set<Id> setLogId) {

		List<Training_Attendee__c> aList = [SELECT Id,Attendee__c,Training__c
        							FROM Training_Attendee__c 
                                    WHERE Id IN :setLogId];   
		Map<Id, List<Training_Attendee__c>> theAttendees = new Map<Id, List<Training_Attendee__c>>();
		Map<Id, List<Training_Attendee__c>> theTrainingAttendees = new Map<Id, List<Training_Attendee__c>>();
		for (Training_Attendee__c a: aList) {
		  List<Training_Attendee__c> atendees = theAttendees.get(a.Id);
		  if (atendees == null)
		  {	
			atendees = new List<Training_Attendee__c>();
			theAttendees.put(a.Attendee__c, atendees);
			theTrainingAttendees.put(a.Training__c, atendees);
		  }
		  atendees.add(a);
		}
		System.debug('====Training_AttendeeGateway + delUserTrainingFlag + aList' + aList); 

 		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c FROM Contact Where Id IN :theAttendees.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		Map<Id, List<Contact>> groupToContact = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = groupToContact.get(c.Id);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
			groupToContact.put(c.Id, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('====Training_AttendeeGateway + delUserTrainingFlag + cList' + cList); 

		List <User> userUpdateList = new list <User>();
		
		List<User> uList = [SELECT Id, IsActive 
							FROM User 
							WHERE Id IN :contactToUser.Keyset()];
		Map<Id, List<User>> user = new Map<Id, List<User>>();
		for (User u: uList)	{
		  List<User> usersTrainingUpdate = user.get(u.Id);
			u.Trained__c = FALSE;
			u.Date_Trained__c = NULL;
	        userUpdateList.add(u);
		  System.debug('====Training_AttendeeGateway + delUserTrainingFlag + u' + u); 
		  }
		return userUpdateList;
	}


    public static List<Event> newGroupEvents (Set<Id> setLogId) {
        
		List<Training_Attendee__c> aList = [SELECT Id,Attendee__c,Training__c
        							FROM Training_Attendee__c 
                                    WHERE Id IN :setLogId];   
		Map<Id, List<Training_Attendee__c>> theAttendees = new Map<Id, List<Training_Attendee__c>>();
		Map<Id, List<Training_Attendee__c>> theTrainingAttendees = new Map<Id, List<Training_Attendee__c>>();
		for (Training_Attendee__c a: aList) {
		  List<Training_Attendee__c> atendees = theAttendees.get(a.Id);
		  if (atendees == null)
		  {	
			atendees = new List<Training_Attendee__c>();
			theAttendees.put(a.Attendee__c, atendees);
			theTrainingAttendees.put(a.Training__c, atendees);
		  }
		  atendees.add(a);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + aList' + aList); 

        List<Training_Log__c> lList = [SELECT Id,Name,Notes__c,Group__c, Group__r.Name, Trainer__r.Name,Trainer__c,Training_Course__r.Name,Training_Course__c,Training_Date__c,Training_Outline__c,Training_Type__c 
        							FROM Training_Log__c 
                                    WHERE Id IN :theTrainingAttendees.Keyset()];   

        Map<Id, List<Training_Log__c>> listToGroup = new Map<Id, List<Training_Log__c>>();    
        Map<Id, List<Training_Log__c>> listToCourse = new Map<Id, List<Training_Log__c>>();   
        Map<Datetime , List<Training_Log__c>> listToDate = new Map<Datetime, List<Training_Log__c>>(); 
        Map<Id, List<Training_Log__c>> thelist = new Map<Id, List<Training_Log__c>>();    
        for (Training_Log__c o: lList) {
            List<Training_Log__c> lists = listToGroup.get(o.Id);
            if (lists == null)
            {
                lists = new List<Training_Log__c>();
                listToGroup.put(o.Group__c, lists);
                listToCourse.put(o.Training_Course__c, lists);
                listToDate.put(o.Training_Date__c, lists);
                thelist.put(o.Id, lists);
            }
        }      
        System.debug('====Training_AttendeeGateway + newGroupEvents + lList' + lList); 

		List<Group__c> gList =  [SELECT Id, Name FROM Group__c Where Id IN :listToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + gList' + gList); 

		List<User_Group_Member__c> ugmList =  [SELECT Id, Name, Group_Member__c, Group_Members__c FROM User_Group_Member__c Where Group_Members__c IN :thegroup.Keyset()];
		Map<Id, List<User_Group_Member__c>> usergroupmem = new Map<Id, List<User_Group_Member__c>>();
		Map<Id, List<User_Group_Member__c>> groupMemFromGroup = new Map<Id, List<User_Group_Member__c>>();
		for (User_Group_Member__c ugm: ugmList) {
		  List<User_Group_Member__c> usergroupmems = usergroupmem.get(ugm.Group_Member__c);
		  if (usergroupmems == null)
		  {
			usergroupmems = new List<User_Group_Member__c>();
			usergroupmem.put(ugm.Group_Member__c, usergroupmems);
			groupMemFromGroup.put(ugm.Group_Members__c, usergroupmems);
		  }
		  usergroupmems.add(ugm);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + ugmList' + ugmList); 

		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c FROM Contact Where Id IN :usergroupmem.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		Map<Id, List<Contact>> groupToContact = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = groupToContact.get(c.Id);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
			groupToContact.put(c.Id, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + cList' + cList); 

		List<Event> eList =  [SELECT WhatId, Training_Course__c,OwnerId,StartDateTime,WhoId 
								FROM Event  
								WHERE WhatId IN :thelist.Keyset() 
								AND WhoId IN :groupToContact.Keyset()
								AND Training_Course__c IN :listToCourse.Keyset()
								AND StartDateTime IN :listToDate.Keyset()
								AND OwnerId IN :contactToUser.Keyset()];
		Map<Id, List<Event>> theEvents = new Map<Id, List<Event>>();
		for (Event e: eList) {
		  List<Event> groups = theEvents.get(e.Id);
		  if (groups == null)
		  {	
			groups = new List<Event>();
			theEvents.put(e.OwnerId, groups);
		  }
		  groups.add(e);
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + eList' + eList); 

		List<User> uList = [SELECT Id, IsActive 
							FROM User 
							WHERE Id IN :contactToUser.Keyset() 
							AND Id NOT IN :theEvents.Keyset()
							AND IsActive = TRUE];
		Map<Id, List<User>> user = new Map<Id, List<User>>();
		for (User u: uList)	{
		  List<User> users = user.get(u.Id);
		  List<User> usersTrainingUpdate = user.get(u.Id);
		  if (users == null)
		  {
			users = new List<User>();
			user.put(u.Id, users);
			u.Trained__c = TRUE;
			u.Date_Trained__c = date.today();
		  }
		  users.add(u);
		  update(u);
		  System.debug('====Training_AttendeeGateway + newGroupEvents + u' + u); 
		}
		System.debug('====Training_AttendeeGateway + newGroupEvents + uList' + uList); 

		List <Event> trainingEventList = new list <Event>();

		for (User u: uList) {
			System.debug('====Training_AttendeeGateway + newGroupEvents + u' + u);
			List < Contact > contacts = contactToUser.get(u.Id);
			If(contacts != NUll) {
				for (Contact cnt: contacts) {
					System.debug('====Training_AttendeeGateway + newGroupEvents + cnt' + cnt);
					List < User_Group_Member__c > usergroupmems = usergroupmem.get(cnt.Id);
					if (usergroupmems != NULL) {
						for (User_Group_Member__c ugrpm: usergroupmems) {
							System.debug('====Training_AttendeeGateway + newGroupEvents + ugrpm' + ugrpm);
							List < Group__c > groups = thegroup.get(ugrpm.Group_Members__c);
							if (groups != NULL) {
								for (Group__c grp: groups) {
									System.debug('====Training_AttendeeGateway + newGroupEvents + grp' + grp);
									for (Training_Log__c tl: lList) {
										System.debug('====Training_AttendeeGateway + newGroupEvents + lList' + lList);
										if (u != NULL) {
											Event event = new Event();
											event.WhatId = tl.Id;
											event.Training_Course__c = tl.Training_Course__c;
											event.OwnerId = u.Id;
											event.StartDateTime = tl.Training_Date__c;
											event.EndDateTime = tl.Training_Date__c.addHours(2);
											event.Subject = tl.Training_Course__r.Name + ' with the ' + tl.Group__r.Name + ' Group, led by ' + tl.Trainer__r.Name;
											event.Goals__c = 'Internal Training';
											event.Type = 'Meeting';
											event.WhoId = cnt.Id;
											event.Type__c = 'Meeting';
											event.OwnerId = u.Id;
											trainingEventList.add(event);
											System.debug('====Training_AttendeeGateway + newGroupEvents + event: ' + event);
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return trainingEventList;
	}
    public static List<Event> delGroupEvents (Set<Id> setLogId) {
        
		List<Training_Attendee__c> aList = [SELECT Id,Attendee__c,Training__c
        							FROM Training_Attendee__c 
                                    WHERE Id IN :setLogId];   
		Map<Id, List<Training_Attendee__c>> theAttendees = new Map<Id, List<Training_Attendee__c>>();
		Map<Id, List<Training_Attendee__c>> theTrainingAttendees = new Map<Id, List<Training_Attendee__c>>();
		for (Training_Attendee__c a: aList) {
		  List<Training_Attendee__c> atendees = theAttendees.get(a.Id);
		  if (atendees == null)
		  {	
			atendees = new List<Training_Attendee__c>();
			theAttendees.put(a.Attendee__c, atendees);
			theTrainingAttendees.put(a.Training__c, atendees);
		  }
		  atendees.add(a);
		}
		System.debug('====Training_AttendeeGateway + delGroupEvents + aList: ' + aList); 

        List<Training_Log__c> lList = [SELECT Id,Name,Notes__c,Group__c, Group__r.Name, Trainer__r.Name,Trainer__c,Training_Course__r.Name,Training_Course__c,Training_Date__c,Training_Outline__c,Training_Type__c 
        							FROM Training_Log__c 
                                    WHERE Id IN :theTrainingAttendees.Keyset()];   

        Map<Id, List<Training_Log__c>> listToGroup = new Map<Id, List<Training_Log__c>>();    
        Map<Id, List<Training_Log__c>> listToCourse = new Map<Id, List<Training_Log__c>>();   
        Map<Datetime , List<Training_Log__c>> listToDate = new Map<Datetime, List<Training_Log__c>>(); 
        Map<Id, List<Training_Log__c>> thelist = new Map<Id, List<Training_Log__c>>();    
        for (Training_Log__c o: lList) {
            List<Training_Log__c> lists = listToGroup.get(o.Id);
            if (lists == null)
            {
                lists = new List<Training_Log__c>();
                listToGroup.put(o.Group__c, lists);
                listToCourse.put(o.Training_Course__c, lists);
                listToDate.put(o.Training_Date__c, lists);
                thelist.put(o.Id, lists);
            }
        }      
        System.debug('====Training_AttendeeGateway + delGroupEvents + lList: ' + lList); 

		List<Group__c> gList =  [SELECT Id, Name FROM Group__c Where Id IN :listToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('====Training_AttendeeGateway + delGroupEvents + gList: ' + gList); 

		List<User_Group_Member__c> ugmList =  [SELECT Id, Name, Group_Member__c, Group_Members__c FROM User_Group_Member__c Where Group_Members__c IN :thegroup.Keyset()];
		Map<Id, List<User_Group_Member__c>> usergroupmem = new Map<Id, List<User_Group_Member__c>>();
		Map<Id, List<User_Group_Member__c>> groupMemFromGroup = new Map<Id, List<User_Group_Member__c>>();
		for (User_Group_Member__c ugm: ugmList) {
		  List<User_Group_Member__c> usergroupmems = usergroupmem.get(ugm.Group_Member__c);
		  if (usergroupmems == null)
		  {
			usergroupmems = new List<User_Group_Member__c>();
			usergroupmem.put(ugm.Group_Member__c, usergroupmems);
			groupMemFromGroup.put(ugm.Group_Members__c, usergroupmems);
		  }
		  usergroupmems.add(ugm);
		}
		System.debug('====Training_AttendeeGateway + delGroupEvents + ugmList: ' + ugmList); 

		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c FROM Contact Where Id IN :theAttendees.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		Map<Id, List<Contact>> groupToContact = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = groupToContact.get(c.Id);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
			groupToContact.put(c.Id, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('====Training_AttendeeGateway + delGroupEvents + cList: ' + cList); 

		List<Event> eList =  [SELECT WhatId, Training_Course__c,OwnerId,StartDateTime,WhoId 
								FROM Event  
								WHERE WhatId IN :thelist.Keyset() 
								AND WhoId IN :groupToContact.Keyset()
								AND Training_Course__c IN :listToCourse.Keyset()
								AND StartDateTime IN :listToDate.Keyset()
								AND OwnerId IN :contactToUser.Keyset()];
		List <Event> delEvents = new list <Event>();
		for (Event e: eList) {
		  System.debug('====Training_AttendeeGateway + delGroupEvents + e: ' + e); 
		  delEvents.add(e);
		}
		return delEvents;
	}
}