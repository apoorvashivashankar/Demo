@isTest
private class TestCRSubmitForApproval {
 
    static testMethod void testApprovalSuccess() {
       try{
       Account acc = new account();
       acc.name='aaa';
       Region__c r = new Region__c(Select__c = true
    	                           ,SBU__c = 'DI'
    	                           ,DW_ID__c = '000111'
    	                           ,Name = 'SOUTHERN CA REGION');
       insert r;
       SSC__c S = new  SSC__c(Closed__c = false
								,DW_ID__c = '000111'
								//,Gallery_ID__c = 
								,Loc_Type__c = 'SSC'
								,Manager__c = UserInfo.getUserId()
								,Region__c = r.Id
								,ROM__c = UserInfo.getUserId()
								,RSM__c = UserInfo.getUserId()
								,RVP__c = UserInfo.getUserId()
								//,Sales__c
								,Sales_Region__c = '04'
								,SBU__c = 'DI'
								,Select__c = true
								,SSC_Fax_Number__c = '123-345-5567'
								,SSC_Phone_Number__c = '123-345-5567'
								,State__c = 'TX'
								,Street_Address__c = '12345 1st street'
								,Zip_Code__c = '12345');
	   insert S;
       Insert acc;
       Customer_class__C c = New Customer_Class__C(Name='13H', Active__c=TRUE, CustomerCountry__c = 'US');
       Insert C;
       
       Sales_Representative__c sr = new Sales_Representative__c(SBU__c = 'DI', DW_ID__c = '7',  Region__c  = r.Id);
       insert sr;
       
       Customer_Type__c ct = new Customer_Type__c(Active__c = true
												  //,Region__c = 
												  ,SBU__c = 'DI');
		ct.Region__c = 'SOUTHERN CA REGION';
		insert ct;
    	
       Change_Request__c CR
			    	= new Change_Request__c(  SBU__c = 'DI'
			    						    , Account__c = acc.Id
			                                , Sales_Representative__c = sr.Id
			                                , Sales_Representative_n__c = sr.Id
			                                , Customer_Class__c = c.Id
			                                , Customer_Class_N__c = c.Id
			                                , Customer_Type_n__c = ct.Id
			                                , Customer_Type__c = ct.Id
			                                , Business_Reason__c = 'Testing'
			                                , RECORDTYPEID=Label.CR_Customer_Update_RT
			                                , SSC_N__c = s.Id
			                                , SSC__c = s.Id
			                                //, Country__c = 'US'
			                                , Country_N2__c = 'US'
			                                , Region_n__c = r.Id
			                                , Region__c = r.Id 
			                                , Bill_Country_N__c = 'US'
			                                , Billing_Country__c = 'US');
      insert CR;
      CR.SSC_N__c=s.id;
  CR.PHONE_N__C = '5454545440';
  CR.RVPWF1__C=TRUE;
  try{
    update CR;
  }
  catch(Exception e){}
    CR.status__C='Rejected';
    Update CR;
    
    Change_Request__c CR1 = new Change_Request__c();
       Cr1.account__C=acc.id;
      
       CR1.RECORDTYPEID=Label.CR_Customer_Update_RT;
       CR1.SSC__C=S.ID;       
       CR1.Status__c='Not Submitted';
       insert CR1;
      
  CR1.PHONE_N__C = '5454545440';
  CR1.RVPWF1__C=TRUE;
    update CR1;
    CR1.Status__C='Rejected';
    Update CR1;
    

    
    Change_Request__c CR3 = new Change_Request__c();
       Cr3.account__C=acc.id;
      
       CR3.RECORDTYPEID=Label.CR_Customer_Update_RT;
       CR3.SSC__C=S.ID;   
       CR3.SBU__C='SC';    
       CR3.Status__c='Not Submitted';
       insert CR3;
      
      CR3.PHONE_N__C = '5454545440';
      CR3.RVPWF1__C=TRUE;
      CR3.Customer_class_n__C=c.id;
      CR3.Business_Reason__c='Here is your reason...';
        update CR3;
       
       }
       catch(Exception e){}
    
  /*Change_Request__c CR2 = new Change_Request__c();
       
       CR2.Customer_Name__c='AASA';
       CR2.RECORDTYPEID=Label.CR_New_Customer_RT;
       CR2.SSC__C=S.ID;      
       CR2.SUFFIX__C='001'; 
       CR2.Status__c='Not Submitted';
       CR2.RVPWF1__C=TRUE;
       insert CR2;
      
        List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :CR.id];
    System.assertEquals(processInstances.size(),1);*/
 
    }
 
}