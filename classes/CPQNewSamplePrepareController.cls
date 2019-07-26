global with sharing class CPQNewSamplePrepareController {

    public String oppId  {get;set;}
    public Opportunity oppList  {get;set;}
    public static Opportunity useThisOpp {get;set;}
    public Account acc {get;set;}
    public Contact cnt {get;set;}
    public Opportunity returnOpp {get;set;}
    public Opportunity opp {get;set;}
    public OpportunityContactRole oppCR {get;set;}
    public String accountId  {get;set;}
    public String accountName  {get;set;}
    public String oppName  {get;set;}
    public String contactId  {get;set;}
    public String apointmentId {get;set;}
    public String theRecord {get;set;}
    public String theRecordCheckId {get;set;}
    public String theRecordId {get;set;}
    public String relatedCustomerId  {get;set;}
    public String nameGalVisitorAccount {get;set;}
    public String varVisitorType {get;set;}
    public Appointment__c apt {get;set;}    
    public Boolean cntCheck {get;set;}
    public Boolean acctCheck {get;set;}
    public Boolean oppCheck {get;set;}
    public Boolean aptCheck {get;set;}
    public Account galAcc {get;set;}
    public Account galVisitorAcc {get;set;}
    public Account newAccount {get;set;}  
    public Account theAcc   {get;set;}
    public Contact galCnt {get;set;}    
    public Contact theCnt {get;set;}        
    public Opportunity theOppID {get;set;}  
    private final Quote__c quote;
    private final Account account;
    public Related_Customer__c relatedCustomer {get;set;} 
    public static Related_Customer__c newRC {get;set;}
    private static final String selCons = 'Select A Consultant';
    private static final String selCon = 'Select A Contact'; 
    private static final String createCon = 'Create A Contact'; 
    transient public String galleryContact = null;
    transient public String visitorType = null;
    transient public String theContact = null;
    transient public String newContactEmail = null;
    public String newContactFirstName = null;
    transient public String newContactLastName = null;
    transient public String newContactPhone = null;
    transient public String oldContactEmail = null;
    public String oldContactFirstName = null;
    transient public String oldContactLastName = null;
    transient public String oldContactPhone = null;
    transient public String oldShipCity = null;
    transient public String oldShipCountry = null;
    transient public String oldShipState = null;
    transient public String oldShipStreet = null;
    transient public String oldShipZip = null;    
    public transient Map<ID, ID> contactNameMap; 

    String cntCheckVal = 'Contact';
    String acctCheckVal = 'Account';
    String oppCheckVal = 'Opportunity';
    String qteCheckVal = 'Quote__c';
    String aptCheckVal = 'Appointment__c';
    String convertedStatus = 'CPQ';
    String userGalleryName = '';

    private ApexPages.StandardController sc;    
    
    public CPQNewSamplePrepareController(ApexPages.StandardController stdController) {

// DEBUG setup...

        this.sc = sc;
        String type = stdController.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType =  String.valueof(stdController.getRecord().getSObjectType());
        String theActualId =  String.valueof(stdController.getRecord().get('Id')); 
        String theRecord =  String.valueof(stdController.getRecord());
        String theRecordtemp =  theRecord.removeEnd('}');
        String theGenericRecordizerPt1 = theRecordtemp.right(18);            
        String theRecordCheckId = theGenericRecordizerPt1.removeStart('_c=');                    
        Boolean cntCheck = theRecord.contains(cntCheckVal);
        Boolean acctCheck = theRecord.contains(acctCheckVal);
        Boolean oppCheck = theRecord.contains(oppCheckVal);
        Boolean qteCheck = theRecord.contains(qteCheckVal);        
        Boolean aptCheck = theRecord.contains(aptCheckVal);
        System.debug('is that a  acctCheck...' + acctCheck + '/ cntCheck... ' + cntCheck + ' / oppCheck...' + oppCheck + ' / aptCheck...' + aptCheck + ' / qteCheck...' + qteCheck);
        System.debug('theRecord: ' + theRecord);
        System.debug('theRecords Type: ' + theSObjectType);        
        System.debug('theRecordCheckId: ' + theRecordCheckId);
        System.debug('theActualId...' + theActualId);
        User u = [SELECT 
                ID
                ,Name 
                ,Gallery_Name__c
                ,Gallery_ID__c
                , email
            FROM User 
            where Id = :UserInfo.getUserId()];
        userGalleryName = u.Gallery_Name__c;
        System.debug('User...' + u);
    
        if (theSObjectType == 'Appointment__c') {
            relatedCustomer = new Related_Customer__c();
            if (theRecordCheckId.left(3) == 'a1m') { 
                theRecordId = theRecordCheckId;
                System.debug('theRecordCheckId...' + theRecordId);
            } else if(theActualId.left(3) == 'a1m')  {
                theRecordId = theActualId;
                System.debug('theActualId...' + theRecordId);
            }
            
            acc = new Account();
            apt = [
                    SELECT Id
                        , Visitor__c
                        , Visitor__r.FirstName
                        , Visitor__r.LastName 
                        , Visitor__r.email
                        , Visitor__r.Company
                        , Visitor__r.Phone
                        , Visitor__r.IsConverted
                        , Visitor__r.Visitor_Type__c
                        , Visitor__r.ConvertedAccountId
                        , Visitor__r.ConvertedContactId
                        , Visitor__r.ConvertedDate
                        , Visitor__r.ConvertedOpportunityId                        
                        , Contact__c
                        , Contact__r.NAME
                        , Contact__r.FirstName
                        , Contact__r.LastName
                        , Contact__r.Email
                        , Contact__r.Phone
                        , Contact__r.AccountId                        
                        , Account__c
                        , Account__r.Name
                        , Account__r.BillingStreet
                        , Account__r.BillingCity
                        , Account__r.BillingState
                        , Account__r.BillingPostalCode 
                        , Account__r.BillingCountry
                        , Account__r.ShippingStreet
                        , Account__r.ShippingCity
                        , Account__r.ShippingState
                        , Account__r.ShippingPostalCode 
                        , Account__r.ShippingCountry
                        , Daltile_Location__c
                        , Daltile_Location__r.Name
                        , Daltile_Location__r.BillingStreet
                        , Daltile_Location__r.BillingCity
                        , Daltile_Location__r.BillingState
                        , Daltile_Location__r.BillingPostalCode 
                        , Daltile_Location__r.BillingCountry
                        , Daltile_Location__r.ShippingStreet
                        , Daltile_Location__r.ShippingCity
                        , Daltile_Location__r.ShippingState
                        , Daltile_Location__r.ShippingPostalCode 
                        , Daltile_Location__r.ShippingCountry     
                        , Daltile_Location__r.Customer_Class__c
                        , Daltile_Location__r.DW_ID__c
                        , Daltile_Location__r.SSC__c                        
                        , New_Account_Name__c
                        , Status__c
                        , Visitor_Time_In__c
                        , Appointment_Time__c
                        , Project__c 
                        , Project__r.Name
                        , Visitor_Name__c
                        , Visitor_Type__c
                        , Consultant__c
                        , Currently_Working_With__c
                    FROM Appointment__c
                    WHERE Id = :theRecordId];
            System.debug('::::CPQNewSampleExtension + aptCheck + apt ...' + apt);
            apointmentId = apt.Id;            
            galleryContact = apt.Consultant__c;
            System.debug('::::CPQNewSampleExtension apt.Daltile_Location__c + ::::> ' + apt.Daltile_Location__c);
        
            varVisitorType = '';
            if (apt.Visitor_Type__c != NULL) {
                varVisitorType = apt.Visitor_Type__c;
            }
        
            if (apt.Daltile_Location__c == NULL) {
                list <User_to_Location__c> galleryUserLocation = [
                    SELECT Account__c,Account__r.Name,Id,User__c,Default_Location__c 
                    FROM User_to_Location__c 
                    WHERE User__c = : UserInfo.getUserId()
                    ];
                if (galleryUserLocation.isEmpty()) {
                    String myGalleryName = u.Gallery_Name__c;
                    system.debug('saveInfo + myGalleryName...' + myGalleryName);  
                    List<Account> myGalleryAccount = [Select ID From Account Where Name = :myGalleryName];
                    if (myGalleryAccount != NULL){
                        for (Account a:myGalleryAccount){     
                            apt.Daltile_Location__c = a.ID;            
                        }   
                    }
                } else {
                    Boolean hasDefault = false;
                    for (User_to_Location__c l : galleryUserLocation) {
                      if (l.Default_Location__c == TRUE) {
                        hasDefault = true;
                      }
                    }
                    if ( hasDefault == true) {
                        for (User_to_Location__c l : galleryUserLocation) {
                      if (l.Default_Location__c == TRUE) {
                                apt.Daltile_Location__c = l.ID;  
                      } 
                        }            
                    } else {
                        for (User_to_Location__c l : galleryUserLocation) {
                            apt.Daltile_Location__c = l.ID;            
                        }
                    }
                }
            } else {
              nameGalVisitorAccount = apt.Daltile_Location__r.Name + ' - Visitor Account';  
              if (nameGalVisitorAccount.length() > 50 ) {
                  nameGalVisitorAccount = nameGalVisitorAccount.left(50);
              }
              System.debug('::::CPQNewSampleExtension + nameGalVisitorAccount : ::::> ' + nameGalVisitorAccount); 
              LIST <Account> galVisitorAccList = [
                  SELECT Id
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
                  WHERE Name = :nameGalVisitorAccount]; 
                    
                if (!galVisitorAccList.isEmpty()) {
                    for (Account a : galVisitorAccList) {
                        galVisitorAcc = a;
                        galVisitorAcc.Name = a.Name;
                    }
                } else {
                  apt.New_Account_Name__c = nameGalVisitorAccount;                        
                }
            }
            
          if (apt.Account__c != null) {
            acc.id = apt.Account__c;
            acc.name = apt.Account__r.Name;
            acc.ShippingPostalCode = apt.Account__r.ShippingPostalCode;
            acc.BillingStreet = apt.Account__r.BillingStreet;
            acc.BillingCity = apt.Account__r.BillingCity;
            acc.BillingState = apt.Account__r.BillingState;
            acc.BillingPostalCode  = apt.Account__r.BillingPostalCode ;
            acc.BillingCountry = apt.Account__r.BillingCountry;
            acc.ShippingStreet = apt.Account__r.ShippingStreet;
            acc.ShippingCity = apt.Account__r.ShippingCity;
            acc.ShippingState = apt.Account__r.ShippingState;
            acc.ShippingPostalCode  = apt.Account__r.ShippingPostalCode ;
            acc.ShippingCountry = apt.Account__r.ShippingCountry;
            relatedCustomer.Related_Account__c = apt.Account__c;
            System.debug('::::CPQNewSampleExtension loading the apt.Account__c + ::::> ' + acc);
            accountName = apt.Account__r.Name;
            accountName = accountName.remove('\'');
          } else {
            acc = new Account();
            acc = galVisitorAcc;                      
          }
        
          if (apt.Project__c != NULL ) {
            oppName = apt.Project__r.Name;
            oppName = oppName.remove('\'');
            System.debug('::::CPQNewSampleExtension loading the apt.Opportunity + ::::> ' + opp);
          } else {
            String dupeOppName = apt.Visitor_Name__c + ' - Product Selection - ' + system.today().format();
            checkDupeOppList(dupeOppName);     
          }   
        
          if (apt.Contact__c != NULL) {
              cnt = new Contact();
            cnt.FirstName = apt.Contact__r.FirstName;
            cnt.LastName = apt.Contact__r.LastName;
            cnt.Email = apt.Contact__r.Email;
            cnt.Phone = apt.Contact__r.Phone;
            cnt.AccountId = apt.Contact__r.AccountId;
            System.debug('::::CPQNewSampleExtension starting with apt.Contact__c + ::::> ' + cnt);
            theContact= apt.Contact__c;
            relatedCustomer.Contact__c = apt.Contact__c;               
          } else {
            cnt = new Contact();
          }       
        
          if (apt.Visitor__c != NULL ) {
            relatedCustomer.New_ContactFirstName__c = apt.Visitor__r.FirstName;
            relatedCustomer.New_ContactLastName__c = apt.Visitor__r.LastName;
            relatedCustomer.New_ContactEmail__c = apt.Visitor__r.email;
            relatedCustomer.New_ContactPhone__c = apt.Visitor__r.phone;
            System.debug('::::CPQNewSampleExtension + l + relatedCustomer ...' + relatedCustomer);
            cnt = new Contact();
            cnt.FirstName = apt.Visitor__r.FirstName;
            cnt.LastName = apt.Visitor__r.LastName;
            cnt.email = apt.Visitor__r.email;
            cnt.phone = apt.Visitor__r.phone;
            System.debug('::::CPQNewSampleExtension + l + cnt ...' + cnt);
          }
        }
        if (theSObjectType == 'Account') {

            if (theRecordCheckId.left(3) == '001') { 
                theRecordId = theRecordCheckId;
            } else if(theActualId.left(3) == '001')  {
                theRecordId = theActualId;
            }
        
            acc = [
                SELECT Id
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
                WHERE Id = :theRecordId];
            System.debug('::::CPQNewSampleExtension starting with acc + step 2::::> ' + acc);
            relatedCustomer = new Related_Customer__c();
            relatedCustomer.Related_account__c= acc.id;
            accountName = acc.Name;
            accountName = accountName.remove('\'');
            String dupeOppName = accountName + ' - Product Selection - ' + system.today().format();
            System.debug('::::CPQNewSampleExtension starting with acc + dupeOppName::::> ' + dupeOppName);
            System.debug('::::CPQNewSampleExtension starting with acc + accountName::::> ' + accountName);
            relatedCustomer.New_Opportunity_Name__c =  dupeOppName;
            checkDupeOppList(dupeOppName);     
        }   

        if (theSObjectType == 'Contact') {
            System.debug('::::CPQNewSampleExtension starting with a cnt + ::::> ');
            if (theRecordCheckId.left(3) == '003') { 
                theRecordId = theRecordCheckId;
            } else if(theActualId.left(3) == '003')  {
                theRecordId = theActualId;
            }
            System.debug('::::CPQNewSampleExtension starting with a cnt + theRecordId::::> ' + theRecordId);
            

            List<Account> aList = new List<Account>();
            List<Contact> cList = new List<Contact>();     
    
            cList =  [
                SELECT Id
                    ,NAME
                    ,FirstName
                    ,LastName
                    ,Email
                    ,Phone
                    ,AccountId
                FROM Contact
                WHERE Id = :theRecordId];
            System.debug('::::CPQNewSampleExtension starting with the cList + ::::> ' + cList);
            
            if (cList.size() > 0) {
                cnt = cList[0];
                theContact = cnt.id;
                relatedCustomer = new Related_Customer__c();
                relatedCustomer.New_ContactFirstName__c = cnt.FirstName;
                relatedCustomer.New_ContactLastName__c = cnt.LastName;
                relatedCustomer.New_ContactEmail__c = cnt.email;
                relatedCustomer.New_ContactPhone__c = cnt.phone;
                relatedCustomer.Contact__c= cnt.id;                 
                relatedCustomer.Related_account__c= cnt.AccountId;         
                aList = [
                    SELECT Id
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
                    WHERE Id = :cnt.AccountId];
                    
                if (aList.size() > 0) {
                     acc = aList[0];
                    
                    System.debug('::::CPQNewSampleExtension starting with cnt + step 2::::> ' + acc);
                    relatedCustomer.Related_account__c= acc.id;
                    accountName = acc.Name;
                    accountName = accountName.remove('\'');
                    System.debug('::::CPQNewSampleExtension starting with acc + accountName::::> ' + accountName);
                    String dupeOppName = cnt.NAME + ' - Product Selection - ' + system.today().format();
                    System.debug('::::CPQNewSampleExtension starting with cnt + dupeOppName::::> ' + dupeOppName);
                    relatedCustomer.New_Opportunity_Name__c =  dupeOppName;
                    checkDupeOppList(dupeOppName);  

                }       
            }   
        oldContactEmail = null;
        oldContactFirstName = null;
        oldContactLastName = null;
        oldContactPhone = null;
        }
        
        if (theSObjectType == 'Opportunity') {
            opp = [
                SELECT Id
                    , Name
                    , StageName
                    , AccountId
                FROM Opportunity
                WHERE Id = :theActualId];
            System.debug('::::oppCheck + opp ...' + opp);
            theOppID = opp;
            oppName = opp.Name;
            oppName = oppName.remove('\'');
            Related_Customer__c theCurrentRC = new Related_Customer__c();
            Map < Related_Customer__c , String > mapRelatedCustomerToAccount = new Map < Related_Customer__c , String >();
            list <Related_Customer__c> relatedCustomersByBox = [SELECT Id
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
                                ,Related_account__r.BillingStreet
                                ,Related_account__r.BillingCity
                                ,Related_account__r.BillingState
                                ,Related_account__r.BillingPostalCode 
                                ,Related_account__r.BillingCountry                                
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
                                ,Contact__r.AccountId
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
                                WHERE Opportunity__c = :opp.Id    
                                ORDER BY Shopping_Cart__c DESC 
                                LIMIT 1];
            if (!relatedCustomersByBox.isEmpty()) {
                ID varAccountId;
                for (Related_Customer__c rc: relatedCustomersByBox) {
                    mapRelatedCustomerToAccount.put(rc,rc.Related_account__c);
                    System.debug('::::oppCheck + rc ...' + rc);
                    
                    relatedCustomer = rc;    
                    relatedCustomer.Related_Account__c = rc.Related_account__c;
                    accountName = rc.Related_account__r.Name;
                    accountName = accountName.remove('\'');    
                    relatedCustomerId = rc.Id;
                    relatedCustomer.New_Opportunity__c = rc.Opportunity__c;
                    // acc = rc.Related_account__c;
                    accountId = rc.Related_account__c;
                    varAccountId = rc.Related_account__c;
                    contactId = rc.Contact__c;        
                    theContact = rc.Contact__c;  
                    acc = new Account ();
                    acc.id = varAccountId;
                    acc.Name = accountName;
                    acc.BillingStreet = rc.Related_account__r.BillingStreet;
                    acc.BillingCity = rc.Related_account__r.BillingCity;
                    acc.BillingState = rc.Related_account__r.BillingState;
                    acc.BillingPostalCode  = rc.Related_account__r.BillingPostalCode ;
                    acc.BillingCountry = rc.Related_account__r.BillingCountry;
                    acc.ShippingStreet = rc.Related_account__r.ShippingStreet;
                    acc.ShippingCity = rc.Related_account__r.ShippingCity;
                    acc.ShippingState = rc.Related_account__r.ShippingState;
                    acc.ShippingPostalCode  = rc.Related_account__r.ShippingPostalCode ;
                    acc.ShippingCountry = rc.Related_account__r.ShippingCountry;                    
                }
            } else  {
                Related_Customer__c relatedCustomer = new Related_Customer__c ();
                acc = [SELECT ID
                            ,Name
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
                          WHERE ID = :opp.AccountId];    

                relatedCustomer.Related_account__c= acc.id;           
                accountName = acc.Name;
                accountName = accountName.remove('\'');     
                    
                relatedCustomerId = relatedCustomer.Id;
                relatedCustomer.New_Opportunity__c = opp.id;
                
                accountId = relatedCustomer.Related_account__c;
                contactId = relatedCustomer.Contact__c;               
                System.debug('::::CPQNewSampleExtension starting with oppCheck + relatedCustomer.Related_Account__c::::> ' + relatedCustomer.Related_Account__c);
            }
        }
    }

    public void checkDupeOppList (string dupeOppName) {
        
            List <Opportunity> dupeOppList = [SELECT ID, Name 
                                            FROM Opportunity  
                                            WHERE NAME = :dupeOppName
                                            LIMIT 1];    
            System.debug('::::CPQNewSampleExtension starting with acc + dupeOppList2::::> ' + dupeOppList);
            if (dupeOppList.IsEmpty()) {           
                System.debug('::::CPQNewSampleExtension starting with acc + no dupes::::> ');
                relatedCustomer.New_Opportunity_Name__c = dupeOppName;   
            } else {
                System.debug('::::CPQNewSampleExtension starting with acc + yep dupes::::> ');
                for (Opportunity dOpp:dupeOppList) {
                    opp = [
                        SELECT Id
                            , Name
                            , StageName
                            , AccountId
                            
                        FROM Opportunity
                        WHERE Id = :dOpp.Id];      
                    
                    relatedCustomer = [SELECT Id
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
                                    WHERE Opportunity__c = :opp.Id                              
                                    ORDER BY CreatedDate DESC 
                                    LIMIT 1];               

                    relatedCustomerId = relatedCustomer.Id;
                    relatedCustomer.New_Opportunity__c = opp.id;
                    oppName = opp.Name;
                    oppName = oppName.remove('\'');
                    accountId = relatedCustomer.Related_account__c;
                    

                    System.debug('::::CPQNewSampleExtension starting with acc + dupeOppList + opp::::> ' + opp);
                }                        
        }
    }

    public Related_Customer__c getRelatedCustomer() {
        return relatedCustomer;
    }
    
    public PageReference setParams() {
        return null;
    }
    
    public boolean getIsVisible(){
        boolean isVis;
        if (userGalleryName != '') {           
            String MyProflieName = OpportunityGateway.getProfile[0].Name;
            if (MyProflieName == 'Gallery User' 
                || MyProflieName == 'System Administrator'
            ){ 
                 isVis = true;
            }  else {
                isVis = false;
            } 
    }
            return isVis;
            system.debug('Called the Controller CPQNewSamplePrepareController, should have info on the record');
            return isVis;
    }
    
    public List<SelectOption> getGalleryContacts() {

        List <Contact> galCnt = [
            SELECT Id
                ,NAME
                ,FirstName
                ,LastName
                ,Email
                ,AccountId
            FROM Contact
            WHERE AccountId = :apt.Daltile_Location__c];
        System.debug('::::CPQNewSampleExtension + galCntList : ::::> ' + galCnt);

        LIST <SelectOption> galCntList = new LIST <SelectOption>();
        galCntList.add(new SelectOption('', selCons));
        
        for (Contact c : galCnt){
            galCntList.add(new SelectOption(c.Id, c.Name));
        }

        return galCntList; 
    }
    
    public String getGalleryContact() {
        
        System.debug('::::CPQNewSampleExtension + getGalleryContact : ::::> ' + galleryContact);
        return galleryContact;
    }

    public void setGalleryContact(String galleryContact) { 
        System.debug('::::CPQNewSampleExtension + getGalleryContact : ::::> ' + galleryContact);
        this.galleryContact = galleryContact; 
    }

    public List<SelectOption> getVisitorTypes() {
        List<SelectOption> options = new List<SelectOption>();
            if (varVisitorType != '' && varVisitorType != NULL){
                options.add(new SelectOption(varVisitorType, varVisitorType));              
            }
            options.add(new SelectOption('Homeowner','Homeowner'));
            options.add(new SelectOption('Appointment','Appointment'));
            options.add(new SelectOption('Arch./Designers','Arch./Designers'));
            options.add(new SelectOption('Residential Architect/Designer','Residential Architect/Designer'));
            options.add(new SelectOption('Commercial Architect/Designer','Commercial Architect/Designer'));
            options.add(new SelectOption('Builder/Developer/GC','Builder/Developer/GC'));
            options.add(new SelectOption('Builders/Developers/GCs','Builders/Developers/GCs'));
            options.add(new SelectOption('Competitor','Competitor'));
            options.add(new SelectOption('Courier Sample A&D','Courier Sample A&D'));
            options.add(new SelectOption('Dealers','Dealers'));
            options.add(new SelectOption('Direct Buy','Direct Buy'));
            options.add(new SelectOption('Fabricator','Fabricator'));
            options.add(new SelectOption('Home Depot','Home Depot'));
            options.add(new SelectOption('Meetings','Meetings'));
            options.add(new SelectOption('Slabyard','Slabyard'));
            options.add(new SelectOption('Tile Contractors','Tile Contractors'));
            options.add(new SelectOption('Vendor','Vendor'));
            options.add(new SelectOption('Visitor','Visitor'));
            options.add(new SelectOption('Walk Through','Walk Through'));
            options.add(new SelectOption('Other','Other'));
            options.add(new SelectOption('Architect/Designer','Architect/Designer'));
            options.add(new SelectOption('A&D (Residential)','A&D (Residential)'));
            options.add(new SelectOption('Sample Pickup','Sample Pickup'));
            options.add(new SelectOption('Walk Thru / Other','Walk Thru / Other'));
            options.add(new SelectOption('Event','Event'));
        return options;
    }
    
    public String getVisitorType() {
        
        System.debug('::::CPQNewSampleExtension + visitorType : ::::> ' + visitorType);
        return visitorType;
    }

    public void setVisitorType(String visitorType) { 
        System.debug('::::CPQNewSampleExtension + getGalleryContact : ::::> ' + visitorType);
        this.visitorType = visitorType; 
    }

    public List<SelectOption> getTheContacts() {
        LIST <Contact> lstCnt = null; 
        LIST <Contact> lstAccCnt = null;
        LIST <Contact> lstCntMaster = new List <Contact>();
        LIST <Contact> lstCntFinal = new List <Contact>();
        Map <Integer , Contact> mapContacts = new Map <Integer , Contact>();
        LIST <SelectOption> selCntList = new LIST <SelectOption>(); 

            System.debug('::::CPQNewSampleExtension + adding selCon : ::::> ' + selCon);
            if (apt != null) {
                if (apt.Contact__c != null) {
                      lstCnt = [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE id = :apt.Contact__c
                        ORDER BY LastModifiedDate DESC
                        LIMIT 999
                    ];
                    System.debug('::::CPQNewSampleExtension + getContacts + lstCnt : ::::> ' + lstCnt);
                    lstCntMaster.addall(lstCnt);               
                    selCntList.add(new SelectOption('', createCon)); 
                    selCntList.add(new SelectOption(lstCntMaster[0].Id, lstCntMaster[0].Name));
                } else if (apt.Visitor__c != null) {
                    selCntList.add(new SelectOption('', createCon)); 
                }    
            } else if (relatedCustomer != null) {
                if (relatedCustomer.Contact__c != NULL) {
                System.debug('::::CPQNewSampleExtension + getContacts + relatedCustomer.Contact__c != NULL : ::::> ' + relatedCustomer.Contact__c);
                    lstCnt = [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE id = :relatedCustomer.Contact__c
                        ORDER BY LastModifiedDate DESC
                        LIMIT 999
                    ];
                    System.debug('::::CPQNewSampleExtension + getContacts + lstCnt : ::::> ' + lstCnt);
                    lstCntMaster.addall(lstCnt); 
                    lstAccCnt = [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE AccountId = :relatedCustomer.Related_account__c
                        ORDER BY LastModifiedDate DESC
                        LIMIT 999
                    ];
                    for (Contact cC:lstCnt) {
                        
                    }
                    lstCntMaster.addall(lstAccCnt);                
                    System.debug('::::CPQNewSampleExtension + getContacts + lstCntMaster : ::::> ' + lstCntMaster);
                } else {
                    if (relatedCustomer.Related_account__c != null) {
                        System.debug('::::CPQNewSampleExtension + getContacts + relatedCustomer.Related_account__c == NULL : ::::> ' + relatedCustomer.Related_account__c);
                        lstAccCnt = [
                            SELECT Id
                                ,NAME
                                ,FirstName
                                ,LastName
                                ,Email
                                ,AccountId
                            FROM Contact
                            WHERE AccountId = :relatedCustomer.Related_account__c
                            ORDER BY LastModifiedDate DESC
                            LIMIT 999
                        ];
                        lstCntMaster.addall(lstAccCnt);
                    }
                }
                lstCntMaster.sort();
    
                Set<Id> conSet= new Set<Id>();
                for(Contact con:lstCntMaster){
                    conSet.add(con.id);
                }   
                
                lstCntFinal = [SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE id in :conSet order by name 
                ];
                System.debug('::::CPQNewSampleExtension + getContacts + lstAccCnt : ::::> ' + lstAccCnt);
                System.debug('::::CPQNewSampleExtension + getContacts + lstCntMaster : ::::> ' + lstCntMaster);
                System.debug('::::CPQNewSampleExtension + getContacts + lstAccCnt.size() : ::::> ' + lstAccCnt.size());
                System.debug('::::CPQNewSampleExtension + getContacts + lstCntMaster.size() : ::::> ' + lstCntMaster.size());
                System.debug('::::CPQNewSampleExtension + getContacts + cnt : ::::> ' + cnt);
    
                if (lstCntFinal.size() > 1 ){   
                        selCntList.add(new SelectOption('', selCon));    
                    for (Contact c : lstCntFinal){          
                        if (c.Id != null && c.Name != null) {
                            selCntList.add(new SelectOption(c.Id, c.Name));
                        }
                    }
                } else if (lstCntFinal.size() == 1 ){         
                    selCntList.add(new SelectOption('', selCon)); 
                    selCntList.add(new SelectOption(lstCntMaster[0].Id, lstCntMaster[0].Name));
                } else {
                    selCntList.add(new SelectOption('', createCon));     
                }
            }

        return selCntList; 
    }
    
    public String getTheContact() {
        
        System.debug('::::CPQNewSampleExtension + getTheContact : ::::> ' + theContact);
        return theContact;
    }

    public void setTheContact(String theContact) { 
        System.debug('::::CPQNewSampleExtension + theContact : ::::> ' + theContact);
        this.theContact = theContact;   
    }   

    public PageReference changeAccount() {

        System.debug('::::CPQNewSampleExtension + changeAccount + relatedCustomer.Related_Account__c : ::::> ' + relatedCustomer.Related_Account__c);

        Account theAcc = [SELECT ID
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
                        WHERE ID = :relatedCustomer.Related_account__c];
        System.debug('::::CPQNewSampleExtension + changeAccount + theAcc : ::::> ' + theAcc);   
            
        List <Contact> lstCnt = [
            SELECT Id
                ,NAME
                ,FirstName
                ,LastName
                ,Email
                ,AccountId
            FROM Contact
            WHERE AccountId = :relatedCustomer.Related_account__c
            ];

        System.debug('::::CPQNewSampleExtension + changeAccount + lstCnt : ::::> ' + lstCnt);           
        id selectedContact; 
        if (contactNameMap == null) {
            System.debug('::::CPQNewSampleExtension + changeAccount + contactNameMap : ::::> ' + contactNameMap);   
            contactNameMap = new Map<ID, ID>();
            for (contact c : lstCnt) {
                System.debug('::::CPQNewSampleExtension + changeAccount + c : ::::> ' + c); 
                selectedContact = contactNameMap.get(c.id);
                if (selectedContact != NULL){
                    contactNameMap.put(c.AccountId, c.id);  
                }
                selectedContact = c.id;
                System.debug('::::CPQNewSampleExtension + changeAccount + selectedContact : ::::> ' + selectedContact); 
            }
        }
      
        if (contactNameMap.containsKey(relatedCustomer.Related_account__c)) {
            theContact = selectedContact;
        }
        relatedCustomer.Contact__c= NULL;
        acc = theAcc;

        // clear out details after account change

        relatedCustomer.New_ContactLastName__c = NULL;
        relatedCustomer.New_ContactFirstName__c = NULL;
        relatedCustomer.New_ContactEmail__c = NULL;
        relatedCustomer.New_ContactPhone__c = NULL;
        
        if (cnt != null) {
            cnt.LastName = NULL;
            cnt.FirstName = NULL;
            cnt.Email = NULL;
            cnt.Phone = NULL;
        }
        relatedCustomer.Update_ShippingCountry__c = NULL;
        relatedCustomer.Update_ShippingStreet__c = NULL;
        relatedCustomer.Update_ShippingCity__c = NULL;
        relatedCustomer.Update_ShippingState__c = NULL;
        relatedCustomer.Update_ShippingPostalCode__c = NULL;
    
        return null;
    }
    
     public PageReference changeContact() {
        System.debug('::::CPQNewSampleExtension + changeContact + theContact: ::::> ' + theContact);
        
        List<Contact> cList = new List<Contact>();      
        
        if (theContact != null ) {
            cList = [
                SELECT Id
                    ,NAME
                    ,FirstName
                    ,LastName
                    ,Email
                    ,Phone
                    ,AccountId
                FROM Contact
                WHERE id = :theContact
                ];
            System.debug('::::CPQNewSampleExtension + changeContact + cList : ::::> ' + cList);
            if (cList.size() > 0) {
                 theCnt = cList[0];
            }            
            System.debug('::::CPQNewSampleExtension + changeContact + theCnt : ::::> ' + theCnt);
            if ( theCnt != NULL) {
                relatedCustomer.New_ContactLastName__c = theCnt.LastName;
                relatedCustomer.New_ContactFirstName__c = theCnt.FirstName;
                relatedCustomer.New_ContactEmail__c = theCnt.Email;
                relatedCustomer.New_ContactPhone__c = theCnt.Phone;
            } else {
                relatedCustomer.New_ContactLastName__c = '';
                relatedCustomer.New_ContactFirstName__c = '';
                relatedCustomer.New_ContactEmail__c = '';
                relatedCustomer.New_ContactPhone__c = '';
            }            
            
        }           
        return null;
    }   

    public void doGetOppID() {
        System.debug('CPQNewSamplePrepareController + oppList --->' + oppList);
        oppList = oppList;
        if (opp != NULL) {
            opplist = opp;
        }
        
    }

    @RemoteAction
    global static string updateCpqAccount( String currentAppointmentId
                                        ,String newAccount
    									,String newContact
    									,String newOpp              
    									,String newAccountName
    									,String updateShipCountry
    									,String updateShipState
    									,String updateShipAddress1
    									,String updateShipCity
    									,String updateShipPostal                          
    									){
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + newContact: ' + newContact);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + currentAppointmentId: ' + currentAppointmentId);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + newAccount: ' + newAccount);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + newAccountName: ' + newAccountName);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + updateShipCountry: ' + updateShipCountry);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + updateShipState: ' + updateShipState);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + updateShipAddress1: ' + updateShipAddress1);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + updateShipCity: ' + updateShipCity);
		System.debug('CPQNewSamplePrepareController + updateCpqAccount + updateShipPostal: ' + updateShipPostal);
		
    	Account a = new Account();
    	Contact c = new Contact();
    	Appointment__c apt = new Appointment__c();	
    	Account galAcc = new Account();
    	String newContactId = newContact;
    	String newAccountId = newAccount;
    	List<Account> aList = new List<Account>();
    	
    	string updatedAccountName = newAccountName;
    	if (newAccountName.length() > 50 ) {
    	    updatedAccountName = newAccountName.left(50);
    	}
    	
	    System.debug('CPQNewSamplePrepareController + updateCpqAccount + newAccountId --->' + newAccountId);
    	
    	if (currentAppointmentId != '') {
            apt = [
                SELECT Id
                    , Daltile_Location__c   
                    , Account__c
                FROM Appointment__c
                WHERE Id = :currentAppointmentId];
    	   System.debug('CPQNewSamplePrepareController + currentAppointmentId --->' + currentAppointmentId);
            
            if (apt.Daltile_Location__c != NULL) {
                galAcc = [
                    SELECT Id
                        ,NAME
                        ,Customer_Class__c
                        ,SSC__c
        				,ShippingCountry
        				,ShippingState
        				,ShippingStreet
        				,ShippingCity
        				,ShippingPostalCode
                    FROM Account
                    WHERE ID = :apt.Daltile_Location__c];

                List<RecordType> rtList = [
                                        SELECT SobjectType
                                            ,Name
                                            ,Id 
                                        FROM RecordType 
                                        WHERE SobjectType = 'Account' 
                                        AND Name = 'Person Account'];              
                String personAccountRT = '';                                        
                for(RecordType rt:rtList){
                    personAccountRT = rt.Id;            
                }
        	    Account newVisitorAccount = new Account();
        	    newVisitorAccount.Name = updatedAccountName;
        	    newVisitorAccount.OwnerId = UserInfo.getUserId();
        	    newVisitorAccount.SSC__c = galAcc.SSC__c;
        	    newVisitorAccount.RecordTypeId = personAccountRT;
        	    newVisitorAccount.Customer_Class__c = galAcc.Customer_Class__c;
        	    newVisitorAccount.Business_Type__c = 'Other';
    			newVisitorAccount.ShippingCountry = galAcc.ShippingCountry;
    			newVisitorAccount.ShippingState = galAcc.ShippingState;
    			newVisitorAccount.ShippingStreet = galAcc.ShippingStreet;
    			newVisitorAccount.ShippingCity = galAcc.ShippingCity;
    			newVisitorAccount.ShippingPostalCode = galAcc.ShippingPostalCode;
            	try {
            		insert newVisitorAccount;
            		newAccount = newVisitorAccount.Id;
            		a = newVisitorAccount;
    	            System.debug('CPQNewSamplePrepareController + newVisitorAccount --->' + newVisitorAccount);
    	            System.debug('CPQNewSamplePrepareController + a --->' + a);
            	} catch(System.Exception ex) {
            		system.debug(ex.getMessage());
            	}
        	}
    	}
    	
    	if (newAccount != NULL && !newAccountId.startsWith('0000000') && newAccountId != '' ){
    		aList = [SELECT ID
    				,Name
    				,ShippingCountry
    				,ShippingState
    				,ShippingStreet
    				,ShippingCity
    				,ShippingPostalCode
    				FROM Account WHERE ID = :newAccount];       
    		if (aList.size() > 0) {
                 a = aList[0];
    		}				
    	} 
    	            System.debug('CPQNewSamplePrepareController + a --->' + a);
    	
    	// Shipping Address update
		if (!String.isBlank(updateShipCountry) || !String.isBlank(updateShipState) || !String.isBlank(updateShipAddress1) || !String.isBlank(updateShipCity) || !String.isBlank(updateShipPostal)){  
			a.Legacy_Shipping_Country__c = a.ShippingCountry;
			a.Legacy_Shipping_State__c = a.ShippingState;
			a.Legacy_Shipping_Address_1__c = a.ShippingStreet;
			a.Legacy_Shipping_City__c = a.ShippingCity;
			a.Legacy_Shipping_Postal__c = a.ShippingPostalCode;    
			if (((updateShipCountry != NULL) && (updateShipCountry != ''))&&(updateShipCountry != a.ShippingCountry)) {
			   System.debug('CPQNewSamplePrepareController + updateShippingAddress --->' + 'Country:' + updateShipCountry); 
				a.ShippingCountry = updateShipCountry;
			}
			if (((updateShipState != NULL) && (updateShipState != ''))&&(updateShipState != a.ShippingState)) {
			   System.debug('CPQNewSamplePrepareController + updateShippingAddress --->' + 'State:' + updateShipState); 
				a.ShippingState = updateShipState;              
			}
			if (((updateShipAddress1 != NULL) && (updateShipAddress1 != ''))&&(updateShipAddress1 != a.ShippingStreet)) {
			   System.debug('CPQNewSamplePrepareController + updateShippingAddress --->' + 'Address:' + updateShipAddress1); 
				a.ShippingStreet = updateShipAddress1;
			}
			if (((updateShipCity != NULL) && (updateShipCity != ''))&&(updateShipCity != a.ShippingCity)) {
			   System.debug('CPQNewSamplePrepareController + updateShippingAddress --->' + 'City:' + updateShipCity); 
				a.ShippingCity = updateShipCity;            
			}
			if (((updateShipPostal != NULL) && (updateShipPostal != ''))&&(updateShipPostal != a.ShippingPostalCode)) {
			   System.debug('CPQNewSamplePrepareController + updateShippingAddress ---> + Postal:' + updateShipPostal); 
				a.ShippingPostalCode = updateShipPostal;                                
			}
			try {
				update a;
			} catch(System.Exception ex) {
				system.debug(ex.getMessage());
			}			
		}
    	newAccountId = a.id;
    	try {
    	    apt.Account__c = a.id;
    	    update apt;
    	}catch(System.Exception ex) {
    		system.debug(ex.getMessage());
    	}
    	return newAccountId;
    }	


    @RemoteAction
    global static string updateCpqContact( String currentAppointmentId
                                        ,id newAccount
    									,id newContact
    									,id newOpp                 
    									,String newContactFirstName
    									,String newContactLastName
    									,String newContactEmail
    									,String newContactPhone                                              
    									){
    	Account a = new Account();
    	Contact c = new Contact();
    	Appointment__c apt = new Appointment__c();	
    	Contact newCon = new Contact();
    	String newContactId = newContact;
    	String newAccountId = newAccount;
		System.debug('CPQNewSamplePrepareController + updateContact + currentAppointmentId: ' + currentAppointmentId);
		System.debug('CPQNewSamplePrepareController + updateContact + newContact: ' + newContact);
		System.debug('CPQNewSamplePrepareController + updateContact + newAccount: ' + newAccount);
		System.debug('CPQNewSamplePrepareController + updateContact + newContactFirstName: ' + newContactFirstName);
		System.debug('CPQNewSamplePrepareController + updateContact + newContactLastName: ' + newContactLastName);
		System.debug('CPQNewSamplePrepareController + updateContact + newContactEmail: ' + newContactEmail);
		System.debug('CPQNewSamplePrepareController + updateContact + newContactPhone: ' + newContactPhone);
		
		List <Contact> oldContactList = [SELECT ID
											,FirstName
											,LastName
											,Email
											,Phone 
											,AccountID
										FROM Contact 
										WHERE Id = :newContactId
                                        ];        
                                                
        
		List <Contact> newContactList = [SELECT ID
											,FirstName
											,LastName
											,Email
											,Phone 
											,AccountID
										FROM Contact 
										WHERE LastName = :newContactLastName
    										AND FirstName = :newContactFirstName
    										AND Email = :newContactEmail
    										AND AccountID = :newAccountId
										LIMIT 1];        
                                        
    	List <Contact> masterContactList = new List <Contact> ();       
        masterContactList.addall(newContactList);   
        masterContactList.addall(oldContactList);
		System.debug('CPQNewSamplePrepareController + updateContact + masterContactList  --->' + masterContactList);   
        if (masterContactList.isEmpty()) {
    		System.debug('CPQNewSamplePrepareController + updateContact: Creating New contact  --->');                  
    		Id accountInUse = NULL;
    		newCon.firstName = newContactFirstName;
    		newCon.email = newContactEmail;
    		newCon.Phone = newContactPhone;
    		newCon.lastName = newContactLastName;
    		newCon.AccountId = newAccount;
			try {
				insert(newCon);
				c = newCon;
			} catch(System.Exception ex) {
				system.debug(ex.getMessage());
			}                   
    	} else {
            for (Contact cUpdate:masterContactList) {
        		if (((newContactFirstName != NULL) && (newContactFirstName != ''))&&(newContactFirstName != cUpdate.FirstName)) {
        			cUpdate.FirstName = newContactFirstName;
        		}   
        		if (((newContactLastName != NULL) && (newContactLastName != ''))&&(newContactLastName != cUpdate.LastName)) {
        			cUpdate.LastName = newContactLastName;
        		}   
        		if (((newContactEmail != NULL) && (newContactEmail != ''))&&(newContactEmail != cUpdate.Email)) {
        			cUpdate.Email = newContactEmail;  
        		}
        		if (((newContactPhone != NULL) && (newContactPhone != '')) &&(newContactPhone != cUpdate.Phone)) {    
        			cUpdate.Phone = newContactPhone;
        		}                                           
        		try {
        			update cUpdate;
    	            c = cUpdate;
        		} catch(System.Exception ex) {
        			system.debug(ex.getMessage());
        		}              
            }    	    
    	}
    	
           if (currentAppointmentId != '') {
                apt = [
                    SELECT Id
                        , Daltile_Location__c   
                        , Contact__c
                    FROM Appointment__c
                    WHERE Id = :currentAppointmentId];
        	   System.debug('CPQNewSamplePrepareController + currentAppointmentId --->' + currentAppointmentId);
                
            	try {
            	    apt.Contact__c = c.id;
            	    update apt;
            	}catch(System.Exception ex) {
            		system.debug(ex.getMessage());
            	}
            }
        	newContactId = c.Id;
        	return newContactId;
        }
    									
    @RemoteAction
    global static string createCpqOpp( String currentAppointmentId
                                        ,String newAccount
    									,String newContact
    									,String newGalleryConsultant
    									,string visitorType 
    									,String newOpp 
    									,String newON                                       
    									){
        System.debug('CPQNewSamplePrepareController + createCpqOpp --->');
        System.debug('CPQNewSamplePrepareController + createCpqOpp + newAccount:--->'+newAccount);
        System.debug('CPQNewSamplePrepareController + createCpqOpp + newContact:--->'+newContact);
        System.debug('CPQNewSamplePrepareController + createCpqOpp + newGalleryConsultant:--->'+newGalleryConsultant);
        System.debug('CPQNewSamplePrepareController + createCpqOpp + visitorType:--->'+visitorType);
        System.debug('CPQNewSamplePrepareController + createCpqOpp + newOpp:--->'+newOpp);
        System.debug('CPQNewSamplePrepareController + createCpqOpp + newON:--->'+newON);
    	String dupeOppName = '';
    	String galleryConsultantName = '';
    	Account a = new Account();
    	Contact c = new Contact();
    	Contact cG = new Contact();
    	Appointment__c apt = new Appointment__c();	
    	Opportunity o = new Opportunity();	
    	Opportunity oNew = new Opportunity();	
    	RecordType recordTypeForProfile;
    	String newContactId = newContact;	
    	String newGalleryContactId = newGalleryConsultant;
    	String newAccountId = newAccount;
    	string newOppId = '';
    	List<Account> aList = new List<Account>();
    	List<Contact> cList = new List<Contact>();      
    	List<Contact> cGList = new List<Contact>();      
        OpportunityContactRole oppCR = new OpportunityContactRole();
        String MyProflieName = OpportunityGateway.getProfile[0].Name;    	
        String MyUserTypeName = UserInfo.getUserType();

    	if (newAccount != NULL && !newAccountId.startsWith('0000000')){
    		aList = [SELECT ID
    				,Name
    				FROM Account WHERE ID = :newAccount];       
    		if (aList.size() > 0) {
                 a = aList[0];
    			 dupeOppName = a.NAME + ' - Product Selection - ' + system.today().format();
    		}				
    	}
    	
    	if (newContact != NULL && !newContactId.startsWith('0000000')){
    		cList = [SELECT ID
    				FROM Contact WHERE ID = :newContactId];     
    		if (cList.size() > 0) {
                 c = cList[0];
    		}				
    	}		

    	if (newGalleryConsultant != NULL && !newGalleryContactId.startsWith('0000000')){
    		cGList = [SELECT ID,Name,AccountID
    				FROM Contact WHERE ID = :newGalleryContactId];     
    		if (cGList.size() > 0) {
                 cG = cGList[0];
    		}				
    	}	
    	
    	if (cG != null) {
    	    galleryConsultantName = cG.Name;
    	}
    	
    	if (newOpp != null) {
    	    newOppId = newOpp;
    	}

    	System.debug('::::CPQNewSampleExtension MyProflieName::::> ' + MyProflieName  ); 
    	System.debug('::::CPQNewSampleExtension MyUserTypeName::::> ' + MyUserTypeName  );
        List<RecordType> rtList = [
                                SELECT SobjectType
                                    ,Name
                                    ,Id 
                                FROM RecordType 
                                WHERE SobjectType = 'Opportunity'];  
        
        if(rtList != null && rtList.size()>0){
            for(RecordType rt:rtList){
                if (MyProflieName.startsWith('Distributor')) {
                    if (rt.Name == 'Distributors' && MyUserTypeName == 'Standard') {
                        recordTypeForProfile = rt;
                    }
                } else if (rt.Name == 'Project'){
                    recordTypeForProfile = rt;
                }       
            }
        }
    	System.debug('::::CPQNewSampleExtension recordTypeForProfile::::> ' + recordTypeForProfile  );
        
    	List <Opportunity> dupeOppList = new List <Opportunity> ();
        String newOpportunityName = '';
        if (newON != NULL && newON != '') {
            newOpportunityName = newON;
        } else {
            newOpportunityName = a.NAME + ' - Product Selection - ' + system.today().format();
        	dupeOppList= [SELECT ID, Name 
        					FROM Opportunity  
        					WHERE NAME = :newOpportunityName
        					LIMIT 1];               
        }
                                            
    	System.debug('::::CPQNewSampleExtension newOpportunityName::::> ' + newOpportunityName);
    	
    	if (dupeOppList.isEmpty()) {
            if (newOppId == '' || newOppId.startsWith('00000000000') || newOpp == NULL) {
                User u = [Select Name, email, ID from User where Id = :UserInfo.getUserId()];
                System.debug('CPQQuoteNewExtension + u ---> '+u);                       

                o.Name = newOpportunityName;
                o.AccountId = a.id;
                // String MyProflieName = OpportunityGateway.getProfile[0].Name;
                date dateToday = system.today();

                List <Task> insertGalleryTask = new list <Task>();
                if ((MyProflieName == 'Gallery User'))  {     
                    date newDate = dateToday.addMonths(3);
                    o.CloseDate = newDate;
                } else {  
                    date newDate = dateToday.addYears(1);
                    o.CloseDate = newDate;
                }
                o.StageName = '2 - Specification';           
                o.Sub_Stage__c= '1 - Prospect';         
                o.Generated_By__c = galleryConsultantName;            
                o.RecordTypeId = recordTypeForProfile.Id;            
                try {
                    insert o;
                } catch(System.Exception ex) {
                    system.debug(ex.getMessage());
                }
    		} else {
    		    if ( !newOppId.startsWith('00000000000') || newOpp != NULL) {
    		        o.Id = newOpp;
                    if (newON != NULL && newON != '') {
                        o.Name = newOpportunityName;
                    }   
                    try {
                        update o;
                    } catch(System.Exception ex) {
                        system.debug(ex.getMessage());
                    }  		        
    		    }
    		    
    		}
    	} else {
    		for (Opportunity dOpp:dupeOppList) {
    			o = dOpp;
    			System.debug('::::CPQNewSampleExtension starting with acc + dupeOppList + dOpp::::> ' + dOpp);
    		}                
    	}
    
    	list<Related_Customer__c> rList = [SELECT Id,
    									Related_Account__c,
    									Opportunity__c,
    									Contact__c,
    									Shopping_Cart__c,
    									Appointment__c,
    									New_ContactLastName__c,
    									New_ContactFirstName__c,
    									New_ContactEmail__c,
    									New_ContactPhone__c
    								FROM Related_Customer__c
    								WHERE Opportunity__c = :o.Id     
    								AND Related_Account__c = :a.id
    								ORDER BY CreatedDate DESC 
    								LIMIT 1
    								]; 
    	System.debug('createOrder rList ---> '+rList);                                                 
    	if (!rlist.isEmpty()){
    		for (Related_Customer__c rc: rList) {     
    			rc.Shopping_Cart__c = TRUE;    			
			    rc.Related_Account__c = a.Id;
    			if (c != NULL) {
    				rc.Contact__c = c.Id;
    			}   
    			try{                                                                       
    				update rc;
    			}catch(Exception e){
    				System.debug('Exception caught in update rc function ---> '+e);
    			}      
    		}
    	} else {
    		// NEW RC
    		if ((newOpp != NULL && !newOppId.startsWith('00000000000'))
    			|| (newAccount != NULL && (newAccount != o.AccountId ))){
    			System.debug('CPQNewSamplePrepareController + updateContact: should be doing an update on account/contact--->');
    			newRC = new Related_Customer__c();
    			newRC.Shopping_Cart__c = TRUE;
    			if (newOpp != null) {
    			    newRC.Opportunity__c = newOpp; 
    			} else {
    			    newRC.Opportunity__c = o.id; 
    			}
    			newRC.Related_Account__c = a.Id;
    			if (c != NULL) {
    				newRC.Contact__c = c.Id;
    			}                           
    			try {
    				insert newRC;           
    			} catch(System.Exception ex) {
    				system.debug(ex.getMessage());
    			}                   
    		}     		
    	}

    	// NEW OppCR
    	if (c != NULL) {
    		// Adding the contact as an Opportunity contact
    		oppCR = new OpportunityContactRole();           
    		oppCR.ContactId = c.Id;
		    oppCR.OpportunityId = o.Id;
    		oppCR.Role = 'Evaluator';
    		oppCR.IsPrimary = true;                 
    		try {
    			insert oppCR;                       
    		} catch(System.Exception ex) {
    			system.debug(ex.getMessage());
    		}       
    	}    	

    	string opportunityId = o.id;
    	return opportunityId;
    }
    

    @RemoteAction
    global static Boolean updateAppointment(id currentAppointmentId
                                            , string theVisitorType
                                            , id galleryContact
                                            , string currentlyWorkingWith){

        System.debug('CPQNewSamplePrepareController + updateAppointmentConsultant: currentappoIntmentId: ' + currentappoIntmentId + ' / theVisitorType: ' +theVisitorType + ' / galleryContact: ' + galleryContact + + ' / currentlyWorkingWith: ' + currentlyWorkingWith +  '--->');
        String galleryContactId = galleryContact ;
        String theVisitorTypeId = theVisitorType ;
        string theAppointmentId = currentAppointmentId;
		String contactId = '';
		String accountId = '';
		String opportunityId = '';
        Contact c = new Contact();
        Contact cGal = new Contact();
                                         
        Appointment__c apt = [SELECT ID
                    ,Consultant__c
                    ,Daltile_Location__c
                    ,Project__c
                    ,Visitor_Type__c
                    ,Visitor__c
                    ,Status__c
                    ,Currently_Working_With__c
                    ,Contact__c
                    ,Account__c
                    FROM Appointment__c WHERE ID = :theAppointmentId];
        System.debug('CPQNewSamplePrepareController + updateAppointmentConsultant +  apt--->' + apt);

        List<Contact> listGalleryContacts = new List<Contact>();      
                
        listGalleryContacts = [SELECT 
                    ID
                    ,FirstName
                    ,LastName
                    ,Email
                    ,AccountId
                    ,Account.SSC__c
                FROM Contact WHERE ID = :galleryContactId];           
        
        if (listGalleryContacts.size() > 0) {
            cGal = listGalleryContacts[0];
            System.debug('CPQNewSamplePrepareController + updateAppointmentConsultant +  Gallery Contact  c--->' + c);       
        }   

        if (apt.Visitor__c != NULL ) {
            Lead l = [Select Id, 
                                FirstName, 
                                LastName, 
                                email, 
                                Company, 
                                Phone,
                                IsConverted, 
                                Visitor_Type__c
                            From Lead 
                            WHERE Id = :apt.Visitor__c];
            System.debug('::::CPQNewSampleExtension + LeadConverting + l ...' + l);  
            if (l.IsConverted == FALSE){
                if (apt.Contact__c == null && l.LastName != '' && l.email != '') {
                    System.debug('::::CPQNewSampleExtension + LeadConverting + searching for existing contact based on last name / email ...' + l.LastName);
                    Contact[] contacts = [Select FirstName, 
                                                LastName, 
                                                email, 
                                                accountId, 
                                                Id 
                                            FROM Contact 
                                            where (LastName = :l.LastName 
                                            AND FirstName = :l.FirstName)
                                            OR ((email = :l.email)
                                            and ( email != ''))
                                            LIMIT 1];
                    if (contacts.size() > 0) {
                        System.debug('::::CPQNewSampleExtension + LeadConverting + found existing contact ...' + contacts);
                        accountId = contacts[0].accountId;
                        contactId = contacts[0].id;
                    }
                } else if (apt.Contact__c != null) {
                    c = [Select FirstName, 
                                    LastName, 
                                    email, 
                                    accountId, 
                                    Id 
                                FROM Contact 
                                where id = : apt.Contact__c
                                LIMIT 1];                
                    contactId = apt.Contact__c;   
                    accountId = c.accountId;
                    opportunityId = apt.Project__c;
                }
                
                // perform the lead conversion
                Database.LeadConvert lc = new Database.LeadConvert();
                String convertedStatus = 'Gallery Converted';
                lc.setLeadId(apt.Visitor__c);
                lc.setConvertedStatus(convertedStatus);
                if (accountId != null && accountId.length() > 0) lc.setAccountId(accountId);
                if (contactId != null && contactId.length() > 0) lc.setContactId(contactId);
                lc.setDoNotCreateOpportunity(TRUE); 
                // if (opportunityId != null && opportunityId.length() > 0) lc.setOpportunityId(opportunityId);
                System.debug('::::CPQNewSampleExtension + LeadConverting + lc ...' + lc);
                Database.LeadConvertResult lcr = Database.convertLead(lc, true);
                if (lcr.isSuccess()) {
                    Account acc = [
                        SELECT Id
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
                        WHERE Id = :lcr.getAccountId()];
                    Contact cnt =  [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,Phone
                            ,AccountId
                        FROM Contact
                        WHERE Id = :lcr.getContactId()];

                    // Opportunity opp = [
                    //     SELECT Id
                    //         , Name
                    //         , StageName
                    //         , AccountId
                            
                    //     FROM Opportunity
                    //     WHERE Id = :lcr.getOpportunityId()];
                                    
                    // get person account record type
                    Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                    
                    // get customer class 
                    Id customerClass = [select Id from Customer_Class__c where Name = 'RCN-SC' limit 1].Id;
                    
                    if (acc.Customer_Class__c == null) {
                        acc.Customer_Class__c = customerClass;
                    }
                    
                    // 
                    if (acc.SSC__c == null) {
                        acc.SSC__c = cGal.Account.SSC__c;
                    }
                    
                    acc.Phone = l.phone;
                    update(acc);
                    cnt.Phone = l.phone;
                    cnt.email = l.email;
                    update(cnt);
                    apt.Contact__c = cnt.Id;
                    apt.Account__c = acc.ID;
                    update(apt);
                } else {
                    String error = lcr.getErrors()[0].getMessage();
                    System.debug('::::CPQNewSampleExtension + LeadConverting + error + ::::> ' + error);
                }
            } else { 
                System.debug('No unconverted leads found with Id : "' + apt.Visitor__c + '"');
                Account acc = [SELECT ID FROM ACCOUNT WHERE ID = :apt.Account__c]; 
                Contact cnt = [SELECT ID FROM CONTACT WHERE ID = :apt.Contact__c];
                // Opportunity opp = [SELECT ID FROM OPPORTUNITY WHERE ID = :apt.Project__c];
            }
        } 
        
        apt.Currently_Working_With__c = currentlyWorkingWith;
        if (cGal != NULL) {
            apt.Consultant__c = cGal.id;                           
        }

        if (theVisitorTypeId != '') {
            apt.Visitor_Type__c = theVisitorTypeId;
        }
        
        apt.Appointment_CPQ_Time__c = System.Now();
        
        apt.Status__c = 'In Progress';
        try {
            update apt;
        } catch(System.Exception ex) {
            system.debug(ex.getMessage());
        }
        System.debug('CPQNewSamplePrepareController + updateAppointmentConsultant: should have updated apt --->' + apt);            

     return true;             
    } 

    @RemoteAction
    global static List<Account> queryAccount(String keyword) {
        List<Account> accountMyList = new List<Account>();
        List<Account> accountAllList = new List<Account>();
        List<Account> accountMasterList = new List<Account>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            accountMyList = [Select Id
                            , Name
                            , Owner.Name
                            , DW_ID__c
                            from Account  
                            WHERE 
                            Name like :keyword 
                            AND OwnerID = :UserInfo.getUserId() 
                            limit 5];
            
            accountMasterList.addall(accountMyList);
            
            accountAllList = [Select Id
                            , Name
                            , Owner.Name
                            , DW_ID__c
                            from Account  
                            WHERE ( Name like :keyword 
                            AND OwnerID != :UserInfo.getUserId() )
                            OR (DW_ID__c like :keyword )
                            limit 5];   
            
            accountMasterList.addall(accountAllList);
        }
        System.debug('::::accountList::::> ' + accountMasterList);
        return accountMasterList;
    }  
    
    @RemoteAction
    global static List<Opportunity> queryOpportunity(String keyword) {
        List<Opportunity> opportunityMyList = new List<Opportunity>();
        List<Opportunity> opportunityAllList = new List<Opportunity>();
        List<Opportunity> opportunityMasterList = new List<Opportunity>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            opportunityMyList = [Select Id
                            , Name
                            , Owner.Name
                            from Opportunity  
                            WHERE Name like :keyword 
                            AND OwnerID = :UserInfo.getUserId()
                            limit 5];
            
            opportunityMasterList.addall(opportunityMyList);
            
            opportunityAllList = [Select Id
                            , Name
                            , Owner.Name
                            from Opportunity  
                            WHERE Name like :keyword 
                            AND OwnerID != :UserInfo.getUserId()
                            limit 5];
            
            opportunityMasterList.addall(opportunityAllList);
        }
        System.debug('::::opportunityMasterList::::> ' + opportunityMasterList);
        return opportunityMasterList;
    }      
}