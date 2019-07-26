public with sharing class CPQQuoteNewExtension {

/* This APEX Extension does the following...
// Gets the record ID used to launch the VF page
// Determines if it was launched from a Contact/Account/Opportunity and gets that records info   
// Since CPQ requires an Opportunity, if the page was not launched from an Opp
// It creates one based off the Contact / Account (createOpp called as an action from the VF page)
// Then returns the ID of the starting / newly created Opportunity
// Which is fed into the CPQ URL, and opened in an iFram 
// on the VisualForce page
*/

    public Account acc {get;set;}
    public Contact cnt {get;set;}
    public Opportunity opp {get;set;}
    public OpportunityContactRole oppCR {get;set;}
    public Boolean cntCheck {get;set;}
    public Boolean acctCheck {get;set;}
    public Boolean oppCheck {get;set;}
    public String theRecord {get;set;}
    public String theRecordId {get;set;}
    String cntCheckVal = 'Contact';
    String acctCheckVal = 'Account';
    String oppCheckVal = 'Opportunity';



    public CPQQuoteNewExtension (ApexPages.StandardController stdController)  {
//        this.theRecord = (theSObjectType)stdController.getId();
//        String theRecordIdddd =  String.valueof(theRecord.getId);
        String type = stdController.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType =  String.valueof(stdController.getRecord().getSObjectType());
        String theRecord =  String.valueof(stdController.getRecord());
        String theRecordtemp =  theRecord.removeEnd('}');
        String theGenericRecordizerPt1 = theRecordtemp.right(18);            
        String theRecordId = theGenericRecordizerPt1.removeStart('_c=');                    
        Boolean cntCheck = theRecord.contains(cntCheckVal);
        Boolean acctCheck = theRecord.contains(acctCheckVal);
        Boolean oppCheck = theRecord.contains(oppCheckVal);
        System.debug('is that a  acctCheck...' + acctCheck + '/ cntCheck... ' + cntCheck + ' / and oppCheck...' + oppCheck);
        System.debug('theRecord: ' + theRecord);
        System.debug('theRecords Type: ' + theSObjectType);        
        System.debug('theRecordId: ' + theRecordId);


        if (cntCheck == TRUE){

        cnt =  [
            SELECT Id
                ,NAME
                ,AccountId
            FROM Contact
            WHERE Id = :theRecordId];
        System.debug('::::CPQQuoteNewExtension starting with cnt + ::::> ' + cnt);

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
            FROM Account
            WHERE Id = :cnt.AccountId];
        } 

        if (acctCheck == TRUE && oppCheck != TRUE && cntCheck != TRUE){
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
                    FROM Account
                    WHERE Id = :theRecordId];
                System.debug('::::CPQQuoteNewExtension starting with acc + step 2::::> ' + acc);
        }

        if (oppCheck == TRUE  && cntCheck != TRUE) {
            opp = [
                SELECT Id
                FROM Opportunity
                WHERE Id = :theRecordId];
        }    
    }      

    public void createOpp() {
        System.debug('::::CPQQuoteNewExtension called  createOpp+');
        if (acc != NULL || cnt != NULL ) {
            System.debug('::::CPQQuoteNewExtension + cnt:' + cnt);
            opp = new Opportunity();
            List<RecordType> rtList = [
                                    SELECT SobjectType
                                        ,Name
                                        ,Id 
                                    FROM RecordType 
                                    WHERE SobjectType = 'Opportunity' 
                                    AND Name = 'Project'];  
            opp.name = acc.NAME + ' - Product Selection - ' + system.today().format();
            opp.AccountId = acc.id;
            opp.Project_Address__c = acc.BillingStreet;
            opp.Project_City__c = acc.BillingCity;
            opp.Project_State__c = acc.BillingState;
            opp.Project_Zip_Code__c = acc.BillingPostalCode;
            opp.Owner_Phone__c = acc.phone;
            opp.CloseDate = system.today();
            opp.StageName = '2 - Specification';           
            opp.Sub_Stage__c= '1 - Prospect';         
            if(rtList != null && rtList.size()>0){
                for(RecordType rt:rtList){
                    opp.RecordTypeId = rt.Id;            
                }
            }
            try{                                                                       
                insert opp;
            }catch(Exception e){
                System.debug('Exception caught in createOpp function ---> '+e);
            }           
            if ( cnt != NULL ) {
                oppCR = new OpportunityContactRole();
                oppCR.ContactId = cnt.Id;
                oppCR.OpportunityId = opp.Id;
                oppCR.Role = 'Evaluator';
                oppCR.IsPrimary = true;
                try{                                                                       
                    insert oppCR;
                }catch(Exception e){
                    System.debug('Exception caught in createOpp function ---> '+e);
                }                 
            }
        } else {System.debug('::::CPQQuoteNewExtension createOpp was not needed, you probably started from an Opp!');}
    }

    public String getResult() {
        return opp.Id;
    } 

}