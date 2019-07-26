global class AccountShareUserToLocationBatch implements Database.Batchable < SObject >, Database.Stateful{

    global String queryGeneric;
    global List < AccountShare > listScopeRecords;

    // Class Constructor - set query string
    global AccountShareUserToLocationBatch () {
        // find the latest AcountShare records 
        queryGeneric = 'SELECT AccountId,Account.DW_ID__c,UserOrGroupId,Id FROM AccountShare WHERE UserOrGroupId != NULL AND AccountId != NULL AND UserOrGroup.Type != \'Queue\' AND (RowCause = \'Manual\' OR RowCause = \'ImplicitParent\') AND UserOrGroupId IN ( SELECT ID FROM User WHERE IsActive = TRUE AND ContactId != NULL)';
    }
    
    // "Start" runs when the class in instanciated 
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQueryLocator(queryGeneric);
    }
    
    // "Execute" is what is being run as a separate process per batch
    global void execute(Database.BatchableContext bcMain, List < AccountShare> listBatchRecords) {
        listScopeRecords = listBatchRecords;
        List < User_to_Location__c > listRecordsToUpdate = new List < User_to_Location__c > ();
        for (AccountShare c: listScopeRecords) {    
            User_to_Location__c ul = new User_to_Location__c ();
            ul.Account__c = c.AccountId;
            ul.User__c = c.UserOrGroupId;
            String varKey = c.UserOrGroupId + '.' + c.AccountId;
            ul.User_to_Location_Key__c = varKey;
            listRecordsToUpdate.add(ul);
            // System.debug('AccountShareUserToLocationBatch + c.Account.DW_ID__c...' + c.Account.DW_ID__c + '... + c.UserOrGroupId:...' + c.UserOrGroupId);
        }
        if (listRecordsToUpdate.size() > 0) {
            Schema.SObjectField k = User_to_Location__c.Fields.User_to_Location_Key__c;
            Database.upsert(listRecordsToUpdate, k, false);
        }    
    }
    
    global void finish(Database.BatchableContext bcMain) {
        UserToLocationAccountShareBatch clsUserToLocationBatch = new UserToLocationAccountShareBatch(); 
        ID idBatch = Database.executeBatch(clsUserToLocationBatch ,  2000 );       
    }
}