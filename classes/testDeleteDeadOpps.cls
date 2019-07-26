@isTest
private class testDeleteDeadOpps {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    private static void initA() {
    
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    
        Region__c r = new Region__c(Select__c = true
            , SBU__c = 'SC'
            , DW_ID__c = '113321'
            , Name = 'MIDWEST REGION11'); 
        insert r;
        
        SSC__c ssc = new SSC__c(Closed__c = false 
            , DW_ID__c = '000111'    
            , Loc_Type__c = 'SSC'
            , Manager__c = UserInfo.getUserId()
            , Region__c = r.Id
            , Sales_Region__c = '04'
            , SBU__c = 'DI'
            , Select__c = true
            , SSC_Fax_Number__c = '123-345-5567'
            , SSC_Phone_Number__c = '123-345-5567'
            , State__c = 'TX'
            , Street_Address__c = '12345 1st street'
            , Zip_Code__c = '12345');
        insert ssc;
        
        Account a1 = new Account(
            name = 'TestAcct1'
            , OwnerId = UserInfo.getUserid()
            , Region__c = r.id
            , BillingStreet = '123'
            , BillingCountry = '123'
            , BillingCity = 'DAL'
            , BillingState = 'TX'
            , BillingPostalCode = '72332'
            , ShippingStreet = '123'
            , ShippingCountry = 'US'
            , ShippingCity = 'DALLAS'
            , ShippingState = 'TX'
            , ShippingPostalCode = '72332'          
            ,  phone = '9722787827'
            ); 
        
        try {
                insert a1;
            }   catch (Exception e) {
            System.debug('::::TestCPQNewSample + insert a1::::> ' + e.getMessage());
            }     
        
        System.debug('::::TestCPQNewSample + a1::::> ' + a1);
        
        Account a2 = new Account(
            name = 'TestAcct2'
            , OwnerId = UserInfo.getUserid()
            , Region__c = r.id
            , BillingStreet = '123'
            , BillingCountry = '123'
            , BillingCity = 'DAL'
            , BillingState = 'TX'
            , BillingPostalCode = '72332'
            , ShippingStreet = '123'
            , ShippingCountry = 'US'
            , ShippingCity = 'DAL'
            , ShippingState = 'TX'
            , ShippingPostalCode = '72332'          
            ,  phone = '9722787827'
            ); 
        insert a2;
    
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = a1.Id
            , UserId = UserInfo.getUserid()
            , TeamMemberRole = 'Sales Rep'
            );
        insert atm;

        Account galAcc = new Account(
            name = 'TestGalleryAcct1'
            , OwnerId = UserInfo.getUserid()
            , Region__c = r.id
            , BillingStreet = '123'
            , BillingCountry = '123'
            , BillingCity = 'DAL'
            , BillingState = 'TX'
            , BillingPostalCode = '72332'
            , ShippingStreet = '123'
            , ShippingCountry = '123'
            , ShippingCity = 'DAL'
            , ShippingState = 'TX'
            , ShippingPostalCode = '72332'          
            ,  phone = '9722787827'
            ); 
        insert galAcc;    
        
        Contact c1 = new Contact (
            AccountId = a1.Id
            , firstName = 'Timmy'
            , lastname = 'TEST1'
            , Email = 'lalal@testst.com'
            , Phone = '214-555-7878'
            );
        insert c1;
            
        Contact c2 = new Contact (
            AccountId = a2.Id
            , firstName = 'Timmy'
            , lastname = 'TEST2'
            , Email = 'lalal@testst1.com'
            , Phone = '214-555-7871'
            );
        insert c2;              
    
        Opportunity o1 = new Opportunity (  
            AccountId = a1.Id
            , Name = 'TEST - Product Selection - Opp 1'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , OwnerId = uMGR.Id
            , CloseDate=  date.today()
            , StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
            );
        insert o1;
    
        Opportunity o2 = new Opportunity (  
            AccountId = a2.Id
            , Name = 'TEST OPP2 DELETE'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , OwnerId = uMGR.Id
            , CloseDate=  date.today()
            , StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
            );
        insert o2;
        
        String dupeOppName = 'TEST OPP1 - Product Selection - ' + system.today().format();

        Opportunity oDupe = new Opportunity (  
            AccountId = a1.Id
            , Name = dupeOppName
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , OwnerId = uMGR.Id
            , CloseDate=  date.today()
            , StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
            );
        insert oDupe;    
   
        OpportunityTeamMember otm = new OpportunityTeamMember(
            OpportunityId = o1.Id
            , OpportunityAccessLevel = 'Read'
            , UserId = uMGR.Id
            , TeamMemberRole = 'Sales Rep'
        );
        insert otm;

