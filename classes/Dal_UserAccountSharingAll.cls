/**
 * Created by jon rust on 6/13/18.
 */

public with sharing class Dal_UserAccountSharingAll {

    public static void generateSharing(){
        Map <String, set<Id>> groupKeyToAccount = new Map <String, set<Id>>();
        Map <User, String> userToGroupKey = new Map <User, String>();
        set <String> allGroupKeys = new set <String>();
        list <AccountShare> sharesToInsert = new list <AccountShare>();
        list <User> listUsersWithSharing = new list <User>();
		listUsersWithSharing = [
			SELECT Id, Share_All_Group_Accounts__c, Primary_Account_Group_Key__c
			FROM User
			WHERE Share_All_Group_Accounts__c = TRUE
		];

        for (User us:listUsersWithSharing){
            if (us.Share_All_Group_Accounts__c == true){
                userToGroupKey.put(us, us.Primary_Account_Group_Key__c);
                allGroupKeys.add(us.Primary_Account_Group_Key__c);
            }
        }

        system.debug('listUsersWithSharing: ' + listUsersWithSharing);

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
            try{
            for(User us:userToGroupKey.keySet()){
                for (Id accId:groupKeyToAccount.get(us.Primary_Account_Group_Key__c)){
                    AccountShare accShare = new AccountShare(AccountId=accId, userorgroupid=us.Id, accountaccesslevel='Read',
                                                            OpportunityAccessLevel='Read');
                    sharesToInsert.add(accShare);
                }
            }
			
            system.debug('sharesToInsert: ' + sharesToInsert);
            }catch(Exception e){
                System.debug('ERROR:' + e);
            }
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