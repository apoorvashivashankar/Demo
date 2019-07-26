/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francoiskorb on 10/10/16.
 */

global with sharing class SVNSUMMITS_Ideas_Common {
    // Set the down voting flag in Custom Settings
    // Enabled by default
    @AuraEnabled
    global Boolean allowDownVoting {
        get;
        private set;
    }

    @AuraEnabled
    global Boolean debugMode {
        get;
        private set;
    }

    @AuraEnabled
    global String portalAccountId {
        get;
        private set;
    }

    private void getCustomSettings() {
        // disabled by default
        Boolean mode = false;

        try {

            Ideas_Settings__mdt settings = [SELECT Allow_Down_Voting__c, Debug_Mode__c, PORTAL_ACCOUNT_ID__c FROM Ideas_Settings__mdt LIMIT 1];

            if (settings != null) {
                this.debugMode = settings.Debug_Mode__c;
                this.allowDownVoting = settings.Allow_Down_Voting__c;
                this.portalAccountId = settings.PORTAL_ACCOUNT_ID__c;
            }
        } catch (Exception e) {
            System.debug(e);
        }

    }

    global SVNSUMMITS_Ideas_Common() {
        getCustomSettings();
    }
}