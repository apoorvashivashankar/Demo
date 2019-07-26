/**
 * Created by lucassoderstrum on 4/26/18.
 */

public with sharing class Dal_UserAccountSharingController {

    private ApexPages.StandardController standardController;

    public Dal_UserAccountSharingController(ApexPages.StandardController standardController) {
        this.standardController = standardController;
    }

    public void createSharing() {
        Id recordId = standardController.getId();
        list <User> users = [
                Select Primary_Account_Group_Key__c, Share_All_Group_Accounts__c
                FROM User
                WHERE Id = :recordId
        ];

        Dal_UserTriggerHandler.generateSharing(users);
    }
}