global class deleteDeadOppsGeneric implements Database.Batchable < SObject >, Database.Stateful{

	global String glstrQuery;
	global String queryGeneric;
	global String queryDelete;
	global String genericName;
	global String deleteName;
	global List < Opportunity > gllstScopeRecords;
	global List < Opportunity > deleteGenericOpps;
	global List < Opportunity > deleteDeleteOpps;
	global List < Opportunity > deleteDeadOppsFull;
	
	// Class Constructor - set query string
	global deleteDeadOppsGeneric() {
        genericName = '%- Product Selection -%';
        queryGeneric = 'SELECT id,NAME,(SELECT Id FROM OpportunityLineItems),LastModifiedDate,CreatedDate FROM Opportunity WHERE NAME LIKE \'%'  + genericName + '%\'  AND Is_Un_Modified__c = TRUE AND Id NOT IN ( SELECT OpportunityId FROM OpportunityLineItem )';
	}
	// "Start" runs when the class in instanciated 
	global Database.QueryLocator start(Database.BatchableContext bcMain) {
		return Database.getQueryLocator(queryGeneric);
	}
	// "Execute" is what is being run as a separate process per batch
	global void execute(Database.BatchableContext bcMain, List < Opportunity > lstBatchRecords) {
		gllstScopeRecords = lstBatchRecords;
		List < Opportunity > lstRecordsToUpdate = new List < Opportunity > ();
		for (Opportunity o: gllstScopeRecords) {		
			lstRecordsToUpdate.add(o);
		}
		if (lstRecordsToUpdate.size() > 0) {
			delete lstRecordsToUpdate;
		}
	}
	// Finish the Batch Job
	global void finish(Database.BatchableContext bcMain) {
		// Optional - you can send an email to an admin with results
		String strResultEmail = 'jon.rust@daltile.com';
		AsyncApexJob aaJob = [SELECT NumberOfErrors, TotalJobItems, ApexClass.Name FROM AsyncApexJob WHERE Id = : bcMain.getJobId()];
 //		if (aaJob.NumberOfErrors > 0) {
			Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
			semResult.setToAddresses(new String[]{
				strResultEmail
			});
			semResult.setSubject('Completed Scheduled APEX : ' + aaJob.ApexClass.Name);
			semResult.setPlainTextBody('Processed ' + aaJob.TotalJobItems + ' batches with ' + aaJob.NumberOfErrors + ' failures.  Here is what got processed...' + gllstScopeRecords);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
 		}
//	} 
}