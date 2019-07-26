global with sharing class GalleryKioskController {

    public String galleryAccountId  {get;set;}
    public String galleryAccountName  {get;set;}
    public String myGalleryName {get;set;}    
    public Datetime timeCheckIn {get;set;}
	public String galleryCity {get;set;}    
	public String galleryState {get;set;}    
    public Account galleryAccount {get;set;}
    public String galleryContact  {get;set;}
    public String galleryLeadRT {get;set;}
    public Lead galleryLead {get;set;}
    public Appointment__c appointment {get;set;}
    private static final String selCons = 'Select A Consultant';
    static PageReference confirmPage; 

	public GalleryKioskController () {
    
    galleryLead = new Lead();
    appointment = new Appointment__c();
    
	    list <User_to_Location__c> galleryUserLocation = [
            SELECT Account__c
            	,Account__r.Name
            	,Account__r.SSC__r.City__c
            	,Account__r.SSC__r.State__c
            	,Id
            	,User__c
            	,Default_Location__c
            FROM User_to_Location__c
            WHERE User__c = :UserInfo.getUserId()
            ORDER BY Default_Location__c desc
	        ];

        List<RecordType> leadRTList = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Lead' AND Name = 'Gallery Lead'];
        
        if(leadRTList != null){
            for(RecordType rt:leadRTList){
                if(rt.Name == 'Gallery Lead'){
                    galleryLeadRT = rt.Id;
                }
            }
        }
	       
	    for (User_to_Location__c l : galleryUserLocation) {
			galleryAccountId = l.Account__c;
			galleryAccountName = l.Account__r.Name; 
			galleryState = l.Account__r.SSC__r.State__c; 
			galleryCity = l.Account__r.SSC__r.City__c;   
	    }

	    myGalleryName = galleryAccountName;
	    timeCheckIn = DateTime.Now();
	}
	
    public List<SelectOption> getGalleryContacts() {
        LIST <SelectOption> galCntList = new LIST <SelectOption>();
        galCntList.add(new SelectOption('', selCons));
        if (myGalleryName != '') {
            List<Account> myGalleryAccount = [Select ID From Account Where Name = :myGalleryName];
            if (myGalleryAccount != NULL){
                for (Account a:myGalleryAccount){
                    List <Contact> galCnt = [
                        SELECT Id
                            ,NAME
                            ,FirstName
                            ,LastName
                            ,Email
                            ,AccountId
                        FROM Contact
                        WHERE AccountId = :a.id];
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
        return galleryContact;
    }

    public void setGalleryContact(String galleryContact) { 
        this.galleryContact = galleryContact; 
    }
	
    public PageReference backWaitlist() {
        confirmPage = Page.AppointmentWaitlist;
        return confirmPage;   
    }  
    
    public PageReference backToScheduler() {
        confirmPage = Page.AppointmentScheduler;
        confirmPage.setRedirect(true);
        return confirmPage;   
    }      

    public PageReference backToCheckIn() {
        PageReference backToCheckin = Page.VisitorCheckIn;
        return backToCheckin;   
    }}