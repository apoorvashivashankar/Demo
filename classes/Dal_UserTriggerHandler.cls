/**
 * Created by lucassoderstrum on 4/20/18.
 */

public with sharing class Dal_UserTriggerHandler {

    public static void generateSharing(list <User> users){
        Map <String, set<Id>> groupKeyToAccount = new Map <String, set<Id>>();
        Map <User, String> userToGroupKey = new Map <User, String>();
        set <String> allGroupKeys = new set <String>();
        list <AccountShare> sharesToInsert = new list <AccountShare>();

        for (User us:users){
            if (us.Share_All_Group_Accounts__c == true){
                userToGroupKey.put(us, us.Primary_Account_Group_Key__c);
                allGroupKeys.add(us.Primary_Account_Group_Key__c);
            }
        }

        system.debug('users: ' + users);

        if(userToGroupKey.size() > 0){

            // create a map of Group Keys to Accounts (with matching Group Key).  This will be used later on to create each AccountShare record
            for (Account acc: [Select Id, GroupKey__c
                                FROM Account
                                WHERE GroupKey__c in :allGroupKeys]){

                if (groupKeyToAccount.containsKey(acc.GroupKey__c)) {
                    groupKeyToAccount.get(acc.GroupKey__c).add(acc.Id);
                } else {
                    groupKeyToAccount.put(
                            acc.GroupKey__c,
                            new Set<Id>{
                                    acc.Id
                            }
                    );
                }
            }

            system.debug('groupKeyToAccount: ' + groupKeyToAccount);

            // loop through each user, then through each Account with a Group Key that matches the User's account.  Create AccountShare for each
            for(User us:userToGroupKey.keySet()){
                for (Id accId:groupKeyToAccount.get(us.Primary_Account_Group_Key__c)){
                    AccountShare accShare = new AccountShare(AccountId=accId, userorgroupid=us.Id, accountaccesslevel='Read',
                                                            OpportunityAccessLevel='Read');
                    sharesToInsert.add(accShare);
                }
            }

            system.debug('sharesToInsert: ' + sharesToInsert);

            if (!Peak_Utils.isNullOrEmpty(sharesToInsert)){
                String jsonAccountShares = JSON.serialize(sharesToInsert);
                insertShareRecords(jsonAccountShares);
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