        Appointment__c apt = new Appointment__c (
            Status__c = 'Checked In'
            , Account__c = a1.id
            , Contact__c = c1.id
            , Daltile_Location__c = galAcc.id
            , Visitor_Time_In__c = System.now()
            , Project__c = o1.Id
        );
        insert apt;  
        
        Related_Customer__c rc1 = new Related_Customer__c(
            Contact__c = c1.Id
            , Related_Account__c = a1.Id
            , Opportunity__c = o1.Id
            , Shopping_Cart__c = TRUE
            , DW_ID__c = 'test1'
            , Appointment__c = apt.id
            );
        insert rc1;
            
        Related_Customer__c rc2 = new Related_Customer__c(
            Contact__c = c2.Id
            , Related_Account__c = a2.Id
            , Opportunity__c = o2.Id
            , Shopping_Cart__c = TRUE
            , DW_ID__c = 'test2'
            );
        insert rc2;  

        id oldAccount = a1.id;
        id newAccount = a2.id;
        id relatedCustomerId = rc1.id;
        id oldOpp = o1.id;
        id oldContactId = c1.id;
        id newContact = c2.id;
        id newOpp = o2.id;
        id oldRc = rc1.id;
        id newRc = rc2.id;      
        String updateShipCountry = 'UN';
        String updateShipState = 'TN';
        String updateShipAddress1 = 'TEST ADDRES...';
        String updateShipCity = 'GARLAND';
        String updateShipPostal = '75203';
        String newContactFirstName = 'JEFF';
        String newContactLastName = 'TESTALOT';
        String newContactEmail = 'tst@tst.com';
        String newContactPhone = '972-444-5555';
        String newON = 'Wooooopiiiieeeee';
        String theVisitorType = 'HomeOwner';
        
    }
      
    static testMethod void testOppUpdates1() {     
    initA();
    UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    User uMGR = [SELECT 
                    ID
                    ,Name 
                FROM User 
                where UserRoleID =  : rMGR.Id 
                AND IsActive = TRUE LIMIT 1];
    Contact c1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST1'];
    Contact c2 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST2'];
    System.debug('::::testOppUpdates1 + c2: 1 :::> ' + c2);
    Account a1 = [ SELECT
                        Id
                        ,NAME
                        ,Customer_Class__c
                        ,phone
                        ,DW_ID__c
                        ,SSC__c
                        ,BillingStreet
                        ,BillingCity
                        ,BillingState
                        ,BillingPostalCode 
                        ,BillingCountry
                        ,ShippingStreet
                        ,ShippingCity
                        ,ShippingState
                        ,ShippingPostalCode 
                        ,ShippingCountry
                    FROM Account
                    WHERE name = 'TestAcct1'];
    Account a2 = [ SELECT
                        Id
                        ,NAME
                        ,Customer_Class__c
                        ,phone
                        ,DW_ID__c
                        ,SSC__c
                        ,BillingStreet
                        ,BillingCity
                        ,BillingState
                        ,BillingPostalCode 
                        ,BillingCountry
                        ,ShippingStreet
                        ,ShippingCity
                        ,ShippingState
                        ,ShippingPostalCode 
                        ,ShippingCountry
                    FROM Account
                    WHERE name = 'TestAcct2'];

    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST - Product Selection - Opp 1'];

    Opportunity o2 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST OPP2 DELETE'];

    Related_Customer__c rc1 = [SELECT Id
                        ,Related_account__c
                        ,DW_ID__c
                        ,Shopping_Cart__c
                        ,Related_account__r.Name
                        ,Related_account__r.Customer_Class__c
                        ,Related_account__r.ShippingCountry
                        ,Related_account__r.ShippingStreet
                        ,Related_account__r.ShippingCity
                        ,Related_account__r.ShippingState
                        ,Related_account__r.ShippingPostalCode
                        ,Opportunity__c
                        ,Opportunity__r.Name
                        ,New_Opportunity__c
                        ,New_Opportunity_Name__c
                        ,New_Contact__c
                        ,New_ContactLastName__c
                        ,New_ContactFirstName__c
                        ,New_ContactEmail__c
                        ,New_ContactPhone__c
                        ,Contact__c
                        ,Contact__r.FirstName
                        ,Contact__r.LastName
                        ,Contact__r.Email
                        ,Contact__r.Phone
                        ,Update_ShippingCountry__c
                        ,Update_ShippingStreet__c
                        ,Update_ShippingCity__c
                        ,Update_ShippingState__c
                        ,Update_ShippingPostalCode__c
                        ,Appointment__c
                        ,Appointment__r.Visitor_Type__c
                        ,Gallery__c
                        ,API_Partner_URL__c                                 
                        FROM Related_Customer__c
                        WHERE Opportunity__c = :o1.Id];
                        

    Related_Customer__c rc2 = [SELECT Id
                        ,Related_account__c
                        ,DW_ID__c
                        ,Shopping_Cart__c
                        ,Related_account__r.Name
                        ,Related_account__r.Customer_Class__c
                        ,Related_account__r.ShippingCountry
                        ,Related_account__r.ShippingStreet
                        ,Related_account__r.ShippingCity
                        ,Related_account__r.ShippingState
                        ,Related_account__r.ShippingPostalCode
                        ,Opportunity__c
                        ,Opportunity__r.Name
                        ,New_Opportunity__c
                        ,New_Opportunity_Name__c
                        ,New_Contact__c
                        ,New_ContactLastName__c
                        ,New_ContactFirstName__c
                        ,New_ContactEmail__c
                        ,New_ContactPhone__c
                        ,Contact__c
                        ,Contact__r.FirstName
                        ,Contact__r.LastName
                        ,Contact__r.Email
                        ,Contact__r.Phone
                        ,Update_ShippingCountry__c
                        ,Update_ShippingStreet__c
                        ,Update_ShippingCity__c
                        ,Update_ShippingState__c
                        ,Update_ShippingPostalCode__c
                        ,Appointment__c
                        ,Appointment__r.Visitor_Type__c
                        ,Gallery__c
                        ,API_Partner_URL__c                                 
                        FROM Related_Customer__c
                        WHERE Opportunity__c = :o2.Id];                        
    
    Id relatedCustomerId = rc1.Id;
    rc1.New_Opportunity__c = o1.id;
    id oldAccount = a1.id;
    id newAccount = a2.id;
    id oldOpp = o1.id;
    id oldContactId = c1.id;
    id newContact = c2.id;
    id newOpp = o2.id;
    id oldRc = rc1.id;
    id newRc = rc2.id;  
    id galleryContact = c1.id;
 
    String updateShipCountry = 'US';
    String updateShipState = 'TN';
    String updateShipAddress1 = 'TEST ADDRES...';
    String updateShipCity = 'GARLAND';
    String updateShipPostal = '75203';
    String newContactFirstName = 'JEFF';
    String newContactLastName = 'TESTALOT';
    String newContactSecondLastName = 'TEST1';
    String newContactEmail = 'tst@tst.com';
    String newContactPhone = '972-444-5555';
    String newON = 'Wooooopiiiieeeee';
    String theVisitorType = 'HomeOwner';
    String theNewContactId = c1.id;
    
    Test.startTest();
 
     //insert test data


     //Call the static method directly
     String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP,
        new deleteDeadOppsScheduled());
        deleteDeadOpps delOppDel = new deleteDeadOpps();
        Database.executeBatch(delOppDel); 
    Test.stopTest();
       
}   

    static testMethod void testOppUpdatesError() {     
        initA();
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                        ID
                        ,Name 
                    FROM User 
                    where UserRoleID =  : rMGR.Id 
                    AND IsActive = TRUE LIMIT 1];
        Contact c1 = [ SELECT 
                            Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,Phone
                            ,AccountId
                        FROM Contact
                        WHERE lastname = 'TEST1'];
        Contact c2 = [ SELECT 
                            Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,Phone
                            ,AccountId
                        FROM Contact
                        WHERE lastname = 'TEST2'];
        System.debug('::::testOppUpdates1 + c2: 1 :::> ' + c2);
        Account a1 = [ SELECT
                            Id
                            ,NAME
                            ,Customer_Class__c
                            ,phone
                            ,DW_ID__c
                            ,SSC__c
                            ,BillingStreet
                            ,BillingCity
                            ,BillingState
                            ,BillingPostalCode 
                            ,BillingCountry
                            ,ShippingStreet
                            ,ShippingCity
                            ,ShippingState
                            ,ShippingPostalCode 
                            ,ShippingCountry
                        FROM Account
                        WHERE name = 'TestAcct1'];
        Account a2 = [ SELECT
                            Id
                            ,NAME
                            ,Customer_Class__c
                            ,phone
                            ,DW_ID__c
                            ,SSC__c
                            ,BillingStreet
                            ,BillingCity
                            ,BillingState
                            ,BillingPostalCode 
                            ,BillingCountry
                            ,ShippingStreet
                            ,ShippingCity
                            ,ShippingState
                            ,ShippingPostalCode 
                            ,ShippingCountry
                        FROM Account
                        WHERE name = 'TestAcct2'];
    
        Opportunity o1 = [SELECT 
                        Id
                        ,Name
                        ,StageName
                        ,AccountId
                        FROM Opportunity
                        WHERE Name = 'TEST - Product Selection - Opp 1'];
    
        Opportunity o2 = [SELECT 
                        Id
                        ,Name
                        ,StageName
                        ,AccountId
                        FROM Opportunity
                        WHERE Name = 'TEST OPP2 DELETE'];
    
        Related_Customer__c rc1 = [SELECT Id
                            ,Related_account__c
                            ,DW_ID__c
                            ,Shopping_Cart__c
                            ,Related_account__r.Name
                            ,Related_account__r.Customer_Class__c
                            ,Related_account__r.ShippingCountry
                            ,Related_account__r.ShippingStreet
                            ,Related_account__r.ShippingCity
                            ,Related_account__r.ShippingState
                            ,Related_account__r.ShippingPostalCode
                            ,Opportunity__c
                            ,Opportunity__r.Name
                            ,New_Opportunity__c
                            ,New_Opportunity_Name__c
                            ,New_Contact__c
                            ,New_ContactLastName__c
                            ,New_ContactFirstName__c
                            ,New_ContactEmail__c
                            ,New_ContactPhone__c
                            ,Contact__c
                            ,Contact__r.FirstName
                            ,Contact__r.LastName
                            ,Contact__r.Email
                            ,Contact__r.Phone
                            ,Update_ShippingCountry__c
                            ,Update_ShippingStreet__c
                            ,Update_ShippingCity__c
                            ,Update_ShippingState__c
                            ,Update_ShippingPostalCode__c
                            ,Appointment__c
                            ,Appointment__r.Visitor_Type__c
                            ,Gallery__c
                            ,API_Partner_URL__c                                 
                            FROM Related_Customer__c
                            WHERE Opportunity__c = :o1.Id];
                            
    
        Related_Customer__c rc2 = [SELECT Id
                            ,Related_account__c
                            ,DW_ID__c
                            ,Shopping_Cart__c
                            ,Related_account__r.Name
                            ,Related_account__r.Customer_Class__c
                            ,Related_account__r.ShippingCountry
                            ,Related_account__r.ShippingStreet
                            ,Related_account__r.ShippingCity
                            ,Related_account__r.ShippingState
                            ,Related_account__r.ShippingPostalCode
                            ,Opportunity__c
                            ,Opportunity__r.Name
                            ,New_Opportunity__c
                            ,New_Opportunity_Name__c
                            ,New_Contact__c
                            ,New_ContactLastName__c
                            ,New_ContactFirstName__c
                            ,New_ContactEmail__c
                            ,New_ContactPhone__c
                            ,Contact__c
                            ,Contact__r.FirstName
                            ,Contact__r.LastName
                            ,Contact__r.Email
                            ,Contact__r.Phone
                            ,Update_ShippingCountry__c
                            ,Update_ShippingStreet__c
                            ,Update_ShippingCity__c
                            ,Update_ShippingState__c
                            ,Update_ShippingPostalCode__c
                            ,Appointment__c
                            ,Appointment__r.Visitor_Type__c
                            ,Gallery__c
                            ,API_Partner_URL__c                                 
                            FROM Related_Customer__c
                            WHERE Opportunity__c = :o2.Id];                        
        
        Id relatedCustomerId = rc1.Id;
        rc1.New_Opportunity__c = o1.id;
        id oldAccount = a1.id;
        id newAccount = a2.id;
        id oldOpp = o1.id;
        id oldContactId = c1.id;
        id newContact = c2.id;
        id newOpp = o2.id;
        id oldRc = rc1.id;
        id newRc = rc2.id;  
        id galleryContact = c1.id;
     
        String updateShipCountry = 'US';
        String updateShipState = 'TN';
        String updateShipAddress1 = 'TEST ADDRES...';
        String updateShipCity = 'GARLAND';
        String updateShipPostal = '75203';
        String newContactFirstName = 'JEFF';
        String newContactLastName = 'TESTALOT';
        String newContactSecondLastName = 'TEST1';
        String newContactEmail = 'tst@tst.com';
        String newContactPhone = '972-444-5555';
        String newON = 'Wooooopiiiieeeee';
        String theVisitorType = 'HomeOwner';
        String theNewContactId = c1.id;
        
        Test.startTest();
     
        //Call the static method directly
        try {
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new deleteDeadOppsScheduled());
        deleteDeadOppsGeneric delOppGen = new deleteDeadOppsGeneric();
        Database.executeBatch(delOppGen); 
        } catch (Exception e) {
            System.debug('::::testOppQuote::::> ' + e.getMessage());
	    } 
        Test.stopTest();
       
    }   
    
    
    
}