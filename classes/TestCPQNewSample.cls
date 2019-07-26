@isTest
public class TestCPQNewSample
{
    
    public String oppId  {get;set;}
    public List <Opportunity> initOppList  {get;set;}
    public Opportunity oppList  {get;set;}
    public static String theOppId {get;set;}
    public static Opportunity useThisOpp {get;set;}
    public Account acc {get;set;}
    public Contact cnt {get;set;}
    public Opportunity returnOpp {get;set;}
    public Opportunity opp {get;set;}
    public OpportunityContactRole oppCR {get;set;}
    public String accountId  {get;set;}
    public String contactId  {get;set;}
    public String theRecord {get;set;}
    public String theRecordCheckId {get;set;}
    public String theRecordId {get;set;}
    public String relatedCustomerId  {get;set;}
    public Appointment__c apt {get;set;}    
    public Boolean cntCheck {get;set;}
    public Boolean acctCheck {get;set;}
    public Boolean oppCheck {get;set;}
    public Boolean aptCheck {get;set;}
    public Account galAcc {get;set;}
    public Account newAccount {get;set;}  
    public Account theAcc   {get;set;}
    public Contact galCnt {get;set;}    
    public Contact theCnt {get;set;}        
    private final Quote__c quote;
    private final Account account;
    public Related_Customer__c relatedCustomer {get;set;} 
    public static Related_Customer__c newRC {get;set;}
    private static final String selCon = 'Select A Contact';
    transient public String galleryContact = null;
    transient public String visitorType = null;
    transient public String theContact = null;
    transient public String newContactEmail = null;
    public String newContactFirstName = null;
    transient public String newContactLastName = null;
    transient public String newContactPhone = null;
    transient public String oldShipCity = null;
    transient public String oldShipCountry = null;
    transient public String oldShipState = null;
    transient public String oldShipStreet = null;
    transient public String oldShipZip = null;    
    public transient Map<ID, ID> contactNameMap; 
    static CPQNewSamplePrepareController con;
    String cntCheckVal = 'Contact';
    String acctCheckVal = 'Account';
    String oppCheckVal = 'Opportunity';
    String qteCheckVal = 'Quote__c';
    String aptCheckVal = 'Appointment__c';
    String convertedStatus = 'CPQ';
    static PageReference pageRef;
    static PageReference pageRef1; 
    
