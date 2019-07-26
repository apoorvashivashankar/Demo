@isTest
Private class testREGIONSUBVALIDATION{

static testMethod void REGIONSBUVALIDATION() {

{ 

      ssc__C s=new ssc__c(Name='asa');
      Insert s;
      REGION__C r = new REGION__C (Name='RGN', SBU__c='SC');
      Insert r;
      Account a = new Account(Name='sss',SBU__c='SC',fax='1234564321',Require_PO__C=false,ssc__c=s.id,REGION__C=r.ID);
      Insert a;
      Customer_Class__c cc = new Customer_Class__c (Name='xxX', CustClass__c='XXX', CustomerSBU__c='SC', Active__c=TRUE);
      Insert cc;

	  
      Account accnt= [select id,name,County__c,Customer_Base__c, Customer_Class__c,phone,
                          Customer_Type__c, DW_ID__c, Fax, Require_PO__c, Salesman__c,
                          SSC__c, Customer_Suffix__c, BillingStreet, BillingCity, BillingState, BillingCountry,
                          Address_3__c, Canada_city__c, SBU__c, Region__c, Shippingstreet, shippingcity, shippingstate,
                          shippingcountry, Canada_postal_code__c, Canada_Province__c
                     from Account where id=:a.ID];
		try 
		    {
		                     Change_Request__c c = new Change_Request__c();
		                     c.RecordtypeId=label.CR_New_Customer_RT;
		                     c.REGION__c =accnt.REGION__c;
		                     c.SBU_N2__c='SC';
		    				 c.ssc__c=accnt.ssc__C;
		    				 c.fax__c=accnt.fax;
		                     C.Skip_Customer_change_WF__c=true;
		                     c.Customer_Class_N__c=cc.id;
		                     c.Business_Reason__c=null;
		                     Insert C;
							 c.SBU_N2__c='DI';
							 Update C;
		 }
		catch(Exception e)
		{
		  
		}
try 
    { 
	  REGION__C r1 = new REGION__C (Name='RG1', SBU__c='DI');
      Insert r1;
	  REGION__C r2 = new REGION__C (Name='RG1', SBU__c='SC');
      Insert r2;
	  ssc__C s1=new ssc__c(Name='bbb');
      Insert s1;
	  ssc__C s2=new ssc__c(Name='bbb');
      Insert s2;
	  Account a1 = new Account(Name='sss1',SBU__c='SC',fax='1234564321',Require_PO__C=false,ssc__c=s1.id,REGION__C=r1.ID);
      Insert a1;
      Customer_Class__c cc1 = new Customer_Class__c (Name='xxX', CustClass__c='XXX', CustomerSBU__c='SC', Active__c=TRUE);
      Insert cc1;
    
      Account accnt1= [select id,name,County__c,Customer_Base__c, Customer_Class__c,phone,
                          Customer_Type__c, DW_ID__c, Fax, Require_PO__c, Salesman__c,
                          SSC__c, Customer_Suffix__c, BillingStreet, BillingCity, BillingState, BillingCountry,
                          Address_3__c, Canada_city__c, SBU__c, Region__c, Shippingstreet, shippingcity, shippingstate,
                          shippingcountry, Canada_postal_code__c, Canada_Province__c from Account where id=:a1.ID];

                     Change_Request__c c1 = new Change_Request__c();
                     c1.RECORDTYPEID=Label.CR_Customer_Update_RT;
                     c1.REGION__c =accnt1.REGION__c;
    				 c1.Business_Reason__c =null;
    				 c1.Customer_Class__c = cc1.id;
                     c1.SBU_N2__c=accnt1.SBU__c;
    				 c1.ssc__c=accnt1.ssc__C;
    				 c1.fax__c=accnt1.fax;
                     C1.Skip_Customer_change_WF__c=true;
                     Insert C1;
					 
    				 c1.RECORDTYPEID=Label.CR_Customer_Update_RT;
					 c1.REGION__c =r2.id;
					 c1.SBU_N2__c=s2.id;
					 c1.fax__c=accnt1.phone;
        			 c1.Customer_Class_N__c=cc1.id;
                     c1.Business_Reason__c='TEST';
    				 Update C1;
    }

catch(Exception e1)
{
	/*
  System.assert( e1.getMessage().contains('SBU value is not matching with selected Region SBU.  Please check once and save the record'), 
                e1.getMessage() );
   System.assert( e1.getMessage().contains('Business Reason must be populated for Class changes.'),
                 e1.getMessage() );*/
}
}
}
}