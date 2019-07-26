/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_IdeaListController {

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
	global static Id getUserId() {
		return UserInfo.getUserId();
	}

	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
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

	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper getIdeas() {
		return getIdeas(50, null, null, 'Popular Ideas', false, false, null, false, null, false, false, 'My Ideas', '', '', '', '');
	}

	@AuraEnabled
	global static Integer getIdeasAttributeCount(String zoneId, String type, String userId) {
		if (type == 'Voted On Ideas') {
			List<Vote> voteList = [SELECT ParentId FROM Vote WHERE CreatedById = :userId AND Parent.Type = 'Idea'];
			List<String> votedOnIdList = new List<String>();
			for (Vote v : voteList) {
				votedOnIdList.add(v.ParentId);
			}

			return [SELECT COUNT() FROM Idea WHERE CommunityId = :zoneId AND Id IN :votedOnIdList AND CreatedById != :userId];
		} else {
			return [SELECT COUNT() FROM Idea WHERE CreatedById = :userId AND CommunityId = :zoneId];
		}
	}


	global class filterWrapper {
		global String field { get; set; }
		global String value { get; set; }

		global filterWrapper(String field, String value) {
			this.field = field;
			this.value = value;
		}
	}

	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper getFeaturedIdeas(String recordId1, String recordId2, String recordId3) {
		Set<Id> ideasIds = new set<Id>();
		Integer listSize = 0;

		if (String.isNotBlank(recordId1)) {
			ideasIds.add(recordId1);
			listSize += 1;
		}
		if (String.isNotBlank(recordId2)) {
			ideasIds.add(recordId2);
			listSize += 1;
		}
		if (String.isNotBlank(recordId3)) {
			ideasIds.add(recordId3);
			listSize += 1;
		}

		String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.Id, Related_Topic_Name__c,';
		QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,';
		QUERY += ' (SELECT Type, CreatedById, CreatedBy.CommunityNickname FROM Votes WHERE CreatedById = \'' + UserInfo.getUserId() + '\'';
		QUERY += ')';
		QUERY += ' FROM Idea';
		QUERY += ' WHERE CommunityId != null';
		QUERY += ' And Id IN :ideasIds ' ;

		SVNSUMMITS_ideaListWrapper wrapper = new SVNSUMMITS_ideaListWrapper(QUERY, listSize, ideasIds);
		return wrapper;
	}

	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper getIdeas(
			Integer listSize,
			String categories,
			String zoneId,
			String sortBy,
			Boolean limitVoteToEmailDomain,
			Boolean filterByTopic,
			String topicName,
			Boolean filterBySearchTerm,
			String searchTerm,
			Boolean filterOnUserOwned,
			Boolean filterOnUserVoted,
			String searchMyIdeas,
			String searchByCategories,
			String searchByTopics,
			String searchByStatus,
			String searchByThemes) {
		system.debug('--- categories ---' + categories);
		system.debug('--- zoneId ---' + zoneId);
		system.debug('--- sortBy ---' + sortBy);
		system.debug('--- limitVoteToEmailDomain ---' + limitVoteToEmailDomain);
		system.debug('--- filterByTopic ---' + filterByTopic);
		system.debug('--- topicName ---' + topicName);
		system.debug('--- filterBySearchTerm ---' + filterBySearchTerm);
		system.debug('--- filterOnUserOwned ---' + filterOnUserOwned);
		system.debug('--- filterOnUserVoted ---' + filterOnUserVoted);
		system.debug('--- searchMyIdeas ---' + searchMyIdeas);
		system.debug('--- searchByCategories ---' + searchByCategories);
		system.debug('--- searchByTopics ---' + searchByTopics);
		system.debug('--- searchByStatus ---' + searchByStatus);
		system.debug('--- searchByThemes ---' + searchByThemes);

		List<String> categoriesList = parseCategoryList(categories);
		Set<Id> ideasIds = new set<Id>();
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : 50;

		Boolean limitVoteToEmailDomainValue = limitVoteToEmailDomain != null ? Boolean.valueOf(limitVoteToEmailDomain) : false;
		Boolean filterByTopicValue = filterByTopic != null ? Boolean.valueOf(filterByTopic) : false;
		Boolean filterBySearchTermValue = filterBySearchTerm != null ? Boolean.valueOf(filterBySearchTerm) : false;
		Boolean filterOnUserOwnedValue = filterOnUserOwned != null ? Boolean.valueOf(filterOnUserOwned) : false;
		Boolean filterOnUserVotedValue = filterOnUserVoted != null ? Boolean.valueOf(filterOnUserVoted) : false;

		if (!String.isEmpty(categories)) {
			categories = String.escapeSingleQuotes(categories);
		}
		if (!String.isEmpty(zoneId)) {
			zoneId = String.escapeSingleQuotes(zoneId);
		}
		if (!String.isEmpty(sortBy)) {
			sortBy = String.escapeSingleQuotes(sortBy);
		}
		if (!String.isEmpty(topicName)) {
			topicName = String.escapeSingleQuotes(topicName);
		}
		if (!String.isEmpty(searchTerm)) {
			searchTerm = String.escapeSingleQuotes(searchTerm);
		}

		String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.CommunityNickname, CreatedBy.Id, Related_Topic_Name__c,';
		QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,';

		if (!String.isEmpty(sortBy) && sortBy == 'Recent Comments') {
			QUERY += ' LastComment.CreatedDate, LastComment.CreatedBy.Name, LastComment.CreatedBy.CommunityNickname, LastComment.CreatedBy.Id,LastComment.CommentBody,';
		}

		QUERY += ' (SELECT Type, CreatedById, CreatedBy.CommunityNickname FROM Votes WHERE CreatedById = \'' + UserInfo.getUserId() + '\'';

		if (limitVoteToEmailDomainValue) {
			String userEmail = UserInfo.getUserEmail();
			String domain = '%' + userEmail.split('@')[1];
			QUERY += ' OR CreatedBy.Email LIKE \'' + domain + '\' ORDER BY CreatedDate DESC)';
		} else {
			QUERY += ')';
		}

		QUERY += ' FROM Idea';

		if (String.isEmpty(zoneId)) {
			QUERY += ' WHERE CommunityId != null';
		} else {
			QUERY += ' WHERE CommunityId = \'' + zoneId + '\'';
		}

		// My Ideas
		if (!String.isEmpty(searchMyIdeas) &&
				searchMyIdeas.indexOf('No') == -1) {
			if (searchMyIdeas.indexOf('Ideas') != -1) {
				for (Idea lstIdeas : [SELECT Id,CreatedById FROM Idea where CreatedById = :userinfo.getuserid() limit 1000]) {
					ideasIds.add(lstIdeas.Id);
				}
			}

			if (searchMyIdeas.indexOf('Voted') != -1) {
				filterOnUserVotedValue = true;
			}

			QUERY += ' And Id IN : ideasIds ' ;
		}

		// Idea Themes
		if (String.isNotBlank(searchByThemes)) {
			QUERY += ' AND IdeaTheme.title=\'' + searchByThemes + '\' ';
		}

		// Categories
		if (categoriesList.size() > 0) {
			String categoriesJoined = '(\'' + String.join(categoriesList, '\',\'') + '\')';

			QUERY += ' AND Categories INCLUDES ' + categoriesJoined;
		}

		// Topics - handle '-' in topic name
		if (filterByTopicValue && !String.isEmpty(topicName)) {
			if (!String.isEmpty(topicName)) {
				if (topicName.indexOf('-') != -1) {
					QUERY += ' AND Related_Topic_Name__c LIKE \'%' + topicName.replace('-', '%') + '%\'';
				}
				else {
					QUERY += ' AND Related_Topic_Name__c = \'' + topicName + '\'';
				}
			}
		}

		// Search term
		if (!String.isEmpty(searchTerm)) {
			searchTerm = System.EncodingUtil.urlDecode(searchTerm, 'UTF-8');
			searchTerm = searchTerm.trim();

			if (!String.isEmpty(searchTerm)) {
				List<String> keywordList = searchTerm.replace('%', '').replace('*', '').split(' ');
				Set<String> keywordSet = new Set<String>();
				Set<String> keywordSetSOSL = new Set<String>();
				Set<String> keywordSetCategories = new Set<String>();
				for (String s : keywordList) {
					if (s.trim().length() > 1) {
						keywordSet.add('( Title LIKE \'%' + s.trim() + '%\' OR Related_Topic_Name__c LIKE \'%' + s.trim() + '%\' )');
						keywordSetSOSL.add('*' + s.trim() + '*');
						keywordSetCategories.add(s.trim());
					}
				}
				List<String> keywordListUnique = new List<String>(keywordSet);
				QUERY += ' AND ( ' + String.join(keywordListUnique, ' OR ');

				List<String> keywordSetCategoriesList = new List<String>(keywordSetCategories);
				String categoriesJoined = '(\'' + String.join(keywordSetCategoriesList, '\',\'') + '\')';
				QUERY += ' OR Categories INCLUDES ' + categoriesJoined + ' )';
				System.debug(QUERY);
			}
		} else if (filterBySearchTermValue && String.isEmpty(searchTerm)) {
			QUERY += ' AND Title = \'______\'';
		}

		if (filterOnUserOwnedValue) {
			QUERY += ' AND CreatedById = \'' + UserInfo.getUserId() + '\'';
		} else if (filterOnUserVotedValue) {
			QUERY += ' AND CreatedById != \'' + UserInfo.getUserId() + '\'';
			QUERY += ' AND Id IN (SELECT ParentId FROM Vote WHERE CreatedById = \'' + UserInfo.getUserId() + '\' AND Parent.Type = \'Idea\')';
		}

		if (String.isNotBlank(searchByCategories)) {
			String fieldName = 'Categories';
			QUERY += ' AND ' + fieldName + ' =\'' + searchByCategories + '\' ';
		}

		// Can't do filter and search together
		if (String.isEmpty(topicName) && filterByTopicValue && String.isNotBlank(searchByTopics)) {
			String fieldName = 'Related_Topic_Name__c';

			QUERY += ' AND ' + fieldName + ' =\'' + searchByTopics + '\' ';
		}

		if (String.isNotBlank(searchByStatus)) {
			String fieldName = 'Status';
			QUERY += ' AND ' + fieldName + ' =\'' + searchByStatus + '\' ';
		}


		if (!String.isEmpty(sortBy)) {
			if (sortBy == 'Recent Ideas') {
				QUERY += ' ORDER BY CreatedDate DESC, Title ASC';
			} else if (sortBy == 'Top All-Time') {
				// R1 sort expression
				// QUERY += ' ORDER BY VoteTotal DESC, VoteScore DESC, Title ASC';
				QUERY += ' ORDER BY VoteTotal DESC, CreatedBy.Name ASC, Title DESC';
			} else if (sortBy == 'Recent Comments') {
				QUERY += ' ORDER BY LastComment.CreatedDate DESC, Title ASC'; //LastComment.CreatedDate DESC,
			}
			// Sort By Popular Ideas
			else {
				QUERY += ' ORDER BY VoteScore DESC, Title ASC';
			}
		}

		System.debug('Ideas QUERY: ' + QUERY);

		return new SVNSUMMITS_ideaListWrapper(QUERY, listSizeValue, ideasIds);
	}


	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper nextPage(
			Integer listSize,
			Integer pageNumber,
			String categories,
			String zoneId,
			String sortBy,
			Boolean limitVoteToEmailDomain,
			Boolean filterByTopic,
			String topicName,
			Boolean filterBySearchTerm,
			String searchTerm,
			Boolean filterOnUserOwned,
			Boolean filterOnUserVoted,
			String searchMyIdeas,
			String searchByCategories,
			String searchByTopics,
			String searchByStatus,
			String searchByThemes) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_ideaListWrapper ilw = getIdeas(
				listSize,
				categories,
				zoneId,
				sortBy,
				limitVoteToEmailDomain,
				filterByTopic,
				topicName,
				filterBySearchTerm,
				searchTerm,
				filterOnUserOwned,
				filterOnUserVoted,
				searchMyIdeas,
				searchByCategories,
				searchByTopics,
				searchByStatus,
				searchByThemes);

		ilw.pageNumber = pageNumberValue;
		ilw.nextPage();

		System.debug('ilw: ' + ilw);

		return ilw;
	}

	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper previousPage(
			Integer listSize,
			Integer pageNumber,
			String categories,
			String zoneId,
			String sortBy,
			Boolean limitVoteToEmailDomain,
			Boolean filterByTopic,
			String topicName,
			Boolean filterBySearchTerm,
			String searchTerm,
			Boolean filterOnUserOwned,
			Boolean filterOnUserVoted,
			String searchMyIdeas,
			String searchByCategories,
			String searchByTopics,
			String searchByStatus,
			String searchByThemes) {

		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_ideaListWrapper ilw = getIdeas(
				listSize,
				categories,
				zoneId,
				sortBy,
				limitVoteToEmailDomain,
				filterByTopic,
				topicName,
				filterBySearchTerm,
				searchTerm,
				filterOnUserOwned,
				filterOnUserVoted,
				searchMyIdeas,
				searchByCategories,
				searchByTopics,
				searchByStatus,
				searchByThemes);

		ilw.pageNumber = pageNumberValue;
		ilw.previousPage();

		return ilw;
	}

	@AuraEnabled
	global static SVNSUMMITS_ideaListWrapper getPage(Integer listSize, Integer pageNumber, String categories, String zoneId, String sortBy, Boolean limitVoteToEmailDomain, Boolean filterByTopic, String topicName, Boolean filterBySearchTerm, String searchTerm, Boolean filterOnUserOwned, Boolean filterOnUserVoted, String searchMyIdeas, String searchByCategories, String searchByTopics, String searchByStatus, String searchByThemes) {
		Integer listSizeValue = listSize != null ? Integer.valueOf(listSize) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;
		Boolean limitVoteToEmailDomainValue = limitVoteToEmailDomain != null ? Boolean.valueOf(limitVoteToEmailDomain) : false;
		Boolean filterByTopicValue = filterByTopic != null ? Boolean.valueOf(filterByTopic) : false;
		Boolean filterBySearchTermValue = filterByTopic != null ? Boolean.valueOf(filterBySearchTerm) : false;
		Boolean filterOnUserOwnedValue = filterOnUserOwned != null ? Boolean.valueOf(filterOnUserOwned) : false;
		Boolean filterOnUserVotedValue = filterOnUserVoted != null ? Boolean.valueOf(filterOnUserVoted) : false;

		SVNSUMMITS_ideaListWrapper ilw = getIdeas(listSizeValue, categories, zoneId, sortBy, limitVoteToEmailDomainValue, filterByTopicValue, topicName, filterBySearchTermValue, searchTerm, filterOnUserOwnedValue, filterOnUserVotedValue, searchMyIdeas, searchByCategories, searchByTopics, searchByStatus, searchByThemes);
		system.debug('records-001' + ilw.ideaList);
		ilw.pageNumber = pageNumberValue;
		ilw.getPage();
		system.debug('records-002' + ilw.ideaList);
		return ilw;
	}

	@AuraEnabled
	global static Idea submitVote(Id ideaId, String voteType) {

		Idea currIdea;

		try {

			Vote v = new Vote();
			v.ParentId = ideaId;
			v.Type = voteType;
			insert v;

			currIdea = [
					SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.Id, Related_Topic_Name__c,
							Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName,
							LastComment.CreatedDate, LastComment.CreatedBy.Name,
							LastComment.CreatedBy.Id,LastComment.CommentBody, (SELECT Type FROM Votes WHERE CreatedById = :UserInfo.getUserId())
					From Idea
					WHERE Id = :ideaId
			];

		} catch (Exception e) {
			System.debug('submitVote failed: ' + e.getMessage());
			currIdea = null;
		}

		return currIdea;
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
		system.debug('====test Query===' + Query);
		return lstFieldValues;
	}

	private static List<String> parseCategoryList(String categories) {
		List<String> categoriesList = new List<String>();
		if (categories != null && !String.isEmpty(categories)) {
			categoriesList = categories.split(',');
		}
		return categoriesList;
	}
}