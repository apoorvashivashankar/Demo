/**
 * Created by lucassoderstrum on 4/23/18.
 */

public with sharing class Dal_AccountTriggerHandler {
    public static void generateSharing(list <Account> accounts){
        Map <String, list<User>> groupKeyToUser = new Map <String, list<User>>();
        Map <Account, String> accountToGroupKey = new Map <Account, String>();
        set <String> allGroupKeys = new set <String>();
        list <AccountShare> sharesToInsert = new list <AccountShare>();

        for (Account acc:accounts){
            if (acc.GroupKey__c != null){
                accountToGroupKey.put(acc, acc.GroupKey__c);
                allGroupKeys.add(acc.GroupKey__c);
            }
        }

        //system.debug('allGroupKeys: ' + allGroupKeys);
        //system.debug('accountToGroupKey: ' + accountToGroupKey);

        if(allGroupKeys.size() > 0) {
            for (User us: [
                    Select Id, Primary_Account_Group_Key__c
                    FROM User
                    WHERE Primary_Account_Group_Key__c in :allGroupKeys]) {
                if (groupKeyToUser.containsKey(us.Primary_Account_Group_Key__c)) {
                    groupKeyToUser.get(us.Primary_Account_Group_Key__c).add(us);
                }
                else {
                    groupKeyToUser.put(us.Primary_Account_Group_Key__c, new list<User>{ us });
                }
            }
            //system.debug('groupKeyToUser: ' + groupKeyToUser);
            if (groupKeyToUser.size() > 0) {
                for (Account acc : accountToGroupKey.keySet()) {
                    if(groupKeyToUser.containsKey(acc.GroupKey__c)){
                        for (User us : groupKeyToUser.get(acc.GroupKey__c)) {
                            AccountShare accShare = new AccountShare(AccountId = acc.Id,
                                                                     userorgroupid = us.Id,
                                                                     accountaccesslevel = 'Read',
                                                                     OpportunityAccessLevel = 'Read');
                            sharesToInsert.add(accShare);
                        }
                    }
                }
                //system.debug('sharesToInsert: ' + sharesToInsert);
                if(!Peak_Utils.isNullOrEmpty(sharesToInsert)) {
                    String jsonAccountShares = JSON.serialize(sharesToInsert);
                    insertShareRecords(jsonAccountShares);
                }
            }
        }
    }
    
    //future method is necessary to avoid mixed-DML exception
    @future
    public static void insertShareRecords(String jsonAccountShares) {
        list <AccountShare> finalSharesToInsert = (list <AccountShare>) JSON.deserialize(jsonAccountShares, List<AccountShare>.class);
        system.debug('finalSharesToInsert: ' + finalSharesToInsert);
        insert finalSharesToInsert;
    }
}