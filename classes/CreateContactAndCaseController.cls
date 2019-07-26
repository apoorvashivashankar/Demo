/** * * * * * * * * * * * *
*  Class Name:   CreateContactAndCaseController
*  Purpose:      Controller class to create contact and case
*  Author:       Srini Aluri
*  Created Date: March-20-2017  
*  Updated Date: March-21-2017
*  Type:         Controller Class
** * * * * * * * * * * * */
public class CreateContactAndCaseController 
{   
    // contact object to store field values and insert
    public Contact contactobj {get;set;}
    // variable to store the ANI no passed in parameter
    public String phoneNo {get;set;}
    //variable to store the accountID passed in parameter
    public String accountId {get;set;}
    //variable to store the sscId passed in parameter
    public String sscId {get;set;}
    
    //Constructor
    public CreateContactAndCaseController()
    {   
        //initialize contact object
        contactobj = new Contact();
        //fetch ANI from querystring parameter
        phoneNo = ApexPages.currentPage().getParameters().get('ANI');
        if(String.isNotBlank(phoneNo))
        {
            contactobj.Phone = phoneNo;    
        }
        //fetch accountID from querystring parameter
        accountId = ApexPages.currentPage().getParameters().get('accId');
        if(String.isNotBlank(accountId))
        {
            contactobj.AccountId = accountId;    
        }
        //fetch sscID from querystring parameter
        sscId = ApexPages.currentPage().getParameters().get('sscId');
        System.debug('::::CreateContactAndCaseController + sscId:...>' + sscId);
        if(String.isNotBlank(sscId))
        {
            contactobj.Originated_from_SSC__c = sscId;    
        }
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  createCaseContact
    *  Purpose:      Method to create contact and case respectively. if error occurs then rollback entire transaction
    *  Author:       Srini Aluri
    *  Created Date: March-20-2017
    *  Updated Date: March-21-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public PageReference createCaseContact()
    {   
        System.debug('::::CreateContactAndCaseController + createCaseContact');
        String vdnValueStr = ApexPages.currentPage().getParameters().get('VDN');
        Decimal vdnVal;
        Savepoint sp;
        try
        {   
        	List<SSC__c> sscObjList;
            if(String.isNotBlank(vdnValueStr))
            {
                vdnVal = Decimal.valueOf(vdnValueStr);    
                sscObjList = [Select Name,VDN__c,SSC_Phone_Number__c,SSC_Extension__c FROM SSC__c where VDN__c =: vdnVal];
            }
            SSC__c sscObj;
            if( sscObjList != null && !sscObjList.isEmpty() ){
            	sscObj = sscObjList[0];
            }
            //set savepoint at this stage
            sp = Database.setSavepoint();
            
            // insert contact first
            insert contactobj;
            System.debug('::::CreateContactAndCaseController + createCaseContact + contactobj:...>' + contactobj);
            if(contactobj.Id != null)
            {
                // create case object and initialize it with necessary values.
                // doubt: what should be the default value for all fields used below.
                /*Case caseObj = new Case();
                caseObj.RecordTypeId = Label.CaseRecordTypeId;
                caseObj.Origin = 'Phone';
                caseObj.Status = 'InProgress';
                caseObj.ContactId = contactobj.Id;
                caseObj.SSC__c = sscObj.Id;
                caseObj.AccountId = accountId;
                // setting this value as there is validation rule written for this field to be required
                caseObj.Type = 'Place Order'; 
                insert caseObj;
                
                if(caseObj.Id != null)
                {
                    
                }
                */
                
                Account accountObj = [Select Name from Account where Id =: accountId];
                
                //set value for contact lookup to be populated on case create page
                    String contactValue = contactobj.LastName;
                if(String.isNotBlank(contactobj.FirstName))
                {
                    contactValue +=contactobj.FirstName;
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Contact created Successfully.'));
                String URL = '/500/e?RecordType='+Label.CaseRecordTypeId+'&'+Label.CaseFieldAccountName+'='+accountObj.ID+'&' + Label.ContactLookupFieldName+ '=' +contactobj.Id+'&'+Label.CaseCallerIDNameAttr+'='+phoneNo;
                System.debug('::::CreateContactAndCaseController + createCaseContact + URL 1:...>' + URL);
				if( sscObj != null ){
					URL += '&'+Label.SSCLookupFieldId+'='+sscObj.Id + '&' + Label.SSCLookupFieldText + '=' + sscObj.Name;
				}                             
                System.debug('::::CreateContactAndCaseController + createCaseContact + URL 2:...>' + URL);
                system.debug('URL '+URL);
                PageReference pageRef = new PageReference(URL); 
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        catch(Exception ex)
        {   
            //if any error occurs then rollback entire transaction 
            Database.rollback(sp);
            //display error caused on VF page
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+ex.getMessage()));
        }
        return null;
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  redirect
    *  Purpose:      Method to redirect back to CustomPopup VF page(CustomScreenPopup.vfp)
    *  Author:       Srini Aluri
    *  Created Date: March-21-2017
    *  Updated Date: March-21-2017
    *  Type:         Method
    ** * * * * * * * * * * * */
    public Pagereference redirect()
    {   
        String vdnValueStr = ApexPages.currentPage().getParameters().get('VDN');
        String URL = '/apex/CustomScreenpopup?ANI='+phoneNo+'&VDN='+vdnValueStr;
        PageReference pageRef = new PageReference(URL); 
        pageRef.setRedirect(true);
        return pageRef;
    }
}