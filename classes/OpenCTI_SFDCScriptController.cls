/** /** * * * * * * * * * * * *
*  Class Name:   OpenCTI_SFDCScriptController
*  Purpose:      Controller class to display contacts and accounts on matched ANI 
*                and SSC on matched VVN paramters in popup page
*  Author:       Srini Aluri
*  Updated Date: April-28-2017
*  Type:         Controller Class
** * * * * * * * * * * * */
global without sharing class OpenCTI_SFDCScriptController 
{
    
    global class ContactAccountLookupResult {
        public List<Contact> contacts {get;set;}
        public List<Account> accounts {get;set;}
        public List<Account> accountsMatched {get;set;} 
        
        // boolean variable to show-hide the account search section
        // Contact Phone not Matched Account Phone not Matched - boolean variable to show account search section
        public Boolean showSection {get;set;}
        
        public ContactAccountLookupResult(){
             contacts = new List<Contact>();
             accounts = new List<Account>();
             accountsMatched = new List<Account>();
             showSection = false;
        }
    }
        
    //list to display searched accounts(Contact Phone not Matched Account Phone not Matched)
    public List<Account> searchedAccounts
    {
      get
      {
        if(setCon != null)
        {
          return (List<Account>)setCon.getRecords();
        }
        else
        {
          return null ;
        }
      }
      private set;
    }

    //string variable to store the search value for account
    public String searchParam {get;set;}
    
    public String sscName {get;set;}
    public String VDN {get;set;}
    public String DNIS {get;set;}
    public String ANI {get;set;}
    public Case theCase {get;set;}
    public Contact theContact {get;set;}
    public Id varSupportCasesRecordType {get;set;}
    
    //Constructor
    public OpenCTI_SFDCScriptController()
    {
        // read VDN from the URL parameters
        VDN = ApexPages.currentPage().getParameters().get('VDN');
        VDN = (String.isBlank(VDN))?'':VDN;
        
        // read DNIS from the URL parameters
        DNIS = ApexPages.currentPage().getParameters().get('DNIS');
        DNIS = (String.isBlank(DNIS))?'':DNIS;
        
        // read ANI from the URL parameters
        ANI = ApexPages.currentPage().getParameters().get('ANI');
        ANI = (String.isBlank(ANI))?'':ANI;        

        varSupportCasesRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SSC_Call_Center').getRecordTypeId(); 
        
        Case theCase = new Case (
          RecordTypeID = varSupportCasesRecordType,
          Status = 'Closed' 
        );
        
        Contact theContact = new Contact ();
                
        size = Integer.valueOf(Label.PageSizeCTI);
        noOfRecords = 0;
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  getSSCData
    *  Purpose:      Method to get matched SSC record on basis of VDN parameter by comparing it with VDN__c field
    *  Author:       Srini Aluri
    *  Modified By:  Magdiel Herrera - June-08-2017 - converted to async call to support more than 1K records and front end features
    *  Created Date: March-16-2017
    *  Updated Date: June-08-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    @RemoteAction
    global static List<SSC__c> getSSCData(String vdnValueStr)
    {
      List<SSC__c> resL = new List<SSC__c>();
      if(!String.isBlank(vdnValueStr)) {
        Decimal vdnValue = Decimal.valueOf(vdnValueStr);
        resL = [Select Name,VDN__c,SSC_Phone_Number__c,SSC_Extension__c,Id FROM SSC__c where VDN__c =: vdnValue limit 10000]; 
      }
      return resL;
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  getUpdatedContactAccountData
    *  Purpose:      Method to get matched Contact records and related account records 
    *                on basis of ANI parameter
    *  Author:       Jon Rust
    *  Created Date: May-09-2019
    *  Updated Date: May-09-2019
    *  Type:         Method
    ** * * * * * * * * * * * */
    @RemoteAction
    global static ContactAccountLookupResult getUpdatedContactAccountData(String ANI)
    {
      UserContactDefaults__c defaultAccount = UserContactDefaults__c.getOrgDefaults();
      ID varDefaultCSCAccountId = defaultAccount.Default_CSC_Account_Id__c;   
      ContactAccountLookupResult res = new ContactAccountLookupResult();
      if( !String.isBlank(ANI) ){
        //set to store Ids of account for matched contacts
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        //fetch matched contact and account based on ANI
        List<List<SObject>> searchList = [FIND :ANI IN ALL FIELDS RETURNING Contact(Id, Name,LastName,FirstName,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone), Account(Id,Name,Phone,ShippingCity,ShippingState,ShippingStreet,ShippingCountry,ShippingPostalCode,DW_ID__c,Customer_Type__r.Name)];
        System.debug('::::OpenCTI_SFDCScriptController + ContactAccountLookupResult + searchList: ' + searchList);  
        System.debug('::::OpenCTI_SFDCScriptController + ContactAccountLookupResult + searchList.size(): ' + searchList.size());  
        if (searchList!=null && searchList.size()>0) {
          Contact[] searchContacts = (Contact[])searchList[0];
          Account[] searchAccounts = (Account[])searchList[1];
          System.debug('Found the following contacts.');
          
          for (Contact c : searchContacts) {
            System.debug(c.LastName + ', ' + c.FirstName);
            contactIds.add(c.Id);
            if (c.AccountId != varDefaultCSCAccountId) {
              accountIds.add(c.AccountId);
            }
          }			

          System.debug('Found the following accounts.');
          for (Account a : searchAccounts) {
            accountIds.add(a.Id);
            System.debug(a.Name);
          }
          
          res.contacts = [SELECT Id, Name,LastName,FirstName,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone,Company_Name__c,Actual_Account_Name__c,Owner.Name FROM Contact WHERE ID IN : contactIds OR AccountId IN : accountIds];
          res.accounts = [SELECT Id,Name,Phone,ShippingCity,ShippingState,ShippingStreet,ShippingCountry,ShippingPostalCode,DW_ID__c,Customer_Type__r.Name,Account.Owner.Name, SSC__r.Name FROM Account WHERE ID IN : accountIds];
          
          if(res.accounts.size()<1 && res.contacts.size()<1) {
              res.showSection = true;
          } 
        }
      }
		  System.debug('::::OpenCTI_SFDCScriptController + ContactAccountLookupResult + res: ' + res);  
      return res;
    }


    /** * * * * * * * * * * * *
    *  Method Name:  getContactAccountData
    *  Purpose:      Method to get matched Contact records and related account records 
    *                on basis of ANI parameter
    *  Author:       Srini Aluri
    *  Created Date: March-16-2017
    *  Updated Date: April-28-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    @RemoteAction
    global static ContactAccountLookupResult getContactAccountData(String ANI)
    {
        ContactAccountLookupResult res = new ContactAccountLookupResult();
        if( !String.isBlank(ANI) )
        {
            //set to store Ids of account for matched contacts
            Set<Id> accountIds = new Set<Id>();
            //fetch matched contact and account based on ANI
            List<List<SObject>> searchList = [FIND :ANI IN PHONE FIELDS RETURNING Contact(Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone)];
            if (searchList!=null && searchList.size()>0) 
            {
                for(sObject contactObj : searchList[0])
                {
                    Contact c = (Contact)contactObj;
                    res.contacts.add(c);
                    // add accountIds for matched contacts to Set
                    accountIds.add(c.AccountId);
                }
                //scenario 2 - Contact Phone Matched
                if(accountIds.size() > 0)
                {
                    //added two fieds DW_ID__c,Customer_Type__r.Name in query April-28-2017
                    res.accounts = [Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name from Account where Id IN:accountIds ];
                }
                else
                {
                    //scenario 2 - Contact Phone not Matched and Account Phone Matched
                    Set<Id> matchedAccountIds = new Set<Id>();
                    res.accountsMatched = new List<Account>();
                    List<List<SObject>> searchAccountList = [FIND :ANI IN PHONE FIELDS RETURNING Account(Id)];
                    if(searchAccountList != null && searchAccountList.size() > 0)
                    {
                        for(Account accountObj : ((List<Account>) searchAccountList[0]))
                        {
                            matchedAccountIds.add(accountObj.Id);
                        }
                        
                        if(matchedAccountIds.size()>0)
                        {
                            //added two fieds DW_ID__c,Customer_Type__r.Name in query April-28-2017
                           res.accountsMatched = [Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name,(Select Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone from Account.Contacts) from Account where Id IN:matchedAccountIds];
                        }
                        //scenarion 3 - Contact Phone not Matched Account Phone not Matched
                        else
                        {
                            res.showSection = true;
                        }
                    }
                }
            }
        }
				if(res.accounts.size()<1 && res.contacts.size()<1) {
				   res.showSection = true;
				}         
        return res;
    }
    
    // code for pagination starts by Srini Aluri on 03-31-2017
    public Integer size {get;set;} 
    public Integer noOfRecords {get; set;} 
    public integer pageNumber
    {
      get
      {
        if( Setcon != null )
            return Setcon.getPageNumber();
        return 0;   
      }
      set;
    }

    public Boolean hasNext 
    {
      get
      {
        if( setCon != null )
            return setCon.getHasNext();
        return false;   
      }
      set;
    }

    public Boolean hasPrevious 
    {
      get 
      {
        if( setCon != null)
            return setCon.getHasPrevious();
        return false;   
      }
      set;
    }

    public void first()
    {
      setCon.first();
    }

    public void last() 
    {
      setCon.last();
    }

    public void previous() 
    {
      setCon.previous();
    }

    public void next() 
    { 
      this.setCon.next();
    }
    
    public ApexPages.StandardSetController setCon 
    {
      get;
      set;
    }
    // code for pagination ends by Srini Aluri on 03-31-2017
    
    /** * * * * * * * * * * * *
    *  Method Name:  searchAccountContacts
    *  Purpose:      Method to search Accounts and related contacts for Contact Phone not Matched Account Phone not Matched scenario
    *  Author:       Srini Aluri
    *  Created Date: March-21-2017
    *  Updated Date: April-28-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public void searchAccountContacts()
    {
      searchedAccounts = new List<Account>();
      
      setCon = null;
      if(String.isBlank(searchParam))
      { 
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter search text.'));
        return;
      }
      if(setCon == null && String.isNotBlank(searchParam))
      {
        String newSearchText = '%'+searchParam+'%';
        //added two fieds DW_ID__c,Customer_Type__r.Name in query April-28-2017  
        String queryStr = 'Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name,(Select Id,FirstName, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone from Account.Contacts limit 100) from Account where Name LIKE :newSearchText LIMIT 50';
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        setCon.setPageSize(size);
        noOfRecords = setCon.getResultSize();
      }
    }
}