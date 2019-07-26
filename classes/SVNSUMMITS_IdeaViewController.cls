/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaViewController {
	
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
		} catch (Exception e) {
			isNicknameDisplayEnabled = true;
		}

		return isNicknameDisplayEnabled;
	}

	@AuraEnabled
	global static SVNSUMMITS_Ideas_Common getCommonSettings() {
		return new SVNSUMMITS_Ideas_Common();
	}

	@AuraEnabled
	global static String getSitePrefix() {

		return System.Site.getPathPrefix();
	}

	private static UserRecordAccess getUserRecordAccess(String userId, String recordId) {
		return [
				SELECT RecordId,
						HasAllAccess,
						HasDeleteAccess,
						HasEditAccess,
						HasTransferAccess,
						HasReadAccess,
						MaxAccessLevel
				FROM UserRecordAccess
				WHERE UserId = :UserInfo.getUserId()
				AND RecordId = :recordId
		];
	}

	@AuraEnabled
	global static Boolean isRecordEditable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasEditAccess;
		} catch (Exception e) {
			return false;
		}
	}

	@AuraEnabled
	global static Boolean isRecordDeletable(String recordId) {
		try {
			return getUserRecordAccess(UserInfo.getUserId(), recordId).HasDeleteAccess;
		} catch (Exception e) {
			return false;
		}
	}

	@AuraEnabled
	global static String getZoneId(String nameValue) {
		String zoneId = '';

		if (!String.isEmpty(nameValue)) {
			List<Community> currCommunity = [Select Id FROM Community WHERE Name = :nameValue];

			if (currCommunity != null && currCommunity.size() > 0) {
				zoneId = currCommunity[0].Id;
			}
		}

		return zoneId;
	}

	@AuraEnabled
	global static List<Topic> getTopicNamesList() {
		return SVNSUMMITS_IdeaNewController.getTopicNamesList();
	}

	@AuraEnabled
	global static Map<String, String> getTopicMap(String topicName) {
		List<String> topicNames = new List<String>();
		topicNames.add(topicName);

		return SVNSUMMITS_IdeasTopicController.getTopicMap(topicNames);
	}

	@AuraEnabled
	global static Idea getIdea(String recordId, String zoneId) {
		Idea currIdea = new Idea();

		try {
			Id recordIdValue = Id.valueOf(recordId);
			Id zoneIdValue = Id.valueOf(zoneId);

			if (zoneIdValue != null && recordIdValue != null) {
				List<Idea> currIdeaList = [
						SELECT Id, Title, Status, CreatedBy.Name,
								CreatedBy.CommunityNickname, CreatedBy.CreatedDate, CreatedById,
								CreatorSmallPhotoUrl, CreatedDate, Categories, VoteTotal, AttachmentName,
								NumComments, Related_Topic_Name__c, IdeaThemeId, IdeaTheme.Title, Body
						FROM Idea
						WHERE Id = :recordId AND communityId = :zoneIdValue
				];
				if (currIdeaList.size() > 0) {
					currIdea = currIdeaList[0];
				}
			}
		} catch (Exception e) {
			System.debug(e);
		}

		return currIdea;
	}

	@AuraEnabled
	global static List<Idea> getMergedIdeas(String recordId, String zoneId) {
		Id parentIdValue = Id.valueOf(recordId);
		Id zoneIdValue = Id.valueOf(zoneId);

		List<Idea> mergedIdeas = [
				SELECT Id, Title, ParentIdeaId, CreatedById, CreatedDate
				FROM Idea
				Where IsMerged = true AND ParentIdeaId = :parentIdValue AND communityId = :zoneIdValue
		];

		return mergedIdeas;
	}

	/*
		Name : getIdeaTitle
		Description : This method is used for getting the idea title.
	*/
	@AuraEnabled
	global static String getIdeaTitle(String recordId, String zoneId) {
		String strIdeaTitle = '';

		try {

			Id zoneIdValue = Id.valueOf(zoneId);
			Id recordIdValue = Id.valueOf(recordId);

			if (recordIdValue != null) {
				List<Idea> currIdeaList = new List<Idea>(
				[SELECT Id, Title FROM Idea WHERE Id = :recordId AND communityId = :zoneIdValue]);

				if (!currIdeaList.isEmpty()) {
					if (currIdeaList[0].Title != null) {
						strIdeaTitle = currIdeaList[0].Title;

						if (strIdeaTitle.length() > 80) {
							strIdeaTitle = strIdeaTitle.substring(0, 80);
						} else {
							strIdeaTitle = currIdeaList[0].Title;
						}
					}

				}
			}
		} catch (Exception e) {
			System.debug(e);
		}

		return strIdeaTitle;
	}

	@AuraEnabled
	global static Boolean deleteIdea(String ideaId) {
		return SVNSUMMITS_IdeaNewController.deleteIdea(ideaId);
	}

	@AuraEnabled
	global static Vote vote(String recordId, Boolean isUp) {
		try {
			if (!String.isEmpty(recordId)) {
				Id recordIdValue = (Id) recordId;
				Vote theVote = new Vote();
				theVote.ParentId = recordIdValue;

				theVote.Type = isUp ? 'Up' : 'Down';

				insert theVote;

				return theVote;
			} else {
				return null;
			}
		} catch (Exception e) {
			System.debug('Apex Error: ' + e);
			return null;
		}
	}

	@AuraEnabled
	global static Vote getVote(String recordId) {
		try {
			return [
					SELECT Id, ParentId, Type, CreatedById
					FROM Vote
					WHERE ParentId = :recordId AND CreatedById = :UserInfo.getUserId()
			];
		} catch (Exception e) {
			// No votes yet
			Vote v = new Vote();
			v.ParentId = recordId;
			return v;
		}
	}

	@AuraEnabled
	global static List<String> getPicklistValues(String objName, String fieldName) {
		List<String> options = new List<String>();
		// Get the object type of the SObject.
		Schema.sObjectType objType = Schema.getGlobalDescribe().get(objName);
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		// Get a map of fields for the SObject
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		// Get the list of picklist values for this field.
		list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a : values) {
			options.add(a.getLabel());
		}
		return options;
	}

}