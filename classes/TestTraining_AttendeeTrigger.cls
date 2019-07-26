@isTest(SeeAllData=true)
private class   TestTraining_AttendeeTrigger {

	static testMethod void  TestTraining_AttendeeTrigger() {
	Test.startTest();
 	Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];    
    User u = [SELECT ID, Name FROM User where ProfileId in (SELECT Id FROM Profile WHERE Name = 'System Administrator') AND IsActive = TRUE LIMIT 1];

 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

	Account a = new Account(
	    	name = 'Daltile Internal Communications'
	    	, OwnerId = uGAL.Id
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	insert a;
	System.debug('::::TestGalleryTaskTrigger + a ' + a);

	Contact c = new Contact(
		FirstName = 'tester'
		, LastName = 'guyer'
		, AccountId = a.Id
		, User__c = uGAL.Id
   	); 
   	insert c;

	Group__c g = new Group__c(
		Name = 'Test Group'
		, RecordTypeId = '0120G000000s1BI'
		, Group_Type__c = 'LPT'
   	);
   	insert g;

	Contact c2 = new Contact(
		FirstName = 'test'
		, LastName = 'guy'
		, AccountId = a.Id
		, User__c = u.Id
   	); 
   	insert c2;
   	System.debug('::::TestGalleryTaskTrigger + c2 ' + c2);


	Group__c g2 = new Group__c(
		Name = 'Test Group 2'
		, RecordTypeId = '0120G000000s1BI'
		, Group_Type__c = 'LPT'
   	);
   	insert g2;
   	System.debug('::::TestGalleryTaskTrigger + g2 ' + g2);

	User_Group_Member__c gm = new User_Group_Member__c(
		Group_Member__c = c.Id
		, Group_Members__c = g2.Id
   	);
   	insert gm;

   	Training_Course__c tc = new Training_Course__c(
   		Name =  'TEST COURSE'
   		, Training_Topics__c = 'Follow me; Sharing a file found in Chatter; Loading a file into Salesforce'
   	);
   	insert tc;
	System.debug('::::TestGalleryTaskTrigger + tc ' + tc);
	Training_Log__c tl = new Training_Log__c(
		 Name = 'TEST LOG'
		, Notes__c = 'TEST NOTEST'
		, Group__c = g2.Id
		, Trainer__c = U.Id
		, Training_Course__c = tc.Id
		, Training_Date__c = System.now()
		, Training_Type__c  = 'Webinar'
	 );
	insert tl;
	System.debug('::::TestGalleryTaskTrigger + tl ' + tl);

	try {
	Training_Attendee__c atendee = new Training_Attendee__c(
		Attendee__c = c.Id
		, Training__c = tl.Id
	);
	insert atendee;


	Event event = new Event(
	WhatId = tl.Id
	, Training_Course__c = tc.Id
	, OwnerId = uGAL.Id
	, StartDateTime = tl.Training_Date__c
	, EndDateTime = tl.Training_Date__c.addHours(2)
	, Subject = tl.Training_Course__r.Name + ' with the ' + tl.Group__r.Name + ' Group, led by ' + tl.Trainer__r.Name
	, Goals__c = 'Internal Training'
	, Type = 'Meeting'
	, WhoId = c.Id
	, Type__c = 'Meeting'
	);
	insert event;


	uGAL.Trained__c = TRUE;
	uGAL.Date_Trained__c = date.today();
	update uGAL;

	System.debug('::::TestGalleryTaskTrigger + uGALuGAL ' + uGAL);
	tl.Training_Outline__c = '...AND A NEW UPDATE!';
   	update tl;
   	System.debug('::::TestGalleryTaskTrigger + tl ' + tl);
   	delete atendee;
   	System.debug('::::TestGalleryTaskTrigger + atendee ' + atendee);

	// Do inserts .. updates

			}   catch (Exception e) {
	        System.debug('::::testAccountQuote::::> ' + e.getMessage());
		    } 

	Test.stopTest();			    
	}
}