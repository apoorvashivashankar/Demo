/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaVotersController {

    @AuraEnabled
    global static Boolean isAuthenticated() {
        return !Auth.CommunitiesUtil.isGuestUser();
    }

    @AuraEnabled
    global static Boolean isNicknameDisplayEnabled() {
        Id networkId = System.Network.getNetworkId();
        Boolean isNicknameDisplayEnabled = true;
        try {
        	Network currNetwork = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId LIMIT 1];
        	isNicknameDisplayEnabled = currNetwork.OptionsNicknameDisplayEnabled;
        }catch(Exception e){
        	isNicknameDisplayEnabled = true;
        }

        return isNicknameDisplayEnabled;
    }

    @AuraEnabled
    global static String getSitePrefix(){
        return System.Site.getPathPrefix();
    }

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

    @AuraEnabled
    global static Boolean isValidIdeaId(String ideaId, String zoneId){
        Boolean isValid = true;
        try {

            Id currIdeaId = Id.valueOf(ideaId);
            Id zoneIdValue = Id.valueOf(zoneId);

            Integer countIdeas = [SELECT COUNT() FROM Idea WHERE Id = :currIdeaId AND CommunityId = :zoneIdValue];

            if(countIdeas == 0)
            {
                isValid = false;
            }
        } catch(exception e){
            isValid = false;
        }

        return isValid;
    }

    @AuraEnabled
    global static Integer getTotalVoterCount(String recordId) {
        return [SELECT COUNT()
                FROM Vote
                WHERE ParentId =: recordId
                    AND Type = 'UP'];
    }

    @AuraEnabled
    global static User[] getIdeaVoters(String recordId, Integer numResults) {
        Integer numResultsValue = Integer.valueOf(numResults);
        if(Schema.sObjectType.User.fields.Id.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible() && Schema.sObjectType.User.fields.SmallPhotoUrl.isAccessible() && Schema.sObjectType.User.fields.CommunityNickname.isAccessible()
        && Schema.sObjectType.Vote.fields.Type.isAccessible() && Schema.sObjectType.Vote.fields.ParentId.isAccessible() && Schema.sObjectType.Vote.fields.CreatedById.isAccessible())
        {
        	return [SELECT Id, Name, SmallPhotoUrl, CommunityNickname FROM User WHERE Id IN (SELECT CreatedById FROM Vote WHERE ParentId =: recordId AND Type = 'UP') ORDER BY CreatedDate DESC LIMIT :numResultsValue];
        }
        else
        {
        	return new List<User>();
        }
    }
}