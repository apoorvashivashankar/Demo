/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name		  : SVNSUMMITS_NewsController
@Created by		  :
@Description		 : Apex class used by News lightning components
*/
global with sharing class SVNSUMMITS_NewsController {

	public static final string STRSEARCHTERM = 'Search Term';
	public static final string STRNONE = 'None';
	public static final string STRTOPICVALUE = 'Topic Value';
	public static final string FORGROUPID = 'Group';
	public static final Integer USER_SEARCH_LIMIT = 50;

	//We need to use both networkId and strNetworkId to handle 15 digit and 18 digit id in news records as per CLF-210

	//networkId of type id returns 18 digit id
	global static Id networkId = System.Network.getNetworkId();

	global static String TOKEN_SOBJECT_NAME = 'News__c';

	//networkId of type string i.e. strNetworkId returns 15 digit id
	global static string strNetworkId = System.Network.getNetworkId();

	//showNickName of type string. i.e it will get value from design attribute
	private static string strShowNickName;

	// CUSTOM METADATA SETTINGS
	@AuraEnabled
	global static Boolean userAuthorizedToPost() {
		Boolean authorized = false;
		try {
			SS_News_Settings__mdt setting = [
					SELECT PermissionSetName__c
					FROM SS_News_Settings__mdt
					WHERE DeveloperName = 'Default'
			];

			System.debug('userAuthorizedToPost name = ' + setting.PermissionSetName__c);
			authorized = [
					SELECT count()
					FROM PermissionSetAssignment
					WHERE AssigneeId = :Userinfo.getUserId()
					AND PermissionSet.Name = :setting.PermissionSetName__c
			] > 0;
		} catch (Exception e) {
			system.debug(System.LoggingLevel.ERROR, 'SS_News_Settings__mdt not configured');
		}

		return authorized;
	}

	@AuraEnabled
	global static Boolean requireGroupMembership() {
		Boolean requireMembership = false;

		try
		{
			SS_News_Settings__mdt setting =
			[
				SELECT Require_Group_Membership__c
				FROM SS_News_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			requireMembership = setting.Require_Group_Membership__c;
		}
		catch(Exception e)
		{
			system.debug(System.LoggingLevel.ERROR, 'SS_News_Settings__mdt not configured');
		}

		return requireMembership;
	}

	// CURRENT USER
	@AuraEnabled
	global static User getCurrentUser() {
		return [SELECT Id, Name, CommunityNickname FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
	}

	 /*
		* MethodName		: getorgnamespace
		* Description	   : Method for getting the namespace
	*/
	public static string getOrgNamespace() {
		integer indexOfToken = -1;
		String namespsacePrefix = null;
		for (Schema.SObjectType typ : Schema.getGlobalDescribe().values()) {
			String sobjName = String.valueOf(typ);
			if (sobjName != null) {
				indexOfToken = sobjName.indexOf(TOKEN_SOBJECT_NAME);
			}
			if (indexOfToken != -1) {
				namespsacePrefix = sobjName.substring(0, indexOfToken);
				break;
			}
		}

		return namespsacePrefix;
	}

	// FOLLOWING
	@AuraEnabled
	global static Boolean isFollowing(String recordId) {
		return [
			SELECT COUNT()
			FROM EntitySubscription
			WHERE NetworkId = :System.Network.getNetworkId()
			AND ParentId = :recordId
			AND SubscriberId = :UserInfo.getUserId()
		] > 0;
	}

	@AuraEnabled
	global static Boolean followRecord(String recordId) {
		try {
			ConnectApi.ChatterUsers.follow(System.Network.getNetworkId(), UserInfo.getUserId(), recordId);
			return true;
		} catch (Exception e) {
			System.debug(e);
		}
		return false;
	}

	@AuraEnabled
	global static Boolean unfollowRecord(String recordId) {
		try {
			for (EntitySubscription follow : [SELECT Id FROM EntitySubscription WHERE NetworkId = :System.Network.getNetworkId() AND ParentId = :recordId AND SubscriberId = :UserInfo.getUserId()]) {
				ConnectApi.Chatter.deleteSubscription(System.Network.getNetworkId(), follow.Id);
				return true;
			}
		} catch (Exception e) {
			System.debug(e);
		}
		return false;
	}

	/*
	@Name		  :  isNicknameDisplayEnabled
	@Description   :  Method to fetch community setting for nick name to display users name or name as per setting.
	*/
	@AuraEnabled
	global static Boolean isNicknameDisplayEnabled() {

		if (!hasNicknameDisplayEnabledQueried) {
			try {
				Network currNetwork = [SELECT Id, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :networkId LIMIT 1];
				isNicknameDisplayEnabled = currNetwork.OptionsNicknameDisplayEnabled;
			} catch (Exception e) {
				isNicknameDisplayEnabled = true;
			} finally {
				hasNicknameDisplayEnabledQueried = true;
			}
		}
		return isNicknameDisplayEnabled;
	}
	@TestVisible private static Boolean hasNicknameDisplayEnabledQueried = false;
	@TestVisible private static Boolean isNicknameDisplayEnabled = true;

	// ACCESS TO OBJECT
	@AuraEnabled
	global static Boolean isObjectCreatable() {

		Boolean isCreateEnabled = false;
		if (Schema.SObjectType.News__c.isCreateable()) {
			isCreateEnabled = true;
		}
		return isCreateEnabled;
	}

	@AuraEnabled
	global static Boolean isObjectEditable() {

		Boolean isEditEnabled = false;
		if (Schema.SObjectType.News__c.isUpdateable()) {
			isEditEnabled = true;
		}
		return isEditEnabled ;
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
	global static Boolean deleteRecord(String recordId) {
		try {
			UserRecordAccess access = getUserRecordAccess(UserInfo.getUserId(), recordId);
			if (access.HasDeleteAccess) {
				delete new News__c(Id = recordId);
				return true;
			}
		} catch (Exception e) {
			System.debug(e);
		}

		return false;
	}

	@TestVisible
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
	global static Boolean getNewsFeedEnabled() {
		return Schema.sObjectType.News__c.isFeedEnabled();
	}

	// GET NEWS
	/*
	@Name		  :  getNews
	@Description   :  Method to News Records as per different criteria in different components
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNews(Integer numberOfNews,
			Integer numberOfNewsPerPage,
			String strfilterType,
			String strRecordId,
			String netwrkId,
			String sortBy,
			String filterByTopic,
			String filterByAuthor,
			String topicName,
			String filterOn,
			String searchTerm,
			String fromDate,
			String toDate) {

		DateTime fromDt;
		DateTime toDt;


		try {
			//create datetime instance of fromDate and toDate as we get them in string format
			if (String.isNotBlank(fromDate) || String.isNotBlank(toDate)) {

				if (String.isNotBlank(fromDate) && fromDate.length() > 0) {
					List<String> lstOfFromDt = fromDate.split('-');

					//Parsing date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd
					fromDt = DateTime.parse(lstOfFromDt[1] + '/' + lstOfFromDt[2] + '/' + lstOfFromDt[0] + ' 12:00 AM');
				}

				if (String.isNotBlank(toDate) && toDate.length() > 0) {
					List<String> lstOfToDt = toDate.split('-');

					//Parsing date by splitting string because expected format is mm/dd/yyyy but we are getting string in yy/mm/dd
					toDt = DateTime.parse(lstOfToDt[1] + '/' + lstOfToDt[2] + '/' + lstOfToDt[0] + ' 11:59 PM');
				}
			}
		} catch (Exception e) {
			//return e.getMessage();
			//return null;
			return new SVNSUMMITS_WrapperNews('Date', e.getMessage());
		}

		try {
			Integer intLimit = Integer.valueOf(numberOfNewsPerPage);
			String recId = validateId(strRecordId);

			// Group membership
			Boolean requireGroupId = requireGroupMembership();

			//set of topicIds ,authorIds and newsIds for filter criteria
			set<string> topicIds = new set<string>();
			set<string> newsIds = new set<string>();
			set<string> authorIds = new set<string>();

			//collect news id related to similar topics
			if (filterOn != STRSEARCHTERM && String.isNotBlank(strRecordId)) {
				System.debug('Search term: ' + STRSEARCHTERM + ' ' + String.valueOf(strRecordId));

				if (String.isNotBlank(recId)) {
					String queryTopicAssignment = getQueryString('TopicAssignment');

					if (String.isNotBlank(queryTopicAssignment)) {
						queryTopicAssignment += ' WHERE EntityId = \'' + String.valueOf(strRecordId) + '\'';
						if (String.isNotBlank(networkId)) {
							queryTopicAssignment += ' AND NetworkId = \'' + networkId + '\'';
						} else {
							queryTopicAssignment += ' AND NetworkId = null';
						}
						queryTopicAssignment += ' LIMIT 1000';
						List<TopicAssignment> topicAssignments = DataBase.query(queryTopicAssignment);

						//collect all topics related to News__c object
						for (TopicAssignment topicAssignment : topicAssignments) {
							topicIds.add(topicAssignment.TopicId);
						}

						//collect all news Ids related to topicIds above
						String queryTopicAssg = getQueryString('TopicAssignment');
						queryTopicAssg += ' WHERE TopicId IN : topicIds';
						if (String.isNotBlank(networkId)) {
							queryTopicAssg += ' AND NetworkId = \'' + networkId + '\'';
						} else {
							queryTopicAssg += ' AND NetworkId = null';
						}
						//queryTopicAssg += ' AND NetworkId = \'' + networkId + '\'';
						queryTopicAssg += ' LIMIT 1000';
						List<TopicAssignment> topics = DataBase.query(queryTopicAssg);

						for (TopicAssignment topicAssignment : topics) {
							newsIds.add(topicAssignment.EntityId);
						}
					}
				}
			}

			//fetch Query string for News__c (news) with child query attachment and user required fields
			String Query = getSobjectQueryString('News__c');

			if (String.isNotBlank(Query)) {

				if (getNewsFeedEnabled()) {
//					query += ' (SELECT COUNT() FROM FeedItems), (SELECT COUNT() FROM FeedComments)';
				}

				// get recommended news records
				if (filterOn == STRNONE && String.isNotBlank(strRecordId) && String.isNotBlank(recId)) {

					if (String.isNotBlank(networkId)) {
						Query += ' Where (NetworkId__c = \'' + networkId + '\'';
						Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
					} else {
						Query += ' Where NetworkId__c = null';
					}
					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}
					Query += ' AND Publish_DateTime__c <= TODAY ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > TODAY )';
					Query += ' AND Id IN : newsIds';
					Query += ' AND Id != \'' + strRecordId + '\'';
					Query += ' ORDER BY Publish_DateTime__c DESC ';
					Query += ' LIMIT : intLimit';

				}
				//get news records on search page as per searchterm entered with sort by filter selected by user
				else if (filterOn == STRSEARCHTERM && String.isNotBlank(searchTerm)) {
					System.debug('get news records on search page as per search term entered with sort by filter selected by user');

					if (String.isNotBlank(searchTerm) && searchTerm.trim().length() > 0) {
						searchTerm = String.escapeSingleQuotes(searchTerm.trim());
					}

					Query += ' WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					Query += ' AND Publish_DateTime__c <= TODAY ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > TODAY )';

					if (String.isNotBlank(networkId)) {
						Query += ' AND (NetworkId__c = \'' + networkId + '\'';
						Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
					} else {
						Query += ' AND NetworkId__c = null';
					}

					if (sortBy == 'Oldest First') {
						Query += ' ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {
						Query += ' ORDER BY Publish_DateTime__c DESC';
					}
				}
				//get news records on Topic detail as per topicName selected by user
				else if (String.isNotBlank(topicName) && filterOn == STRTOPICVALUE) {
					System.debug('Searching by topic: ' + topicName);

					newsIds = new set<string>();

					if (Schema.getGlobalDescribe().get('Topic').getDescribe().accessible) {
						Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('Topic').getDescribe().fields.getMap();

						if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
							String queryStrTopic = getQueryString('TopicAssignment');

							if (String.isNotBlank(queryStrTopic)) {

								// hack for Topic names with spaces that are replaced with a '-' in the URL
								String subTopicQuery;

								if (topicName.indexOf('-') != -1) {
									subTopicQuery = ' WHERE Topic.Name LIKE \'%' + topicName.replace('-', '%') + '%\'';
								} else {
									subTopicQuery = ' WHERE Topic.Name = \'' + topicName + '\'';
								}

								queryStrTopic += subTopicQuery;

								if (String.isNotBlank(networkId)) {
									queryStrTopic += ' AND NetworkId = \'' + networkId + '\'';
								} else {
									queryStrTopic += ' AND NetworkId = null';
								}

								//queryStrTopic += ' AND NetworkId = \'' + networkId + '\'';
								queryStrTopic += ' LIMIT 500';

								System.Debug('Topic query: ' + queryStrTopic);

								List<TopicAssignment> topicsLst = DataBase.query(queryStrTopic);

								for (TopicAssignment topic : topicsLst) {
									newsIds.add(topic.EntityId);
								}

								System.debug('News IDs filtered by topic list: ' + newsIds);
							}
						}
					}

					Query += ' Where Id IN : newsIds';

					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}

					Query += ' AND Publish_DateTime__c <= TODAY ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > TODAY )';

					if (String.isNotBlank(networkId)) {
						Query += ' AND (NetworkId__c = \'' + networkId + '\'';
						Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
					} else {
						Query += ' AND NetworkId__c = null';
					}

					if (sortBy == 'Oldest First') {
						Query += ' ORDER BY Publish_DateTime__c';
					}

					if (sortBy == 'Most Recent') {

						Query += ' ORDER BY Publish_DateTime__c DESC';
					}
				}
				// filter by group id (stored in topicName for now)
				else if (filterOn == FORGROUPID) {
					Query += ' WHERE GroupId__c  = \'' + topicName + '\'';
					system.debug('Query for Groups : ' + Query);
				}
				//get news records on List View as per combination of Topic, date, Author and sort by
				else if (String.isNotBlank(filterByTopic) ||
						String.isNotBlank(filterByAuthor) ||
						fromDt != null ||
						toDt != null ||
						String.isNotBlank(sortBy)) {

					Query += ' WHERE (Archive_DateTime__c = null OR Archive_DateTime__c > TODAY )';
					if (String.isNotBlank(networkId)) {
						Query += ' AND (NetworkId__c = \'' + networkId + '\'';
						Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
					} else {
						Query += ' AND NetworkId__c = null';
					}
					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}

		// PRIVATE GROUPS ---------------------------------------------------------------------------------
					// Hide Private items
					// re-purposed newsId for the group id's that the user is a member of
					// the 2 will never be used together in the same query
					// not great but it is difficult to add to the packaged WrapperNews parameters
					if (requireGroupId)
					{
						newsIds = getGroups().keySet();

						System.Debug('My group list: ' + newsIds);

						Query += newsIds.size() > 0 ? ' AND (GroupId__c = null OR GroupId__c IN : newsIds)' : ' AND GroupId__c = null';
					}
					else
					{
						Query += ' AND Private_Group__c = false';
					}

					if (String.isNotBlank(filterByTopic) && filterByTopic.trim().length() > 0) {
						set<string> topicLst = new set<string>();
						topicLst.addAll(filterByTopic.split(';'));
						newsIds = new set<string>();

						String queryTopic = getQueryString('TopicAssignment');
						if (String.isNotBlank(queryTopic)) {
							queryTopic += ' WHERE TopicId IN : topicLst ';
							queryTopic += ' LIMIT 1000';
							List<TopicAssignment> topicsLst = DataBase.query(queryTopic);

							for (TopicAssignment topic : topicsLst) {
								newsIds.add(topic.EntityId);
							}
						}

						Query += ' AND Id IN : newsIds';
					}

					if (String.isNotBlank(filterByAuthor) && filterByAuthor.trim().length() > 0) {
						authorIds = new set<string>();
						authorIds.addAll(filterByAuthor.split(';'));

						Query += ' AND Author__c IN : authorIds';
						Query += ' AND Show_Author__c = true';
					}

					if (fromDt != null || toDt != null) {
						if (fromDt != null) {
							Query += ' AND Publish_DateTime__c >=: fromDt ';
						}

						if (toDt != null) {
							Query += ' AND Publish_DateTime__c <=:  toDt ' ;
						}
					} else {
						Query += ' AND Publish_DateTime__c <= TODAY ' ;
					}

					if (String.isNotBlank(sortBy)) {
						if (sortBy == 'Oldest First') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' ORDER BY Publish_DateTime__c';
						}

						if (sortBy == 'Most Recent') {
							intLimit = Integer.valueOf(numberOfNewsPerPage);

							Query += ' ORDER BY Publish_DateTime__c DESC';
						}
					}

				}
				//when no criteria is selected without sort by as well
				else {
					if (String.isNotBlank(networkId)) {
						Query += ' WHERE (NetworkId__c = \'' + networkId + '\'';
						Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
					} else {
						Query += ' WHERE NetworkId__c = null';
					}
					if (String.isNotBlank(searchTerm)) {
						Query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'';
					}
					Query += ' AND Publish_DateTime__c <= TODAY ';
					Query += ' AND (Archive_DateTime__c = null OR Archive_DateTime__c > TODAY )';
					Query += ' ORDER BY Publish_DateTime__c DESC';
				}

				//calling wrapper class to execute query and set controller parameters
				return new SVNSUMMITS_WrapperNews(Query, intLimit, newsIds, authorIds, fromDt, toDt, false, null);
			} else {
				return null;
			}
		} catch (Exception e) {
			return new SVNSUMMITS_WrapperNews('others', e.getMessage());
		}
	}


	/*
	@Name		  :  nextPage
	@Description   :  Method used on click of "Next" in pagination to diaplay news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews nextPage(Integer numberOfNews, Integer numberOfNewsPerPage, Integer pageNumber, String strfilterType, String strRecordId, String netwrkId, String sortBy, String filterByTopic, String filterByAuthor, String topicName, String filterOn, String searchTerm, String fromDate, String toDate) {

		Integer listSizeValue = numberOfNewsPerPage != null ? Integer.valueOf(numberOfNewsPerPage) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_WrapperNews nlw = getNews(numberOfNews, numberOfNewsPerPage, strfilterType, strRecordId, networkId, sortBy, filterByTopic, filterByAuthor, topicName, filterOn, searchTerm, fromDate, toDate);
		nlw.pageNumber = pageNumberValue;

		nlw.nextPage();

		return nlw;
	}

	/*
	@Name		  :  previousPage
	@Description   :  Method used on click of "Previous" in pagination to diaplay news records as per numberOfNewsPerPage
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews previousPage(Integer numberOfNews, Integer numberOfNewsPerPage, Integer pageNumber, String strfilterType, String strRecordId, String netwrkId, String sortBy, String filterByTopic, String filterByAuthor, String topicName, String filterOn, String searchTerm, String fromDate, String toDate) {

		Integer listSizeValue = numberOfNewsPerPage != null ? Integer.valueOf(numberOfNewsPerPage) : 50;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : 1;

		SVNSUMMITS_WrapperNews nlw = getNews(numberOfNews, numberOfNewsPerPage, strfilterType, strRecordId, networkId, sortBy, filterByTopic, filterByAuthor, topicName, filterOn, searchTerm, fromDate, toDate);
		nlw.pageNumber = pageNumberValue;

		nlw.previousPage();

		return nlw ;
	}

	/*
	@Name		  :  getTopics
	@Description   :  Method to fetch topics and display in dropdown of "Topic Filter" component.
	*/
	@AuraEnabled
	global static Map<string, string> getTopics() {

		Map<string, string> topics = new Map<string, string>();
		List<Topic> topicList = new List<Topic>();

		String queryTopic = getQueryString('Topic');
		if (String.isNotBlank(queryTopic)) {
			if (String.isNotBlank(networkId)) {
				queryTopic += ' Where (NetworkId = \'' + networkId + '\'';
				queryTopic += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryTopic += ' WHERE NetworkId = null';
			}
			queryTopic += ' LIMIT 1000';
			topicList = DataBase.query(queryTopic);

			for (Topic t : topicList) {
				topics.put(t.Id, t.Name);
			}

			return topics;
		} else {
			return null;
		}
	}

	/*
	@Name		   : getGroups
	@Description	: Get a list of all the groups this user is a member of
	 */
	@AuraEnabled
	global static Map<string, string> getGroups() {
		Map<string, string> groups = new Map<string, string>();

		for (CollaborationGroupMember member : [
				SELECT id, CollaborationGroupId, CollaborationGroup.Name
				FROM CollaborationGroupMember
				WHERE MemberId = :userinfo.getuserid()
				LIMIT 1000
		]) {
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	/*
	@Name		   : getAllGroups
	@Description	: Get a list of all the groups
	 */
	@AuraEnabled
	global static Map<string, string> getAllGroups() {
		Map<string, string> groups = new Map<string, string>();

		for (CollaborationGroupMember member : [
				SELECT id, CollaborationGroupId, CollaborationGroup.Name
				FROM CollaborationGroupMember
				LIMIT 1000
		]) {
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.Name);
		}

		return groups;
	}

	/*
	@Name		  :  getUsers
	@Description   :  Method to fetch users and display in dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<string, string> getUsers() {

		Map<string, string> users = new Map<string, string>();
		String queryUser = getQueryString('NetworkMember') + ' n';

		if (String.isNotBlank(queryUser)) {
			if (String.isNotBlank(networkId)) {
				queryUser += ' WHERE (NetworkId = \'' + networkId + '\'';
				queryUser += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryUser += ' WHERE NetworkId = null';
			}
			queryUser += ' AND n.Member.IsActive = true';
			queryUser += ' LIMIT ' + USER_SEARCH_LIMIT;

			system.debug(LoggingLevel.DEBUG, 'getUsers QRY: ' + queryUser);
			List<NetworkMember> userLst = DataBase.query(queryUser);


			for (NetworkMember u : userLst) {
				if (isNicknameDisplayEnabled()) {
					users.put(u.MemberId, u.Member.CommunityNickname);
				} else {
					users.put(u.MemberId, u.Member.Name);
				}
			}

			// make sure we add the current user
			User currentUser = getCurrentUser();

			if (!users.containsKey(currentUser.Id)) {
				if (isNicknameDisplayEnabled()) {
					users.put(currentUser.Id, currentUser.CommunityNickname);
				} else {
					users.put(currentUser.Id, currentUser.Name);
				}
			}

			return users;
		} else {
			return null;
		}
	}

	/*
	@Name		  :  searchUsers
	@Description   :  Method to search users and display for the dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<string, string> searchUsers(String searchString) {
		Map<string, string> users = new Map<string, string>();
		String queryUser = getQueryString('NetworkMember') + ' n ';

		if (String.isNotBlank(queryUser)) {
			if (String.isNotBlank(networkId)) {
				queryUser += ' WHERE (NetworkId = \'' + networkId + '\'';
				queryUser += ' OR NetworkId = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryUser += ' WHERE NetworkId = null';
			}

			if (String.isNotBlank(searchString)) {
				queryUser += ' AND (n.Member.Name LIKE \'%' + String.valueOf(searchString) + '%\')';
			}

			queryUser += ' AND n.Member.IsActive = true';
			queryUser += ' LIMIT ' + USER_SEARCH_LIMIT;

			system.debug(LoggingLevel.DEBUG, 'searchUsers QRY: ' + queryUser);
			List<NetworkMember> userLst = DataBase.query(queryUser);

			for (NetworkMember u : userLst) {
				if (isNicknameDisplayEnabled()) {
					users.put(u.MemberId, u.Member.CommunityNickname);
				} else {
					users.put(u.MemberId, u.Member.Name);
				}
			}

			return users;
		} else {
			return null;
		}
	}

	 /*
	@Name		  :  getAuthors
	@Description   :  Method to fetch users and display in dropdown of "Author Filter" component.
	*/
	@AuraEnabled
	global static Map<string, string> getAuthors() {
		Map<string, string> authors = new Map<string, string>();

		if (Schema.sObjectType.News__c.isAccessible() && Schema.sObjectType.News__c.fields.Author__c.isAccessible()) {
			String queryNews = 'SELECT Author__c authorId, Author__r.Name authorName, Author__r.CommunityNickname authorNickname';

			queryNews += ' FROM ';
			queryNews += getOrgNamespace();
			queryNews += TOKEN_SOBJECT_NAME;

			if (String.isNotBlank(networkId)) {
				queryNews += ' Where (NetworkId__c = \'' + networkId + '\'';
				queryNews += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				queryNews += ' Where NetworkId__c = null';
			}

			queryNews += ' AND Author__c != null';
			queryNews += ' GROUP BY Author__c, Author__r.Name, Author__r.CommunityNickname';
			queryNews += ' LIMIT ' + USER_SEARCH_LIMIT;

			System.debug(queryNews);
			List<AggregateResult> newsLst = DataBase.query(queryNews);

			for (AggregateResult n : newsLst) {
				if (isNicknameDisplayEnabled()) {
					authors.put(String.valueOf(n.get('authorId')), String.valueOf(n.get('authorNickname')));
				} else {
					authors.put(String.valueOf(n.get('authorId')), String.valueOf(n.get('authorName')));
				}
			}

			return authors;
		} else {
			return null;
		}

	}
	/*
	@Name		  :  getSitePrefix
	@Description   :  Method to fetch site prefix so that urls are redirected properly dynamically in any org.
	*/
	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	/*
	@Name		  :  getFeaturedNews
	@Description   :  Method to fetch featured news records to show on featured components.
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getFeaturedNews(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5) {
		boolean isFeatured = true;
		Map<string, string> featurdNewsIds = new Map<string, string>();
		set<string> newsIds = new set<string>();

		if (String.isNotBlank(recordId1)) {
			String newsRecordId1 = validateId(recordId1);
			if (String.isNotBlank(newsRecordId1)) {
				featurdNewsIds.put(newsRecordId1, newsRecordId1);
			}
		}
		if (String.isNotBlank(recordId2)) {
			String newsRecordId2 = validateId(recordId2);
			if (String.isNotBlank(newsRecordId2)) {
				featurdNewsIds.put(newsRecordId2, newsRecordId2);
			}
		}
		if (String.isNotBlank(recordId3)) {
			String newsRecordId3 = validateId(recordId3);
			if (String.isNotBlank(newsRecordId3)) {
				featurdNewsIds.put(newsRecordId3, newsRecordId3);
			}
		}
		if (String.isNotBlank(recordId4)) {
			String newsRecordId4 = validateId(recordId4);
			if (String.isNotBlank(newsRecordId4)) {
				featurdNewsIds.put(newsRecordId4, newsRecordId4);
			}
		}
		if (String.isNotBlank(recordId5)) {
			String newsRecordId5 = validateId(recordId5);
			if (String.isNotBlank(newsRecordId5)) {
				featurdNewsIds.put(newsRecordId5, newsRecordId5);
			}
		}

		newsIds = featurdNewsIds.keyset();

		String Query = getSobjectQueryString('News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id IN : newsIds';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				Query += ' AND NetworkId__c = null';
			}
			Query += ' LIMIT 5';

			return new SVNSUMMITS_WrapperNews(Query, 5, newsIds, null, null, null, isFeatured, featurdNewsIds);
		} else {
			return null;
		}
	}

	static public String validateId(String Idparam) {
		try {
			String recId = String.escapeSingleQuotes(Idparam);
			if (Id.valueOf(recId).getSobjectType() == News__c.SobjectType)
				return recId; else
					return null;
		} catch (Exception e) {
			return null;
		}
	}

	/*
	@Name		  :  getNewsRecord
	@Description   :  Method to fetch news record as per newsRecordId used on news detail page components
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNewsRecord(String newsRecordId) {
		String Query = getSobjectQueryString('News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id = \'' + newsRecordId + '\'';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				Query += ' AND NetworkId__c = null';
			}
			Query += ' LIMIT 1';

			return new SVNSUMMITS_WrapperNews(Query, 1, null, null, null, null, false, null);
		} else {
			return null;
		}
	}

	@AuraEnabled
	global static SVNSUMMITS_WrapperNews getNewsRecord(String newsRecordId, String showNickName) {
		system.debug('---- showNickName ----' + showNickName);
		strShowNickName = showNickName;
		system.debug('---- strShowNickName ----' + strShowNickName);

		String Query = getSobjectQueryString('News__c');

		if (String.isNotBlank(Query)) {
			Query += ' Where Id = \'' + newsRecordId + '\'';
			if (String.isNotBlank(networkId)) {
				Query += ' AND (NetworkId__c = \'' + networkId + '\'';
				Query += ' OR NetworkId__c = \'' + String.escapeSingleQuotes(strNetworkId) + '\')';
			} else {
				Query += ' AND NetworkId__c = null';
			}
			Query += ' LIMIT 1';

			return new SVNSUMMITS_WrapperNews(Query, 1, null, null, null, null, false, null);
		} else {
			return null;
		}
	}

	/*
		Save news item
	 */
	@AuraEnabled
	global static News__c saveNewsItem(
			String newsName,
			String newsDetails,
			Boolean newsShowAuthor,
			String newsAuthor,
			String newsPublishDate,
			String newsArchiveDate,
			String newsGroupId,
			String strFilterByTopic	) {

		DateTime publishDate;

		if (String.isNotBlank(newsPublishDate)) {
			publishDate = DateTime.valueOf(newsPublishDate);
		}

		DateTime archiveDate;

		if (String.isNotBlank(newsArchiveDate)) {
			archiveDate = DateTime.valueOf(newsArchiveDate);
		}

		News__c news = new News__c(
				Name = newsName,
				Details__c = newsDetails,
				Show_Author__c = newsShowAuthor,
				Author__c = newsAuthor,
				Publish_DateTime__c = publishDate,
				Archive_DateTime__c = archiveDate,
				GroupId__c = newsGroupId);

		return saveNews(news, strFilterByTopic);
	}

	/*
	@Name		  :  saveNews
	@Description   :  Method to save new news object used on create news component.
	*/
	@AuraEnabled
	global static News__c saveNews(News__c newsObj, String strfilterByTopic) {
		String strNamespacePrefix = getOrgNamespace();

		Schema.DescribeSObjectResult soBjRes = Schema.getGlobalDescribe().get(strNamespacePrefix + 'News__c').getDescribe();

		if (soBjRes.accessible && soBjRes.createable) {
			newsObj.NetworkId__c = networkId;

			if (newsObj.Publish_DateTime__c != null) {
				string pubDt = string.valueOf(newsObj.Publish_DateTime__c.date());
				List<String> lstOfPublishDt = pubDt.split('-');
			}

			Map<string, TopicAssignment> topicMap = new Map<string, TopicAssignment>();

			if (newsObj.Id != null) {
				String queryTopicAssignment = getQueryString('TopicAssignment');

				if (String.isNotBlank(queryTopicAssignment)) {
					queryTopicAssignment += ' WHERE EntityId = \'' + newsObj.Id + '\'';
					queryTopicAssignment += ' LIMIT 1000';
					List<TopicAssignment> topicAssignments = DataBase.query(queryTopicAssignment);
					for (TopicAssignment tAssgn : topicAssignments) {
						topicMap.put(tAssgn.TopicId, tAssgn);
					}
				}
			}

			upsert newsObj;

			if (String.isNotBlank(strfilterByTopic) && strfilterByTopic.trim().length() > 0) {
				List<TopicAssignment> topicAssignmentLst = new List<TopicAssignment>();
				Set<string> topicLst = new set<string>();

				topicLst.addAll(strfilterByTopic.split(';'));
				set<string> topicSet = new set<string>();
				List<TopicAssignment> deleteAssignments = new List<TopicAssignment>();

				if (topicMap.size() > 0) {
					for (String topicId : topicMap.KeySet()) {
						for (String tId : topicLst) {
							if (tId == topicId) {

							} else {
								if (!topicSet.contains(tId)) {
									topicSet.add(tId);
									TopicAssignment t = new TopicAssignment();
									t.EntityId = newsObj.id;
									t.TopicId = tId;
									topicAssignmentLst.add(t);
								}
							}
						}
						if (!topicLst.contains(topicId)) {
							deleteAssignments.add(topicMap.get(topicId));
						}
					}
				} else {
					for (string strTopicId : topicLst) {
						TopicAssignment t = new TopicAssignment();
						t.EntityId = newsObj.id;
						t.TopicId = strTopicId;
						topicAssignmentLst.add(t);
					}
				}

				if (deleteAssignments.size() > 0) {
					delete deleteAssignments;
				}

				if (topicAssignmentLst.size() > 0) {
					upsert topicAssignmentLst;
				}
			}

			system.debug('****newsObj******' + newsObj);

			return newsObj;
		} else {
			return null;
		}
	}

	//Delete attchment where user updates attchment on news edit page
	@AuraEnabled
	global static void deleteAttachment(String newsRecordId) {
		List<Attachment> attachments = new List<Attachment>();
		attachments = [select id from Attachment where parentId = :newsRecordId];
		if (!attachments.isEmpty()) {
			delete attachments;
		}
	}

	//get session id to use forcetk to upload attchment
	@AuraEnabled
	global static String getSessionId() {
		return String.isEmpty(UserInfo.getSessionId()) ? '' : UserInfo.getSessionId();
	}

	/*
	@Name		  :  getAccessibleFields
	@Description   :  Method to check all fields used in query are accessible
	*/
	public static List<string> getAccessibleFields(String strObj) {

		system.debug('--- strShowNickName access field ---' + strShowNickName);

		set<string> NewsAccessFields = new set<string>{
				'id',
				'name',
				'publish_datetime__c',
				'Author__c',
				'archive_datetime__c',
				'details__c',
				'networkid__c',
				'show_author__c',
				'groupid__c',
				'private_group__c'
		};

		set<string> TopicAssigmtAccessFields = new set<string>{
				'entityid',
				'topicid'
		};
		set<string> TopicAccessFields = new set<string>{
				'name',
				'id'
		};
		set<string> AttachmentAccessFields = new set<string>{
				'id',
				'name'
		};

		String strNamespacePrefix = getOrgNamespace();

		if (strObj.contains('__c')) {
			strObj = strNamespacePrefix + strObj;
		}

		if (Schema.getGlobalDescribe().get(strObj).getDescribe().accessible) {

			String strFieldName = '';

			Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get(strObj).getDescribe().fields.getMap();
			List<String> objectAccessFields = new List<String>();
			String query = '';


			for (String fieldToCheck : strFldNameToFldDesc.KeySet()) {
				if (fieldToCheck.contains('__c')) {
					strFieldName = strNamespacePrefix + fieldToCheck;
				} else {
					strFieldName = fieldToCheck;
				}

				if (strObj == strNamespacePrefix + 'News__c' && NewsAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(strFieldName);
					}
				} else if (strObj == 'TopicAssignment' && TopicAssigmtAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else if (strObj == 'Topic' && TopicAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else if (strObj == 'Attachment' && AttachmentAccessFields.contains(fieldToCheck)) {
					if (strFldNameToFldDesc.get(strFieldName).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				} else {
					if (strFldNameToFldDesc.get(fieldToCheck).getDescribe().isAccessible()) {
						if (fieldToCheck != 'body') {
							objectAccessFields.add(fieldToCheck);
						}
					}
				}
			}

			return objectAccessFields;
		} else {
			return null;
		}
	}

	/*
	@Name		  :  getSobjectQueryString
	@Description   :  Method to generate dynamic query for objects used in process.
					  this method is generating query for News,Attachment (as child query),User (some fields of user needed in news object) as per our requirement
	*/
	public static string getSobjectQueryString(String strObj) {
		List<String> objectAccessFields = getAccessibleFields(strObj);

		if (objectAccessFields != null && objectAccessFields.size() > 0) {
			String query = '';
			List<String> childFields = getAccessibleFields('Attachment');

			if (Schema.getGlobalDescribe().get('User').getDescribe().accessible) {
				Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();
				if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.Name'));
					objectAccessFields.add(String.escapeSingleQuotes('CreatedBy.Name'));
				}
				if (strFldNameToFldDesc.get('FullPhotoUrl').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('createdBy.FullPhotoUrl'));
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.FullPhotoUrl'));
				}
				if (strFldNameToFldDesc.get('CommunityNickname').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('Author__r.CommunityNickName'));
					objectAccessFields.add(String.escapeSingleQuotes('createdBy.CommunityNickname'));
				}
			}

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');
			if (childFields != null && childFields.size() > 0) {
				query += ',(' + 'SELECT ' + String.join(childFields, ',') + ' FROM Attachments )';
			}

			query += ' FROM ';
			if (strObj.contains('__c')) {
				query += getOrgNamespace();
			}
			query += strObj;

			return query;
		} else {
			return null;
		}
	}

	/*
	@Name		  :  getQueryString
	@Description   :  Method to generate dynamic query for objects used in process.
					  this method is generating query for TopicAssignment,Topic as per our requirement
	*/
	public static string getQueryString(String strObj) {
		List<String> objectAccessFields = getAccessibleFields(strObj);

		if (objectAccessFields != null && objectAccessFields.size() > 0) {
			String query = '';

			if (strObj == 'TopicAssignment') {
				if (Schema.getGlobalDescribe().get('Topic').getDescribe().accessible) {
					Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get('Topic').getDescribe().fields.getMap();
					if (strFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
						objectAccessFields.add(String.escapeSingleQuotes('Topic.Name'));
					}
				}
			}

			if (strObj == 'NetworkMember') {
				objectAccessFields.add(String.escapeSingleQuotes('member.CommunityNickname'));
				objectAccessFields.add(String.escapeSingleQuotes('member.Name'));
			}

			query += 'SELECT ';
			query += String.join(objectAccessFields, ',');

			query += ' FROM ';
			if (strObj.contains('__c')) {
				query += getOrgNamespace();
			}
			query += strObj;

			return query;
		} else {
			return null;
		}
	}
/*
	@deprecated
	global static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
		//deprecated
		return null;
	}

	@deprecated
	global static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
		//deprecated
		return null;
	}
*/
}