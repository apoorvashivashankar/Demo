public with sharing class Training_LogGateway {
    public static List<Training_Attendee__c> newTrainingAtendee (Set<Id> setLogId) {
        
        List<Training_Log__c> lList = [SELECT Id,Name,Notes__c,Group__c, Group__r.Name, Trainer__r.Name,Trainer__c,Training_Course__r.Name,Training_Course__c,Training_Date__c,Training_Outline__c,Training_Type__c 
        							FROM Training_Log__c 
                                    WHERE Id IN :setLogId];   

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

		List<Training_Attendee__c> aList =  [SELECT Attendee__c, Training__c,Id
								FROM Training_Attendee__c  
								WHERE Training__c IN :thelist.Keyset() 
								AND Attendee__c IN :groupToContact.Keyset()];
		Map<Id, List<Training_Attendee__c>> theAttendees = new Map<Id, List<Training_Attendee__c>>();
		for (Training_Attendee__c a: aList) {
		  List<Training_Attendee__c> atendees = theAttendees.get(a.Id);
		  if (atendees == null)
		  {	
			atendees = new List<Training_Attendee__c>();
			theAttendees.put(a.Attendee__c, atendees);
		  }
		  atendees.add(a);
		}

		List <Training_Attendee__c> trainingAtendeeList = new list <Training_Attendee__c>();

		for (Contact cnt: cList) {
			List < Training_Attendee__c > atendeeLIST = theAttendees.get(cnt.Id);
			for (Training_Log__c tl: lList) {
				if (atendeeLIST == null)  { 
					Training_Attendee__c atendee = new Training_Attendee__c();
					atendee.Attendee__c = cnt.Id;
					atendee.Training__c = tl.Id;
					trainingAtendeeList.add(atendee);
				} 
			} 
		}
		return trainingAtendeeList;
	}
}