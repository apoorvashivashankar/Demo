/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaCommentsController {
    //Comment
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

            System.debug(ideaId);
            System.debug(zoneId);

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
    global static Integer getTotalCommentCount(String ideaId, String zoneId) {
        return [SELECT COUNT()
                FROM IdeaComment
                WHERE IdeaId =: ideaId AND CommunityId = :zoneId];
    }

    @AuraEnabled
    global static List<IdeaComment> getIdeaComments(String ideaId, Integer numComments, String zoneId) {
        Integer numCommentsValue = Integer.valueOf(numComments);
        return [SELECT Id, CommentBody, CommunityId, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName, CreatedById, CreatedBy.CommunityNickname, CreatedDate, UpVotes, IsHtml
                FROM IdeaComment
                WHERE IdeaId =: ideaId AND CommunityId = :zoneId
                ORDER BY CreatedDate DESC
                LIMIT :numCommentsValue];
    }

    @AuraEnabled
    global static Map<String,Vote> getIdeaCommentVotes(String ideaId, Integer numComments, String zoneId) {

    	List<IdeaComment> ideaCommentList = getIdeaComments(ideaId,numComments,zoneId);
    	List<Vote> voteList = [SELECT CreatedById,CreatedDate,Id,ParentId,Type FROM Vote where Parent.Type = 'IdeaComment' AND parentid IN :ideaCommentList AND Type = 'Up' AND CreatedById = :UserInfo.getUserId()];

    	Map<String,Vote> voteMap = new Map<String,Vote>();
    	for(Vote v : voteList)
    	{
    		voteMap.put(v.ParentId,v);
    	}

    	return voteMap;

    }

    @AuraEnabled
    global static Vote likeIdeaComment(String ideaCommentId) {
    	Vote v = new Vote();
    	v.ParentId = ideaCommentId;
    	v.Type = 'Up';
    	insert v;

    	return v;
    }

    @AuraEnabled
    global static Boolean unlikeIdeaComment(String ideaCommentVoteId) {
		try {
    		List<Vote> voteList = [SELECT Id FROM Vote where Parent.Type = 'IdeaComment' AND Id = :ideaCommentVoteId AND Type = 'Up' AND CreatedById = :UserInfo.getUserId() LIMIT 1];

			delete voteList;
    		return true;
		} catch(Exception e) {
			return false;
		}
    }

    @AuraEnabled
    global static IdeaComment addComment(String ideaId, String commentBody) {
        IdeaComment c = new IdeaComment();
        c.CommentBody = commentBody;
        c.IdeaId = ideaId;
        insert c;

        return c;
    }

}