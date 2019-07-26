public with sharing class VisitorCheckinController {

    // the soql without the order and limit
    public String welcomePhoneNumber {get;set;}
    // the collection of contacts to display
    public List<Contact> contacts {get;set;}
    public List<Lead> leads {get;set;}
    public List<Appointment__c> appointments {get;set;}
    public List <sObject> listPossibleVisitors {get;set;}
    public String galleryAccountId  {get;set;}
    public String galleryAccountName  {get;set;}
    public String verbiageCreateUpdate  {get;set;}
    public String verbiageVisitorCheckedIn  {get;set;}
    public String pageName {get;set;}    
    public String myGalleryName {get;set;}    
    public Account galleryAccount {get;set;}
    public Account visitorAccount {get;set;}
    public Contact visitorContact {get;set;}
    public List<contact> selectcon;
    public List<Lead> selectLead;
    private final Lead visitorLead;
    public Lead newLead;
    public Appointment__c appointment;
    private User galleryUser {get;set;}
    transient public String firstName = null;
    transient public String lastName = null;
    transient public String email = null;
    transient public String phone = null; 
    transient public String galleryContact = null;
    transient public String visitorType = null;   
    static PageReference visitorCreated;
    static PageReference confirmPage; 
    static PageReference appointmentPage;
    static PageReference backToCheckin;
    private static final String selCons = 'Select A Consultant';

	public Appointment__c getAppointment() {
	    if(appointment == null) {
	        appointment = new Appointment__c();
	        appointment.Visitor_Phone_Number__c =  welcomePhoneNumber;
	    }
	  return appointment;
	}

	public VisitorCheckinController () {

        System.debug('::::VisitorCheckinController + appointment : ::::> ' + appointment);
    
	    list <User_to_Location__c> galleryUserLocation = [
	        SELECT Account__c,Account__r.Name,Id,User__c,Default_Location__c 
	        FROM User_to_Location__c 
	        WHERE User__c = : UserInfo.getUserId()
	        ];
	        
	    Boolean hasDefault = false;
	       
	    for (User_to_Location__c l : galleryUserLocation) {
		    if (l.Default_Location__c == TRUE) {
			    hasDefault = true;
		    }
	    }

	    if ( hasDefault == true) {
	        for (User_to_Location__c l : galleryUserLocation) {
				if (l.Default_Location__c == TRUE) {
					galleryAccountId = l.Account__c;
					galleryAccountName = l.Account__r.Name;   
				} 
	        }            
	    } else {
	        for (User_to_Location__c l : galleryUserLocation) {
	            galleryAccountId = l.Account__c;
	            galleryAccountName = l.Account__r.Name;                   
	        }
	    }
	    myGalleryName = galleryAccountName;
	}

    // Gallery Setup
    // Gets list of possible contacts from the logged in users Gallery, and builds into a dropdown list
    // Then gets list of possible visitor types, and builds into a dropdown list
    
    public List<SelectOption> getGalleryContacts() {
        LIST <SelectOption> galCntList = new LIST <SelectOption>();
        galCntList.add(new SelectOption('', selCons));
        if (myGalleryName != '') {
            List<Account> myGalleryAccount = [Select ID From Account Where Name = :myGalleryName];
            if (myGalleryAccount != NULL){
                for (Account a:myGalleryAccount){
                    appointment.Daltile_Location__c = a.ID;       
                    List <Contact> galCnt = [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE AccountId = :a.id];
                    System.debug('::::CPQNewSampleExtension + galCntList : ::::> ' + galCnt);
                    for (Contact c : galCnt){
                        galCntList.add(new SelectOption(c.Id, c.Name));
                    }
                }   
            }
        } else {
            galCntList.add(new SelectOption('', 'Please Setup a Gallery'));
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
        
        LIST <SelectOption> listVisitorTypes = new LIST <SelectOption>();
        listVisitorTypes.add(new SelectOption('', selCons));  
        List <Visitor_Type__c> galCnt = [SELECT Id,NAME FROM Visitor_Type__c];
        for (Visitor_Type__c c : galCnt){
            listVisitorTypes.add(new SelectOption(c.Id, c.Name));
        }
        return listVisitorTypes;
    }
    
    public String getVisitorType() {
        return visitorType;
    }

    public void setVisitorType(String visitorType) { 
        this.visitorType = visitorType; 
    }

    // Searching for the visitor by phone number
    // Looks through contacts and leads for possible record
    // If none are found it gets information to create a Lead
    // If only one record is found it uses it 
    // If multiple are found there is a search results screen to confirm
    // After recird selected / data entered for new lead, records are created / updated
    // Last, if appointment scheduled there is a conifirmation screen with links to either the list view , the appointment , or the screen to log a new
    // If it was logged in via kiosk, it refreshes back to the kios page

    
    public PageReference checkin() { 
        String pageName = ApexPages.currentPage().getParameters().get('currentvfpage');
//        system.debug('-----current page name----'+pageName);
        IF (appointment.Visitor_Phone_Number__c != '' && appointment.Visitor_Phone_Number__c != null) {
            if (pageName.toLowerCase().contains('visitorcheckin')) {
                appointment.Self_Check_In__c = true;
            }
             // remove all non numeric
	        string nondigits = '[^0-9]';
	        string PhoneDigits;                
            PhoneDigits = '%'+appointment.Visitor_Phone_Number__c.replaceAll(nondigits,'')+'%';
            if (PhoneDigits.length() != 12) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a 10 digit phone number'));
            } else {
    			findCurrentVisitor(PhoneDigits);      
            }
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a phone number'));
        }
        system.debug('-----verbiageVisitorCheckedIn----' + verbiageVisitorCheckedIn);
        return confirmPage;
    }       
    
	public void findCurrentVisitor(String PhoneDigits) {   
	    pageName = ApexPages.currentPage().getUrl().substringAfter('apex/');
	    System.debug('::::findCurrentVisitor + PhoneDigits ' + PhoneDigits);
	    findCurrentAppointment(PhoneDigits);
	    if (appointments.isEmpty() || appointments == null) {
		    combineDateTime(appointment.Appointment_Date__c, appointment.Appointment_TimeOnly__c);
	    	getPossibleVisitors();
	    	if (!leads.isEmpty() || !contacts.isEmpty()) {
	    		if ((leads.size() > 1) || (contacts.size() > 1) || (leads.size() == 1 && contacts.size() >= 1) || (leads.size() >= 1 && contacts.size() == 1) ) {  
    				confirmPage = Page.VisitorSearch;     
				} else {
				    saveInfo();
		        } 
    		} else {
    			if (appointment.Self_Check_In__c == true) {
    				confirmPage = Page.VisitorCheckinCreate;
    			} else {
    				confirmPage = Page.AppointmentSchedulerConfirm;
    			}		
    		}
    		if (appointment.Visitor_Last_Name__c != '' && appointment.Visitor_Last_Name__c != NULL) {
    			verbiageCreateUpdate = 'Confirm Your Information';
    		} else {
    			verbiageCreateUpdate = 'Enter Your Information';
    		}	
    	}
	}

    public void findCurrentAppointment (String PhoneDigits) {
        
		system.debug('-----findCurrentAppointment + appointment.Visitor_First_Name__c:...'+appointment.Visitor_First_Name__c);
		system.debug('-----findCurrentAppointment + appointment.Visitor_Last_Name__c:...'+appointment.Visitor_Last_Name__c);
		system.debug('-----findCurrentAppointment + appointment.Visitor_Phone_Number__c:...'+appointment.Visitor_Phone_Number__c);
		DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

        appointments = [SELECT
                    NAME 
                    , ID
                    , Daltile_Location__c
                    , Visitor_Name__c
                    , Visitor_First_Name__c
                    , Visitor_Last_Name__c
                    , Visitor_Phone_Number__c 
                    , Phone_Lookup__c
                    , Prescheduled__c
                    , Status__c
                    , Visitor_Time_In__c
                    , Appointment_Date__c
                FROM Appointment__c
                // WHERE Daltile_Location__c = :galleryAccount.Id 
                WHERE Visitor_Phone_Number__c LIKE :appointment.Visitor_Phone_Number__c
                AND Visitor_First_Name__c = :appointment.Visitor_First_Name__c
                AND Visitor_Last_Name__c = :appointment.Visitor_Last_Name__c
                ORDER BY Visitor_Time_In__c DESC
                limit 1
                ];        

    		system.debug('-----findCurrentAppointment + appointments:...'+appointments);
			
            if (appointments != null && !appointments.isEmpty()) {
                for (Appointment__c a:appointments) {
                    if (a.Appointment_Date__c == Date.Today() || a.Visitor_Time_In__c.date() == Date.Today() ) {
                        appointment = a;
                        appointment.Visitor_Time_In__c = DateTime.Now();
                        appointment.Status__c = 'Checked In';
                    }
                    // update a;
                }
			system.debug('-----findCurrentAppointment + appointment:...'+appointment);
            } 
    }

	public List<sObject> getPossibleVisitors() {
        System.debug('::::getPossibleVisitors + welcomePhoneNumber::::> ' + welcomePhoneNumber);   
        string nondigits = '[^0-9]';
        string PhoneDigits;  
        if (welcomePhoneNumber == null) {
            PhoneDigits = '%'+appointment.Visitor_Phone_Number__c.replaceAll(nondigits,'')+'%';            
        } else {
            PhoneDigits = '%'+welcomePhoneNumber.replaceAll(nondigits,'')+'%';
        }
        String searchQuery = 'FIND \'' + PhoneDigits + '\' IN ALL FIELDS RETURNING  Lead (FirstName,LastName,email,Company,Phone,Phone_Lookup__c,IsConverted,Visitor_Type__c,ConvertedAccountId,ConvertedContactId,ConvertedDate,ConvertedOpportunityId),Contact(FirstName,LastName,email,accountId,Phone,MobilePhone,Phone_Lookup__c,Mobile_Lookup__c,Id )';
        List<List <sObject>> searchList = search.query(searchQuery);
        System.debug('::::getPossibleVisitors + searchList : ::::> ' + searchList);        
        leads = ((List<Lead>)searchList[0]);
        contacts  = ((List<Contact>)searchList[1]);
        System.debug('::::getPossibleVisitors + leads : ::::> ' + leads);        
        System.debug('::::getPossibleVisitors + contacts : ::::> ' + contacts);         
        LIST<sObject> listPossibleVisitors = new LIST<sObject>();
        listPossibleVisitors.addAll((List<sObject>)leads);
        listPossibleVisitors.addAll((List<sObject>)contacts);
        System.debug('::::getPossibleVisitors + listPossibleVisitors : ::::> ' + listPossibleVisitors);   
		return listPossibleVisitors;
	}

    // Saves visitor to the Appointment when creating a new Lead
    
    public PageReference saveInfo() { 
        system.debug('-----current appointment saving----' + appointment);
        
	    if (leads.size() == 1 || contacts.size() == 1) {
		    if (!contacts.isEmpty()) {
		        for (Contact c:contacts) {
					appointment.Visitor_First_Name__c = c.FirstName;
					appointment.Visitor_Last_Name__c = c.LastName;
					appointment.Visitor_Email__c = c.Email;
					appointment.Account__c = c.accountid;
					appointment.Contact__c = c.id;
		        }
		    } else {
                if (!leads.isEmpty()) {
			        for (Lead l:leads) {
						appointment.Visitor_First_Name__c = l.FirstName;
						appointment.Visitor_Last_Name__c = l.LastName;
						appointment.Visitor_Email__c = l.Email;
			        }
                }
		    }
	    }
		if (appointment.Self_Check_In__c == true) {
			confirmPage = Page.VisitorCheckinCreate;
		} else {
			confirmPage = Page.AppointmentSchedulerConfirm;
		}	        
        
        //Querying for Lead Record Type Details.
	    findCurrentAppointment(appointment.Visitor_Phone_Number__c);
        if (appointment.Visitor__c == NULL) {
            if (appointment.Contact__c == NULL) {
                Lead visitorLead = new Lead();
                List<RecordType> leadRTList = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Lead' AND Name = 'Gallery Lead'];
                if(leadRTList != null){
                    for(RecordType rt:leadRTList){
                        if(rt.Name == 'Gallery Lead'){
                            visitorLead.RecordTypeId = rt.Id;
                        }
                    }
                }
                visitorLead.Company = 'Unknown';
                visitorLead.Status = 'Open';
                visitorLead.phone = appointment.Visitor_Phone_Number__c;
                visitorLead.FirstName = appointment.Visitor_First_Name__c;
                visitorLead.LastName = appointment.Visitor_Last_Name__c;
                visitorLead.Email = appointment.Visitor_Email__c;
                visitorLead.Visitor_Type__c = 'Appointment';
                insert visitorLead;
                
                appointment.Visitor__c = visitorLead.Id;
            }
        }        

        appointment.Daltile_Location__c = galleryAccountId;    

        String myID;
        String pageName = ApexPages.currentPage().getUrl().substringAfter('apex/');
                
        if (appointment.Prescheduled__c != TRUE) {
            appointment.Visitor_Time_In__c = DateTime.now();
            appointment.Status__c = 'Checked In';
        } else {
            appointment.Prescheduled__c = TRUE;
            appointment.Status__c = 'Scheduled';
        }

        if (appointment.id == null){
            try {
                insert appointment;
            } catch (Exception e) { 
                // some debug 
            }
        } else {
            update appointment;
        }
        if (pageName.contains('visitorcheckincreate')) {
            visitorCreated = Page.VisitorCheckedIn;
        } else {
            visitorCreated = Page.AppointmentScheduled;
        }
        
        return visitorCreated;
    }   
    
    // Here we get the contact / lead selected from the Visitor Search and select it for the Appointment
    
    public PageReference selectVisitor() {
        String selcontactid = System.currentPagereference().getParameters().get('conid');
        id selectId = System.currentPagereference().getParameters().get('conid');
        System.debug('object is '+ selectId.getsobjecttype());
        String selectedObject = '' + selectId.getsobjecttype();
        if (selectedObject == 'Contact') {
            List <Contact> listCon =  new List<contact>(); 
            selectcon =  new List<contact>();
            listCon = [Select FirstName, 
                                        LastName, 
                                        email, 
                                        accountId, 
                                        Phone,
                                        MobilePhone,
                                        Phone_Lookup__c,
                                        Mobile_Lookup__c,
                                        Account.Name,
                                        Id 
                                    FROM Contact 
                                    where Id=:selcontactid];
            for (Contact c: listCon) {
                selectcon.add(c);
            }            
            if (selectcon != null && selectcon.size() == 1) {
                for (Contact c:selectcon) {
                    System.debug('::::VisitorCheckinController + checkin + found 1 existing contact ...' + c);
                    appointment.Visitor_First_Name__c = c.FirstName;
                    appointment.Visitor_Last_Name__c = c.LastName;
                    appointment.Visitor_Email__c = c.Email;
                    appointment.Account__c = c.accountid;
                    appointment.Contact__c = c.id;
    
                }
            }            
        } else if (selectedObject == 'Lead') {
            List <Lead> listLead =  new List<Lead>(); 
            selectLead =  new List<Lead>();
            listLead = [Select FirstName, 
                                LastName, 
                                email, 
                                Phone,
                                MobilePhone,
                                Phone_Lookup__c,
                                Id 
                            FROM Lead 
                            where Id=:selectId
                            AND IsConverted = false];
            for (Lead c: listLead) {
                selectLead.add(c);
            }            
            if (selectLead.size() == 1) {
                for (Lead c:selectLead) {
                    System.debug('::::VisitorCheckinController + checkin + found 1 existing lead  ...' + c);
                    appointment.Visitor_First_Name__c = c.FirstName;
                    appointment.Visitor_Last_Name__c = c.LastName;
                    appointment.Visitor_Email__c = c.Email;
                    appointment.Visitor__c = c.id;
                }
            }             
        }

        verbiageVisitorCheckedIn = 'Thanks ' + appointment.Visitor_First_Name__c + ' for checking in!';
        if (appointment.Prescheduled__c != TRUE) {
            appointment.Visitor_Time_In__c = DateTime.now();
            appointment.Status__c = 'Checked In';
        } else {
            appointment.Prescheduled__c = TRUE;
            appointment.Status__c = 'Scheduled';
        }
        appointment.Daltile_Location__c = galleryAccountId;    

        if (appointment.id == null){
            insert appointment;
        } else {
            update appointment;
        }

    	if (appointment.Self_Check_In__c == true) {
			confirmPage = Page.VisitorCheckedIn;
		} else {
			confirmPage = Page.AppointmentScheduled;
		}		

        return confirmPage;   
    }       

	public void combineDateTime(Date dateOnly, String timeOnly){
		if (dateOnly != null && timeOnly != '') {
			Integer d = dateOnly.day();
			Integer mo = dateOnly.month();
			Integer yr = dateOnly.year();			
			String appointmentTime = timeOnly ;
			system.debug('-----checkin + appointmentTime:...'+appointmentTime);
			String hh = appointmentTime.substring(0,2);
			String mm = appointmentTime.mid(3,2);
			integer hr =  integer.valueof(hh);
			integer min = integer.valueof(mm);
			system.debug('-----checkin + hr:...'+hr);
			system.debug('-----checkin + min:...'+min);
			String meridiem = appointmentTime.mid(5,2);
			system.debug('-----checkin + meridiem:...'+meridiem);
			
			if (meridiem == 'PM') {
				hr = hr + 12;
				system.debug('-----checkin + PM hr:...'+hr);
			}

			DateTime appointmentDateTime = DateTime.newInstance(yr, mo, d, hr, min, 00);
			system.debug('-----checkin + appointmentDateTime:...'+appointmentDateTime);			
			appointment.Appointment_Time__c = appointmentDateTime;
		}		
	}

    // Navigation

    public PageReference cancel() { 
        PageReference backToCheckin = new PageReference('/apex/VisitorCheckIn');
        backToCheckin.setRedirect(true);
        system.debug('saving and should redirect to CPQ...' + backToCheckin);   
        return backToCheckin;
    }   
    
    public PageReference cancelToAppointments() { 
        Schema.DescribeSObjectResult anySObjectSchema = Appointment__c.SObjectType.getDescribe();
        String objectIdPrefix = anySObjectSchema.getKeyPrefix();
        visitorCreated = new PageReference('/'+objectIdPrefix+'?fcf=00B29000000W3P8EAK');
        visitorCreated.setRedirect(true);
        return visitorCreated;
    }     
    
    public PageReference goCreateContact() {
        confirmPage = Page.AppointmentSchedulerConfirm;
        return confirmPage;   
    }    
    
    public PageReference goCreateVisitorContact() {
        confirmPage = Page.VisitorCheckinCreate;
        return confirmPage;   
    }      
    
    public PageReference backWaitlist() {
        confirmPage = Page.AppointmentWaitlist;
        return confirmPage;   
    }  
    
    public PageReference backToScheduler() {
        confirmPage = Page.AppointmentScheduler;
        appointment = null;
        confirmPage.setRedirect(true);
        return confirmPage;   
    }      

    public PageReference backToSchedulerMobile() {
        confirmPage = Page.AppointmentSchedulerMobile;
        appointment = null;
        confirmPage.setRedirect(true);
        return confirmPage;   
    }     

    public PageReference backToCheckIn() {
        PageReference backToCheckin = Page.VisitorCheckIn;
        backToCheckin.setRedirect(true);
        return backToCheckin;   
    }

    
    public PageReference goToAppointment() {
        PageReference appointmentPage = new PageReference('/' + appointment.Id);
        return appointmentPage;   
    }        

}