/** /** * * * * * * * * * * * *
*  Class Name:   SearchPageController
*  Purpose:      Controller class to display contacts and accounts on matched ANI 
*                and SSC on matched VVN paramters in popup page
*  Author:       Srini Aluri
*  Updated Date: April-28-2017
*  Type:         Controller Class
** * * * * * * * * * * * */
public class SearchPageController 
{
    // list to display matched accounts on basis of ANI parameter
    public List<Account> accounts {get; private set;}
    // list to display accounts for (contact not matched and account matched with ANI)
    public List<Account> accountsMatched {get; private set;}
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

    //list to display matched contacts on basis of ANI Parameter
    public List<Contact> contacts {get; private set;}
    //list to display matched SSC object on basis of VDN parameter
    public List<SSC__c> sscObjList {get; private set;}
    
    //string variable to store the search value for account
    public String searchParam {get;set;}
    
    // boolean variable to show-hide the account search section
    public Boolean showSection {get;set;}

    //Constructor
    public SearchPageController() 
    {

        size = Integer.valueOf(Label.PageSizeCTI);
        // Contact Phone not Matched Account Phone not Matched - boolean variable to show account search section
        showSection = false;
        // method to get SSC data 
        getSSCData();
        //method to get matched Contact and related account data
        getContactAccountData();
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  getSSCData
    *  Purpose:      Method to get matched SSC record on basis of VDN parameter by comparing it with VDN__c field
    *  Author:       Srini Aluri
    *  Created Date: March-16-2017
    *  Updated Date: March-21-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public void getSSCData()
    {
      String vdnValueStr = ApexPages.currentPage().getParameters().get('VDN');
      if(String.isNotBlank(vdnValueStr))
      {
        Decimal vdnValue = Decimal.valueOf(vdnValueStr);
        sscObjList = [Select Name,VDN__c,SSC_Phone_Number__c,SSC_Extension__c FROM SSC__c where VDN__c =: vdnValue];
      }
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
    public void getContactAccountData()
    {
        showSection = false;
        String callerId = ApexPages.currentPage().getParameters().get('ANI');
        if(String.isNotBlank(callerId))
        {    
            //initialze contact and account lists
            contacts = new List<Contact>();
            accounts = new List<Account>();
            //set to store Ids of account for matched contacts
            Set<Id> accountIds = new Set<Id>();
            //fetch matched contact and account based on ANI no
            List<List<SObject>> searchList = [FIND :callerId IN PHONE FIELDS RETURNING Contact(Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone)];
            if (searchList!=null && searchList.size()>0) 
            {
                contacts = ((List<Contact>) searchList[0]);
                for(Contact contactObj : contacts)
                {    
                    // add accountIds for matched contacts to Set
                    accountIds.add(contactObj.AccountId);
                }
                //scenario 2 - Contact Phone Matched
                if(accountIds.size() > 0)
                {
                    //added two fieds DW_ID__c,Customer_Type__r.Name in query April-28-2017
                    accounts = [Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name from Account where Id IN:accountIds ];
                }
                else
                {
                    //scenario 2 - Contact Phone not Matched and Account Phone Matched
                    Set<Id> matchedAccountIds = new Set<Id>();
                    accountsMatched = new List<Account>();
                    List<List<SObject>> searchAccountList = [FIND :callerId IN PHONE FIELDS RETURNING Account(Id)];
                    if(searchAccountList != null && searchAccountList.size() > 0)
                    {
                        for(Account accountObj : ((List<Account>) searchAccountList[0]))
                        {
                            matchedAccountIds.add(accountObj.Id);
                        }
                        
                        if(matchedAccountIds.size()>0)
                        {
                            //added two fieds DW_ID__c,Customer_Type__r.Name in query April-28-2017
                           accountsMatched = [Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name,(Select Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone from Account.Contacts) from Account where Id IN:matchedAccountIds];
                        }
                        //scenarion 3 - Contact Phone not Matched Account Phone not Matched
                        else
                        {
                            showSection = true;
                        }
                    }
                }
            }
        }
    }

    // code for pagination starts by Srini Aluri on 03-31-2017
    public Integer size {get;set;} 
    public Integer noOfRecords {get; set;} 
    public integer pageNumber
    {
      get
      {
        return Setcon.getPageNumber();
      }
      set;
    }

    public Boolean hasNext 
    {
      get
      {
        return setCon.getHasNext();
      }
      set;
    }

    public Boolean hasPrevious 
    {
      get 
      {
        return setCon.getHasPrevious();
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
        String queryStr = 'Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,DW_ID__c,Customer_Type__r.Name,(Select Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone from Account.Contacts) from Account where Name LIKE :newSearchText LIMIT 9999';
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryStr));
        setCon.setPageSize(size);
        noOfRecords = setCon.getResultSize();
      }
    }

    /** * * * * * * * * * * * *
    *  Method Name:  redirectToCreateCasePage
    *  Purpose:      Method to redirect to createCase page
    *  Author:       Srini Aluri
    *  Created Date: March-16-2017
    *  Updated Date: March-21-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public PageReference redirectToCreateCasePage()
    {    
        String contactName = System.currentPageReference().getParameters().get('contactName');
        String phoneNo = ApexPages.currentPage().getParameters().get('ANI');
        String accountName = System.currentPageReference().getParameters().get('accountName');
        // added code on April-28-2017 starts
        String sscName = '';
        if(sscObjList!= null && sscObjList.size() > 0 && String.isNotBlank(sscObjList[0].Name))
        {
            sscName = sscObjList[0].Name;
        }
        // added code on April-28-2017 ends
        String URL = '/500/e?RecordType='+Label.CaseRecordTypeId+'&'+Label.SSCLookupFieldId+'='+sscName+'&'+Label.ContactLookupFieldName+'='+contactName+'&'
                     +Label.CaseFieldAccountName+'='+accountName+'&'+Label.CaseCallerIDNameAttr+'='+phoneNo;
        system.debug('URL '+URL);
        PageReference pageRef = new PageReference(URL); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  redirectToContactAndCasePage
    *  Purpose:      Method to redirect to ContactAndCaseCreate VF Page with necessary parameters
    *  Author:       Srini Aluri
    *  Created Date: March-21-2017
    *  Updated Date: March-21-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public PageReference redirectToContactAndCasePage()
    {
        String phoneNo = ApexPages.currentPage().getParameters().get('ANI');
        String vdnValueStr = ApexPages.currentPage().getParameters().get('VDN');
        String accountId = System.currentPageReference().getParameters().get('accountId');
        
        String URL = '/apex/CreateContactAndCase?ANI='+phoneNo+'&VDN='+vdnValueStr+'&accId='+accountId;
        PageReference pageRef = new PageReference(URL); 
        pageRef.setRedirect(true);
        return pageRef;
    }
}