global class UserToLocationAccountShareBatch implements Database.Batchable < SObject >, Database.Stateful{

    global String queryGeneric;
    global List < User_to_Location__c > listScopeRecords;

    // Class Constructor - set query string
    global UserToLocationAccountShareBatch () {
        // find the latest AcountShare records
        queryGeneric = 'SELECT Account__c,User__c,Id FROM User_to_Location__c WHERE User__r.IsActive = true AND Account__c != null';

    }
    
    // "Start" runs when the class in instanciated 
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        // System.debug('UserToLocationAccountShareBatch + start + queryGeneric:...' + queryGeneric);
        return Database.getQueryLocator(queryGeneric);
    }
    
    // "Execute" is what is being run as a separate process per batch
    global void execute(Database.BatchableContext bcMain, List < User_to_Location__c> listBatchRecords) {
        // System.debug('UserToLocationAccountShareBatch + execute + listBatchRecords:...' + listBatchRecords);
        listScopeRecords = listBatchRecords;
        List < AccountShare > listRecordsToUpdate = new List < AccountShare > ();
        for (User_to_Location__c c: listScopeRecords) {    
            AccountShare accShare = new AccountShare(AccountId=c.Account__c, userorgroupid=c.User__c, accountaccesslevel='Read', OpportunityAccessLevel='Read');
            listRecordsToUpdate.add(accShare);
        }
        if (listRecordsToUpdate.size() > 0) {
            // System.debug('UserToLocationAccountShareBatch + execute + listRecordsToUpdate:...' + listRecordsToUpdate);
            Database.insert(listRecordsToUpdate);
        }    
    }
    
    global void finish(Database.BatchableContext bcMain) {
    
    }
}