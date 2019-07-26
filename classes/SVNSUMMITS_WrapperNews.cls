/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name		  : SVNSUMMITS_WrapperNews
@Created by		  :
@Description		 : Wrapper Apex class used by SVNSUMMITS_NewsController Apex class
					   Mainly this class was created for implementing pagination using setcontroller.
*/
global with sharing class SVNSUMMITS_WrapperNews {

	//List of News__c object
	@AuraEnabled
	global List<News__c> newsList {
		get;
		set;
	}

	@AuraEnabled
	global NetworkMember netMem {
		get;
		set;
	}

	//Map of Topic name to id used to pass name to topicURL component so that it form url for topic detail using topic id from map
	@AuraEnabled
	global Map <String, String> topicNameToId {
		get;
		set;
	}

	// Map of Group id to name for group name
	@AuraEnabled
	global Map<string, string> groupIdToName {
		get;
		set;
	}

	//List of topics associated with news record
	@AuraEnabled
	global List<TopicAssignment> topicsOfRecord {
		get;
		set;
	}

	//Total number of result (records) retured in query
	@AuraEnabled
	global Integer totalResults {
		get;
		set;
	}

	//Total number of pages in pagination as per total results
	@AuraEnabled
	global Integer totalPages {
		get;
		set;
	}

	//Page number for all total number of pages
	@AuraEnabled
	global Integer pageNumber {
		get;
		set;
	}

	//Boolean to check is there previous functionality to show previous button on component
	@AuraEnabled
	global Boolean hasPreviousSet {
		get;
		set;
	}

	//Boolean to check is there nxet functionality to show next button on component
	@AuraEnabled
	global Boolean hasNextSet {
		get;
		set;
	}

	//Integer listSizeValue to define limit in query as per design attributes
	@AuraEnabled
	global Integer listSizeValue {
		get;
		private set;
	}

	//As we have newList and one news can be associated with many topic,map of news id and list of topics associated with it
	@AuraEnabled
	global Map<Id, List<TopicAssignment>> newsToTopicsMap {
		get;
		set;
	}

	@AuraEnabled
	global String strTimeZone {
		get;
		set;
	}

	@AuraEnabled
	global String errorMsg {
		get;
		set;
	}

	@AuraEnabled
	global String field {
		get;
		set;
	}

	@AuraEnabled
	global Map<Id, Integer> newsToCommentCountMap {
		get;
		set;
	}

	private ApexPages.StandardSetController setController { get; set; }

	global SVNSUMMITS_WrapperNews(String field, String errorMsg) {
		this.field = field;
		this.errorMsg = errorMsg;
	}

		/*
		@Name		  :  SVNSUMMITS_WrapperNews
		@parameters	  :  QUERY(query string to query records), intLimit is the limit to query ,newsIds to get records of specified news,
						  authorIds to get news records related to authorIds, fromDt and toDt to get news records in between these to dates as per filter applied on component,
						  isFeatured and featuredNewsIds are used featured 1+4 component is called.
		@Description   :  constructor for wrapper
		*/
	global SVNSUMMITS_WrapperNews(
		String QUERY,
		Integer intLimit,
		set<string> newsIds,
		set<string> authorIds,
		datetime fromDt,
		datetime toDt,
		boolean isFeatured,
		Map<string, string> featurdNewsIds) {

		strTimeZone = String.valueOf(UserInfo.getTimeZone());
		//Initialise newsList
		this.newsList = new List<News__c>();

		//set limit to query
		this.listSizeValue = intLimit;

		System.debug('WrapperNews - QUERY: ' + QUERY);
		//Query news records as per query string from parameters
		this.setController = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY));

		//setting page size for position based on listSizeValue
		this.setController.setPageSize(listSizeValue);

		//call updateControllerAttributes method
		updateControllerAttributes(isFeatured, featurdNewsIds, intLimit);
	}

	 /*
		@Name		  :  nextPage
		@Description   :  used in pagination on click on next button
		*/
	global void nextPage() {

		//set page number for next page in pagination
		this.setController.setpageNumber(this.pageNumber + 1);

		//call updateControllerAttributes method
		updateControllerAttributes(false, null, 0);
	}

		/*
		@Name		  :  previousPage
		@Description   :  used in pagination on click on previous button
		*/
	global void previousPage() {

		//set page number for previous page in pagination
		this.setController.setpageNumber(this.pageNumber - 1);

		//call updateControllerAttributes method
		updateControllerAttributes(false, null, 0);
	}

		/*
		@Name		  :  updateControllerAttributes
		@parameters	:  isFeatured boolean , featuredNewsIds map
		@Description   :  used to set attributes of wrapper so that it can be used on components with proper data
		*/
	private void updateControllerAttributes(boolean isFeatured, Map<string, string> featuredNewsIds, Integer intLimit) {

			/*For featured news, records are to be query in order they are entered in design property of component ,
			so we used map as it store order of ids entered*/

		if (isFeatured == true) {
			List<News__c> templist = this.setController.getRecords();
			Map<id, News__c> tempNewsMap = new Map<id, News__c>();

			for (News__c news : templist) {
				tempNewsMap.put(news.id, news);
			}

			for (string str : featuredNewsIds.keyset()) {
				if (tempNewsMap.containsKey(str)) {
					this.newsList.add(tempNewsMap.get(str));
				}
			}
		}

		//for all other news list get records for set controller directly
		else {

			this.newsList = this.setController.getRecords();
		}

		Id netwrkId = System.Network.getNetworkId();

		if (intLimit == 1) {
			if (!this.newsList.isEmpty()) {
				List<NetworkMember> netMem = new List<NetworkMember>();
				if (this.newsList[0].Author__c != null) {
					netMem = [select id,createdDate from NetworkMember where MemberId = :this.newsList[0].Author__c and NetworkId = :netwrkId limit 1];
				} else {
					netMem = [select id,createdDate from NetworkMember where MemberId = :this.newsList[0].CreatedById and NetworkId = :netwrkId limit 1];
				}
				if (!netMem.isEmpty()) {
					this.netMem = netMem[0];
				}
			}
		}

		this.errorMsg = '';

		this.field = '';

		//set totalResults from query result
		this.totalResults = this.setController.getResultSize();

		//set totalPages as per totalResults and page size
		this.totalPages = Math.mod(this.setController.getResultSize(), this.setController.getPageSize()) == 0 ? this.setController.getResultSize() / this.setController.getPageSize() : this.setController.getResultSize() / this.setController.getPageSize() + 1;

		//set pageNumber as per totalPages
		this.pageNumber = this.totalPages > 0 ? this.setController.getPageNumber() : 0;

		//set hasPreviousSet from getHasPrevious of set controller
		this.hasPreviousSet = this.setController.getHasPrevious();

		//set hasNextSet from getHasNext of set controller
		this.hasNextSet = this.setController.getHasNext();

		//fill set of news id retrived from query to fetch related topics
		set<Id> newsObjIds = new set<Id>();
		for (Sobject news : this.setController.getRecords()) {
			newsObjIds.add(news.Id);
		}

		//Initialise topicNameToId map and newsToTopicsMap
		this.topicNameToId = new Map<String, String>();
		newsToTopicsMap = new Map<Id, List<TopicAssignment>>();

		//created temporary list of topics to add it to map and associate with news id
		List<TopicAssignment> topics = new List<TopicAssignment>();

		List<TopicAssignment> topicList = new List<TopicAssignment>();
		if (netwrkId != null) {
			string strTopicQuery = SVNSUMMITS_NewsController.getQueryString('TopicAssignment');
			strTopicQuery += ' WHERE EntityId IN : newsObjIds';
			strTopicQuery += ' And Topic.NetworkId = \'' + netwrkId + '\'';
			strTopicQuery += ' limit 1000';
			topicList = DataBase.query(strTopicQuery);
			//topicList = [SELECT Id,EntityId,Topic.Id,Topic.Name FROM TopicAssignment WHERE EntityId IN : newsObjIds And Topic.NetworkId =: netwrkId ];
		} else {
			string strTopicQuery = SVNSUMMITS_NewsController.getQueryString('TopicAssignment');
			strTopicQuery += ' WHERE EntityId IN : newsObjIds';
			strTopicQuery += ' limit 1000';
			topicList = DataBase.query(strTopicQuery);
			//topicList = [SELECT Id,EntityId,Topic.Id,Topic.Name FROM TopicAssignment WHERE EntityId IN : newsObjIds limit 2000];
		}

		//Iterate on all topics of news ids retrived from query
		for (TopicAssignment t : topicList) {

			//fill map of topic name to topic id
			this.topicNameToId.put(t.Topic.Name, t.TopicId);
			topics = new List<TopicAssignment>();

			//fill map of news id to topics associated with it
			if (newsToTopicsMap.containsKey(t.EntityId)) {

				topics.addAll(newsToTopicsMap.get(t.EntityId));
			}

			topics.add(t);
			if (intLimit == 1) {
				newsToTopicsMap.put(t.EntityId, topics);
			} else {
				if (topics.size() < 4) {
					newsToTopicsMap.put(t.EntityId, topics);
				}
			}
		}

		// update group id, name map
		this.groupIdToName = SVNSUMMITS_NewsController.getAllGroups();

		newsToCommentCountMap = generateNewsToCommentCountMap(newsObjIds);
	}

	private static Map<Id, Integer> generateNewsToCommentCountMap(Set<Id> newsIds) {
		Map<Id, Integer> newsToCommentCountMap = new Map<Id, Integer>();

		for (Id newsId : newsIds) {
			newsToCommentCountMap.put(newsId, 0); // Initialize...
		}

		// Sadly doesn't support aggregate queries or sub-counts :( so this is all manual...
		// https://developer.salesforce.com/forums/?id=906F0000000917CIAQ
		for (News__Feed item : [Select ParentId, Id,CommentCount From News__Feed where ParentId = :newsIds]) {
			// Get the current count
			Integer num = newsToCommentCountMap.get(item.ParentId);
			// Increment by 1 at least (the parent feed item)
			num++;
			// Add the count of the comments to that first feed item
			num += item.CommentCount;
			newsToCommentCountMap.put(item.ParentId, num);
		}

		return newsToCommentCountMap;
	}
/*
	@deprecated
	//this is not used anywhere but could not delete it due to packaging
	global SVNSUMMITS_WrapperNews(String QUERY, Integer intLimit, set<string> newsIds, set<string> authorIds, datetime fromDt, datetime toDt, boolean isFeatured) {
		//this is not used anywhere but could not delete it due to packaging deprecated
	}
*/
}