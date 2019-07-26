/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_ideaListWrapper {

	// Use the debug mode to display more diagnostic information
	// Disabled by default
	@AuraEnabled
	global Boolean debugMode {
		get;
		private set;
	}

	// Set the down voting flag in Custom Settings
	// Enabled by default
	@AuraEnabled
	global Boolean allowDownVoting {
		get;
		private set;
	}

	@AuraEnabled
	global List<Idea> ideaList {
		get;
		set;
	}

	@AuraEnabled
	global Integer totalResults {
		get;
		set;
	}

	@AuraEnabled
	global Integer totalPages {
		get;
		set;
	}

	@AuraEnabled
	global Integer pageNumber {
		get;
		set;
	}

	@AuraEnabled
	global Boolean hasPreviousSet {
		get;
		set;
	}

	@AuraEnabled
	global Boolean hasNextSet {
		get;
		set;
	}

	@AuraEnabled
	global Integer listSizeValue {
		get;
		private set;
	}

	@AuraEnabled
	global Map <String, String> topicNameToId {
		get;
		set;
	}

	private ApexPages.StandardSetController setController { get; set; }

	global SVNSUMMITS_ideaListWrapper(String QUERY, Integer listSizeValue) {
		this(QUERY, listSizeValue, new Set<id>());
	}

	global SVNSUMMITS_ideaListWrapper(String QUERY, Integer listSizeValue, Set<Id> ideasIds) {

		this.topicNameToId = new Map<String, String>();

		this.listSizeValue = listSizeValue;
		system.debug('--->>>>IntoQuery' + QUERY);
		//system.debug('--->>>>' + Database.query(QUERY));
		//this.setController = new ApexPages.StandardSetController(lstObj);
		this.setController = new ApexPages.StandardSetController(Database.getQueryLocator(QUERY));

		this.setController.setPageSize(listSizeValue);

		SVNSUMMITS_Ideas_Common common = new SVNSUMMITS_Ideas_Common();
		this.debugMode = common.debugMode;
		this.allowDownVoting = common.allowDownVoting;

		updateControllerAttributes(ideasIds);
	}

	global void nextPage() {

		this.setController.setpageNumber(this.pageNumber + 1 > 0 ? this.pageNumber + 1 : 1);

		updateControllerAttributes(new Set<id>());
	}

	global void previousPage() {

		this.setController.setpageNumber(this.pageNumber - 1 > 0 ? this.pageNumber - 1 : 1);

		updateControllerAttributes(new Set<id>());
	}

	global void getPage() {
		this.setController.setpageNumber(this.pageNumber);
		updateControllerAttributes(new Set<id>());
	}

	@TestVisible
	private void updateControllerAttributes(Set<Id> ideasIds) {

		if (!ideasIds.isEmpty()) {
			this.ideaList = new List<Idea>();
			List<Idea> tempList = this.setController.getRecords();
			Map<Id, Idea> tempMap = new Map<Id, Idea>();

			for (Idea item : tempList) {
				tempMap.put(item.Id, item);
			}

			for (Id key : ideasIds) {
				if (tempMap.containsKey(key)) {
					this.ideaList.add(tempMap.get(key));
				}
			}
		} else {
			this.ideaList = this.setController.getRecords();
		}

		this.totalResults = this.setController.getResultSize();

		system.debug('    total results ' + this.setController.getResultSize());
		system.debug('    page size     ' + this.setController.getPageSize());
		system.debug('    page number   ' + this.setController.getPageNumber());

		this.totalPages = Math.mod(
				this.setController.getResultSize(), this.setController.getPageSize()) == 0
				? this.setController.getResultSize() / this.setController.getPageSize()
				: this.setController.getResultSize() / this.setController.getPageSize() + 1;
		this.pageNumber = this.totalPages > 0 ? this.setController.getPageNumber() : 0;
		this.hasPreviousSet = this.pageNumber > 1;
		this.hasNextSet = this.pageNumber < this.totalPages;

		Set<String> uniqueTopicNames = new Set<String>();

		for (Idea currIdea : this.ideaList) {
			if (!String.isEmpty(currIdea.Related_Topic_Name__c)) {
				uniqueTopicNames.add(currIdea.Related_Topic_Name__c);
			}
		}

		system.debug('topicNames' + uniqueTopicNames);
		List<string> topicNames = new List<String>();
		topicNames.addAll(uniqueTopicNames);

		this.topicNameToId = SVNSUMMITS_IdeasTopicController.getTopicMap(topicNames);

		system.debug('----this.topicNameToId' + this.topicNameToId);
	}
}