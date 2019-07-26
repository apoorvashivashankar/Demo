global class deleteDeadOpps implements Database.Batchable < SObject >, Database.Stateful{

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
	global deleteDeadOpps() {
        deleteName = '%DELETE%';
        queryDelete = 'SELECT id,NAME,(SELECT Id FROM OpportunityLineItems),LastModifiedDate,CreatedDate FROM Opportunity WHERE NAME LIKE \'%'  + deleteName + '%\' ';
	}
	// "Start" runs when the class in instanciated 
	global Database.QueryLocator start(Database.BatchableContext bcMain) {
		return Database.getQueryLocator(queryDelete);
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
		AsyncApexJob aaJob = [SELECT NumberOfErrors, TotalJobItems FROM AsyncApexJob WHERE Id = : bcMain.getJobId()];
//		if (aaJob.NumberOfErrors > 0) {
			Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
			semResult.setToAddresses(new String[]{
				strResultEmail
			});
			semResult.setSubject('Error in Scheduled APEX');
			semResult.setPlainTextBody('Processed ' + aaJob.TotalJobItems + ' batches with ' + aaJob.NumberOfErrors + ' failures.');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
//		}
	} 
}