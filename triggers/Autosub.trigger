/* This Trigger is responsible for following
 * Auto submit CR based on the record type and RVPWF1,RSMWF1 fields.  
 */




trigger Autosub on Change_Request__c (after update,after insert) {
 
     
     IF(TRIGGER.ISUPDATE)
     
     {
     CHANGE_REQUEST__C CR = TRIGGER.new[0];  
     
         
     IF(CR.GONE_THROUGH_APPROVAL_PROCESS__C!=TRUE&&CR.Skip_Customer_change_WF__c==FALSE){
     IF(CR.RECORDTYPEID==Label.CR_Customer_Update_RT&&(CR.RVPWF1__c!=FALSE||CR.RSM_WF1__c!=FALSE)&&(CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL))
      {
            // create the new approval request to submit for Customer update RT
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(CR.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
                      System.debug('Submitted for approval successfully: '+result.isSuccess());
      }
        }
          }

    IF(TRIGGER.ISINSERT){
    CHANGE_REQUEST__C CR = TRIGGER.NEW[0];  
  
      IF(CR.Skip_Customer_change_WF__c==FALSE&&CR.RECORDTYPEID==Label.CR_New_Customer_RT&&(CR.APPROVER1__C!=NULL||CR.APPROVER2__C!=NULL))
      {
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(Trigger.new[0].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            
            System.debug('Submitted for approval successfully: '+result.isSuccess());
           }
             }

    }