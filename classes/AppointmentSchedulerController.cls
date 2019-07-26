global with sharing class AppointmentSchedulerController {
    public Appointment__c appointment {get;set;}
    public Contact newContact {get;set;}
    public Contact theCnt {get;set;}        
    private static final String selCon = 'Select A Contact';    
    transient public String galleryContact = null;
    transient public String visitorType = null;    
    transient public String theContact = null;
    transient public String newContactEmail = null;
    public String newContactFirstName = null;
    transient public String newContactLastName = null;
    transient public String newContactPhone = null;
    public transient Map<ID, ID> contactNameMap; 
    private static final String selCons = 'Select A Consultant';
    public String pageName {get;set;}    
    public String welcomePhoneNumber {get;set;}
    private Boolean isPreSchedueled {get;set;}    
    // the collection of contacts to display
    public List<Contact> contacts {get;set;}
    public List<Lead> leads {get;set;}
    public List<Appointment__c> appointments {get;set;}
    public String verbiageCreateUpdate  {get;set;}
    public String verbiageVisitorCheckedIn  {get;set;}
    public String galleryAccountId  {get;set;}
    public String galleryAccountName  {get;set;}
    public Account galleryAccount {get;set;}
    public Account visitorAccount {get;set;}
    public Contact visitorContact {get;set;}
    static PageReference visitorCreated;
    static PageReference confirmPage; 
    static PageReference appointmentPage;
    static PageReference backToCheckin;
    private final Lead visitorLead;
    public Lead newLead;
    private User galleryUser {get;set;}
    
    ApexPages.StandardController controller;
    
    public AppointmentSchedulerController(ApexPages.StandardController controller) {
        
        String type = controller.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType =  String.valueof(controller.getRecord().getSObjectType());
        String theActualId =  String.valueof(controller.getRecord().get('Id')); 
        String theRecord =  String.valueof(controller.getRecord());
        String theRecordtemp =  theRecord.removeEnd('}');
        String theGenericRecordizerPt1 = theRecordtemp.right(18);            
        String theRecordCheckId = theGenericRecordizerPt1.removeStart('_c=');     
        System.debug('theRecords Type: ' + theSObjectType);        
        System.debug('theRecordCheckId: ' + theRecordCheckId);
        System.debug('theActualId...' + theActualId);        

        if (theSObjectType == 'Appointment__c') {
            List <Appointment__c> aList = [ SELECT ID
                                                , Name
                                                , Visitor__c
                                                , Contact__c
                                                , Status__c
                                                , Consultant__c
                                                , Daltile_Location__c
                                                , Comments__c
                                                , Consultant__r.Name
                                                , Visitor_Type__c
                                            FROM Appointment__c
                                            WHERE ID = :theActualId
            ];  
            System.debug('aList: ' + aList);
            if (!aList.isEmpty()) {
                for (Appointment__c a:aList){
                    appointment = a;
                    if (a.Contact__c != NULL){
                        List <Contact> cList = [ SELECT ID
                                                        , FirstName
                                                        , LastName
                                                    FROM Contact
                                                    WHERE ID =: a.Contact__c
                        ];
                        if (!cList.isEmpty()) {
                            for (Contact c:cList)  {
                                newContact = c;
                            }
                        }
                    } else {
                        newContact = new Contact();              
                    }
                }
            } else {
                appointment = new Appointment__c();
                newContact = new Contact();                
            }
        } else {
        
            appointment = new Appointment__c();
            newContact = new Contact();
        }
    }
    
    public void updateTimeOpened() {        
        System.debug('MADE IT TO updateTimeOpened!');
        PageReference appointmentPage = new ApexPages.StandardController(appointment).view();
        if (appointment.Status__c == 'Checked In') {
            appointment.Appointment_Start_Time__c = System.Now();
            System.debug('::::CPQNewSamupdateTimeOpenedpleExtension + appointment.Appointment_Start_Time__c : ::::> ' + appointment.Appointment_Start_Time__c);
            appointment.Status__c = 'In Progress';
            try {
                update appointment;           
                appointmentPage.setRedirect(true);
            } catch(System.Exception ex) {
                system.debug(ex.getMessage());
                System.debug('::::CPQNewSamupdateTimeOpenedpleExtension + ex : ::::> ' + ex);
            }        
        }
    }

    public List<SelectOption> getGalleryContacts() {
        LIST <SelectOption> galCntList = new LIST <SelectOption>();   
        LIST <Contact> galCurrentCnt = new LIST <Contact>();           
        List <Contact> galCnt = [
            SELECT Id
                ,NAME
                ,FirstName
                ,LastName
                ,Email
                ,AccountId
            FROM Contact
            WHERE AccountId = :appointment.Daltile_Location__c];
        System.debug('::::CPQNewSampleExtension + galCnt : ::::> ' + galCnt);


        if (appointment.Consultant__c != null) {
            // for (Contact c : galCurrentCnt){            
                galCntList.add(new SelectOption(appointment.Consultant__c, appointment.Consultant__r.Name));
            // }     
        } else {
            galCntList.add(new SelectOption('', selCons));
        }
        
        for (Contact c : galCnt){            
            galCntList.add(new SelectOption(c.Id, c.Name));
        }
        System.debug('::::CPQNewSampleExtension + galCntList : ::::> ' + galCntList);

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
            if (appointment.Visitor_Type__c != '' && appointment.Visitor_Type__c != NULL){
                options.add(new SelectOption(appointment.Visitor_Type__c, appointment.Visitor_Type__c));              
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
        LIST <SelectOption> selCntList = new LIST <SelectOption>(); 
        if (appointment.Contact__c != NULL) {
        System.debug('::::CPQNewSampleExtension + getContacts + appointment.Contact__c != NULL : ::::> ' + appointment.Contact__c);
            lstCnt = [
                SELECT Id
                    ,NAME
                    ,FirstName
                    ,LastName
                    ,Email
                    ,AccountId
                FROM Contact
                WHERE id = :appointment.Contact__c
            ];
            lstAccCnt = [
                SELECT Id
                    ,NAME
                    ,FirstName
                    ,LastName
                    ,Email
                    ,AccountId
                FROM Contact
                WHERE AccountId = :appointment.Account__c
                AND id != :appointment.Contact__c
            ];          
        } else {
        System.debug('::::CPQNewSampleExtension + getContacts + appointment.Contact__c == NULL : ::::> ' + appointment.Contact__c);
            lstAccCnt = [
                SELECT Id
                    ,NAME
                    ,FirstName
                    ,LastName
                    ,Email
                    ,AccountId
                FROM Contact
                WHERE AccountId = :appointment.Account__c
            ];
        }
        System.debug('::::CPQNewSampleExtension + getContacts + lstCnt : ::::> ' + lstCnt);

        if (newContact.FirstName != ''){
            selCntList.add(new SelectOption('', selCon));
        }       
        if (lstCnt != NULL ){   
            for (Contact c : lstCnt){
                selCntList.add(new SelectOption(c.Id, c.Name));
            }
        }
        for (Contact ac : lstAccCnt){
            selCntList.add(new SelectOption(ac.Id, ac.Name));
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
    
    @RemoteAction
    global static Appointment__c closeAppointment(id appointmentID, String consultantID, string visitorType, string comments) {
        Appointment__c closedAPT = new Appointment__c();
        String newGalleryConsultant = consultantID;
    	Contact cG = new Contact();
    	List<Contact> cGList = new List<Contact>();      
        if (appointmentID != NULL) {
            system.debug('Closing the Appointment__c)...' + appointmentID);   
            system.debug('Closing the Appointment__c + consultantID...' + consultantID);   
            system.debug('Closing the Appointment__c + visitorType...' + visitorType);  
            system.debug('Closing the Appointment__c + comments...' + comments);  

        	if (newGalleryConsultant != NULL && !conSultantId.startsWith('0000000')){
        		cGList = [SELECT ID,Name,AccountID
        				FROM Contact WHERE ID = :conSultantId];     
        		if (cGList.size() > 0) {
                     cG = cGList[0];
        		}				
        	}	
        	String galleryConsultantName = '';
        	if (cG != null) {
        	    galleryConsultantName = cG.Name;
        	}

            closedAPT = [select ID, 
                                Name, 
                                Consultant__c,
                                Consultant__r.Name,
                                Comments__c, 
                                Daltile_Location__r.Name,
                                Status__c,  
                                Account__c,
                                Account__r.Name,
                                Project__c,
                                Project__r.Name,
                                Visitor_Type__c,
                                Visitor_Name__c,
                                Visitor_Time_In__c,
                                Visitor_Time_Out__c,
                                Prescheduled__c,
                                Appointment_Start_Time__c
                        from Appointment__c 
                        where ID = :appointmentID
                        AND Status__c != 'Closed'];

            System.debug('::::OpportunityGateway + closedAPT.Account__r.Name: ' + closedAPT.Account__r.Name);   
            System.debug('::::OpportunityGateway + closedAPT.Project__r.Name: ' + closedAPT.Project__r.Name);   

        } 
        return closedAPT;
    }    
    
    @RemoteAction
    public static void createGalleryTask (String appointmentID) {

        system.debug('createGalleryTask + appointmentID:...' + appointmentID);   
        String varAppointmentIdTrim = appointmentID.remove(']');
        varAppointmentIdTrim = varAppointmentIdTrim.remove('[');
        system.debug('createGalleryTask + varAppointmentIdTrim:...' + varAppointmentIdTrim);   
        List <Appointment__c> listAppointment = [select ID, 
                        Name, 
                        Consultant__c,
                        Consultant__r.Name,
                        Comments__c, 
                        Daltile_Location__r.Name,
                        Status__c,  
                        Account__c,
                        Account__r.Name,
                        Project__c,
                        Project__r.Name,
                        Visitor_Type__c,
                        Visitor_Name__c,
                        Visitor_Time_In__c,
                        Visitor_Time_Out__c,
                        Prescheduled__c,
                        Appointment_Start_Time__c
                from Appointment__c 
                where ID = :varAppointmentIdTrim];
        
        Appointment__c closedAPT = new Appointment__c();
        
        for (Appointment__c app : listAppointment) {
            closedAPT = app;
        }
        
        system.debug('createGalleryTask + closedAPT:...' + closedAPT);   

        String accountName = '';
        if (closedAPT.Account__r.Name != '' && closedAPT.Account__r.Name != null) {
            accountName = 'Account: ' + closedAPT.Account__r.Name;   
        }
        String oppName = '';
        if (closedAPT.Project__r.Name != '' && closedAPT.Project__r.Name != null) {
            oppName = ' - ' + closedAPT.Project__r.Name;   
        }
        String consultantName = '';
        if (closedAPT.Consultant__r.Name != '' && closedAPT.Consultant__r.Name != null) {
            consultantName = ' was helped by ' + closedAPT.Consultant__r.Name;   
        }
        String locationName = '';
        if (closedAPT.Daltile_Location__r.Name != '' && closedAPT.Daltile_Location__r.Name != null) {
            locationName = ' at the ' + closedAPT.Daltile_Location__r.Name + ' Location.';   
        }
        
        String visitorName = closedAPT.Visitor_Name__c;
        String taskSubject = 'Gallery Visit: ' + accountName + oppName;
        String taskDesc = 'Visitor: ' + visitorName +  consultantName + locationName;

        Id galRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Gallery Task').getRecordTypeId();
        System.debug('::::createGalleryTask + galRecordTypeId: ' + galRecordTypeId);  
        List<Profile> getProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        Boolean varIsGalleryUser;
        for (Profile p : getProfile) {
            if (p.Name == 'Gallery User') {
                varIsGalleryUser = true;
            }
        }
        if (varIsGalleryUser = true) {
            List<Task> tList =  [SELECT WhatId,Description,RecordTypeId,OwnerId,ActivityDate,WhoId 
                                    FROM Task  
                                    WHERE WhatId = : closedAPT.Daltile_Location__c
                                    AND WhoId = : closedAPT.Consultant__c
                                    AND Subject = : taskSubject
                                    AND Type__c = 'Gallery Visit'
                                    AND Description__c = : taskDesc
                                    AND ActivityDate = :date.today()];
            System.debug('::::createGalleryTask + tList: ' + tList);   
    
            List <Task> insertGalleryTask = new list <Task>();
            if (tList.isEmpty()) {  
                Task gt=new Task();
                gt.WhatID=closedAPT.Id;
                gt.Appointment_Location__c=closedAPT.Daltile_Location__c;
                gt.RecordTypeId=galRecordTypeId;
                gt.Goals__c='Sample Prep';
                gt.Type__c='Gallery Visit';
                gt.Type='Meeting';
                gt.Subject = taskSubject;
                gt.Primary_Objective__c='Switched Spec';
                gt.ActivityDate=date.today();
                gt.Status='Completed';
                gt.Visitor_Type__c = closedAPT.Visitor_Type__c;
                gt.WhoId = closedAPT.Consultant__c;
                gt.Priority='Normal';
                gt.Design_Consultation__c = closedAPT.Prescheduled__c;
                gt.Description__c = taskDesc;
                gt.Description = taskDesc;
                insertGalleryTask.add(gt);

                for (Task t : insertGalleryTask) {
                    try {
                        insert t;
                    } catch (Exception e) {
                        System.debug('::::createGalleryTask + insertGalleryTask error' + e);
                    }
                }
            } else {
                for (Task gt : tList) {
                    gt.Visitor_Type__c = closedAPT.Visitor_Type__c;
                    gt.WhoId = closedAPT.Consultant__c;
                    gt.WhatID=closedAPT.Daltile_Location__c;
                    update gt;
                }
            }
        }
    }

    
}