/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaNewController {

	@AuraEnabled
	global static Boolean isAuthenticated() {
		return !Auth.CommunitiesUtil.isGuestUser();
	}

	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	@AuraEnabled
	global static String getSessionId() {
		return String.isEmpty(UserInfo.getSessionId()) ? '' : UserInfo.getSessionId();
		//return ''; //could not remove this function from this class because it's part of a managed package, so changed this to return an empty string
	}

	@AuraEnabled
	global static String getInstanceUrl() {
		//return System.URL.getSalesforceBaseUrl().toExternalForm();

		String instanceName = [select InstanceName from Organization limit 1].InstanceName;
		String instance = 'https://' + instanceName + '.salesforce.com';

		return instance;
	}

	@AuraEnabled
	global static String getZoneId(String nameValue) {
		if (!String.isEmpty(nameValue)) {
			List<Community> currCommunity = [Select Id FROM Community WHERE Name = :nameValue];
			if (currCommunity != null && currCommunity.size() > 0) {
				return currCommunity[0].Id;
			} else {
				return '';
			}
		} else {
			return '';
		}
	}


	@AuraEnabled
	global static SVNSUMMITS_Ideas_Common getCommonSettings() {
		return new SVNSUMMITS_Ideas_Common();
	}

    /*
        Name : createIdeaNew
        Discription: This method is used to get the Id of idea records which is going to insert and
        if any error occurs it passes the error message.
    */
	@AuraEnabled
	global static String createIdeaNew(List<Idea> currIdeaList) {

		try {
			if (currIdeaList != null && currIdeaList.size() > 0) {
				insert currIdeaList;
				return String.valueOf(currIdeaList[0].Id);
			} else {
				return null;
			}
		} catch (Exception e) {
			System.debug('createNewIdea Apex exception: ' + e);
			return e.getMessage();
		}
	}

	@AuraEnabled
	global static String updateIdea(List<Idea> currIdeaList) {
		try {
			if (currIdeaList != null && currIdeaList.size() > 0) {
				update currIdeaList;
				return String.valueOf(currIdeaList[0].Id);
			} else {
				return null;
			}
		} catch (Exception e) {
			System.debug('Update Idea Apex exception: ' + e);
			return e.getMessage();
		}

	}

	@AuraEnabled
	global static Idea getIdea(String recordId, String zoneId) {
		return SVNSUMMITS_IdeaViewController.getIdea(recordId, zoneId);
	}

	@AuraEnabled
	global static List<String> getobjValues(String objName, String fieldName) {
		List<String> lstFieldValues = new List<String>();
		if (String.isBlank(objName)) {
			return null;
		}
		String Query = 'Select Id';
		if (String.isNotBlank(fieldName)) {
			Query += ',' + fieldName;
		}
		Query += ' FROM ' + objName;
		for (sobject sobj: Database.Query(Query.trim())) {
			lstFieldValues.add(String.valueOf(sobj.get(fieldName)));
		}
		system.debug('getobjValues ====test Query===' + Query);
		return lstFieldValues;
	}

	@AuraEnabled
	global static Boolean deleteIdea(String ideaId) {
		Boolean result = true;
		if (!String.isEmpty(ideaId)) {
			try {
				Idea currIdea = new Idea(id = ideaId);
				delete currIdea;
			} catch (Exception e) {
				result = false;
			}
		}
		return result;
	}

	@AuraEnabled
	global static List<Idea> checkDuplicateIdeas(String title, String zoneId, Integer simIdeasLimit) {

		Integer simIdeasLimitValue = Integer.valueOf(simIdeasLimit);

		List<Idea> ideasList = new List<Idea>();
		List<Idea> ideasListSOSL = new List<Idea>();

		if (!String.isEmpty(title)) {

			List<String> keywordList = title.replace('%', '').replace('*', '').split(' ');
			Set<String> keywordSet = new Set<String>();
			Set<String> keywordSetSOSL = new Set<String>();
			for (String s : keywordList) {
				if (s.trim().length() > 1) {
					keywordSet.add(s.trim());
					keywordSetSOSL.add('*' + s.trim() + '*');
				}
			}
			keywordList = new List<String>(keywordSet);
			String keywordStringSOSL = '("' + String.join(new List<String>(keywordSetSOSL), '") OR ("') + '")';
			ideasListSOSL = (List<Idea>) [FIND :keywordStringSOSL RETURNING Idea(Id, Title, VoteTotal WHERE CommunityId = :zoneId) LIMIT :simIdeasLimitValue][0];
			ideasList = [SELECT Id, Title, VoteTotal FROM Idea WHERE CommunityId = :zoneId AND Title IN :keywordList AND (NOT Id IN :ideasListSOSL) ORDER BY VoteScore DESC LIMIT :simIdeasLimitValue];
			ideasList.addAll(ideasListSOSL);

			if (ideasList.size() > simIdeasLimitValue) {
				List<Idea> tmpIdeasList = new List<Idea>();
				for (Idea currIdea : ideasList) {
					if (tmpIdeasList.size() < simIdeasLimitValue) {
						tmpIdeasList.add(currIdea);
					} else {
						break;
					}
				}
				ideasList = tmpIdeasList;
			}

		}

		return ideasList;
	}

	@AuraEnabled
	global static List<IdeaTheme> getThemeList(String zoneName) {
		try {
			Community c = [SELECT Id FROM Community WHERE Name = :zoneName];
			return c.Id != null ?  [SELECT Id, Title FROM IdeaTheme WHERE CommunityId = :c.Id] : null;
		} catch (QueryException e) {
			return null;
		}
	}

	@AuraEnabled
	global static List<Topic> getTopicNamesList() {
		Id networkId = System.Network.getNetworkId();
		List<String> topicNamesList = new List<String>();
		List<Topic> topicList = new List<Topic>();

		if (networkId != null) {
			topicList = [
					SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
					FROM Topic
					WHERE NetworkId = :networkId
			];
		} else {
			topicList = [
					SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
					FROM Topic
					LIMIT 2000
			];
		}

		for (Topic t : topicList) {
			topicNamesList.add(t.Name);
		}

		return topicList;
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

		// Add these values to the select option list.
		for (Schema.PicklistEntry a : values) {
			if (a.isActive()) {
				options.add(a.getLabel());
			}
		}
		return options;
	}

	@AuraEnabled
	global static String getDefaultStatus() {
		String defaultVal;
		Schema.DescribeFieldResult F = Idea.Status.getDescribe();
		List <Schema.PicklistEntry> pickVals = F.getPicklistValues();
		for (Schema.PicklistEntry pv: pickVals) {
			if (pv.isDefaultValue()) {
				defaultVal = pv.getValue();
			}
		}

		return String.isBlank(defaultVal) ? pickVals[0].getValue() : defaultVal;
	}
}