    private static void initA() {
        
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        Profile pGAL = [SELECT ID, Name from Profile WHERE Name = 'Gallery User'];
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
        
        //        uMGR.ProfileID = pGAL.id;
        uMGR.Gallery_Name__c = 'TestGalleryAcct1';
        uMGR.Gallery_ID__c = '123';
        try {
            update uMGR;
        }   catch (Exception e) {
            System.debug('::::TestCPQNewSample + update uMGR::::> ' + e.getMessage());
        }     
        
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
            , OwnerId = uMGR.id
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
            , OwnerId = uMGR.id
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
        
        Account galAcc1 = new Account(
            name = 'TestGalleryAcct1'
            , OwnerId = uMGR.id
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
        insert galAcc1;
        
        Account galAcc2 = new Account(
            name = 'TestGalleryAcct2'
            , OwnerId = uMGR.id
            , Region__c = r.id
            , BillingStreet = '1233'
            , BillingCountry = '123'
            , BillingCity = 'DAL'
            , BillingState = 'TX'
            , BillingPostalCode = '72332'
            , ShippingStreet = '1234'
            , ShippingCountry = '123'
            , ShippingCity = 'DAL'
            , ShippingState = 'TX'
            , ShippingPostalCode = '72332'          
            ,  phone = '9722787828'
        ); 
        insert galAcc2;	    
        
        User_to_Location__c u2LMGR1 = new User_to_Location__c(
            Account__c = galAcc1.ID
            , User__c = uMGR.id
            , Default_Location__c = true
        ); 
        insert u2LMGR1;	 
        
        User_to_Location__c u2LMGR2 = new User_to_Location__c(
            Account__c = galAcc2.ID
            , User__c = uMGR.id
            , Default_Location__c = true
        ); 
        insert u2LMGR2;	 
        
        Account galVisitorAcc = new Account(
            name = 'TestGalleryAcct1 - Visitor Account'
            , OwnerId = uMGR.id
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
        insert galVisitorAcc;    
        
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
        
        Contact c2b = new Contact (
            AccountId = a2.Id
            , firstName = 'Tommy'
            , lastname = 'TEST2'
            , Email = 'lalal@testst2.com'
            , Phone = '214-565-7871'
        );
        insert c2b;      
        
        Contact cGal1 = new Contact (
            AccountId = galVisitorAcc.Id
            , firstName = 'Timmy'
            , lastname = 'ContactGal'
            , Email = 'lalal@daltile.com'
            , Phone = '214-555-7878'
        );
        insert cGal1;
        
        Contact cGal2 = new Contact (
            AccountId = galVisitorAcc.Id
            , firstName = 'Tammy'
            , lastname = 'ContactGal'
            , Email = 'lalaaal@daltile.com'
            , Phone = '214-555-7828'
        );
        insert cGal2;
        
        Opportunity o1 = new Opportunity (  
            AccountId = a1.Id
            , Name = 'TEST OPP1'
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
            , Name = 'TEST OPP2'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
            , OwnerId = uMGR.Id
            , CloseDate=  date.today()
            , StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
        );
        insert o2;
        
        String accountName = a1.Name;
        String dupeOppName = accountName + ' - Product Selection - ' + system.today().format();
        
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
                            
		Related_Customer__c rc = new Related_Customer__c (
			Related_account__c = a1.Id
			,Opportunity__c = oDupe.id
        );
		insert rc;
            
        OpportunityTeamMember otm = new OpportunityTeamMember(
            OpportunityId = o1.Id
            , OpportunityAccessLevel = 'Read'
            , UserId = uMGR.Id
            , TeamMemberRole = 'Sales Rep'
        );
        insert otm;
        
        Lead l1 = new Lead (
            FirstName = 'LeadTest'
            , OwnerId = uMGR.Id
            , LastName = 'LastName'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , email = 'testwhatmay@test.com'
            , IsConverted = FALSE
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Appointment__c aptLead = new Appointment__c (
            Status__c = 'Checked In'
            , Visitor_Time_In__c = System.now()
            , Visitor__c = l1.id
        );
        insert aptLead;  
        
        Appointment__c aptContact = new Appointment__c (
            Status__c = 'Checked In'
            , Account__c = a1.id
            , Contact__c = c1.id
            , Daltile_Location__c = galAcc1.id
            , Visitor_Time_In__c = System.now()
            
        );
        insert aptContact;  
        
        Related_Customer__c rc1 = new Related_Customer__c(
            Contact__c = c1.Id
            , Related_Account__c = a1.Id
            , Opportunity__c = o1.Id
            , Shopping_Cart__c = TRUE
            , DW_ID__c = 'test1'
            , Appointment__c = aptLead.id
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

    static testMethod void testOpportunitySample() {        
    
        initA();

        UserRole rMGR = [SELECT 
                         Id
                         ,Name 
                         FROM UserRole 
                         WHERE Name = 'MW SSC Manager'];    
        
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
                     FROM User 
                     where UserRoleID =  : rMGR.Id 
                     AND IsActive = TRUE LIMIT 1];
        
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
                      
        Opportunity o1 = [ SELECT
                        AccountId
                        , Name
                        , Project_City__c
                        , Project_State__c 
                        , OwnerId 
                        , CloseDate
                        , StageName 
                        , Sub_Stage__c 
                        FROM Opportunity 
                        WHERE Name = 'TEST OPP1'];

        Related_Customer__c rc1 = [ SELECT
                                    Contact__c
                                    , Related_Account__c
                                    , Opportunity__c
                                    , Shopping_Cart__c
                                    , DW_ID__c
                                    , Appointment__c
                                    FROM Related_Customer__c            
                                    WHERE DW_ID__c = 'test1'];
            delete rc1;
        System.debug('::::TestCPQNewSample + testAppointmentLeadSample + o1 = ::::> ' + o1);

        id currentID = o1.id;

        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewAppointmentSampleLaunch;
                pageRef1.getParameters().put('id',currentID);
                Test.setCurrentPage(pageRef1);
                System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);
                
                con.cntCheck = FALSE;
                con.doGetOppID(); 
            } catch (Exception e) {
                System.debug('::::TestCPQNewSample::::> ' + e.getMessage());
            } 
            
        }
        Test.stopTest();      
    }    
    
    static testMethod void testAppointmentLeadSample() {        
        
        initA();
        
        UserRole rMGR = [SELECT 
                         Id
                         ,Name 
                         FROM UserRole 
                         WHERE Name = 'MW SSC Manager'];    
        
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
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
                      WHERE firstName = 'Tammy'
                      AND lastname = 'ContactGal'];
        
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
        
        Lead l1 = [ SELECT
                   FirstName 
                   , LastName 
                   , Company 
                   , phone 
                   , email 
                   , IsConverted 
                   FROM Lead
                   WHERE email = 'testwhatmay@test.com'];
        
        System.debug('::::TestCPQNewSample + testAppointmentLeadSample + l1 = ::::> ' + l1);
        
        Appointment__c aptLead = [ SELECT
                                  Status__c 
                                  ,Visitor_Time_In__c
                                  ,Visitor__c
                                  ,Visitor__r.FirstName 
                                  ,Visitor__r.LastName 
                                  ,Visitor__r.Company 
                                  ,Visitor__r.phone 
                                  ,Visitor__r.email 
                                  ,Visitor__r.IsConverted 
                                  FROM Appointment__c
                                  WHERE Visitor__c  = : l1.id
                                 ];
        System.debug('::::TestCPQNewSample + testAppointmentLeadSample + aptLead = ::::> ' + aptLead);
        
        id currentAppointment = aptLead.id;
        String galleryContact = c1.id;
        String theVisitorType = 'HomeOwner';
        String theNewContactId = c1.id;
        String newAccountName = 'NEW NAME';
        String emptyAppointment = '';
        String emptyGalleryConsultant = '';
        string emptyVisitorType = '';
        string currentlyWorkingWith = 'test';
        
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewAppointmentSampleLaunch;
                pageRef1.getParameters().put('id',aptLead.id);
                Test.setCurrentPage(pageRef1);
                System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(aptLead);
                con = new CPQNewSamplePrepareController(tstCls2);
                
                con.cntCheck = TRUE;
                con.doGetOppID(); 
                CPQNewSamplePrepareController.updateAppointment(currentAppointment
                                                                ,theVisitorType
                                                                ,galleryContact  
                                                                ,currentlyWorkingWith
                                                               );
            } catch (Exception e) {
                System.debug('::::TestCPQNewSample::::> ' + e.getMessage());
            } 
            
        }
        Test.stopTest();      
    }    
    
    static testMethod void testAppointmentContactDupe() {        
        
        initA();
        UserRole rMGR = [SELECT 
                         Id
                         ,Name 
                         FROM UserRole 
                         WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
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
                      WHERE FirstName = 'Timmy'
                      AND lastname = 'TEST1'];
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
        
        
        String accountName = a1.Name;
        String dupeOppName = accountName + ' - Product Selection - ' + system.today().format();
        
        Opportunity o1 = [SELECT 
                          Id
                          ,Name
                          ,StageName
                          ,AccountId
                          FROM Opportunity
                          WHERE Name = : dupeOppName];
        
        Appointment__c aptContact = [ SELECT
                                     Status__c 
                                     ,Daltile_Location__c
                                     ,Visitor_Time_In__c
                                     ,Contact__c
                                     ,Account__c
                                     FROM Appointment__c
                                     WHERE Contact__c  = : c1.id];
        
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewAccountSampleLaunch;
                pageRef1.getParameters().put('id',aptContact.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(aptContact);
                con = new CPQNewSamplePrepareController(tstCls2);
                System.debug('::::TestCPQNewSample + pageRef::::> ' + pageRef);
                
                con.cntCheck = TRUE;
                con.doGetOppID();
            }   catch (Exception e) {
                System.debug('::::TestCPQNewSample::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();      
    }
    
    static testMethod void testAppointmentContactSample() {        
        
        initA();
        UserRole rMGR = [SELECT 
                         Id
                         ,Name 
                         FROM UserRole 
                         WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
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
                      WHERE FirstName = 'Timmy'
                      AND lastname = 'TEST2'];
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
        
        Lead l1 = [ SELECT
                   FirstName 
                   , LastName 
                   , Company 
                   , phone 
                   , email 
                   FROM Lead
                   WHERE email = 'testwhatmay@test.com'];
        
        Appointment__c aptContact = [ SELECT
                                     Status__c 
                                     ,Daltile_Location__c
                                     ,Visitor_Time_In__c
                                     ,Contact__c
                                     ,Account__c
                                     FROM Appointment__c
                                     WHERE Visitor__c  = : l1.id];
        
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewAccountSampleLaunch;
                pageRef1.getParameters().put('id',aptContact.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(aptContact);
                con = new CPQNewSamplePrepareController(tstCls2);
                System.debug('::::TestCPQNewSample + pageRef::::> ' + pageRef);
                
                con.cntCheck = TRUE;
                con.doGetOppID();
            }   catch (Exception e) {
                System.debug('::::TestCPQNewSample::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();      
    }
    
    static testMethod void testAccountQuote1() {        
        
        initA();
        UserRole rMGR = [SELECT 
                         Id
                         ,Name 
                         FROM UserRole 
                         WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
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
                      WHERE FirstName = 'Timmy'
                      AND lastname = 'TEST2'];
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
        
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewAccountSampleLaunch;
                pageRef1.getParameters().put('id',a1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(a1);
                con = new CPQNewSamplePrepareController(tstCls2);
                System.debug('::::TestCPQNewSample + pageRef::::> ' + pageRef);
                
                con.cntCheck = TRUE;
                con.doGetOppID();
            }   catch (Exception e) {
                System.debug('::::TestCPQNewSample::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();      
    }
    
    static testMethod void testContactQuote1() {        
        
        initA();
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
                     FROM User 
                     where UserRoleID =  : rMGR.Id 
                     AND IsActive = TRUE LIMIT 1];
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
        Contact c1 = [ SELECT 
                      Id
                      ,NAME
                      ,FirstName
                      ,LastName
                      ,Email
                      ,Phone
                      ,AccountId
                      FROM Contact
                      WHERE lastname = 'TEST2'
                      AND FirstName = 'Tommy'];
        
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewContactSampleLaunch;
                pageRef1.getParameters().put('id',c1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(c1);
                con = new CPQNewSamplePrepareController(tstCls2);
                //                    System.assertEquals(con.cnt, c1);
                con.cnt = c1;
                con.cnt.AccountId = a1.ID;
                
                System.debug('::::TestCPQNewSample + pageRef::::> ' + pageRef);
                
                con.cntCheck = TRUE;
            }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();      
        
    }
    
    static testMethod void testAppointmentQuote() {        
        
        initA();
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c
                     ,Gallery_ID__c
                     FROM User 
                     where UserRoleID =  : rMGR.Id 
                     AND IsActive = TRUE LIMIT 1];
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
        Account aGal1 = [ SELECT
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
                         WHERE name = 'TestGalleryAcct1'];
        Account aGalVisitor1 = [ SELECT
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
                                WHERE name = 'TestGalleryAcct1 - Visitor Account'];
        Contact c1 = [ SELECT 
                      Id
                      ,NAME
                      ,FirstName
                      ,LastName
                      ,Email
                      ,Phone
                      ,AccountId
                      FROM Contact
                      WHERE lastname = 'TEST2'
                      AND FirstName = 'Tommy'];
        
        Appointment__c apt1 = [ SELECT 
                               Id
                               ,Name
                               ,Status__c
                               ,Account__c
                               ,Contact__c
                               ,Daltile_Location__c
                               ,Visitor_Time_In__c
                               ,Project__c
                               FROM Appointment__c
                               WHERE Account__c =: a1.id];  
        
        String theVisitorType = 'HomeOwner';
        String theNewContactId = c1.id;
        Test.startTest();
        System.runAs(uMGR){
            try {
                pageRef1 = Page.CPQNewContactSampleLaunch;
                pageRef1.getParameters().put('id',apt1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(apt1);
                con = new CPQNewSamplePrepareController(tstCls2);
                //                    System.assertEquals(con.cnt, c1);
                con.acc = a1;
                con.cnt = c1;
                con.apt = apt1;
                
                con.getGalleryContacts();
                con.getGalleryContact();
                con.setGalleryContact(theNewContactId);
                con.getVisitorTypes();
                con.getVisitorType();
                con.setVisitorType(theVisitorType);                    
                
                System.debug('::::TestCPQNewSample + pageRef::::> ' + pageRef);
                
                con.cntCheck = TRUE;
                con.doGetOppID();
            }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();      
        
    } 
    
    static testMethod void testExtensionRemoteActionsExistingVisitor() {        
        
        initA();
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c 
                     ,Gallery_ID__c 
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
                      WHERE lastname = 'TEST1'
                      AND FirstName = 'Timmy'];
        
        Contact c2 = [ SELECT 
                      Id
                      ,NAME
                      ,FirstName
                      ,LastName
                      ,Email
                      ,Phone
                      ,AccountId
                      FROM Contact
                      WHERE lastname = 'TEST2'
                      AND FirstName = 'Tommy'];
        
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
                          WHERE Name = 'TEST OPP1'];
        
        Opportunity o2 = [SELECT 
                          Id
                          ,Name
                          ,StageName
                          ,AccountId
                          FROM Opportunity
                          WHERE Name = 'TEST OPP2'];

        
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
        
        Appointment__c aptContact = [SELECT ID
                                     , Name
                                     , Account__c
                                     , Contact__c
                                     FROM Appointment__c
                                     WHERE Contact__c = :c1.Id];      
        
        
        Lead l1 = [ SELECT
                   FirstName 
                   , LastName 
                   , Company 
                   , phone 
                   , email 
                   , IsConverted 
                   FROM Lead
                   WHERE email = 'testwhatmay@test.com'
                  ];
        
        Appointment__c aptLead = [ SELECT
                                  Status__c 
                                  ,Visitor_Time_In__c
                                  ,Visitor__c
                                  FROM Appointment__c
                                  WHERE Visitor__c  = : l1.id
                                 ];                        
        
        Id relatedCustomerId = rc1.Id;
        rc1.New_Opportunity__c = o1.id;
        id oldAccount = a1.id;
        id newAccount = a2.id;
        id oldOpp = o1.id;
        id oldContactId = c1.id;
        id newContact = c2.id;
        id newOpp = o2.id;
        id newOppEmpty = null;
        id oldRc = rc1.id;
        id newRc = rc2.id;  
        id galleryContact = c1.id;
        id currentAppointment = aptContact.id;
        id leadAppointment = aptLead.id;
        
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
        String newONEmpty = '';
        String theVisitorType = 'HomeOwner';
        String theNewContactId = c1.id;
        String newAccountName = 'NEW NAME';
        String emptyAppointment = '';
        String emptyGalleryConsultant = '';
        string emptyVisitorType = '';
        

        String accountDupeName = a1.Name;
        String dupeOppName = accountDupeName + ' - Product Selection - ' + system.today().format();        
        
        Test.startTest();
        // System.runAs(uMGR){
        try { 
            
            pageRef1 = Page.CPQNewOpportunitySample;
            pageRef1.getParameters().put('id',o1.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
            con = new CPQNewSamplePrepareController(tstCls2);            
            
            con.getRelatedCustomer();
            con.setParams();
            con.getIsVisible();
        } catch (Exception e) {
            System.debug('::::testAccountQuote::::> ' + e.getMessage());
        } 
        
        try { 
            
            pageRef1 = Page.CPQNewOpportunitySample;
            pageRef1.getParameters().put('id',o1.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
            con = new CPQNewSamplePrepareController(tstCls2);                       
            con.getTheContacts();
            con.setTheContact(theNewContactId);
            con.getTheContact();
        } catch (Exception e) {
            System.debug('::::testAccountQuote::::> ' + e.getMessage());
        } 
        
        // System.runAs(uMGR){
        try { 
            
            pageRef1 = Page.CPQNewOpportunitySample;
            pageRef1.getParameters().put('id',o1.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
            con = new CPQNewSamplePrepareController(tstCls2);                       
            con.changeAccount();
            con.theContact = theNewContactId;
            con.changeContact();
            con.oppCheck = TRUE;
            con.acctCheck = TRUE;
            con.aptCheck = TRUE;
            con.galAcc = NULL;
            // 	con.newAccount = NULL;
            con.galCnt = NULL;
            con.returnOpp = NULL;
            con.theAcc = NULL;
            con.apt = NULL;
            con.theRecord = '';
            con.theRecordCheckId = '';
        } catch (Exception e) {
            System.debug('::::testAccountQuote::::> ' + e.getMessage());
        }
        
        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.updateCpqContact(emptyAppointment
                                                               ,newAccount
                                                               ,newContact
                                                               ,newOpp                
                                                               ,newContactFirstName
                                                               ,newContactLastName
                                                               ,newContactEmail
                                                               ,newContactPhone                                              
                                                              );                
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }

        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.updateCpqAccount(currentAppointment
                                                               ,newAccount
                                                               ,newContact
                                                               ,newOpp              
                                                               ,newAccountName
                                                               ,updateShipCountry
                                                               ,updateShipState
                                                               ,updateShipAddress1
                                                               ,updateShipCity
                                                               ,updateShipPostal                         
                                                              );         
                                                                            
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.createCpqOpp(emptyAppointment
                                                           ,newAccount
                                                           ,newContact
                                                           ,emptyGalleryConsultant
                                                           ,emptyVisitorType 
                                                           ,newOpp 
                                                           ,newON                  
                                                          );
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                pageRef1 = Page.CPQNewAccountSampleLaunch;
                pageRef1.getParameters().put('id',a1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(a1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.createCpqOpp(emptyAppointment
                                                           ,oldAccount
                                                           ,oldContactId
                                                           ,emptyGalleryConsultant
                                                           ,emptyVisitorType 
                                                           ,newOppEmpty 
                                                           ,newONEmpty                  
                                                          );
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);         
                string currentlyWorkingWith = 'test';
                CPQNewSamplePrepareController.updateAppointment(currentAppointment
                                                                ,theVisitorType
                                                                ,galleryContact  
                                                                ,currentlyWorkingWith
                                                               );
                //                CPQNewSamplePrepareController.getUpdatedRelatedCustomer(newRC);      
                con.doGetOppID(); 
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }

        // system.RunaS(UmgR){
        try { 
            
            pageRef1 = Page.CPQNewOpportunitySample;
            pageRef1.getParameters().put('id',o1.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
            con = new CPQNewSamplePrepareController(tstCls2);    
            string testKeyword = 'TEST';
            CPQNewSamplePrepareController.queryOpportunity(testKeyword);  
            string testAccountKeyword = 'TEST';     
            CPQNewSamplePrepareController.queryAccount(testAccountKeyword);                    
        } catch (Exception e) {
            System.debug('::::testAccountQuote::::> ' + e.getMessage());
        } 
        //              
        // system.RunaS(UmgR){
        try { 
            
            pageRef1 = Page.CPQNewOpportunitySample;
            pageRef1.getParameters().put('id',o1.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
            con = new CPQNewSamplePrepareController(tstCls2);    
            string testKeyword = 'MIDWEST';
            CPQNewSamplePrepareController.queryAccount(testKeyword);        									  
        } catch (Exception e) {
            System.debug('::::testAccountQuote::::> ' + e.getMessage());
        } 
        Test.stopTest();       
    }   
    static testMethod void testExtensionRemoteActionsNewVisitor() {        
        
        initA();
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
        User uMGR = [SELECT 
                     ID
                     ,Name 
                     ,Gallery_Name__c 
                     ,Gallery_ID__c 
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
                      WHERE lastname = 'TEST1'
                      AND FirstName = 'Timmy'];
        
        Contact c2 = [ SELECT 
                      Id
                      ,NAME
                      ,FirstName
                      ,LastName
                      ,Email
                      ,Phone
                      ,AccountId
                      FROM Contact
                      WHERE lastname = 'TEST2'
                      AND FirstName = 'Tommy'];
        
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
                          WHERE Name = 'TEST OPP1'];
        
        Opportunity o2 = [SELECT 
                          Id
                          ,Name
                          ,StageName
                          ,AccountId
                          FROM Opportunity
                          WHERE Name = 'TEST OPP2'];

        
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
        
        Appointment__c aptContact = [SELECT ID
                                     , Name
                                     , Account__c
                                     , Contact__c
                                     FROM Appointment__c
                                     WHERE Contact__c = :c1.Id];      
        
        
        Lead l1 = [ SELECT
                   FirstName 
                   , LastName 
                   , Company 
                   , phone 
                   , email 
                   , IsConverted 
                   FROM Lead
                   WHERE email = 'testwhatmay@test.com'
                  ];
        
        Appointment__c aptLead = [ SELECT
                                  Id
                                  ,Status__c 
                                  ,Visitor_Time_In__c
                                  ,Visitor__c
                                  FROM Appointment__c
                                  WHERE Visitor__c  = : l1.id
                                 ];                        
        
        Id relatedCustomerId = rc1.Id;
        rc1.New_Opportunity__c = o1.id;
        id oldAccount = a1.id;
        id newAccount = a2.id;
        id oldOpp = o1.id;
        id oldContactId = c1.id;
        id newContact = c2.id;
        id newOpp = o2.id;
        id newOppEmpty = null;
        id oldRc = rc1.id;
        id newRc = rc2.id;  
        id galleryContact = c1.id;
        id currentAppointment = aptContact.id;
        id leadAppointment = aptLead.id;
        
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
        String newONEmpty = '';
        String theVisitorType = 'HomeOwner';
        String theNewContactId = c1.id;
        String newAccountName = 'NEW NAME';
        String emptyAppointment = '';
        String emptyGalleryConsultant = '';
        string emptyVisitorType = '';
        string varBlank = '';
        

        String accountDupeName = a1.Name;
        String dupeOppName = accountDupeName + ' - Product Selection - ' + system.today().format();        
        
        Test.startTest();    
     
        System.runAs(uMGR){
            try { 
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.Id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.updateCpqContact(leadAppointment
                                                               ,oldAccount
                                                               ,varBlank
                                                               ,newOppEmpty                
                                                               ,newContactFirstName
                                                               ,newContactLastName
                                                               ,newContactEmail
                                                               ,newContactPhone                                              
                                                              );                
            } catch (Exception e) {
                System.debug('::::updateCpqContact::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',leadAppointment);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(aptLead);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.updateCpqContact(leadAppointment
                                                               ,oldAccount
                                                               ,varBlank
                                                               ,newOppEmpty                
                                                               ,newContactFirstName
                                                               ,newContactLastName
                                                               ,newContactEmail
                                                               ,newContactPhone                                              
                                                              );                
            } catch (Exception e) {
                System.debug('::::updateCpqContact::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                pageRef1 = Page.CPQNewAccountSampleLaunch;
                pageRef1.getParameters().put('id',a1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(a1);
                con = new CPQNewSamplePrepareController(tstCls2);                       
                CPQNewSamplePrepareController.createCpqOpp(currentAppointment
                                                           ,oldAccount
                                                           ,oldContactId
                                                           ,galleryContact
                                                           ,theVisitorType 
                                                           ,newOppEmpty 
                                                           ,newON                  
                                                          );
            } catch (Exception e) {
                System.debug('::::createCpqOpp::::> ' + e.getMessage());
            } 
        }
        
        System.runAs(uMGR){
            try { 
                
                pageRef1 = Page.CPQNewOpportunitySample;
                pageRef1.getParameters().put('id',o1.id);
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(o1);
                con = new CPQNewSamplePrepareController(tstCls2);         
                string currentlyWorkingWith = 'test';
                CPQNewSamplePrepareController.updateAppointment(leadAppointment
                                                                ,theVisitorType
                                                                ,galleryContact  
                                                                ,currentlyWorkingWith
                                                               );
                //                CPQNewSamplePrepareController.getUpdatedRelatedCustomer(newRC);      
                con.doGetOppID(); 
            } catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
            } 
        }        
    }
}