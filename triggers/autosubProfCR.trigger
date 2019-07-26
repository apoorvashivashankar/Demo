trigger autosubProfCR on Profile_Change_Request__c (after insert, after update) {
    boolean hasErrors = false;

    
    IF(TRIGGER.ISINSERT || TRIGGER.ISUPDATE){
    Profile_Change_Request__c PCR = TRIGGER.NEW[0];  
    SSC__c ssc2 = new SSC__c();
    ssc2=[SELECT id,Manager__c,Name, DW_ID__c FROM SSC__c WHERE ID=:PCR.Stone_Center_Name__c LIMIT 1]; 
      IF(PCR.Status__c=='Not Submitted')
      {
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            if (PCR.Current_Inventory_sqft__c!=NULL)
            {
                req.setComments('New Profile Change submitted for approval from ' + ssc2.Name + ' SSC:' + PCR.Stone_Center__c + '.  Request to DROP Current Inventory for Item:' + PCR.Item_Number__c + ' Color: ' + PCR.Color_Description__c + ' to Current Inventory of: ' + PCR.Current_Inventory_sqft__c + '. Please review.');
                req.setObjectId(PCR.Id);
            }
            if (PCR.Current_Inventory_sqft__c==NULL)
            {
                req.setComments('New Profile Change submitted for approval from ' + ssc2.Name + ' SSC:' + PCR.Stone_Center__c + '.  Request to ADD Item: ' + PCR.Item_Number__c + ', Color: ' + PCR.Color_Description__c + ', Thickness/Finish: ' + PCR.Thickness_Finish__c + ', with a Monthly Sales Forecast of ' + PCR.Monthly_Sales_Forecast_sqft__c + '(sqft).  Please review.');
                req.setObjectId(PCR.Id);
            }
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            
            System.debug('Submitted for approval successfully: '+result.isSuccess());
           }

             }
}