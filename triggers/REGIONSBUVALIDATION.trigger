trigger REGIONSBUVALIDATION on Change_Request__c (BEFORE INSERT, BEFORE UPDATE) {
 
CHANGE_REQUEST__C CR11=TRIGGER.NEW[0];

	IF(TRIGGER.ISINSERT) {
		List<REGION__C> lstRegion = [SELECT SBU__C FROM REGION__C WHERE ID=:CR11.REGION__C];
		REGION__C R = new REGION__C();
		if (!lstRegion.isEmpty() ) {
			R = lstRegion[0];
			}
		IF(	CR11.RecordTypeId==Label.CR_New_Customer_RT&&	CR11.REGION__c !=null&&	CR11.SBU_N2__c!=null&&	R.SBU__c!=null&&	CR11.SBU_N2__c.TOUPPERCASE()!=R.SBU__c.TOUPPERCASE()	)
		{	CR11.ADDERROR('SBU value is not matching with selected Region SBU.  Please check once and save the record');
			}
	}
	IF(TRIGGER.ISUPDATE){ 
		List<REGION__C> lstRegion1 =[SELECT SBU__c FROM REGION__C WHERE ID=:CR11.REGION_N__C];
		REGION__C R1 = new REGION__C();
		if (!lstRegion1.isEmpty() ) {
			R1 = lstRegion1[0];
			}
		If( CR11.RECORDTYPEID==Label.CR_Customer_Update_RT&&  CR11.REGION_N__c !=NULL&&	CR11.SBU_N2__c!=NULL&&	R1.SBU__c <>NULL&&	R1.SBU__c.TOUPPERCASE() <>CR11.SBU_N2__c.touppercase() 	)

		{	CR11.ADDERROR('SBU value is not matching with selected Region SBU.  Please check once and save the record');
			}
	}
	IF(TRIGGER.ISUPDATE){ 
		If( CR11.RECORDTYPEID==Label.CR_Customer_Update_RT&&  CR11.Customer_Class_N__c !=NULL &&  CR11.Business_Reason__c==Null) 
		{	CR11.ADDERROR('Business Reason must be populated for Class changes.');
			}
	}
}