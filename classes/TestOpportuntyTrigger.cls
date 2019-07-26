@isTest(SeeAllData=true)
private class TestOpportuntyTrigger
{
	static OpportunityHandler ext;
 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
    User uGAL = [SELECT ID, Name FROM User where UserRoleID =  : rGAL.Id AND IsActive = TRUE LIMIT 1];


	private static void init() {

	}

    static testMethod void testSalesAccountTeamTrigger2(){
    	Test.startTest();
		try {       
		Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

	    Profile pAdm = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uAdm = [SELECT ID, Name FROM User where ProfileId =  : pAdm.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
	    Opportunity opp = new Opportunity (
    	AccountId = a.Id
    	, Name = 'TEST OPP'
        , Project_City__c = 'Dallas'
        , Project_State__c = 'TX'
		, CloseDate=  date.today()
		, StageName = '2 - Specification'
        , Sub_Stage__c = '1 - Prospect'
    	);
		insert opp; 

        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = opp.Id;
        otm.OpportunityAccessLevel = 'Read';
        otm.UserId = UserInfo.getUserid();
        otm.TeamMemberRole = 'Sales Rep';
        insert otm;
        
        opp.OwnerId = [select Id from User where isActive=true and profile.Name = 'System Administrator' limit 1][0].Id;
        update opp;

		Group__c g = new Group__c(
			Name = 'Test Group'
			, RecordTypeId = '0120G000000s1BI'
			, Group_Type__c = 'LPT'
	   	);
	   	insert g;

		}   catch (Exception e) {
        System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
		Test.stopTest();		       
    }

    static testMethod void testOppGroupOpp(){
    	Test.startTest();
		try {       
		
	 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

	    Profile pAdm = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uAdm = [SELECT ID, Name FROM User where ProfileId =  : pAdm.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

		Group__c g = new Group__c(
			Name = 'Test Group'
			, RecordTypeId = '0120G000000s1BI'
			, Group_Type__c = 'LPT'
	   	);
	   	insert g;

		Group__c g2 = new Group__c(
			Name = 'Test Group 2'
			, RecordTypeId = '0120G000000s1BI'
			, Group_Type__c = 'LPT'
	   	);
	   	insert g2;	   	
		
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
	    Opportunity opp = new Opportunity (
    	AccountId = a.Id
    	, Name = 'TEST OPP'
        , Project_City__c = 'Dallas'
        , Project_State__c = 'TX'
        , OwnerId = uGAL.Id
		, CloseDate=  date.today()
		, StageName = '2 - Specification'
        , Sub_Stage__c = '1 - Prospect'
        , Opportunity_Group__c = g.Id
    	);
		insert opp; 
		System.debug('::::TestGalleryTaskTrigger + opp ' + opp);

        GroupOpportunity__c groupOpps = new GroupOpportunity__c();
        groupOpps.Group_Name__c = g.id;
        groupOpps.Opportunity_Name__c = opp.Id;
        insert groupOpps;

        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = opp.Id;
        otm.OpportunityAccessLevel = 'Read';
        otm.UserId = UserInfo.getUserid();
        otm.TeamMemberRole = 'Sales Rep';
        insert otm;
        
        System.debug('::::TestGalleryTaskTrigger + 1:opp.Opportunity_Group__c ' + opp.Opportunity_Group__c);        
        opp.Opportunity_Group__c = g2.id;
        update opp;
        System.debug('::::TestGalleryTaskTrigger + 2:opp.Opportunity_Group__c ' + opp.Opportunity_Group__c);

        delete opp; 

		}   catch (Exception e) {
        System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
		Test.stopTest();		       
    }

    static testMethod void testOppGroupOppUpdate(){
    	Test.startTest();
		try {       
		
	 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

	    Profile pAdm = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uAdm = [SELECT ID, Name FROM User where ProfileId =  : pAdm.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

		Group__c g = new Group__c(
			Name = 'Test Group'
			, RecordTypeId = '0120G000000s1BI'
			, Group_Type__c = 'LPT'
	   	);
	   	insert g;

		Group__c g2 = new Group__c(
			Name = 'Test Group 2'
			, RecordTypeId = '0120G000000s1BI'
			, Group_Type__c = 'LPT'
	   	);
	   	insert g2;	   	
		
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
	    Opportunity opp = new Opportunity (
    	AccountId = a.Id
    	, Name = 'TEST OPP'
        , Project_City__c = 'Dallas'
        , Project_State__c = 'TX'
        , OwnerId = uGAL.Id
		, CloseDate=  date.today()
		, StageName = '2 - Specification'
        , Sub_Stage__c = '1 - Prospect'
        , Opportunity_Group__c = g.Id
    	);
		insert opp; 
		System.debug('::::TestGalleryTaskTrigger + opp ' + opp);

        GroupOpportunity__c groupOpps = new GroupOpportunity__c();
        groupOpps.Group_Name__c = g.id;
        groupOpps.Opportunity_Name__c = opp.Id;
        insert groupOpps;

        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = opp.Id;
        otm.OpportunityAccessLevel = 'Read';
        otm.UserId = UserInfo.getUserid();
        otm.TeamMemberRole = 'Sales Rep';
        insert otm;
        
        OpportunityGateway.firstRun = true;
        OpportunityHandler.firstRun = true;

        System.debug('::::TestGalleryTaskTrigger + 1:opp.Opportunity_Group__c ' + opp.Opportunity_Group__c);        
        opp.Opportunity_Group__c = g2.id;
        update opp;
        System.debug('::::TestGalleryTaskTrigger + 2:opp.Opportunity_Group__c ' + opp.Opportunity_Group__c);

	    Opportunity opp2 = new Opportunity (
    	AccountId = a.Id
    	, Name = 'TEST OPP'
        , Project_City__c = 'Dallas'
        , Project_State__c = 'TX'
		, CloseDate=  date.today()
		, StageName = '2 - Specification'
        , Sub_Stage__c = '1 - Prospect'
    	);
		insert opp2; 

        GroupOpportunity__c groupOpps2 = new GroupOpportunity__c();
        groupOpps.Group_Name__c = g.id;
        groupOpps.Opportunity_Name__c = opp2.Id;
        insert groupOpps2;

        GroupOpportunity__c groupOpps3 = new GroupOpportunity__c();
        groupOpps.Group_Name__c = g2.id;
        groupOpps.Opportunity_Name__c = opp.Id;
        insert groupOpps3;

        delete opp2; 

		}   catch (Exception e) {
        System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
		Test.stopTest();		       
    }



//     static testMethod void TestNewGalleryTaskTrigger() {
//  	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
//  	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
//     User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
//     System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

// 	    Account a = new Account(
// 	    	name = 'test account'  
// 	    	); 


// 	    Opportunity o = new Opportunity (
// 	    	AccountId = a.Id
// 	    	, Name = 'TEST OPP'
//             , Project_City__c = 'Dallas'
//             , Project_State__c = 'TX'
// 	    	, OwnerId = uGAL.Id
// 			, CloseDate=  date.today()
// 			, StageName = '2 - Specification'
//             , Sub_Stage__c = '1 - Prospect'
// 	    	);

 
//         Task t = new Task();
//         t.WhatId=o.Id;
//         t.RecordTypeId='012F0000000mpvb';
//         t.Number_of_Gallery_Visits__c=8;
//         t.OwnerId=UserInfo.getUserId();
//         t.Status='Completed';
//         t.Gallery_Visit_Date__c=Date.today().addDays(3);
//         t.Gallery_Visit_From_Opp__c=true;
//         t.Gallery_Visit_Instructions__c='Test';

    

//     	Test.startTest();
// 					System.runAs(uGAL){
// 			try {
// 						insert a;
// 						System.debug('::::testOppQuote + a ' + a);
// 						insert o;
// 						System.debug('::::testOppQuote + o ' + o);
// 						insert t;			        
// 				        o.OwnerId = [select Id from User where isActive=true and profile.Name = 'System Administrator' limit 1][0].Id;
// 				        update o;
// //	              		OpportunityHandler.afterInsert(o);	
// 				}   catch (Exception e) {
// 		        System.debug('::::testOppQuote::::> ' + e.getMessage());
// 			    } 
// 	              	}
// 		Test.stopTest();

//     }

//     static testMethod void TestUpdateGalleryTaskTrigger() {
//  	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
//  	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
//     User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
//     System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

//     Profile pAdm = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];    
//  	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
//     User uAdm = [SELECT ID, Name FROM User where ProfileId =  : pAdm.Id AND IsActive = TRUE LIMIT 1];
//     System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

// 	    Account a = new Account(
// 	    	name = 'x'
// 	        , BillingStreet = 'XXX'
// 	        , BillingCity = 'XXX'
// 		    , BillingState = 'xx'
// 	        , BillingPostalCode = '72332'
// 	        ,  phone = '9722787827'
// 	    	); 

// 		insert a;
// 		System.debug('::::testOppQuote + a ' + a);

// 	    Opportunity o = new Opportunity (
// 	    	AccountId = a.Id
// 	    	, Name = 'TEST OPP' 
//             , Project_City__c = 'Dallas'
//             , Project_State__c = 'TX'
// 	    	, OwnerId = uGAL.Id
// 			, CloseDate=  date.today()
// 			, StageName = '2 - Specification'
//             , Sub_Stage__c = '1 - Prospect'
// 	    	);

// 		insert o;
// 		System.debug('::::testOppQuote + o ' + o);
//         Task t = new Task();
//         t.WhatId=o.Id;
//         t.RecordTypeId='012F0000000mpvb';
//         t.Number_of_Gallery_Visits__c=8;
//         t.OwnerId=UserInfo.getUserId();
//         t.Status='Completed';
//         t.Gallery_Visit_Date__c=Date.today().addDays(3);
//         t.Gallery_Visit_From_Opp__c=true;
//         t.Gallery_Visit_Instructions__c='Test';

    
//     	Test.startTest();
// 			try {

// 					System.runAs(uGAL){
// 					        o.OwnerId = [select Id from User where isActive=true and profile.Name = 'System Administrator' limit 1][0].Id;
// 					        update o;
// 	              	}
// 						insert t;			        
// //	              		OpportunityHandler.afterInsert(o);	
// 				}   catch (Exception e) {
// 		        System.debug('::::testOppQuote::::> ' + e.getMessage());
// 			    } 
// 		Test.stopTest();

//     }

    static testMethod void testSalesAccountTeamTrigger(){
 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);


	    Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 

	    Account a1 = new Account(
	    	name = 'x1'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 

	    Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
	    	, OwnerId = uGAL.Id
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);

        AccountTeamMember atm = new AccountTeamMember(
	        AccountId = a.Id
	        , UserId = UserInfo.getUserid()
	        , TeamMemberRole = 'Sales Rep'
	        );


    	Test.startTest();
			try {
						insert a;
						System.debug('::::testOppQuote + a ' + a);
						insert o;
						System.debug('::::testOppQuote + o ' + o);
				        insert atm;
			            Id oldOwnerId = o.OwnerId;

			            OpportunityShare oppSh = new OpportunityShare(OpportunityId = o.Id,
			                                                userOrGroupId = oldOwnerId,
			                                                OpportunityAccessLevel = 'Edit' );
            			insert oppSh;
						insert a1;			        
//						System.runAs(uGAL){
				        o.OwnerId = uGAL.Id;
				        update o;
				        o.AccountId = a1.Id;
				        update o;				        
//	              		OpportunityHandler.afterInsert(o);	
//	              	}
				}   catch (Exception e) {
		        System.debug('::::testOppQuote::::> ' + e.getMessage());
			    } 

    }

    static testMethod void testSwitchedSpedTrigger(){
	 	Profile rGAL = [SELECT Id, Name FROM Profile WHERE Name = 'Gallery User'];    
	 	System.debug('::::TestGalleryTaskTrigger + rGAL ' + rGAL);
	    User uGAL = [SELECT ID, Name FROM User where ProfileId =  : rGAL.Id AND IsActive = TRUE LIMIT 1];
	    System.debug('::::TestGalleryTaskTrigger + uGAL ' + uGAL);

        Account act = new Account();
        act.Name = 'test account';
        insert act;
        
        Opportunity opp = new Opportunity (
	    	AccountId = act.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
	    	, OwnerId = uGAL.Id
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
        insert opp;

        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.OpportunityId = opp.Id;
        otm.OpportunityAccessLevel = 'Read';
        otm.UserId = uGAL.Id;
        otm.TeamMemberRole = 'Sales Rep';
        insert otm;
        

	    opp.OwnerId = uGAL.Id;
	    update opp;

        Task t = new Task();
        t.WhatId=opp.Id;
        t.RecordTypeId='012F0000000mpvb';
        t.Number_of_Gallery_Visits__c=8;
        t.OwnerId=UserInfo.getUserId();
        t.Status='Completed';
        t.Gallery_Visit_Date__c=Date.today().addDays(3);
        t.Gallery_Visit_From_Opp__c=true;
        t.Gallery_Visit_Instructions__c='Test';
        insert t;

        opp.Switched_Spec__c = TRUE;
        update opp;

        Task tt = new Task();
        tt.WhatID=opp.id;
        tt.Goals__c='Switched Spec';
        tt.Type__c='Switched Spec';
        tt.Type='Switched Spec';
        tt.Subject='Switched Spec';
        tt.Primary_Objective__c='Switched Spec';
        tt.ActivityDate=date.today();
        tt.Status='Completed';
        tt.Priority='Normal';
        tt.Description='New Switched Spec on Opportuntiy: ' + opp.Account_Opportunity_Name__c;
        insert tt;

        delete opp;
    }
    static testMethod void testNewSwitchedSpecTrigger(){

        Account act = new Account();
        act.Name = 'test account';
        insert act;
	    System.debug('::::TestGalleryTaskTrigger + act ' + act);
        
        Opportunity opp = new Opportunity (
	    	AccountId = act.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , Switched_Spec__c = TRUE
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
        insert opp;


        Task tt = new Task();
        tt.WhatID=opp.id;
        tt.Goals__c='Switched Spec';
        tt.Type__c='Switched Spec';
        tt.Type='Switched Spec';
        tt.Subject='Switched Spec';
        tt.Primary_Objective__c='Switched Spec';
        tt.ActivityDate=date.today();
        tt.Status='Completed';
        tt.Priority='Normal';
        tt.Description='New Switched Spec on Opportuntiy: ' + opp.Account_Opportunity_Name__c;
        insert tt;
    }

   static testMethod void testUpdateSalesAccountTeamTrigger(){
	    Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 

	    Account a1 = new Account(
	    	name = 'x1'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 

	    Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);

    	Related_Customer__c rc = new Related_Customer__c(
	        Opportunity__c = o.id
	        , Related_Account__c=o.AccountId
	        , Role__c='Architect'
        );

    	Test.startTest();

			try {
						insert a;
						System.debug('::::testOppQuote + a ' + a);
						insert o;
						System.debug('::::testOppQuote + o ' + o);

						insert a1;			        
//						System.runAs(uGAL){
				        o.AccountId = a1.Id;
				        update o;	
				        insert rc;			        
//	              		OpportunityHandler.afterInsert(o);	
//	              	}
				}   catch (Exception e) {
		        System.debug('::::testOppQuote::::> ' + e.getMessage());
			    } 
		Test.stopTest();
    }

        @isTest static void testEstValue(){

        Account act = new Account();
        act.Name = 'test account';
        insert act;
	    System.debug('::::testEstValue + act ' + act);
        
        Opportunity opp = new Opportunity (
	    	AccountId = act.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , Estimated_Value__c = 0
            , Switched_Spec__c = TRUE
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
            , RecordTypeId = '012A0000000gXv8'
	    	);
        insert opp;
        System.debug('::::testEstValue + opp ' + opp);
		Test.startTest();
		try {
			//opp.Estimated_Value__c = 75;
			//update opp;
			//System.debug('::::testEstValue + opp update ... ' + opp);

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
	    System.debug('::::testEstValue + pricebookId ' + pricebookId);

        // First, set up test price book entries.
        // Insert a test product.
        Product2 prod = new Product2(Name = 'Free Frorm',IsActive = TRUE);
        insert prod;
	    System.debug('::::testEstValue + prod ' + prod);
        
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice;
	    System.debug('::::testEstValue + standardPrice ' + standardPrice);

        opportunitylineitem oli = new opportunitylineitem(
	        opportunityid = opp.id,
	        unitprice = 50,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::testEstValue + oli ' + oli);
		

	        opportunitylineitem oli2 = new opportunitylineitem(
		        opportunityid = opp.id,
		        unitprice = 25,
		        quantity = 1,        // Don't reference product, but its pricebook entry
		        pricebookentryid = standardPrice.Id);
			insert oli2;
            
            OpportunityGateway.firstRun = true;
            OpportunityHandler.firstRun = true;
            opp.Estimated_Value__c = 75;
			update opp;
			System.debug('::::testEstValue + opp update ... ' + opp);

 		}   catch (Exception e) {
        System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
		Test.stopTest();	
    }

    @isTest static void testEstValue2(){


		Test.startTest();

        Account act = new Account();
        act.Name = 'test account';
        insert act;
	    System.debug('::::testEstValue2 + act ' + act);


        Opportunity opp2 = new Opportunity (
	    	AccountId = act.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , Estimated_Value__c = 75
            , Switched_Spec__c = TRUE
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
//            , RecordTypeId = '012A0000000gXv8'
	    	);
        insert opp2;
        System.debug('::::testEstValue2 + opp2 ' + opp2);

		try {

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        System.debug('::::testEstValue2 + pricebookId ' + pricebookId);

        // First, set up test price book entries.
        // Insert a test product.
        Product2 prod = new Product2(Name = 'Free Frorm');
        insert prod;
        System.debug('::::testEstValue2 + prod ' + prod);
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice;
        System.debug('::::testEstValue2 + standardPrice ' + standardPrice);
	

        opportunitylineitem oli4 = new opportunitylineitem(
	        opportunityid = opp2.id,
	        TotalPrice  = 75,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli4;
		System.debug('::::testEstValue2 + oli4 ' + oli4);



 		}   catch (Exception e) {
        System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
		Test.stopTest();	
    }
}