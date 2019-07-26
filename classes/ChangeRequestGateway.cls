public class ChangeRequestGateway {

    // String NEW_CUSTOMER_REQUEST = Label.CR_New_Customer_RT;
    // String CUSTOMER_UPDATE = Label.CR_Customer_Update_RT;
    // @TestVisible boolean hasErrors = false;
    public static boolean firstRun = true;
    public static boolean testRun = false;
    
    public static void onBeforeInsert(map<Id,SObject> newMap) {
        System.debug( ' :::onBeforeInsert:>');
        Boolean varReadyForApproval;
        varReadyForApproval = validate(); 
        if (varReadyForApproval != true) {
            findApprover();
            updateStatus();
        }        
    }
    
    public static List <Approval.ProcessSubmitRequest> onAfterInsert(map<Id,SObject> newMap) {
        System.debug( ' :::onAfterInsert:>');
        Boolean hasErrors;
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        Change_Request__c crNewRequest = (Change_Request__c)newMap.get(idKeySet);
        List <Approval.ProcessSubmitRequest> listApprovalSubmit = new List <Approval.ProcessSubmitRequest> (); 
        List <Approval.ProcessSubmitRequest> listApproval = new List <Approval.ProcessSubmitRequest> ();
        listApproval = autoSubInsert(crNewRequest);
        listApprovalSubmit.addAll(listApproval);
        return listApprovalSubmit;
    }
    
    public static void onBeforeUpdate(map<Id,SObject> newMap, map<Id,SObject> oldMap) {
        System.debug( ' :::onBeforeUpdate:>');
        Boolean varReadyForApproval;
        varReadyForApproval = validate();
        if (varReadyForApproval != true) {
            findApprover();
            updateStatus();
        }        
    }
    
    public static List <Approval.ProcessSubmitRequest> onAfterUpdate(map<Id,SObject> newMap, map<Id,SObject> oldMap) {
        System.debug( ' :::onAfterUpdate:>');
        Boolean hasErrors;
        Id idKeySet = (new list<ID>(newMap.keySet())[0] );
        Change_Request__c crNewRequest = (Change_Request__c)newMap.get(idKeySet);
        List <Change_Request__c> listNewCR = new List <Change_Request__c> ();
        listNewCR.add(crNewRequest);
        List <Approval.ProcessSubmitRequest> listApprovalSubmit = new List <Approval.ProcessSubmitRequest> (); 
        List <Approval.ProcessSubmitRequest> listApproval = new List <Approval.ProcessSubmitRequest> ();
        listApproval = autoSubUpdate(crNewRequest);
        listApprovalSubmit.addAll(listApproval);
        return listApprovalSubmit;
    }

    public static List <Approval.ProcessSubmitRequest> autoSubInsert(SObject crNewRequest) {
        System.debug( ' :::autoSubInsert:>');
        Change_Request__c CR = (Change_Request__c) crNewRequest;       
        List <Approval.ProcessSubmitRequest> listApprovalSubmit = new List <Approval.ProcessSubmitRequest> ();
        System.debug( ' :::autoSubInsert + :>' + CR.Skip_Customer_change_WF__c);
        System.debug( ' :::autoSubInsert + :>' + CR);
        IF(CR.Skip_Customer_change_WF__c==FALSE
           &&CR.RECORDTYPEID==Label.CR_New_Customer_RT
           &&(CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL)
           &&(CR.Region__c!=NULL&&CR.Customer_Name__c!=NULL&&CR.SSC__c!=NULL&&CR.Sales_Representative__c!=NULL&&CR.Customer_Class__c!=NULL&&CR.Billing_Street_N__c!=NULL))
        {
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('A New Account request was submitted for approval. Please approve.');
            req.setObjectId(CR.Id);
            // submit the approval request for processing
            listApprovalSubmit.add(req);
        }
        
        IF(CR.RECORDTYPEID==Label.CR_Customer_Update_RT 
           &&(CR.RVPWF1__c!=FALSE||CR.RSM_WF1__c!=FALSE)
           &&(CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL)
           && CR.Status__c == 'Submitting for Approval')
        {
            if (cr.New_ShipTo_Request__c == TRUE){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('A new Customer ShipTo Request has been submitted for Account: ' + CR.Account__r.Name + '. Please approve.');
                req.setObjectId(CR.Id);
                // submit the approval request for processing
                listApprovalSubmit.add(req);
            } else {                      
                // create the new approval request to submit for Customer update RT
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('A new Change Request has been submitted for Account: ' + CR.Account__r.Name + '. Please approve.');
                req.setObjectId(CR.Id);
                // submit the approval request for processing
                listApprovalSubmit.add(req);
            }
        }       
        return listApprovalSubmit;
    } 
    
    public static List <Approval.ProcessSubmitRequest> autoSubUpdate(SObject crNewRequest) {
        System.debug(':::: autoSubUpdate::::>');
        Change_Request__c CR = (Change_Request__c) crNewRequest;      
         
        System.debug( ' :::autoSubUpdate + Status__c ::::> ' + CR.Status__c);        
        System.debug( ' :::autoSubUpdate + RecordTypeId ::::> ' + CR.RecordTypeID);
        System.debug( ' :::autoSubUpdate + GONE_THROUGH_APPROVAL_PROCESS__C ::::> ' + CR.GONE_THROUGH_APPROVAL_PROCESS__C);   
        System.debug( ' :::autoSubUpdate + Skip_Customer_change_WF__c ::::> ' + CR.Skip_Customer_change_WF__c);        
        System.debug( ' :::autoSubUpdate + APPROVER1__C ::::> ' + CR.APPROVER1__C);   
        System.debug( ' :::autoSubUpdate + APPROVER2__C ::::> ' + CR.APPROVER2__C);       
        System.debug( ' :::autoSubUpdate + VPWF1__c ::::> ' + CR.VPWF1__c);        
        System.debug( ' :::autoSubUpdate + VP_Approved__c ::::> ' + CR.VP_Approved__c);        
        
        List <Approval.ProcessSubmitRequest> listApprovalSubmit = new List <Approval.ProcessSubmitRequest> ();
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        IF(CR.GONE_THROUGH_APPROVAL_PROCESS__C!=TRUE && CR.Skip_Customer_change_WF__c==FALSE) {
            System.debug('Cr 1 autoSubUpdate:...' + CR);
            IF(CR.RECORDTYPEID==Label.CR_Customer_Update_RT ) {
               if ((CR.RVPWF1__c != FALSE || CR.RSM_WF1__c != FALSE) && (CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL) && CR.Status__c == 'Submitting for Approval') {
                    if (cr.New_ShipTo_Request__c == TRUE) {
                        req.setComments('A new Customer ShipTo Request has been submitted for Account: ' + CR.Account_Name_txt__c + '. Please approve.');
                    } else {                      
                        // create the new approval request to submit for Customer update RT
                        req.setComments('A new Change Request has been submitted for Account: ' + CR.Account_Name_txt__c + '. Please approve.');
                    }       
                    req.setObjectId(CR.Id);
                    // submit the approval request for processing
                    listApprovalSubmit.add(req);
                }
            }
            IF(CR.RECORDTYPEID==Label.CR_New_Customer_RT
               &&(CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL)                   
               &&(CR.Region__c!=NULL&&CR.Customer_Name__c!=NULL&&CR.SSC__c!=NULL&&CR.Sales_Representative__c!=NULL&&CR.Customer_Class__c!=NULL&&CR.Billing_Street_N__c!=NULL))
            {
                // create the new approval request to submit for Customer update RT
                req.setComments('A request for New Account:' + CR.Customer_Name__c + ' was submitted for approval. Please approve.');
       
                req.setObjectId(CR.Id);
                // submit the approval request for processing
                listApprovalSubmit.add(req);
            }      
        } else if (CR.RECORDTYPEID==Label.CR_Customer_Update_RT && cr.VPWF1__c == true && cr.VP_Approved__c != true && CR.Status__c == 'Approved') {
            req.setComments('A new Customer Class change has been submitted for Account: ' + CR.Account_Name_txt__c + ' going from Class: ' + CR.Customer_Class_txt__c + ' to Class: ' + cr.New_Cust_Class_txt__c + '. Please review.');
            req.setObjectId(CR.Id);
            listApprovalSubmit.add(req);
        }
        return listApprovalSubmit;
    }
    
    
    public static Boolean validate() {
        Boolean hasErrors;
        Boolean hasIssueValidating;
        List <Change_Request__c> listNewCR = new List <Change_Request__c> ();
        for (SObject so : trigger.new) {
            Change_Request__c theCR = (Change_Request__c)so;
            listNewCR.add(theCR);
        }       
        
        System.debug('::: validate + listNewCR:...' + listNewCR);
        
        if (firstRun) {
            set<Id> salesRepIds = new set<Id>();
            set<Id> salesRepNIds = new set<Id>();
            set<Id> customerClassIds = new set<Id>();
            set<Id> customerClassNIds = new set<Id>();
            set<Id> customerTypeIds = new set<Id>();
            set<Id> customerTypeNIds = new set<Id>();
            set<Id> SSCIds = new set<Id>();
            set<Id> SSCNIds = new set<Id>();
            set<Id> RegionIds = new set<Id>();
            set<Id> RegionNIds = new set<Id>();
            
            for(Change_Request__c c : listNewCR) {
                salesRepIds.add(c.Sales_Representative__c);
                salesRepNIds.add(c.Sales_Representative_n__c);
                customerClassIds.add(c.Customer_Class__c);
                customerClassNIds.add(c.Customer_Class_n__c);
                customerTypeIds.add(c.Customer_Type__c);
                customerTypeNIds.add(c.Customer_Type_n__c);
                SSCIds.add(c.SSC__c);
                SSCNIds.add(c.SSC_N__c);
                RegionIds.add(c.Region__c);
                RegionNIds.add(c.Region_n__c);
            }
            
            map<Id, Sales_Representative__c> salesRepMap = new map<Id,Sales_Representative__c>([select Id, SBU__c, Country__c, Region__c from Sales_Representative__c where Id in :salesRepIds]);
            map<Id, Sales_Representative__c> salesRepNMap = new map<Id,Sales_Representative__c>([select Id, SBU__c, Country__c, Region__c from Sales_Representative__c where Id in :salesRepNIds]);
            map<Id, Customer_Class__c> customerClassMap = new map<Id, Customer_Class__c>([Select Id, CustomerSBU__c, Region__c, PPS_Rgn__c from Customer_Class__c where Id in:customerClassIds]);
            map<Id, Customer_Class__c> customerClassNMap = new map<Id,Customer_Class__c>([Select Id, CustomerSBU__c, Region__c, PPS_Rgn__c from Customer_Class__c where Id in:customerClassNIds]);
            map<Id, Customer_Type__c> customerTypeMap = new map<Id,Customer_Type__c>([Select Id,SBU__c, Country__c, Region__c from Customer_Type__c where Id in :customerTypeIds]);
            map<Id, Customer_Type__c> customerTypeNMap = new map<Id, Customer_Type__c>([Select Id,SBU__c, Country__c, Region__c from Customer_Type__c where Id in :customerTypeNIds]);
            map<Id, SSC__c> SSCMap = new map<Id, SSC__c>([Select Id,Country__c, SBU__c, Region__c from SSC__c where Id in :SSCIds]);
            map<Id, SSC__c> SSCNMap = new map<Id, SSC__c>([Select Id,Country__c, SBU__c, Region__c from SSC__c where Id in :SSCNIds]);
            map<Id, Region__c> RegionMap = new map<Id, Region__c>([Select Id,Name, SBU__c, DW_ID__c from Region__c where Id in :RegionIds]);
            map<Id, Region__c> RegionNMap = new map<Id, Region__c>([Select Id,Name, SBU__c, DW_ID__c from Region__c where Id in :RegionNIds]);
            
            //retrieve the maps for all the parent objects               
            
            for(Sales_Representative__c u : salesRepMap.values()) {
                salesRepMap.put(u.Id, u);
            }
            
            for(Sales_Representative__c u : salesRepNMap.values()) {
                salesRepNMap.put(u.Id, u);
            }            
            
            for(Customer_Class__c c : customerClassMap.values()) {
                customerClassMap.put(c.Id, c);
            }
            
            for(Customer_Class__c c : customerClassNMap.values()) {
                customerClassNMap.put(c.Id, c);
            }
            
            for(Customer_Type__c c : customerTypeMap.values()) {
                customerTypeMap.put(c.Id, c);
            }
            
            for(Customer_Type__c c : customerTypeNMap.values()) {
                customerTypeNMap.put(c.Id, c);
            }
            
            for(SSC__c c : SSCMap.values()) {
                SSCMap.put(c.Id, c);
            }
            
            for(SSC__c c : SSCNMap.values()) {
                SSCNMap.put(c.Id, c);
            }
            
            for(Region__c c : RegionMap.values()) {
                RegionMap.put(c.Id, c);
            }
            
            for(Region__c c : RegionNMap.values()) {
                RegionNMap.put(c.Id, c);
            }
            
            for(Change_Request__c c : listNewCR) {  
                updateOptions();
                
                System.debug(':::::::c:::::::'+c);
                
                // get users profile info             
                
                List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                String MyProflieName = PROFILE[0].Name;
                System.debug( ' :::validate + MyProflieName :::>' + MyProflieName);
                System.debug( ' :::validate + testRun :::>' + testRun);
                System.debug( ' :::validate + Status__c :::>' + c.Status__c);
                System.debug( ' :::validate + GONE_THROUGH_APPROVAL_PROCESS__C :::>' + c.GONE_THROUGH_APPROVAL_PROCESS__C);
                System.debug( ' :::validate + does Label.CR_Customer_Update_RT :::>' + Label.CR_Customer_Update_RT + ' = c.RECORDTYPEID :::>' + c.RECORDTYPEID);

                // to bypass validations, user will need to be system admin profile
                if ((testRun != true && c.GONE_THROUGH_APPROVAL_PROCESS__C != TRUE)                    
                    && (c.Status__c == 'Submitting for Approval' || c.Status__c == 'Rejected' || (MyProflieName == 'CustomerRequest Profile' && c.Status__c == 'Not Submitted'))) {                
                        if (MyProflieName != 'System Administrator' && MyProflieName != 'Support' ) {
                        
                        //=============================
                        //=========VALIDATIONS=========
                        //=============================
                        
                        //=============================
                        // Customer Class
                        
                        if(  (c.Business_Reason__c == null && c.Customer_Class_n__c != null)
                           || (c.Business_Reason__c == null && c.Customer_Class__c != null && c.Customer_Name__c != NULL))
                        {
                            c.Business_Reason__c.addError(Label.Business_Reason_required_for_Class_Change);
                            hasErrors = true;
                        }
                        
                        //=============================
                        // Customer Type Matches Country / SBU
                        // 
                        if (c.RecordTypeId == Label.CR_Customer_Update_RT) {
                            if ( c.Customer_Type_n__c != null) {
                                if ( c.Bill_Country_N__c == 'CA' || c.Bill_Country_N__c == 'US') {
                                    if(c.Bill_Country_N__c != customerTypeMap.get(c.Customer_Type__c).Country__c)
                                    {
                                        c.addError(Label.Customer_Type_must_match_County);
                                        hasErrors = true;
                                    } 
                                }
                                if ( c.Region_n__c != null) {
                                    if (customerTypeNMap.get(c.Customer_Type_n__c).SBU__c != regionNMap.get(c.Region_n__c).SBU__c){
                                        c.addError(Label.Customer_Type_must_match);
                                        hasErrors = true;
                                    }
                                } else {
                                    if (customerTypeNMap.get(c.Customer_Type_n__c).SBU__c != regionMap.get(c.Region__c).SBU__c){
                                        c.addError(Label.Customer_Type_must_match);
                                        hasErrors = true;
                                    }
                                }
                            } else {
                                if (c.Cross_SBU_Request__c == TRUE) {
                                        c.addError('Please choose a new Customer Type');
                                        hasErrors = true;                                
                                }
                            }
                        } else if (c.RecordTypeId == Label.CR_New_Customer_RT) {
                            if ( c.Customer_Type__c != null) {
                                if ( c.Bill_Country_N__c == 'CA' || c.Bill_Country_N__c == 'US') {
                                    if(c.Bill_Country_N__c != customerTypeMap.get(c.Customer_Type__c).Country__c)
                                    {
                                        c.addError(Label.Customer_Type_must_match_County);
                                        hasErrors = true;
                                    } 
                                }							
                                if (customerTypeMap.get(c.Customer_Type__c).SBU__c != regionMap.get(c.Region__c).SBU__c){
                                    c.addError(Label.Customer_Type_must_match);
                                    hasErrors = true;
                                }                        
                            }
                        }
                        
                        
                        // =============================
                        // Customer Class must match Region
                        
                        if (c.RECORDTYPEID==Label.CR_New_Customer_RT) {
                            if (regionMap.get(c.Region__c).DW_ID__c != customerClassMap.get(c.Customer_Class__c).PPS_Rgn__c && customerClassMap.get(c.Customer_Class__c).Region__c!='Unknown') {
                                c.addError(Label.Customer_Class_must_match_Region);
                            }
                        } else if (c.RECORDTYPEID==Label.CR_Customer_Update_RT) {
                            if (c.Customer_Class_n__c != null && customerClassNMap.get(c.Customer_Class_n__c).Region__c!='Unknown' ) {
                                if (c.Region_n__c != null) {
                                    if (regionNMap.get(c.Region_n__c).DW_ID__c != customerClassNMap.get(c.Customer_Class_n__c).PPS_Rgn__c ) {
                                        c.addError(Label.Customer_Class_must_match_Region);
                                    }
                                } else {
                                    if (regionMap.get(c.Region__c).DW_ID__c != customerClassNMap.get(c.Customer_Class_n__c).PPS_Rgn__c) {
                                        c.addError(Label.Customer_Class_must_match_Region);
                                    }
                                }            
                            }
                        }
                        
                        
                        
                        //=============================
                        // Sales Rep must match Region
                        if(  (c.Region_n__c != null && c.Sales_Representative_n__c == null && (!salesRepMap.containsKey(c.Sales_Representative__c) || c.Region_n__c != salesRepMap.get(c.Sales_Representative__c).Region__c))
                           || (c.Region_n__c == null && c.Sales_Representative_n__c != null && c.Region__c != salesRepNMap.get(c.Sales_Representative_n__c).Region__c)
                           || (c.Region_n__c != null && c.Sales_Representative_n__c != null && c.Region_n__c != salesRepNMap.get(c.Sales_Representative_n__c).Region__c)
                           || (c.Customer_Name__c != NULL  && (!salesRepMap.containsKey(c.Sales_Representative__c) || c.Region__c != salesRepMap.get(c.Sales_Representative__c).Region__c)))
                        {
                            c.addError(Label.Sales_Rep_must_match_Region);
                            hasErrors = true;
                        }
                        
                        //=============================
                        // SSC must match Region
                        
                        if (  (c.Region_n__c != null && c.SSC_n__c == null && (c.SSC__c == null || c.Region_n__c != SSCMap.get(c.SSC__c).Region__c))
                           || (c.Region_n__c == null && c.SSC_n__c != null && c.Region__c != SSCNMap.get(c.SSC_n__c).Region__c)
                           || (c.Region_n__c != null && c.SSC_n__c != null && c.Region_n__c != SSCNMap.get(c.SSC_n__c).Region__c)
                           || (c.Customer_Name__c != NULL && (c.SSC__c == null || c.Region__c != SSCMap.get(c.SSC__c).Region__c))
                          )
                        { 
                            System.Debug(':::c.Region_n__c: > ' + c.Region_n__c);
                            c.addError(Label.SSC_must_match_Region);
                            hasErrors = true;
                        }             
                        
                        //=============================
                        // Shipping ZIP / State populated-                
                        
                        if ( c.Bill_Country_N__c == 'CA' || c.Bill_Country_N__c == 'US') {                    
                            if ( (c.RECORDTYPEID == Label.CR_New_Customer_RT && c.Shipping_Zip_N__c == null && c.Billing_City__c != null)
                               ||  (c.RECORDTYPEID == Label.CR_Customer_Update_RT && c.Shipping_Zip_N__c == null && c.Shipping_City__c != null))
                            {
                                c.Shipping_Zip_N__c.addError(Label.Shipping_Zip_Required);
                                hasErrors = true;
                            }
                            if ( (c.Customer_Name__c != NULL && c.Shipping_State_N2__c == null && c.Billing_City__c != null)
                               ||  (c.RECORDTYPEID == Label.CR_Customer_Update_RT && c.Shipping_State_N2__c == null && c.Shipping_City__c != null))
                            {
                                c.Shipping_State_N2__c.addError(Label.Shipping_State_Required);
                                hasErrors = true;
                            } 
                        } else {
                            System.Debug(':::International c.Shipping_country__c> ' + c.Shipping_country__c);
                        }
                        
                        //=============================
                        // Shipping Address populated-                
                        
                        IF (c.RECORDTYPEID == Label.CR_New_Customer_RT && c.Copy_Bill_To_Address__c != TRUE) {
                            if (c.Country_N2__c == NULL || c.Country_N2__c == '') {
                                c.Country_N2__c.addError(Label.Shipping_Country_Required);
                                hasErrors = true;
                            }
                            if (c.Billing_Street__c == NULL || c.Billing_Street__c == '') {
                                c.Billing_Street__c.addError(Label.Shipping_Street_Required);
                                hasErrors = true;
                            }
                            if (c.Billing_City__c == NULL || c.Billing_City__c == '') {
                                c.Billing_City__c.addError(Label.Shipping_City_Required);
                                hasErrors = true;
                            }
                            if (c.Shipping_State_N2__c == NULL || c.Shipping_State_N2__c == '') {
                                c.Shipping_State_N2__c.addError(Label.Shipping_State_Required);
                                hasErrors = true;
                            }
                            if (c.Shipping_Zip_N__c == NULL || c.Shipping_Zip_N__c == '') {
                                c.Shipping_Zip_N__c.addError(Label.Shipping_Zip_Required);
                                hasErrors = true;
                            }
                        } ELSE {
                            System.Debug(':::Not a new customer!> ' );
                        }
                        
                        //=============================
                        // No PO Box in Shipping Address
                        String po1 = 'PO';
                        String po2 = 'P.O.';
                        String po3 = 'P .O .';
                        String po4 = 'P. O.';
                        String po5 = 'P. O.';
                        
                        IF (c.Shipping_street__c != NULL && (c.Shipping_street__c.CONTAINS(po1) || c.Shipping_street__c.CONTAINS(po2) || c.Shipping_street__c.CONTAINS(po3) || c.Shipping_street__c.CONTAINS(po4) || c.Shipping_street__c.CONTAINS(po5)))
                        {
                            c.Shipping_street__c.addError(Label.No_PO_Box_in_Shipping_Address);
                            hasErrors = true;
                        }
                        
                        
                        //=============================
                        // Reason for New Suffix Required
                        system.debug('New Suffix Required? = ' + c.New_ShipTo_Request__c +  '- And the new reason is ' + c.Reason_for_New_Suffix__c  );
                        if ( c.New_ShipTo_Request__c == TRUE ) {
                            if (c.Reason_for_New_Suffix__c == '' || c.Reason_for_New_Suffix__c == NULL) {
                                c.New_ShipTo_Request__c.addError(Label.Reason_For_ShipTo_Required);
                                hasErrors = true;           
                            } 
                        }
                        
                        //=============================
                        // No DEL request on mark for del                    
                        if (c.RecordType.Name == 'Customer Delete Request') {
                            if (c.Account__r.Mark_For_Deletion__c == true) {
                                c.addError('Sorry, but it looks like this Account is already marked for delete.');
                                hasErrors = true;           
                            }
                            
                        }
                        
                        //==============================
                        // Dupe Checker
                        System.debug('About to Dupe Check c: .....' + c);
                        if (c.RECORDTYPEID == Label.CR_New_Customer_RT) {
                            System.debug('Dupe Checker New Account Request + c: .....' + c);
                            if (Trigger.isInsert) {
                                List <Change_Request__c> crList = [SELECT
                                                                        Name,
                                                                        CreatedById,
                                                                        Customer_Name__c,
                                                                        SSC__c,
                                                                        Created_Date__c,
                                                                        Sales_Representative__c,
                                                                        Customer_Class__c,
                                                                        Ship_To_Phone__c,
                                                                        Customer_Type__c,
                                                                        Region__c,
                                                                        Billing_Street_N__c,
                                                                        Address2__c,
                                                                        Bill_Country_N__c,
                                                                        Billing_City_N__c,
                                                                        Billing_State_N2__c,
                                                                        Billing_Zip_N__c,
                                                                        Contact__c
                                                                    FROM Change_Request__c
                                                                    WHERE 
                                                                        Customer_Name__c = : c.Customer_Name__c
                                                                        AND SSC__c = : c.SSC__c
                                                                        AND Sales_Representative__c = : c.Sales_Representative__c
                                                                        AND Customer_Class__c = : c.Customer_Class__c
                                                                        AND Ship_To_Phone__c = : c.Ship_To_Phone__c
                                                                        AND Customer_Type__c = : c.Customer_Type__c
                                                                        AND Region__c = : c.Region__c
                                                                        AND Billing_Street_N__c = : c.Billing_Street_N__c
                                                                        AND Address2__c = : c.Address2__c
                                                                        AND Bill_Country_N__c = : c.Bill_Country_N__c
                                                                        AND Billing_City_N__c = : c.Billing_City_N__c
                                                                        AND Billing_State_N2__c = : c.Billing_State_N2__c
                                                                        AND Billing_Zip_N__c = : c.Billing_Zip_N__c
                                                                        AND Contact__c = : c.Contact__c
                                                                        AND Id != : c.id 
                                                                        AND Status__c != 'Not Submitted'
                                                                        AND Status__c != 'Rejected'
                                                                        AND Status__c != 'SFDC Updated'];
                                System.debug('c = .....' + c);
                                System.debug('crList = .....' + crList);
                                if (!crList.isEmpty()) {
                                    for (Change_Request__c chngR : crList ) {
                                        C.ADDERROR('This Account has already been requested as ' + chngR.Name + ', successfully submitted on ' + chngR.Created_Date__c);
                                        hasErrors = true;     
                                    }
                                } else {
                                    System.debug('crList must be empty.....');
                                }
                            }
                        } else if ((c.RECORDTYPEID == Label.CR_Customer_Update_RT)) {
                            System.debug('Dupe Checker: CR_Customer_Update_RT: .....');
                            List <Change_Request__c> crList = [SELECT
                                                                   Id,
                                                                   Name,
                                                                   CreatedById,
                                                                   Created_Date__c,
                                                                   Status__c,
                                                                   Account__c,
                                                                   Billing_Street_N__c,
                                                                   Shipping_street__c,
                                                                   New_ShipTo_Request__c,
                                                                   Current_Approver__r.Email,
                                                                   Current_Approver__c,
                                                                   Sales_Representative__c,
                                                                   Sales_Representative_n__c,
                                                                   SSC__c,
                                                                   SSC_N__c,
                                                                   Customer_Class__c,
                                                                   Customer_Class_N__c,
                                                                   Customer_Type__c,
                                                                   Customer_Type_N__c,
                                                                   Customer_Name_Change__c,
                                                                   Name_Change__c
                                                               FROM Change_Request__c
                                                               WHERE Account__c = : c.Account__c
                                                                   AND Status__c != 'Not Submitted'
                                                                   AND Status__c != 'Creating'
                                                                   AND Status__c != 'Rejected'
                                                                   AND Status__c != 'Source System Updated'
                                                                   AND Status__c != 'SFDC Updated'
                                                              ];
                            System.debug('crList = .....' + crList);
                            if (!crList.isEmpty()) {
                                for (Change_Request__c chngR : crList ) {
                                        if (c.New_ShipTo_Request__c == TRUE) {
                                            if (chngR.New_ShipTo_Request__c == TRUE && c.New_ShipTo_Request__c == TRUE) {
                                                C.ADDERROR('There has already been a New ShipTo request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                                hasErrors = true;   
                                            }
                                        } else if (chngR.Sales_Representative_n__c != NULL && c.Sales_Representative_n__c != NULL ) {
                                            C.ADDERROR('There has already been a Salesrep change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if (chngR.Customer_Class_N__c != NULL && c.Customer_Class_N__c != NULL ) {
                                            C.ADDERROR('There has already been a Customer Class change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if (chngR.SSC_N__c != NULL && c.SSC_N__c != NULL ) {
                                            C.ADDERROR('There has already been a SSC change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if (chngR.Customer_Type_N__c != NULL && c.Customer_Type_N__c != NULL ) {
                                            C.ADDERROR('There has already been a Customer Type change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if (chngR.Billing_Street_N__c != NULL && c.Billing_Street_N__c != NULL ) {
                                            C.ADDERROR('There has already been a Billing Address change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if (chngR.Shipping_street__c != NULL && c.Shipping_street__c != NULL ) {
                                            C.ADDERROR('There has already been a Shipping Address change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                            hasErrors = true;                                     
                                        } else if ((chngR.Customer_Name_Change__c != NULL && chngR.Customer_Name_Change__c != '')
                                                 && (c.Name_Change__c == TRUE && c.Customer_Name_Change__c != NULL  && c.Customer_Name_Change__c != '')) {
                                                       C.ADDERROR('There has already been a Name change request submitted for this Account as ' + chngR.Name + ', created on ' + chngR.Created_Date__c + ', and the current status is: ' + chngR.Status__c + '. Please wait until it has been approved and updated before requesting another change, feel free to email the Current Approver: ' + chngR.Current_Approver__r.Email + ' with any questions.');
                                                       hasErrors = true;                                     
                                       }             
                                    }
                                } else {
                                    System.debug('crList must be empty.....');
                                }
                            }                   
                    } else {                   
                        System.debug('Admin made a change.....');
                    }
                }
                //=============================
                // Set up Pro Exchange Users
                Set<String> setInvalidNames = new Set<String> {'-', '.', ',', ' ', 'none', 'n/a'};
                if (c.RECORDTYPEID == Label.CR_New_Customer_RT && c.Set_Up_In_ProExchange__c == true) {
                    System.debug('Set_Up_In_ProExchange__c.....');
                    System.debug('Set_Up_In_ProExchange__c + c.Contact_Email__c: .....' + c.Contact_Email__c);
                    if ( (c.Contact_First_Name__c == null) || (c.Contact_First_Name__c.length() < 2) || (!c.Contact_First_Name__c.isAlpha()) || ( setInvalidNames.contains(c.Contact_First_Name__c))){
                        c.Contact_First_Name__c.addError('Please provide a valid first name for all new ProExchange members.');
                        hasErrors = true;               
                        System.debug('Set_Up_In_ProExchange__c + Contact_First_Name__c error .....');
                    }
                    if ( (c.Contact_Last_Name__c == null) || (c.Contact_Last_Name__c.length() < 2) || (!c.Contact_Last_Name__c.isAlpha()) || ( setInvalidNames.contains(c.Contact_Last_Name__c))){
                        c.Contact_Last_Name__c.addError('Please provide a valid last name for all new ProExchange members.');
                        hasErrors = true;                                
                    }
                    if ((c.Contact_Email__c == null) || (!c.Contact_Email__c.contains('@'))) {
                        c.Contact_Email__c.addError('Please provide a valid Email address for all new ProExhange members.');
                        hasErrors = true;                                
                    }  
                    if ((!String.isBlank(c.Contact_Email__c)) && (c.Contact_Email__c.contains('@'))) {
                        Set <String> setInvalidEmail = new Set <String> {'daltile', 'americanolean', 'marazzitile', 'ao-marazzi', 'mohawkind', 'keysgranite' };
                        for (String s : setInvalidEmail) {
                            if (c.Contact_Email__c.contains(s) ) {
                                c.Contact_Email__c.addError(' Sorry, ProExchange is for Customers only, not employees.');
                                hasErrors = true;                                
                            }                        
                        }                                          
                    }
                    c.Contact__c = c.Contact_First_Name__c + ' ' + c.Contact_Last_Name__c;
                } else {
                    c.Contact__c = c.Contact_First_Name__c + ' ' + c.Contact_Last_Name__c;
                }                    
                firstRun = false;
            }
        } else {
            System.debug('Already ran!');
        }
        if (hasErrors != true) {
            hasErrors = false;
        }
        return hasErrors;
    }

	public class wrapperApproverClass {
	   public Date varDate {get; set;}
	   public String varApprover {get; set;}
	   public Boolean varApproved {get; set;}
	   
	   public wrapperApproverClass (Date theDate, String theApprover, Boolean theApproved) {
	       varDate = theDate;
	       varApprover = theApprover;
	       varApproved = theApproved;
	   }
	   
	}	
	
    public static List<wrapperApproverClass> checkApprover (Change_Request__c cr, map < Id, SSC__C > sscOLDMap, map < Id, SSC__C > sscNEWMap, String approver) {    

        // ==========================================================
        // Here we take the collection of old SSC and new SSC, and what approver position (MGR1, MGR2, RSM, RVP) 
        // And returns the user that will be the approver for that change
        // ==========================================================
		
        System.debug('checkApprover:...' + approver);
	    System.debug('checkApprover + cr:...' + cr);
		
		String varApprover;
		Date varDate;
		Boolean varApproved;       
		Boolean varIsApprover;
		
		List<wrapperApproverClass> listApprovalInfo = new List<wrapperApproverClass>();
		
		if ( cr.RecordTypeID == Label.CR_New_Customer_RT || ((cr.Status__c == 'Submitting for Approval') && (cr.SSC_N__C != NULL || cr.Customer_Class_N__c != NULL || cr.Sales_Representative_n__c != NULL || cr.New_ShipTo_Request__c == true))) {
			
			Boolean hasAutoApprove;
			Boolean userActive;
			String userApprover;
			
			if(cr.SSC_N__C == NULL) {
			    System.debug('checkApprover + sscOLDMap:...' + sscOLDMap);
			    System.debug('checkApprover + sscOLDMap.get(cr.SSC__C).RVP__r.IsActive:...' + sscOLDMap.get(cr.SSC__C).RVP__r.IsActive);
			    System.debug('checkApprover + sscOLDMap.get(cr.SSC__C).RSM__r.IsActive:...' + sscOLDMap.get(cr.SSC__C).RSM__r.IsActive);
			    System.debug('checkApprover + sscOLDMap.get(cr.SSC__C).Manager__r.IsActive:...' + sscOLDMap.get(cr.SSC__C).Manager__r.IsActive);
				if (approver == 'RVP' && cr.RVPWF1__c == TRUE) {
					userApprover = sscOLDMap.get(cr.SSC__C).RVP__C;
					userActive = sscOLDMap.get(cr.SSC__C).RVP__r.IsActive;					
				} else if (approver == 'RSM' && cr.RSM_WF1__c == True) {
					userApprover = sscOLDMap.get(cr.SSC__C).RSM__C;
					userActive = sscOLDMap.get(cr.SSC__C).RSM__r.IsActive;		
				} else if (approver == 'MGR2' && cr.MGR_WF2__c == TRUE) {
					userApprover = sscOLDMap.get(cr.SSC__C).Manager__C;
					userActive = sscOLDMap.get(cr.SSC__C).Manager__r.IsActive;		
				} else if (approver == 'MGR1' && cr.MGR_WF1__c == TRUE) {
					userApprover = sscOLDMap.get(cr.SSC__C).Manager__C;
					userActive = sscOLDMap.get(cr.SSC__C).Manager__r.IsActive;
				} 
			} else {
			    System.debug('checkApprover + sscNEWMap:...' + sscNEWMap);
				if (approver == 'RVP' && cr.RVPWF1__c == TRUE) {
					userApprover = sscNEWMap.get(cr.SSC_N__C).RVP__C;
					userActive = sscNEWMap.get(cr.SSC_N__C).RVP__r.IsActive;					
				} else if (approver == 'RSM' && cr.RSM_WF1__c == True) {
					userApprover = sscNEWMap.get(cr.SSC_N__C).RSM__C;
					userActive = sscNEWMap.get(cr.SSC_N__C).RSM__r.IsActive;		
				} else if (approver == 'MGR2' && cr.MGR_WF2__c == TRUE) {
					userApprover = sscNEWMap.get(cr.SSC_N__C).Manager__C;
					userActive = sscNEWMap.get(cr.SSC_N__C).Manager__r.IsActive;		
				} else if (approver == 'MGR1' && cr.MGR_WF1__c == TRUE) {
					userApprover = sscOLDMap.get(cr.SSC__C).Manager__C;
					userActive = sscOLDMap.get(cr.SSC__C).Manager__r.IsActive;
				} 		
			}
			if (userApprover != NULL && userActive == true) {
				varApprover = userApprover;
				if (cr.OwnerId == userApprover) {
					varApproved = true;
				} else {
				    varApproved = false;
				}	
			} else {
				varApprover = Label.Default_Approver;
				if ((approver == 'MGR1' && cr.MGR_WF1__c == TRUE) || (approver == 'MGR2' && cr.MGR_WF2__c == TRUE)) {
					varApproved = true;
				} else {
				    varApproved = false;
				}
			}
			listApprovalInfo.add(new wrapperApproverClass(varDate,varApprover,varApproved));
			System.debug('checkApprover + listApprovalInfo:...' + listApprovalInfo);
		}
        return listApprovalInfo;
    } 
    
    public static void findApprover () {

        // ==========================================================
        // Here we look at the type of change being made
        // And decide what positions will be approving based on the change
        // ==========================================================

        System.debug('findApprover + trigger.new:...' + trigger.new);
        List <Change_Request__c> listNewCR = new List <Change_Request__c> ();
        Id oldSSC; 
        Id newSSC; 
        boolean firstRun = true;
        string theBillStateName;
        State__c theBillState;
        string theBillCountryName;
        Country__c theBillCountry;   
        Country__c theShipCountry;
        string theShipCountryName;
        string theShipStateName ;
        State__c theShipState;        

        for (SObject so : trigger.new) {
            Change_Request__c theCR = (Change_Request__c)so;
            oldSSC = theCR.SSC__c;
            newSSC = theCR.SSC_N__C;
            listNewCR.add(theCR);
        }
        
        System.debug('FindApprover oldSSC:...' + oldSSC);
        System.debug('FindApprover newSSC:...' + newSSC);
        List <Change_Request__c> listRequestWithApprovers = new List <Change_Request__c> ();

        // map < Id, SSC__C > sscOLDMap = new map < Id, SSC__C > ([SELECT id, Name, ROM__c, ROM__r.IsActive, RSM__C, RSM__r.IsActive, RVP__C, RVP__r.IsActive, Manager__c, Manager__r.IsActive FROM SSC__C WHERE ID = : cr.SSC__C LIMIT 1]);
        map < Id, SSC__C > sscOLDMap = new map < Id, SSC__C > ();
        map < Id, SSC__C > sscNEWMap = new map < Id, SSC__C > ();
        List <SSC__c> listSSC =[SELECT id
                                    , Name
                                    , ROM__c
                                    , ROM__r.IsActive
                                    , RSM__C
                                    , RSM__r.IsActive
                                    , RVP__C
                                    , RVP__r.IsActive
                                    , Manager__c
                                    , Manager__r.IsActive 
                                FROM SSC__C]; 

        for (SSC__C ssc : listSSC) {
            if (oldSSC == ssc.Id) {
                sscOLDMap.put(ssc.Id, ssc);
            } 
            if (newSSC == ssc.Id) {
                sscNEWMap.put(ssc.Id, ssc);
            }
        }
        
        System.debug('FindApprover sscOLDMap:...' + sscOLDMap);
        System.debug('FindApprover sscNEWMap:...' + sscNEWMap);

        for (Change_Request__c cr: listNewCR) {
            System.debug('FindApprover cr.Skip_Customer_change_WF__c:...' + cr.Skip_Customer_change_WF__c);
            if (cr.Skip_Customer_change_WF__c == FALSE && cr.Status__c != 'Submitted to Support Team' && cr.Status__c != 'Source System Updated' && cr.Status__c != 'Submitted-Pending MGR Approval' && cr.Status__c != 'Submitted-Pending RSM Approval' && cr.Status__c != 'Submitted-Pending RVP Approval' ) {
                System.debug('FindApprover firstRun:...' + firstRun);
                // cr.IsNew__c = false; 
                if (firstRun == true) {
                    firstRun = false;
                    if ((cr.GONE_THROUGH_APPROVAL_PROCESS__C == TRUE && cr.STATUS__c == 'Not Submitted')) {
                        try {
                            cr.ADDERROR('This Change Request has been submitted already for Approval before');
                        } catch (Exception e) {
                            cr.ADDERROR('Exception caught during Change Request submission. Please contact your Administrator');
                        }
                    }
                    if (cr.RECORDTYPEID == Label.CR_Customer_Update_RT || cr.RECORDTYPEID == Label.CR_Customer_Update_RT_2) {
                        System.debug( 'FindApprover + GONE_THROUGH_APPROVAL_PROCESS__C :::>' + cr.GONE_THROUGH_APPROVAL_PROCESS__C);
                        if (cr.GONE_THROUGH_APPROVAL_PROCESS__C != TRUE) {
                            for (SSC__C s: sscOLDMap.values()) {
                                sscOLDMap.put(s.Id, s);
                            }
                            for (SSC__C s: sscNEWMap.values()) {
                                sscNEWMap.put(s.Id, s);
                            }
                            if (cr.SSC_N__c == NULL && cr.SSC__c == NULL) {
                                cr.APPROVER1__c = Label.Default_Approver;
                                cr.APPROVER2__C = Label.Default_Approver;
                            }
                            if (cr.New_ShipTo_Request__c == TRUE) {
                                cr.RVPWF1__c = TRUE;
                                cr.MGR_WF2__c = TRUE;
                            } else if (cr.New_ShipTo_Request__c == FALSE) {
                                if (cr.SSC_N__C != NULL) {
                                    cr.RVPWF1__c = TRUE;
                                    cr.MGR_WF1__c = TRUE;
                                    cr.MGR_WF2__c = TRUE;
                                }
                                if (cr.Sales_Representative_n__c != null) {
                                    cr.RSM_WF1__c = True;
                                    cr.RVPWF1__c = True;
                                }
                                if (cr.Customer_Class_n__c != NULL) {
                                    cr.RVPWF1__c = TRUE;
                                    cr.MGR_WF1__c = TRUE;
                                    cr.VPWF1__c = TRUE;
                                }
                            }           
                            if (cr.APPROVER1__c == null && cr.RVPWF1__c == True) {
                            	List <wrapperApproverClass> approvalInfoRVP = checkApprover(cr, sscOLDMap, sscNEWMap, 'RVP');
                            	for (wrapperApproverClass w : approvalInfoRVP) {
                            		cr.APPROVER1__c = w.varApprover;
                        		    cr.RVP_Approved_Date__c = w.varDate;
                        		    cr.RVP_Approved__c = w.varApproved;	
                            	}
                            }
                            if (cr.Approver2__c == null && cr.RSM_WF1__c == True) {
                            	List <wrapperApproverClass> approvalInfoRSM = checkApprover(cr, sscOLDMap, sscNEWMap, 'RSM');
                            	for (wrapperApproverClass w : approvalInfoRSM) {
                            		cr.Approver2__c = w.varApprover;
                        		    cr.RSM_Approved_Date__c = w.varDate;
                        		    cr.RSM_Approved__c = w.varApproved;	
                            	}
                            }	
                            if (cr.MGR_Approver_1__c == null && cr.MGR_WF1__c == True) {		
                            	List <wrapperApproverClass> approvalInfoMGR1 = checkApprover(cr, sscOLDMap, sscNEWMap, 'MGR1');
                            	for (wrapperApproverClass w : approvalInfoMGR1) {
                            		cr.MGR_Approver_1__c = w.varApprover;
                        		    cr.MGR_1_Approved_Date__c = w.varDate;
                        		    cr.MGR_1_Approved__c = w.varApproved;	
                        		}	
                            }
                            if (cr.MGR_Approver_2__c == null && cr.MGR_WF2__c == True) {
                            	List <wrapperApproverClass> approvalInfoMGR2 = checkApprover(cr, sscOLDMap, sscNEWMap, 'MGR2');
                            	for (wrapperApproverClass w : approvalInfoMGR2) {
                                    cr.MGR_Approver_2__c = w.varApprover;
                                    cr.MGR_2_Approved_Date__c = w.varDate;
                                    cr.MGR_2_Approved__c = w.varApproved;	
                            	}
                            }		
                			if (cr.VPWF1__c == true ) {
                			    cr.VP_Approver__c = Label.DAL_VP;
                			}						
                    	}	
                        System.debug('FindApprover + Customer Update +  Status__c:...' + cr.Status__c);
                        System.debug('FindApprover + Customer Update + MGR_Approver_1__c:...' + cr.MGR_Approver_1__c);
                        System.debug('FindApprover + Customer Update + MGR_Approver_2__c:...' + cr.MGR_Approver_2__c);
                        System.debug('FindApprover + Customer Update + Approver2__c:...' + cr.Approver2__c);
                        System.debug('FindApprover + Customer Update + Approver1__c:...' + cr.Approver1__c);
                        
                    } else if (cr.RECORDTYPEID == Label.CR_New_Customer_RT) {
                        
                        cr.RSM_WF1__c = True;
                        cr.MGR_WF1__c = TRUE;     
                        
                        for (SSC__C s: sscOLDMap.values()) {
                            sscOLDMap.put(s.Id, s);
                        }                   
                        
                    	List <wrapperApproverClass> approvalInfoRSM = checkApprover(cr, sscOLDMap, sscNEWMap, 'RSM');
                    	for (wrapperApproverClass w : approvalInfoRSM) {
                    		cr.Approver2__c = w.varApprover;
                		    cr.RSM_Approved_Date__c = w.varDate;
                		    cr.RSM_Approved__c = w.varApproved;	
                    	}
                    	
                    	List <wrapperApproverClass> approvalInfoMGR1 = checkApprover(cr, sscOLDMap, sscNEWMap, 'MGR1');
                    	for (wrapperApproverClass w : approvalInfoMGR1) {
                    		cr.MGR_Approver_1__c = w.varApprover;
                		    cr.MGR_1_Approved_Date__c = w.varDate;
                		    cr.MGR_1_Approved__c = w.varApproved;	
                    	}			                        	
                    	
                        System.debug('FindApprover + New Customer + Status__c:...' + cr.Status__c);
                        System.debug('FindApprover + New Customer + MGR_Approver_1__c:...' + cr.MGR_Approver_1__c);
                        System.debug('FindApprover + New Customer + MGR_Approver_2__c:...' + cr.MGR_Approver_2__c);
                        System.debug('FindApprover + New Customer + Approver2__c:...' + cr.Approver2__c);
                        System.debug('FindApprover + New Customer + Approver1__c:...' + cr.Approver1__c);
                        
                    }
                    listRequestWithApprovers.add(cr);
                }
            } else {
                System.debug('Already ran!');
            }
        }
    }


    public static void updateStatus () {

        // ==========================================================
        // Here we determine what the status should be
        // Based off who has approved the record so far
        // And who has indicated as being the next approver
        // ==========================================================

        List <Change_Request__c> listNewCR = new List <Change_Request__c> ();
        for (SObject so : trigger.new) {
            Change_Request__c theCR = (Change_Request__c)so;
            listNewCR.add(theCR);
        }
        List <Change_Request__c> listRequestsWithOptions = new List <Change_Request__c> ();
        for (Change_Request__c cr: listNewCR) {
            System.debug( ' :::updateStatus + 1) cr.Status__c: >' + cr.Status__c);
            System.debug( ' :::updateStatus + 1) MGR_WF1__c ::::> ' + CR.MGR_WF1__c);   
            System.debug( ' :::updateStatus + 1) MGR_1_Approved__c ::::> ' + CR.MGR_1_Approved__c);      
            System.debug( ' :::updateStatus + 1) MGR_WF2__c ::::> ' + CR.MGR_WF2__c);           
            System.debug( ' :::updateStatus + 1) MGR_2_Approved__c ::::> ' + CR.MGR_2_Approved__c);      
            System.debug( ' :::updateStatus + 1) RSM_WF1__c ::::> ' + CR.RSM_WF1__c);    
            System.debug( ' :::updateStatus + 1) RSM_Approved__c ::::> ' + CR.RSM_Approved__c);      
            System.debug( ' :::updateStatus + 1) RVPWF1__c ::::> ' + CR.RVPWF1__c);      
            System.debug( ' :::updateStatus + 1) RVP_Approved__c ::::> ' + CR.RVP_Approved__c);      
            List <Change_Request__c> listRequestsWithStatus = new List <Change_Request__c> ();
            if (cr.RECORDTYPEID == Label.CR_Customer_Update_RT) {
                if (cr.Status__c != 'Submitting for Approval' && cr.Status__c != 'Submitted to Support Team' && cr.Status__c != 'Source System Updated' && cr.Status__c != 'SFDC Updated' && cr.Status__c != 'Not Submitted' && cr.Status__c != 'Creating' && cr.Status__c != 'Rejected') {
                    if (cr.MGR_WF1__c == TRUE && cr.MGR_1_Approved__c != TRUE) { 
        				cr.Status__c = 'Submitted-Pending MGR Approval';
        				cr.Current_Approver__c = cr.MGR_Approver_1__c;
        				cr.MGR_1_For_Approval_Date__c = System.TODAY(); 
        			} else if (cr.MGR_WF2__c == TRUE && cr.MGR_2_Approved__c != TRUE) { 
                        if (cr.MGR_Approver_2__c != cr.MGR_Approver_1__c) {
                            cr.Status__c = 'Submitted-Pending MGR Approval';
                            cr.Current_Approver__c = cr.MGR_Approver_2__c;
                            cr.MGR_2_For_Approval_Date__c = System.TODAY();
                        } else if (cr.RVPWF1__c == TRUE && cr.RVP_Approved__c != TRUE) { 
                            cr.Status__c = 'Submitted-Pending RVP Approval';
                            cr.Current_Approver__c = cr.Approver1__c;
                            cr.RVP_For_Approval_Date__c = System.TODAY();  
                            cr.MGR_2_Approved__c = TRUE;
                        }
        			} else if (cr.RSM_WF1__c == TRUE && cr.RSM_Approved__c != TRUE) { 
        				cr.Status__c = 'Submitted-Pending RSM Approval';
        				cr.Current_Approver__c = cr.Approver2__c;
                        cr.RSM_For_Approval_Date__c = System.TODAY();
        			} else if (cr.RVPWF1__c == TRUE && cr.RVP_Approved__c != TRUE) { 
                        if (cr.Approver1__c != cr.Approver2__c) {
                            cr.Status__c = 'Submitted-Pending RVP Approval';
                            cr.Current_Approver__c = cr.Approver1__c;
                            cr.RVP_For_Approval_Date__c = System.TODAY();      			        
                        } else {
                            // cr.Status__c = 'Approved';
                            cr.RVP_Approved_Date__c = System.TODAY();      
                            cr.RVP_Approved__c = true;
                        }
			        } else if (cr.VPWF1__c == true && cr.VP_Approved__c != TRUE && cr.RVP_Approved__c == TRUE) {
    				    //
    			    } else if (cr.Status__c == 'Approved' && cr.VPWF1__c != true) {			
        			     if (cr.VPWF1__c != true) {     			        
            				cr.Status__c = 'Submitted to Support Team';
            				cr.Current_Approver__c = null;
                            cr.Submitted_To_Support_Date__c = System.TODAY();  
        			     }
        			} else { 
        			    System.debug( ' :::updateStatus there is some sort of isssue, were ending this now::::> ');  
        				cr.Status__c = 'Submitted to Support Team';
        				cr.Current_Approver__c = null;
                        cr.Submitted_To_Support_Date__c = System.TODAY();
        			}
                }               
            } else if (cr.RECORDTYPEID == Label.CR_New_Customer_RT) {
                if (cr.Status__c != 'Submitting for Approval' && cr.Status__c != 'Submitted to Support Team' && cr.Status__c != 'Source System Updated' && cr.Status__c != 'SFDC Updated' && cr.Status__c != 'Not Submitted' && cr.Print_Complete__c != TRUE && cr.Status__c != 'Rejected') {
                    if (cr.MGR_WF1__c == TRUE && cr.MGR_1_Approved__c != TRUE) {
                        if (cr.OwnerId == cr.MGR_Approver_1__c) {
    					    cr.Current_Approver__c = cr.Approver2__c;
                            cr.MGR_1_Approved_Date__c = System.TODAY();
                            cr.MGR_1_Approved__c = TRUE;
                            cr.Status__c = 'Submitted-Pending RSM Approval';
                        } else {
    					cr.Status__c = 'Submitted-Pending MGR Approval';
    					cr.Current_Approver__c = cr.MGR_Approver_1__c;
    				    }
    				} else if (cr.RSM_WF1__c == TRUE && cr.RSM_Approved__c != TRUE) { 
    					cr.Status__c = 'Submitted-Pending RSM Approval';
    					cr.Current_Approver__c = cr.Approver2__c;
    				} else { 
    					cr.Status__c = 'Submitted to Support Team';
    					cr.Current_Approver__c = null;
    				}
                }
            }    
            System.debug( ' :::updateStatus + end) Status__c ::::> ' + CR.Status__c);              
        // return listRequestsWithStatus;
        }
    }    

    public static void updateOptions () {
        System.debug('findApprover + trigger.new:...' + trigger.new);
        List <Change_Request__c> listNewCR = new List <Change_Request__c> ();
        for (SObject so : trigger.new) {
            Change_Request__c theCR = (Change_Request__c)so;
            listNewCR.add(theCR);
        }
        List <Change_Request__c> listRequestsWithOptions = new List <Change_Request__c> ();
        for (Change_Request__c cr: listNewCR) {
            if (cr.RECORDTYPEID == Label.CR_Customer_Update_RT) {
                IF(cr.Sales_Representative_n__c != NULL
                     && cr.Customer_Class_n__c == NULL
                     && cr.Address2__c == NULL
                     && cr.Bill_Country_N__c == NULL
                     && cr.Billing_City_N__c == NULL
                     && cr.Billing_State_N2__c == NULL
                     && cr.Billing_Street_N__c == NULL
                     && cr.Billing_Zip_N__c == NULL
                     && cr.Contact__c == NULL
                     && cr.Country_N2__c == NULL
                     && cr.Customer_Class_N__c == NULL
                     && cr.Customer_Name_Change__c == NULL
                     && cr.Customer_Type_N__c == NULL
                     && cr.DBA_Name__c == NULL
                     && cr.Fax_N__c == NULL
                     && cr.New_Class_Description__c == NULL
        //                         && cr.Region_n__c == NULL
                     && cr.Ship_To_Phone__c == NULL
                     && cr.Shipping_Address_2__c == NULL
                     && cr.Shipping_City__c == NULL
                     && cr.Shipping_State_N2__c == NULL
                     && cr.Shipping_street__c == NULL
                     && cr.Shipping_Zip_N__c == NULL
                     && cr.SSC_N__c == NULL
                     && cr.Suffix_N__c == NULL) {
                    cr.Territory_Assignment_Change_Only__c = TRUE;
                }
        
                if (cr.Copy_Bill_To_Address__c == TRUE) {
                    cr.Shipping_street__c = cr.Billing_Street_N__c;
                    cr.Shipping_Address_2__c = cr.Address2__c;
                    cr.Address3__c = cr.Address_3_N__c;
                    cr.Country_N2__c = cr.Bill_Country_N__c;
                    cr.Shipping_City__c = cr.Billing_City_N__c;
                    cr.Shipping_State_N2__c = cr.Billing_State_N2__c;
                    cr.Shipping_Zip_N__c = cr.Billing_Zip_N__c;
                }
            } else if (cr.RECORDTYPEID == Label.CR_New_Customer_RT) {
                if (cr.Copy_Bill_To_Address__c == TRUE) {
                    cr.Country_N2__c = cr.Bill_Country_N__c;
                    cr.Billing_Street__c = cr.Billing_Street_N__c;
                    cr.Shipping_Address_2__c = cr.Address2__c;
                    cr.Billing_City__c = cr.Billing_City_N__c;
                    cr.Shipping_State_N2__c = cr.Billing_State_N2__c;
                    cr.Shipping_Zip_N__c = cr.Billing_Zip_N__c;
                }        
            }
        }
    }
    
    public static List <Case> updateCase (map<Id,SObject> newMap, map<Id,SObject> oldMap) {
        
        Id oldIdKeySet = (new list<ID>(oldMap.keySet())[0] );
        Change_Request__c oldRequest = (Change_Request__c)oldMap.get(oldIdKeySet);
        Change_Request__c oldCR = (Change_Request__c) oldRequest;  
        Id newIdKeySet = (new list<ID>(newMap.keySet())[0] );
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        Change_Request__c newRequest = (Change_Request__c)newMap.get(newIdKeySet);
        Change_Request__c newCR = (Change_Request__c) newRequest;  
        
        List <Case> listCase = new List <Case> ();
        List <Account> listAccount = new List <Account> ();
        List <Case> listUpdateCase = new List <Case> ();

        System.debug( ' :::updateCase + oldCR.DM_New_Acct_Nbr__c ::::> ' + oldCR.DM_New_Acct_Nbr__c); 
        System.debug( ' :::updateCase + newCr.DM_New_Acct_Nbr__c ::::> ' + newCr.DM_New_Acct_Nbr__c); 
        System.debug( ' :::updateCase + newCr.Case__c ::::> ' + newCr.Case__c); 

        // if (newCr.DM_New_Acct_Nbr__c != oldCR.DM_New_Acct_Nbr__c && !String.isBlank(newCr.DM_New_Acct_Nbr__c)) {        
        if (newCr.New_Account__c != oldCR.New_Account__c && newCr.New_Account__c != null) {
            listAccount = [SELECT ID, DW_ID__c FROM Account WHERE ID = : newCr.New_Account__c];
            if (newCr.Case__c != null) {
            
                listCase = [SELECT ID
                                , AccountId
                                , ProExchange_Status__c
                                , AccountNumber__c
                            FROM Case
                            WHERE ID = :newCr.Case__c];
                            
                for (Case c : listCase ) {
                    if (String.isBlank(c.AccountNumber__c)) {
                        for (Account a : listAccount) {
                            c.AccountNumber__c = a.DW_ID__C;
                        }
                    }
                    c.AccountId = newCr.New_Account__c; 
                    c.ProExchange_Status__c = 'Customer Account Created';           
                    listUpdateCase.add(c);
                }
            } else if (newCr.Set_Up_In_ProExchange__c == true) {
                Case c = new Case();
                c.Subject = 'New ProExchange User Request';
                c.RecordTypeId = varProExchangeRecordType;
                c.First_Name__c = newCr.Contact_First_Name__c;
                c.Last_Name__c = newCr.Contact_Last_Name__c;         
                c.Email_Address__c = newCr.Contact_Email__c;
                c.Phone_Number__c = newCr.Phone__C;             
                c.ProExchange_Status__c = 'Customer Account Created';
                // c.AccountNumber__c = newCr.DM_New_Acct_Nbr__c;
                for (Account a : listAccount) {
                    c.AccountNumber__c = a.DW_ID__C;
                }
                c.AccountId = newCr.New_Account__c;
                c.Add_New_Account__c = true;
                c.Origin = 'Customer Request';
                listUpdateCase.add(c);
            }
        }
        
        System.debug( ' :::updateCase + listUpdateCase ::::> ' + listUpdateCase);       
        
        return listUpdateCase;
    }
    
    public static List <Account> updateAccount (map<Id,SObject> newMap, map<Id,SObject> oldMap) {
        
        Id oldIdKeySet = (new list<ID>(oldMap.keySet())[0] );
        Change_Request__c oldRequest = (Change_Request__c)oldMap.get(oldIdKeySet);
        Change_Request__c oldCR = (Change_Request__c) oldRequest;  
        System.debug( ' :::updateAccount + oldCR.New_Account__c ::::> ' + oldCR.New_Account__c); 
        
        Id newIdKeySet = (new list<ID>(newMap.keySet())[0] );
        Change_Request__c newRequest = (Change_Request__c)newMap.get(newIdKeySet);
        Change_Request__c newCR = (Change_Request__c) newRequest;  
        System.debug( ' :::updateAccount + newCr.New_Account__c ::::> ' + newCr.New_Account__c); 
        
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        
        List <Account> listAccount = new List <Account> ();
        List <Case> listCase = new List <Case> ();
        List <Account> listUpdateAccount = new List <Account> ();

        if (newCr.New_Account__c != oldCR.New_Account__c && newCr.New_Account__c != null) {

            listCase = [SELECT ID
                            , AccountId
                            , ProExchange_Status__c
                            , AccountNumber__c
                            , Origin 
                        FROM Case
                        WHERE Id = :newCr.Case__c];
                        
            listAccount = [SELECT ID
                            , DW_ID__c
                            , Created_by_PE__c
                        FROM Account
                        WHERE ID = :newCr.New_Account__c];
                        
            for (Account a : listAccount ) {
                for (Case c : listCase ) {
                    if ( c.Origin == 'Web Customer Request') {
                        a.Created_by_PE__c = true;
                        listUpdateAccount.add(a);
                    }
                }
            }
        }
        
        System.debug( ' :::updateAccount + listUpdateAccount ::::> ' + listUpdateAccount);       
        
        return listUpdateAccount;
    }

}