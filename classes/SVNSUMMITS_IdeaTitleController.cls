/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaTitleController {


    global SVNSUMMITS_IdeaTitleController() {


    }


     @AuraEnabled
    global static Boolean isAuthenticated() {
        return !Auth.CommunitiesUtil.isGuestUser();
    }


    /*
        Name : getSitePrefix
        Description: This method is used for getting the site prefix

    */
    @AuraEnabled
    global static String getSitePrefix(){
        return System.Site.getPathPrefix();
    }

    /*
        Name : getZoneId
        Description: This method is used for getting the CommunityId

    */
     @AuraEnabled
    global static String getZoneId(String nameValue) {
    	if(!String.isEmpty(nameValue))
    	{
    		List<Community> currCommunity = [Select Id FROM Community WHERE Name = :nameValue];
    		if(currCommunity != null && currCommunity.size() > 0)
    		{
    			return currCommunity[0].Id;
    		}
    		else
    		{
    			return '';
    		}
    	}
    	else
    	{
    		return '';
    	}
    }


    /*
        Name : getIdea
        Description: This method is used for getting the Idea record detail

    */
     @AuraEnabled
    global static Idea getIdea(String recordId, String zoneId) {

        Idea currIdea = new Idea();
        try {

            Id recordIdValue = Id.valueOf(recordId);
            Id zoneIdValue = Id.valueOf(zoneId);
            if(zoneIdValue != null && recordIdValue != null) {

                List<Idea> currIdeaList = [SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.CreatedDate, CreatedById, CreatorSmallPhotoUrl, CreatedDate, Categories, VoteTotal, attachmentName, NumComments, Related_Topic_Name__c, Body FROM Idea WHERE Id =: recordId AND communityId = :zoneIdValue];
                if(currIdeaList.size() > 0) {

                    currIdea = currIdeaList[0];
                }
            }
        } catch(Exception e) {
           System.debug(e);
        }

        return currIdea;

    }

}