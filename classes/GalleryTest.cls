@isTest
private class GalleryTest {

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
    String cntCheckVal = 'Contact';
    String acctCheckVal = 'Account';
    String oppCheckVal = 'Opportunity';
    String qteCheckVal = 'Quote__c';
    String aptCheckVal = 'Appointment__c';
    static VisitorCheckinController con;
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
            } catch (Exception e) {
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

	    Account galAcc = new Account(
			name = 'TestGalleryAcct1'
			, OwnerId = UserInfo.getUserid()
			, Region__c = r.id
            , RecordTypeId = '012F0000000mpvR'			
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
	    
	    Account galVisitorAcc = new Account(
			name = 'TestGalleryAcct1 - Visitor Account'
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
	    insert galVisitorAcc;    
        
        User_to_Location__c loc1 = new User_to_Location__c (
            User__c = UserInfo.getUserid()
            , Account__c = galAcc.Id       
            , Default_Location__c = true
            );
        insert loc1;
        
        User_to_Location__c loc2 = new User_to_Location__c (
            User__c = UserInfo.getUserid()
            , Account__c = galAcc.Id       
            , Default_Location__c = false
            );
        insert loc2;        
        
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
        
        Contact cGal1 = new Contact (
            AccountId = galVisitorAcc.Id
            , firstName = 'Timmy'
            , lastname = 'ContactGal'
            , Email = 'lalal@daltile.com'
            , Phone = '214-555-7878'
            );
        insert cGal1;
    
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
   
        OpportunityTeamMember otm = new OpportunityTeamMember(
            OpportunityId = o1.Id
            , OpportunityAccessLevel = 'Read'
            , UserId = uMGR.Id
            , TeamMemberRole = 'Sales Rep'
        );
        insert otm;

        Lead l1 = new Lead (
            FirstName = 'LeadTest'
            , LastName = 'LastName'  
            , Company = 'TestCo'
            , phone = '214-767-6771'
            , email = 'testwhatmay@test.com'
        );
        insert l1;

		Appointment__c aptContact = new Appointment__c (
			Status__c = 'Checked In'
			, Account__c = a1.id
			, Contact__c = c1.id
			, Visitor_Phone_Number__c = c1.phone
			, Daltile_Location__c = galAcc.id
			, Visitor_Time_In__c = System.now()
			, Visitor_Type__c = 'HomeOwner'
            , Comments__c = 'test Contact'
            , Prescheduled__c = false
            , Appointment_Time__c = System.now()
			
		);
		insert aptContact;  
                
		Appointment__c aptLead = new Appointment__c (
			Status__c = 'Checked In'
			, Visitor_Phone_Number__c = l1.phone
			, Daltile_Location__c = galAcc.id
			, Visitor_Time_In__c = System.now()
			, Visitor__c = l1.id
			, Visitor_Type__c = 'HomeOwner'
            , Comments__c = 'test Lead'
            , Prescheduled__c = false
            , Appointment_Time__c = System.now()
			
		);
		insert aptLead;  
        
		Appointment__c apt = new Appointment__c (
			Status__c = 'Checked In'
			, Account__c = a1.id
			, Contact__c = c1.id
			, Visitor_Phone_Number__c = c1.phone
			, Daltile_Location__c = galAcc.id
			, Visitor_Time_In__c = System.now()
			, Project__c = o1.Id
			, Visitor__c = l1.id
			, Visitor_Type__c = 'HomeOwner'
            , Comments__c = 'test 1'
            , Prescheduled__c = false
            , Appointment_Time__c = System.now()
			
		);
		insert apt;  
            
        System.debug('::::TestCPQNewSample + apt::::> ' + apt);
        
		Appointment__c apt2 = new Appointment__c (
			Status__c = 'Checked In'
			, Visitor_Phone_Number__c = '2142678433'
			, Daltile_Location__c = galAcc.id
			, Visitor_Time_In__c = System.now()
			, Visitor_First_Name__c = 'Jimmy'
            , Visitor_Last_Name__c = 'Craquekorn'
            , Visitor_Email__c = 'idontcare@masters.com'
            , Visitor_Type__c = 'Appointment'
            , Comments__c = 'test 2'
            , Prescheduled__c = true
            , Appointment_Time__c = System.now()
			
		);
		insert apt2;
        
        Visitor_Type__c vt = new Visitor_Type__c (
            
        );

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
    



    static testMethod void testAppointmentContactCheckIn() {        

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
    Account galA1 = [ SELECT
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
    Contact c1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST2'];
                    
    Contact cGal1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'ContactGal'];

    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST OPP1'];
   
    Appointment__c apt1 = [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test Contact'];  
    System.debug('::::GalleryTest + testCheckIn + apt1::::> ' + apt1);

        
    User_to_Location__c l = [ SELECT
                                Id
                                , User__c
                                , Account__c
                                , Default_Location__c
                    		FROM User_to_Location__c
                            WHERE Account__c = :galA1.id
                            AND Default_Location__c = true];
        

    String theVisitorType = 'HomeOwner';
    String welcomePhone = apt1.Visitor_Phone_Number__c;
    String theNewContactId = c1.id;
    id appointmentID = apt1.id;
    id consultantID = cGal1.id;
    String visitorType = 'HomeOwner';
    String comments = 'Nah';
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    pageRef1 = Page.AppointmentScheduler;
                    Test.setCurrentPage(pageRef1);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                    ApexPages.StandardController tstCls2 = new ApexPages.StandardController(apt1);
                    AppointmentSchedulerController con = new AppointmentSchedulerController(tstCls2);
                    con.updateTimeOpened();
                    con.getGalleryContacts();
                    con.getGalleryContact();
                    con.setGalleryContact(theNewContactId);
                    con.getVisitorTypes(); 
                    con.getVisitorType();
                    con.setVisitorType(theVisitorType);   
                    con.getTheContacts();
                    con.getTheContact();
                    con.setTheContact(theNewContactId);           
                    AppointmentSchedulerController.closeAppointment(appointmentID
                            									,consultantID
                            									,visitorType 
                            									,comments                  
                                								);
                    
                } catch (Exception e) {
                    System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
                    
//            }
    Test.stopTest();      
    
    } 

    static testMethod void testAppointmentCreateGalleryTask() {        

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
    Account galA1 = [ SELECT
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
    Contact c1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST2'];
                    
    Contact cGal1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'ContactGal'];

    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST OPP1'];
   
    Appointment__c apt1 = [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test Contact'];  
    System.debug('::::GalleryTest + testCheckIn + apt1::::> ' + apt1);

        
    User_to_Location__c l = [ SELECT
                                Id
                                , User__c
                                , Account__c
                                , Default_Location__c
                    		FROM User_to_Location__c
                            WHERE Account__c = :galA1.id
                            AND Default_Location__c = true];
        

    String theVisitorType = 'HomeOwner';
    String welcomePhone = apt1.Visitor_Phone_Number__c;
    String theNewContactId = c1.id;
    id appointmentID = apt1.id;
    id consultantID = cGal1.id;
    String visitorType = 'HomeOwner';
    String comments = 'Nah';
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    
                    AppointmentSchedulerController.createGalleryTask(appointmentID);
                    
                } catch (Exception e) {
                    System.debug('::::test createGalleryTask::::> ' + e.getMessage());
                } 
                    
//            }
    Test.stopTest();      
    
    } 

    static testMethod void testVisitorContactCheckIn() {        

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
    Account galA1 = [ SELECT
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
    Contact c1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST2'];

    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST OPP1'];
   
    Appointment__c apt1 = [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test Contact'];  
    System.debug('::::GalleryTest + testCheckIn + apt1::::> ' + apt1);
    
    User_to_Location__c l = [ SELECT
                                Id
                                , User__c
                                , Account__c
                                , Default_Location__c
                    		FROM User_to_Location__c
                            WHERE Account__c = :galA1.id
                            AND Default_Location__c = false];
                            
    String theVisitorType = 'HomeOwner';
    String welcomePhone = apt1.Visitor_Phone_Number__c;
    String theNewContactId = c1.id;
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    pageRef1 = Page.VisitorCheckin;
                    Test.setCurrentPage(pageRef1);
                    pageRef1.getParameters().put('welcomePhoneNumber',welcomePhone);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
            //     }   catch (Exception e) {
            //     System.debug('::::testAccountQuote::::> ' + e.getMessage());
            //     }                     

            // try {
                    VisitorCheckinController con = new VisitorCheckinController();
//                    con.sortDir();
//                    con.sortField();
                    con.welcomePhoneNumber = welcomePhone;
                    con.visitorType = 'HomeOwner';
                    con.appointment = apt1;
                    con.getAppointment();
                    con.galleryAccountId = galA1.id;
                    con.galleryAccountName = galA1.name;
                    // con.isPreSchedueled();
                    con.galleryAccount = galA1;
                    con.visitorAccount = a1;
                    con.visitorContact = c1;
                    pageRef1.getParameters().put('currentvfpage','VisitorCheckin');
                    con.checkin();
                    pageRef1 = Page.VisitorContactSearch;
                    Test.setCurrentPage(pageRef1);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                    pageRef1.getParameters().put('conid',theNewContactId);
                    con.getGalleryContacts();
                    con.getGalleryContact();
                    con.setGalleryContact(theNewContactId);
                    con.getVisitorTypes();
                    con.getVisitorType();
                    con.setVisitorType(theVisitorType);   
                    con.getPossibleVisitors();
                    con.selectVisitor();           
                    // // con.selectContactVisitor();
                    con.cancel();
                    con.cancelToAppointments();
                    con.saveInfo();
                    // // con.save();
                    con.findCurrentAppointment('2145557871');
                    con.findCurrentVisitor(welcomePhone) ;             
                    con.goCreateContact();               
                    con.goCreateVisitorContact();               
                    con.backToScheduler();             
                    con.backToSchedulerMobile();     
                    con.backToCheckIn();               
                    con.appointment = apt1;
                    con.combineDateTime(toadysDate, '12:00PM');
                    con.goToAppointment();           
                    
                }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
//            }
    Test.stopTest();      
    
    } 
    

    static testMethod void testVisitorContactDupeOpp() {

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
    Account galA1 = [ SELECT
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
    Contact c1 = [ SELECT 
                        Id
                        ,NAME
                        ,FirstName
                        ,LastName
                        ,Email
                        ,Phone
                        ,AccountId
                    FROM Contact
                    WHERE lastname = 'TEST2'];
        
    String accountName = a1.Name;
    String dupeOppName = accountName + ' - Product Selection - ' + system.today().format();
        
    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = : dupeOppName];
   
    Appointment__c apt1 = [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test Contact'];  
    System.debug('::::GalleryTest + testCheckIn + apt1::::> ' + apt1);

    String theVisitorType = 'HomeOwner';
    String welcomePhone = apt1.Visitor_Phone_Number__c;
    String theNewContactId = c1.id;
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    pageRef1 = Page.VisitorCheckin;
                    Test.setCurrentPage(pageRef1);
                    pageRef1.getParameters().put('welcomePhoneNumber',welcomePhone);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
            //     }   catch (Exception e) {
            //     System.debug('::::testAccountQuote::::> ' + e.getMessage());
            //     }                     

            // try {
                    VisitorCheckinController con = new VisitorCheckinController();
//                    con.sortDir();
//                    con.sortField();
                    con.visitorType = 'HomeOwner';
                    con.appointment = apt1;
                    con.galleryAccountId = galA1.id;
                    con.galleryAccountName = galA1.name;
                    // con.isPreSchedueled();
                    con.galleryAccount = galA1;
                    con.visitorAccount = a1;
                    con.visitorContact = c1;
                    pageRef1.getParameters().put('currentvfpage','VisitorCheckin');
                    con.checkin();
                    pageRef1 = Page.VisitorContactSearch;
                    Test.setCurrentPage(pageRef1);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                    pageRef1.getParameters().put('conid',theNewContactId);
                    con.getGalleryContacts();
                    con.getGalleryContact();
                    con.setGalleryContact(theNewContactId);
                    con.getVisitorTypes();
                    con.getVisitorType();
                    con.setVisitorType(theVisitorType);   
//                    con.possibleVisitors();
                    con.selectVisitor();           
                    // // con.selectContactVisitor();
                    con.cancel();
                    con.cancelToAppointments();
                    con.saveInfo();
                    // // con.save();
                    con.findCurrentAppointment('2145557871');
                    con.findCurrentVisitor(welcomePhone) ;             
                    con.goCreateContact();               
                    con.goCreateVisitorContact();               
                    con.backToScheduler();             
                    con.backToSchedulerMobile();     
                    con.backToCheckIn();               
                    con.appointment = apt1;
                    con.combineDateTime(toadysDate, '12:00PM');
                    con.goToAppointment();           
                    
                }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
//            }
    Test.stopTest();      
    
    }     
    

    static testMethod void testVisitorLeadCheckIn() {        

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
    Account galA1 = [ SELECT
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

    Lead l1 = [SELECT
                    FirstName
                    , LastName
                    , Company 
                    , phone
                    , email
                FROM Lead
                WHERE LastName = 'LastName'];

    Opportunity o1 = [SELECT 
                    Id
                    ,Name
                    ,StageName
                    ,AccountId
                    FROM Opportunity
                    WHERE Name = 'TEST OPP1'];
   
   
    Appointment__c apt1 = [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test Lead'];  
    System.debug('::::GalleryTest + testCheckIn + apt1::::> ' + apt1);
   
    Appointment__c apt2= [ SELECT 
                        Id
                        ,Name
            			,Status__c
            			,Account__c
            			,Visitor_Type__c
            			,Contact__c
            			,Daltile_Location__c
            			,Visitor_First_Name__c
            			,Visitor_Last_Name__c
            			,Visitor_Email__c
            			,Visitor_Time_In__c
            			,Prescheduled__c
            			,Visitor_Phone_Number__c
            			,Project__c
            			,Appointment_Time__c
                        ,Comments__c
        			FROM Appointment__c
                    WHERE Comments__c = 'test 2'];  
    System.debug('::::GalleryTest + testCheckIn + apt2::::> ' + apt2);

    String theVisitorType = 'HomeOwner';
    String welcomePhone = apt1.Visitor_Phone_Number__c;
 

    String welcomePhone2 = l1.phone;
    String theNewContactId = l1.id;
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    pageRef1 = Page.VisitorCheckin;
                    Test.setCurrentPage(pageRef1);
                    pageRef1.getParameters().put('welcomePhoneNumber',welcomePhone2);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);

                    VisitorCheckinController con = new VisitorCheckinController();
//                    con.sortDir();
//                    con.sortField();
                    con.welcomePhoneNumber = welcomePhone2;
                    con.visitorType = 'HomeOwner';
                    con.galleryAccountId = galA1.id;
                    con.galleryAccountName = galA1.name;
                    // con.isPreSchedueled();
                    con.galleryAccount = galA1;
                    con.visitorAccount = a1;
//                    con.visitorContact = c1;
                    pageRef1.getParameters().put('currentvfpage','VisitorCheckin');
                    con.checkin();
                    pageRef1 = Page.VisitorContactSearch;
                    Test.setCurrentPage(pageRef1);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                    pageRef1.getParameters().put('conid',theNewContactId);
                    con.saveInfo();
                    con.getGalleryContacts();
                    con.getGalleryContact();
                    con.setGalleryContact(theNewContactId);
                    con.getVisitorTypes();
                    con.getVisitorType();
                    con.setVisitorType(theVisitorType);   
//                    con.possibleVisitors();
                    con.selectVisitor();           
                    // con.selectContactVisitor();
                    con.cancel();
                    con.cancelToAppointments();
                    con.saveInfo();
                    // con.save();
                    con.findCurrentAppointment(welcomePhone2);
                    con.findCurrentVisitor(welcomePhone2) ;             
                    con.goCreateContact();               
                    con.goCreateVisitorContact();               
                    con.backToScheduler();             
                    con.backToSchedulerMobile();     
                    con.backToCheckIn();               
                	con.backWaitlist();
                    con.combineDateTime(toadysDate, '12:00PM');
                    con.goToAppointment();           
                    
                }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
                          
            try {
                    pageRef1 = Page.VisitorCheckin;
                    Test.setCurrentPage(pageRef1);
                    pageRef1.getParameters().put('welcomePhoneNumber',welcomePhone2);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);

                    VisitorCheckinController con = new VisitorCheckinController();
//                    con.sortDir();
//                    con.sortField(); 
                    con.welcomePhoneNumber = welcomePhone2;
                    con.visitorType = 'Appointment';
                    con.appointment = apt2;
                    con.galleryAccountId = galA1.id;
                    con.galleryAccountName = galA1.name;
                    // con.isPreSchedueled();
                    con.galleryAccount = galA1;
                    con.visitorAccount = a1;
//                    con.visitorContact = c1;
                    pageRef1.getParameters().put('currentvfpage','VisitorCheckin');
                    con.checkin();
                    pageRef1 = Page.VisitorContactSearch;
                    Test.setCurrentPage(pageRef1);
                    System.debug('::::TestCPQNewSample + pageRef1::::> ' + pageRef1);
                    pageRef1.getParameters().put('conid',theNewContactId);
                    con.saveInfo();
                    con.getGalleryContacts();
                    con.getGalleryContact();
                    con.setGalleryContact(theNewContactId);
                    con.getVisitorTypes();
                    con.backWaitlist();
                    con.getAppointment();
                    con.setVisitorType(theVisitorType);   
//                    con.possibleVisitors();
                    con.selectVisitor();           
                    // con.selectContactVisitor();
                    con.cancel();
                    con.cancelToAppointments();
                    con.saveInfo();
                    // con.save();
                    con.findCurrentAppointment(welcomePhone2);
                    con.findCurrentVisitor(welcomePhone2) ;             
                    con.goCreateContact();               
                    con.goCreateVisitorContact();               
                    con.backToScheduler();             
                    con.backToSchedulerMobile();     
                    con.backToCheckIn();          
                    con.backWaitlist();
                    con.appointment = apt2;
                    con.combineDateTime(toadysDate, '12:00PM');
                    con.goToAppointment();           
                    
                }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
//            }
    Test.stopTest();      
    
    }     
    
    static testMethod void testNoCurrentCheckIn() {        

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
    Account galA1 = [ SELECT
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

    String theVisitorType = 'HomeOwner';
    String welcomePhone = '9534448888';
 
    Date toadysDate = Date.today();
    // String today = toadysDate;
    Test.startTest();
//        System.runAs(uMGR){
            try {
                    pageRef1 = Page.AppointmentScheduler;
                    Test.setCurrentPage(pageRef1);
                    pageRef1.getParameters().put('welcomePhoneNumber',welcomePhone);
                    VisitorCheckinController con = new VisitorCheckinController();
                    pageRef1.getParameters().put('appointmentScheduled','true');
//                    con.sortDir();
//                    con.sortField();
                    con.welcomePhoneNumber = welcomePhone;
                    con.visitorType = 'HomeOwner';
                    con.galleryAccountId = galA1.id;
                    con.galleryAccountName = galA1.name;
                    // con.isPreSchedueled();
                    con.galleryAccount = galA1;
//                    con.visitorContact = c1;
                    con.checkin();
                    // con.findCurrentAppointment(welcomePhone);
                    con.findCurrentVisitor(welcomePhone) ;   
//                     pageRef1 = Page.VisitorContactSearch;
//                     Test.setCurrentPage(pageRef1);
//                     con.saveInfo();
//                     con.getGalleryContacts();
//                     con.getGalleryContact();
//                     con.getVisitorTypes();
//                     con.getVisitorType();
//                     con.setVisitorType(theVisitorType);   
//                     con.possibleVisitors();
//                     con.selectVisitor();           
//                     // con.selectContactVisitor();
//                     con.cancel();
//                     con.cancelToAppointments();
//                     con.saveInfo();
//                     // con.save();          
//                     con.goCreateContact();               
//                     con.goCreateVisitorContact();               
//                     con.backToScheduler();             
//                     con.backToSchedulerMobile();     
//                     con.backToCheckIn();               
//                 	   con.backWaitlist();
//                     con.combineDateTime(toadysDate, '12:00PM');
//                     con.goToAppointment();           
                    
                }   catch (Exception e) {
                System.debug('::::testAccountQuote::::> ' + e.getMessage());
                } 
                          
    Test.stopTest();      
    
    }     
    
    
}