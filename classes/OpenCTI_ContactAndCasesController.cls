/** /** * * * * * * * * * * * *
*  Class Name:   OpenCTI_ContactAndCasesController
*  Purpose:      Controller class to display contacts and cases on matched ANI
*                and SSC on matched VVN paramters in popup page
*  Author:       Md Yaqub
*  Updated Date: Dec-12-2018
*  Type:         Controller Class
** * * * * * * * * * * * */
global without sharing class OpenCTI_ContactAndCasesController {
    public List<Contact> contactslist { get; set; }
    public List<Contact> contactslistother { get; set; }
    /*public List<account> accountlist { get; set; }*/
    public List<Contactdetailswrapper> allWrapGlobal { get; set; }
    public List<Contactdetailswrapper> allWrapGlobalsorted { get; set; }
    public List<case> caseslist { get; set; }
    public boolean noServiceCon { get; set; }
    public boolean noCon { get; set; }
    
    static final String CSR_CASE_RECORD_TYPE = 'CSR_Case';
    static final String CSR_DISCONNECTED_RECORD_TYPE = 'Disconnected_Call';
    
    /*public String sscName { get; set; }*/
    public String csrDisconnectRecID { get; set; }
    /*public String VDN { get; set; }*/
    public String DNIS { get; set; }
    public String ANI { get; set; }
    public OpenCTI_ContactAndCasesController() {
        contactslist = new list<contact>();
        contactslistother = new list<contact>();
        noServiceCon = false;
        noCon = false;
        allWrapGlobalsorted = new List<Contactdetailswrapper>();
        caseslist = new list<case>();
        // read VDN from the URL parameters
        // VDN = ApexPages.currentPage().getParameters().get('VDN');
        //VDN = (String.isBlank(VDN)) ? '' : VDN;
        
        // read DNIS from the URL parameters
        DNIS = ApexPages.currentPage().getParameters().get('DNIS');
        DNIS = (String.isBlank(DNIS)) ? '' : DNIS;
        
        // read ANI from the URL parameters
        ANI = ApexPages.currentPage().getParameters().get('ANI');
        ANI = (String.isBlank(ANI)) ? '' : ANI;
        
        csrDisconnectRecID = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get(CSR_DISCONNECTED_RECORD_TYPE).getRecordTypeId();
        getContactAccountData(formatphonenum(ANI));
    }
    /** * * * * * * * * * * * *
*  Method Name:  getContactAccountData
*  Purpose:      Method to get matched Contact records and related account records 
*                on basis of ANI parameter
*  Author:       Md Yaqub
*
*  Type:         Method
** * * * * * * * * * * * */
    
    public void getContactAccountData(String ANI) {
        if (!String.isBlank(ANI)) {
            //set to store Ids for cases
            Set<id> contactIds = new Set<id>();
            //fetch matched contact and case based on ANI
            
            List<List<SObject>> searchList = [FIND :ANI IN PHONE FIELDS RETURNING Contact(Id, Name, Email, Phone, Account.Name, AccountId, MobilePhone, OtherPhone)];
            
            if (searchList != null && searchList.size() > 0) {
                for (sObject contactObj : searchList[0]) {
                    Contact con = (Contact) contactObj;
                    //contactslist.add(con);
                    // add accountIds for matched contacts to Set
                    contactIds.add(con.Id);
                }
                //scenario  - Contact Phone Matched
                if (contactIds.size() > 0) {
                    
                    Map<Id, Account> mapAccounts = new Map<Id, Account>();
                    allWrapGlobal = new List<Contactdetailswrapper>();
                    
                    contactslist = [SELECT Id, phone, Name,Email, Title,AccountId,Account.name,Account.Division__c,Account.SoldToAccount__c,Account.SAP_Account_Id__c,Account.Customer_Base__c,
                                    (SELECT Id, Owner.name, Priority, Status, Subject, CreatedDate,CaseNumber,Team_Sub_Category__c,Customer_Account__c, ContactId, AccountId FROM Cases where  RecordType.DeveloperName = :CSR_CASE_RECORD_TYPE  order by CreatedDate DESC), 
                                    (SELECT Id,accountId, IsDirect,Account.name,Account.Division__c,Account.SoldToAccount__c,Account.SAP_Account_Id__c,Account.Customer_Base__c FROM AccountContactRelations order by Account.Customer_Base__c  ) FROM Contact where id in:contactIds And Contact_Type__c = 'Service'];
                    contactslistother = [SELECT Id, phone, Name,Email, Title FROM Contact where id in:contactIds And Contact_Type__c != 'Service'  ];
                    if(contactslist.size() == 0 && contactslistother.size() ==0){
                        noCon = true;
                    }else if(contactslistother.size() > 0 && contactslist.size() == 0 ){
                        noServiceCon = true;
                    }
                    
                    for (Contact con : contactslist) {
                        
                        Map<Id, List<Case>> mapAccIdToCases = new Map<Id, List<Case>>();
                        for (Case caseObj : con.Cases) {
                            if(caseObj.Status != 'Closed' && caseObj.Status  !='Duplicate'){ 
                                if (mapAccIdToCases.containsKey(caseObj.AccountId)) {
                                    List<Case> caseList = mapAccIdToCases.get(caseObj.AccountId);
                                    caseList.add(caseObj);
                                    mapAccIdToCases.put(caseObj.AccountId, caseList);
                                } else {
                                    mapAccIdToCases.put(caseObj.AccountId, new List<Case>{
                                        caseObj
                                            });
                                }
                            }
                        }
                        
                        Map<id, String> mapAccToIsDirect = new Map<Id, string>();
                        
                        for (AccountContactRelation acrObj : con.AccountContactRelations) {
                            mapAccToIsDirect.put(acrObj.accountId, (acrObj.IsDirect) ? 'Y' : 'N') ;
                            mapAccounts.put(acrObj.AccountId, getAccountDetailsfromACR(acrObj));
                        }
                        
                        
                        Map<id, integer> mapAccToAccountNumber = new Map<Id, integer>();
                        
                        for (case caseObj : con.cases) {
                             mapAccToAccountNumber.put(caseObj.accountId,(caseObj.Customer_Account__c==null?0:Integer.valueOf(caseObj.Customer_Account__c))) ;
                           system.debug('accounum'+ (caseObj.Customer_Account__c==null?0:Integer.valueOf(caseObj.Customer_Account__c)));
                        }
                        
                        //mapAccIdToCases.keySet() acrIds
                        for (AccountContactRelation acrObj : con.AccountContactRelations) {
                            Contactdetailswrapper conWrap = new Contactdetailswrapper();
                            conWrap.conObj = getContact(con);
                            conWrap.accountObj = mapAccounts.get(acrObj.AccountId);
                            
                            conWrap.cases = mapAccIdToCases.get(acrObj.AccountId);
                            conWrap.isDirect = mapAccToIsDirect.get(acrObj.AccountId);
                            conWrap.accountNumber = mapAccToAccountNumber.get(acrObj.AccountId);
                            allWrapGlobal.add(conWrap);
                        }
                    }
                }
            }
            if(allWrapGlobal !=null){
                system.debug('allWrapGlobal'+allWrapGlobal);
                allWrapGlobal.sort();  
                system.debug('after sort'+allWrapGlobal);
                List<Contactdetailswrapper> allWrapGlobalDirY= new list<Contactdetailswrapper>();
                List<Contactdetailswrapper> allWrapGlobalDirN = new list<Contactdetailswrapper>();
                integer iterationsize  =  allWrapGlobal.size();
                for(integer i = 0 ;i<iterationsize;i++){
                     if(allWrapGlobal[i].isDirect == 'Y'){
                        allWrapGlobalDirY.add(allWrapGlobal[i]);
                    }else if(allWrapGlobal[i].isDirect == 'N' || true){
                        allWrapGlobalDirN.add(allWrapGlobal[i]);
                    }
                }
                
                allWrapGlobalsorted.addAll( allWrapGlobalDirY);
                allWrapGlobalsorted.addAll( allWrapGlobalDirN);
            }
            System.debug('allWrapGlobalsorted' + allWrapGlobalsorted);
        }
    }
    /** * * * * * * * * * * * * 
*  Method Name:  formatphonenum
*  Purpose:     To format phone number
*  Author:       Md Yaqub
*  Type:         Method
** * * * * * * * * * * * */
    static String formatphonenum(String phonenumber) {
        if (phonenumber.length() == 10) {
            phonenumber = '(' + phonenumber.substring(0, 3) + ') ' + phonenumber.substring(3, 6) + '-' + phonenumber.substring(6);
            
        }
        
        return phonenumber;
    }
    /** * * * * * * * * * * * *
*  Method Name:  getContact
*  Purpose:     To Get contact information.
*  Author:       Md Yaqub
*  Type:         Method
** * * * * * * * * * * * */
    
    static contact getContact(Contact conObj) {
        return new Contact(Id = conObj.Id, Email = conObj.Email, Title = conObj.Title, phone = conObj.phone, FirstName = conObj.Name);
    }
    
    /** * * * * * * * * * * * *
*  Method Name:  getAccountDetailsfromACR
*  Purpose:     To Get Account information via AccountContactRelation.
*  Author:       Md Yaqub
*  Type:         Method
** * * * * * * * * * * * */
    static Account getAccountDetailsfromACR(AccountContactRelation ACRObj) {
        return new Account(
            Id = ACRObj.AccountId,
            name = ACRObj.Account.name,
            Division__c = ACRObj.Account.Division__c,
            SoldToAccount__c = ACRObj.Account.SoldToAccount__c,
            SAP_Account_Id__c = ACRObj.Account.SAP_Account_Id__c,
            Customer_Base__c = ACRObj.Account.Customer_Base__c
        );
    }
    /** * * * * * * * * * * * *
*  Method Name:  Contactdetailswrapper
*  Purpose:     wrapper for data  information.
*  Author:       Md Yaqub
*  Type:         Method
** * * * * * * * * * * * */
    global class Contactdetailswrapper  implements Comparable{
        public Contact conObj { get; set; }
        public Account accountObj { get; set; }
        public String isDirect { get; set; }
        public integer accountNumber { get; set; }
        public List<Case> cases { get; set; }
        
        public Integer compareTo(Object compareTo) 
        {
            //return isDirect.compareTo(((Contactdetailswrapper)compareTo).isDirect);
            Contactdetailswrapper compareToisd = (Contactdetailswrapper)compareTo;
            if (accountNumber == compareToisd.accountNumber) {
                return 0;
            }			
            if (accountNumber > compareToisd.accountNumber) {
                return 1;
            }
             
            if (accountNumber == 0) {
                return 1;
            }
                       
            return -1;        
        }
    }        
}