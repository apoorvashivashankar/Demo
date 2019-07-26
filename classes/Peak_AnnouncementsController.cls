// ===================
// Peak Announcements Controller
// ===================
public with sharing class Peak_AnnouncementsController {

    // Get the current community's name
    @AuraEnabled
    public static String getCommunityName() {
        // Get the Community ID and associated name
        Id networkId = System.Network.getNetworkId();
        List<Network> communityResults = [SELECT Name FROM Network WHERE Id = :networkId];
        String communityName;
        if(communityResults != null && !communityResults.isEmpty() && communityResults[0] != null) {
            communityName = communityResults[0].Name;
        }
        return communityName;
    }

    // Get the Network ID
    @AuraEnabled
    public static String getNetworkId() {
        return System.Network.getNetworkId();
    }


    // Get the logged in user's ID
    @AuraEnabled
    public static String getUserId() {
        return UserInfo.getUserId();
    }

    // Get the announcements
    @AuraEnabled
    public static Peak_Response getActiveAnnouncements(String numResultsString, String displayChannelString, String displayTypeString, String hiddenAnnouncementString) {
        Peak_Response response = new Peak_Response();

        // Get the selected query limit
        Integer queryLimit = Integer.valueOf(numResultsString);
        // If the user entered 0 or less, we want to set this to "unlimited" results.
        if (queryLimit <= 0) {
            queryLimit = 10000;
        }

        // Get the selected channel to display
        String displayChannel = displayChannelString;

        // Get the selected type of announcement to display
        String displayType;
        // If the announcement is set to all, we want to grab everything, otherwise filter.
        if (displayTypeString == 'All') {
            displayType = '%';
        } else {
            displayType = displayTypeString;
        }

        // Get the announcements to hide, based on user's cookies
        List<String> hiddenAnnouncements = new List<String>();
        if (hiddenAnnouncementString == null) {
            hiddenAnnouncements.add('');
        } else {
            hiddenAnnouncements = hiddenAnnouncementString.split(',');
        }

                // Get the Community Name
        String communityName = getCommunityName();

        // Perform the query
        List<Community_Announcement__c> activeAnnouncements = [SELECT Announcement_Body__c, Announcement_Call_to_Action__c, Announcement_Type__c, Announce_to_Community__c, Announcement_Channel__c, Announcement_Dismissible__c, Announcement_URL__c, CreatedById, End_Date_Time__c, Id, Name, Owner.Name, Start_Date_Time__c
            FROM Community_Announcement__c
            WHERE (Start_Date_Time__c < :DateTime.now() AND End_Date_Time__c > :DateTime.now())
                AND Announce_to_Community__c includes ('All',:communityName)
                AND Announcement_Channel__c includes ('All',:displayChannel)
                AND Announcement_Type__c LIKE :displayType
                AND Id NOT IN :hiddenAnnouncements
            ORDER BY Order__c, Start_Date_Time__c DESC
            LIMIT :queryLimit
        ];

        response.results = activeAnnouncements;

        return response;

    }
    // Get the site prefix (for displaying links/assets)
    @AuraEnabled
    public static String getSitePrefix(){
        return Peak_Utils.getSitePrefix();
    }
}