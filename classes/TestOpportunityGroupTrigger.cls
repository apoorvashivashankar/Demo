@isTest(SeeAllData=true)
private class TestOpportunityGroupTrigger {

	// Declare variables
	public static List<GroupOpportunity__c> groupOpportunityList;
	public static List<Group__c> groupList;
	public static List<User_Group_Member__c> groupMemberList;
	public static List<Contact> contactList;
	public static List<User> userList;
	public static List<Opportunity> opportunityList;
	public static List<Account> accountList;
	public static List<OpportunityTeamMember> opportunityTeamMemberList;


	static testMethod void  testOpportunityContact() {
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

	Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, OwnerId = uGAL.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	insert o;
	System.debug('::::TestGalleryTaskTrigger + o ' + o);  

	Contact c2 = new Contact(
		FirstName = 'Jon'
		, LastName = 'Rust'
		, AccountId = a.Id
		, User__c = UserInfo.getUserId()
   	); 
   	insert c2;
   	System.debug('::::TestGalleryTaskTrigger + c2 ' + c2);

	Group__c g = new Group__c(
		Name = 'Test Group'
		, RecordTypeId = '0120G000000s1BI'
		, Group_Type__c = 'LPT'
   	);
   	insert g;
   	System.debug('::::TestGalleryTaskTrigger + g ' + g);

	User_Group_Member__c gm = new User_Group_Member__c(
		Group_Member__c = c2.Id
		, Group_Members__c = g.Id
   	);
   	insert gm;
   	System.debug('::::TestGalleryTaskTrigger + gm ' + gm);

   	GroupOpportunity__c go = new GroupOpportunity__c(
   		Group_Name__c = g.Id
   		, Opportunity_Name__c = o.Id
   	);
   	insert go;
	System.debug('::::TestGalleryTaskTrigger + go ' + go);

	OpportunityTeamMember otm = new OpportunityTeamMember(
		OpportunityId = go.Opportunity_Name__c,   
		UserId = UserInfo.getUserId(),
		TeamMemberRole = 'Sales Rep',
		OpportunityAccessLevel = 'Edit'
   	);
   	insert otm;
   	System.debug('::::TestGalleryTaskTrigger + go ' + go);
   	
	// Do inserts .. updates

	Test.stopTest();
	}

	static testMethod void  TestOpportunityGroupTrigger2() {
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

	Group__c g = new Group__c(
		Name = 'Test Group'
		, RecordTypeId = '0120G000000s1BI'
		, Group_Type__c = 'LPT'
   	);
   	insert g;

	Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, OwnerId = uGAL.Id
	    	, Name = 'TEST OPP'
	    	, Opportunity_Group__c = g.Id
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	insert o;
	System.debug('::::TestGalleryTaskTrigger + o ' + o);  

	Contact c = new Contact(
		FirstName = 'tester'
		, LastName = 'guyer'
		, AccountId = a.Id
		, User__c = uGAL.Id
   	); 
   	insert c;

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

	User_Group_Member__c gm2 = new User_Group_Member__c(
		Group_Member__c = c2.Id
		, Group_Members__c = g2.Id
   	);
   	insert gm2;
   	System.debug('::::TestGalleryTaskTrigger + gm ' + gm);

   	GroupOpportunity__c go = new GroupOpportunity__c(
   		Group_Name__c = g2.Id
   		, Opportunity_Name__c = o.Id
   		, Primary_Group__c = TRUE
   	);
   	insert go;
	System.debug('::::TestGalleryTaskTrigger + go ' + go);

	OpportunityTeamMember otm = new OpportunityTeamMember(
		OpportunityId = go.Opportunity_Name__c,   
		UserId = UserInfo.getUserId(),
		TeamMemberRole = 'Sales Rep',
		OpportunityAccessLevel = 'Edit'
   	);
   	insert otm;
   	System.debug('::::TestGalleryTaskTrigger + go ' + go);
   	
	// Do inserts .. updates

	Test.stopTest();
	}

	static testMethod void  TestOpportunityGroupTriggerDel() {
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

	Group__c g = new Group__c(
		Name = 'Test Group'
		, RecordTypeId = '0120G000000s1BI'
		, Group_Type__c = 'LPT'
   	);
   	insert g;

	Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, OwnerId = uGAL.Id
	    	, Name = 'TEST OPP'
	    	, Opportunity_Group__c = g.Id
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	insert o;
	System.debug('::::TestGalleryTaskTrigger + o ' + o);  

	Contact c = new Contact(
		FirstName = 'tester'
		, LastName = 'guyer'
		, AccountId = a.Id
		, User__c = uGAL.Id
   	); 
   	insert c;

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

	User_Group_Member__c gm2 = new User_Group_Member__c(
		Group_Member__c = c2.Id
		, Group_Members__c = g2.Id
   	);
   	insert gm2;
   	System.debug('::::TestGalleryTaskTrigger + gm ' + gm);

   	GroupOpportunity__c go = new GroupOpportunity__c(
   		Group_Name__c = g2.Id
   		, Opportunity_Name__c = o.Id
   		, Primary_Group__c = TRUE
   	);
   	insert go;
	System.debug('::::TestGalleryTaskTrigger + go ' + go);

	OpportunityTeamMember otm = new OpportunityTeamMember(
		OpportunityId = go.Opportunity_Name__c,   
		UserId = UserInfo.getUserId(),
		TeamMemberRole = 'Sales Rep',
		OpportunityAccessLevel = 'Edit'
   	);
   	insert otm;
   	System.debug('::::TestGalleryTaskTrigger + go ' + go);
   	

   	delete go;
	// Do inserts .. updates

	Test.stopTest();
	}

}