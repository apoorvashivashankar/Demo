/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsControllerTest
@Created by          :
@Description         : Apex Test class for SVNSUMMITS_NewsController
*/
@isTest
public class SVNSUMMITS_NewsControllerTest {

	//Hardcoded Network Id as we can't able to get get Network Id in Test classes.
	//Packaging org
	//public Static String strNetId = '0DB36000000PB5MGAW';

	public static String strNetId {
		get {
			return [SELECT Id from Network LIMIT 1][0].Id;
		}
	}

	// Fran Summer 17 org
	//public Static String strNetId = '0DBB0000000CayaOAC';

     @testSetup
    static void testSetup(){
        Contact con = Dal_TestUtils.createTestContact();  
        
        List<SSC__c> sscList = new List<SSC__c>();
        SSC__c ssc = new SSC__c();
        ssc.Name = 'SSC Account';
        sscList.add(ssc);
        insert sscList;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.SSC__c = ssc.Id;        
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
        
    }

	@isTest
	static void test_NewsBulk() {

		//set NetworkId variables of the Class with hardcoded value.
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create News in Bulk to check with bulk data.
		List<News__c> objNewzBulkList = SVNSUMMITS_NewsUtilityTest.createBulkNews(1001, strNetId);

		//create Topic Records
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(1001, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj.id);
		TopicAssignment topicAssg1 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj1.id);
		TopicAssignment topicAssg2 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj2.id);
		TopicAssignment topicAssg3 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj3.id);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		//User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		//System.runAs(u)

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				LanguageLocaleKey = 'en_US');
		System.runAs(admin) {
			Test.startTest();

             Contact c = new Contact(FirstName = 'test1'
                             ,LastName = 'test2'
                             );
               insert c;
            
			//call getNews to fetch records on list view with no recordid and without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapper = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertEquals(newsWrapper.newsList.size(), 10);

			//call getNews to fetch records on list view without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapperList = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews method to fetch records on list with sirt by as 'Most Recent'
			SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Most Recent', null, null, null, 'None', null, null, null);
			system.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews method to fetch records on list with sirt by as 'Oldest First'
			SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', null, null, null, 'None', null, null, null);
			system.assertEquals(newsWrapperList.newsList.size(), 10);

			//call getNews to fetch recommended records on detail page of news record
			SVNSUMMITS_WrapperNews newsWrapperRecomm = SVNSUMMITS_NewsController.getNews(0, 10, null, newsObj.id, null, null, null, null, null, 'None', null, null, null);
			system.assertEquals(newsWrapperRecomm.newsList.size(), 3);

			//call getNews method on search page to show related data of search term with sort by as 'Most Recent'
			SVNSUMMITS_WrapperNews newsWrapperSearchItemsRecent = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Most Recent', null, null, null, 'Search Term', 'test', null, null);
			system.assertEquals(newsWrapperSearchItemsRecent.newsList.size(), 10);

			//call getNews method on search page to show related data of search term with sort by as 'Oldest First'
			SVNSUMMITS_WrapperNews newsWrapperSearchItemsOldest = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', null, null, null, 'Search Term', 'test', null, null);
			system.assertEquals(newsWrapperSearchItemsOldest.newsList.size(), 10);

			//call getNews method to show all news related to topic on topic detail page with sort by as 'Most Recent'
			SVNSUMMITS_WrapperNews newsWrapperTopicsRecent = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Most Recent', null, null, topics[0].Name, 'Topic Value', null, null, null);
			system.assertEquals(newsWrapperTopicsRecent.newsList.size(), 4);

			//call getNews method to show all news related to topic on topic detail page with sort by as 'Oldest First'
			SVNSUMMITS_WrapperNews newsWrapperTopicsOldest = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', null, null, topics[0].Name, 'Topic Value', null, null, null);
			system.assertEquals(newsWrapperTopicsOldest.newsList.size(), 4);

			//call getNews method to filter list view on basis of topic filter
			SVNSUMMITS_WrapperNews newsWrapperTopicsFilter = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', topics[0].Id, null, null, null, null, null, null);
			system.assertEquals(newsWrapperTopicsFilter.newsList.size(), 4);

			Test.stopTest();
		}
	}

	@isTest
	static void test_GetNews() {

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//create Topic Records
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(1001, strNetId);

		//Assign Topic to News Records
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj.id);
		TopicAssignment topicAssg1 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj1.id);
		TopicAssignment topicAssg2 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj2.id);
		TopicAssignment topicAssg3 = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj3.id);

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		//User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		//System.runAs(u)

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				LanguageLocaleKey = 'en_US');
		System.runAs(admin) {
			Test.startTest();

			//call getNews method to filter list view on basis of date filter
			SVNSUMMITS_WrapperNews newsWrapperDateFilter = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', null, null, null, null, null,
					String.valueOf(system.today().addDays(-15)), String.valueOf(system.today().addDays(15)));
			system.assertEquals(newsWrapperDateFilter.newsList.size(), 5);

			//call getNews method to filter list view on basis of date filter and topic Filter
			SVNSUMMITS_WrapperNews newsWrapperDateTopicFilter = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', topics[0].Id, null, null, null, null,
					String.valueOf(system.today().addDays(-15)), String.valueOf(system.today().addDays(15)));
			system.assertEquals(newsWrapperDateTopicFilter.newsList.size(), 4);

			//Get Authors for Author dropdown in List view of news
			Map<string, string> authorMap = SVNSUMMITS_NewsController.getAuthors();
			string authorId ;
            
            if(authorMap != null)
            {
                for (String str : authorMap.KeySet()) {
                    authorId = str;
                }
         
            	system.assertEquals(authorMap.size(), 1);
			               
            }
			//update news record show author as true
			newsObj.Show_Author__c = true;
			update newsObj;

			//call getNews method to filter list view on basis of Author filter
			SVNSUMMITS_WrapperNews newsWrapperAuthorFilter = SVNSUMMITS_NewsController.getNews(0, 10, null, null, null, 'Oldest First', null, authorId, null, null, null, null, null);
			system.assertNotEquals(newsWrapperAuthorFilter.newsList, null);

			//call getNews to fetch records on list view with no recordid,without any filter and sorting
			SVNSUMMITS_WrapperNews newsWrapperlst = SVNSUMMITS_NewsController.getNews(0, 2, null, null, null, null, null, null, null, 'None', null, null, null);

			//call nextPage method to perform next operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstnextPage = SVNSUMMITS_NewsController.nextPage(0, 2, 1, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertNotEquals(newsWrapperlstnextPage.newsList, null);
			System.assertEquals(2, newsWrapperlstnextPage.pageNumber);

			//call nextPage method to perform next operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstnextPage1 = SVNSUMMITS_NewsController.nextPage(0, 2, 2, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertNotEquals(newsWrapperlstnextPage1.newsList, null);
			System.assertEquals(3, newsWrapperlstnextPage1.pageNumber);

			//call previousPage method to perform previous operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstprevPage = SVNSUMMITS_NewsController.previousPage(0, 2, 3, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertNotEquals(newsWrapperlstprevPage.newsList, null);
			System.assertEquals(2, newsWrapperlstprevPage.pageNumber);

			//call previousPage method to perform previous operation in pagination
			SVNSUMMITS_WrapperNews newsWrapperlstprevPage1 = SVNSUMMITS_NewsController.previousPage(0, 2, 2, null, null, null, null, null, null, null, 'None', null, null, null);
			system.assertNotEquals(newsWrapperlstprevPage1.newsList, null);
			System.assertEquals(1, newsWrapperlstprevPage1.pageNumber);

			Test.stopTest();
		}
	}

	@isTest
	static void test_News() {

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj.id);

		//Create Community user
		List<user> lstOfUser = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		//User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		//System.runAs(u)

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				LanguageLocaleKey = 'en_US');

		System.runAs(admin) {
			Test.startTest();

			//Get Topics for Topic dropdown in List view of news
			Map<string, string> topicMap = SVNSUMMITS_NewsController.getTopics();
			system.assertEquals(topicMap.size(), 2);

			//call method to check if object is creatable to show hide "Add new" button on header in list view page
			SVNSUMMITS_NewsController.isObjectCreatable();

			//call method to check if object creatable and updateable to show hide edit button on detail page of news
			SVNSUMMITS_NewsController.isObjectEditable();

			//call method to get session Id of user
			String sessionId = SVNSUMMITS_NewsController.getSessionId();
			system.assertNotEquals(sessionId, null);

			//call method to get Site Prefix
			String strSitePathPrefix = SVNSUMMITS_NewsController.getSitePrefix();
			system.assertEquals(strSitePathPrefix, System.Site.getPathPrefix());

			//call method to check if "display community nick name" is true or false in community
			SVNSUMMITS_NewsController.isNicknameDisplayEnabled();

			//Get Featured News 1+4 Across
			SVNSUMMITS_WrapperNews featured14newsWrapper = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.id, newsObj1.id, newsObj2.id, newsObj3.id, newsObj4.id);
			system.assertEquals(featured14newsWrapper.newsList.size(), 5);

			//Get Featured News 3 Across
			SVNSUMMITS_WrapperNews featuredNewsWrapper = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.id, newsObj1.id, newsObj2.id, null, null);
			system.assertEquals(featuredNewsWrapper.newsList.size(), 3);

			//Get Featured News 3 Across with invalid Id
			SVNSUMMITS_WrapperNews featuredNewsWrapper1 = SVNSUMMITS_NewsController.getFeaturedNews(newsObj.id, newsObj1.id, '12343534', null, null);
			system.assertEquals(featuredNewsWrapper1.newsList.size(), 2);

			//Get News Record for detail page
			SVNSUMMITS_WrapperNews newsRecord = SVNSUMMITS_NewsController.getNewsRecord(newsObj.id);
			system.assertEquals(newsRecord.newsList.size(), 1);

			//create new News Object to pass it to save method to create new news record
			News__c newNewsObj = new News__c(Name = 'Test New News', Details__c = 'Test Description', Publish_DateTime__c = system.today().addDays(5));

			//Call Save method to insert new News record
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);
			system.assertNotEquals(newNewsObj.Id, null);

			//create Attachment related to news object created
			Attachment attach = new Attachment();
			attach.Name = 'Unit Test Attachment';
			Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
			attach.body = bodyBlob;
			attach.parentId = newNewsObj.Id;
			insert attach;

			//updated news records with one more topic added
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id + ';' + topics[1].id);

			//Check if topic updated is assigned to news record
			TopicAssignment topicAssgnmentNew = [select id,EntityId from TopicAssignment where topicId = :topics[1].id and EntityId = :newNewsObj.Id];
			system.assertNotEquals(topicAssgnmentNew.Id, null);

			//Delete attchment if user updates attchment
			SVNSUMMITS_NewsController.deleteAttachment(newNewsObj.Id);
			List<Attachment> attachment = [select id from Attachment where parentId = :newNewsObj.Id];
			system.assertEquals(attachment.size(), 0);

			//updated news records with by removing one topic
			SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);

			//Check if topic assignment is deleted when it is removed on updating news record
			List<TopicAssignment> topicAssgnmentDeleted = [select id,EntityId from TopicAssignment where topicId = :topics[1].id and EntityId = :newNewsObj.Id];
			system.assertEquals(topicAssgnmentDeleted.size(), 0);

			Test.stopTest();
		}
	}

	@isTest
	static void test_Authors() {
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		//create News Records
		News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
		News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);
		TopicAssignment topicAssg = SVNSUMMITS_NewsUtilityTest.createTopicAssignment(topics[0].id, newsObj.id);

		//Create Community user
		List<user> lstOfUser = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');

		//Create Community User
		//As we are using custom object News, we have created user with the custom Community Profile,
		//Because standard community profile do not allow to give permissions to such custom objects.
		//User u = SVNSUMMITS_NewsUtilityTest.createCommunityUsers('Customer Community User Clone');
		//System.runAs(u)

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				LanguageLocaleKey = 'en_US');

		System.runAs(admin) {
			Test.startTest();

			//Get Authors for Author dropdown in List view of news
			Map<string, string> authorMap = SVNSUMMITS_NewsController.getAuthors();
			system.debug('get users: ' + authorMap); // added by MTX 
			
			if(authorMap != null)
			{
				system.assertEquals(1, authorMap.size());
			}
			
						//Get Network Members for Author dropdown in Create news Page
			Map<string, string> getUsers = SVNSUMMITS_NewsController.getUsers();
			system.debug('get users: ' + getUsers);
			system.assertNotEquals(null, getUsers);

			Map<string, string>searchUsers = SVNSUMMITS_NewsController.searchUsers('michael');
			system.debug('get users: ' + searchUsers);
			system.assertNotEquals(null, searchUsers);

			Test.stopTest();
		}
	}

	@isTest
	static void test_saveNewsItem() {
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				UserRoleId = portalRole.Id,
				LanguageLocaleKey = 'en_US');

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		System.runAs(admin) {
			Test.startTest();

			News__c news = SVNSUMMITS_NewsController.saveNewsItem(
					'News for 2',
					'<p>News text for two</p>',
					true,
					admin.Id,
					'2017-06-02 17:10:00',
					'','',''
					);

			system.assert(news.Id != null);
			Test.stopTest();
		}
	}

	@isTest
	static void test_Topics() {
		//Create Topic Record
		//List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2000);
		//Get Topics for Topic dropdown in List view of news
		//Map<string,string> topicMap = SVNSUMMITS_NewsController.getTopics();
		//system.assertEquals(topicMap.size(),2000);

		//set NetworkId variables of the Class with hardcoded value.
		//String strNetId = '0DB36000000PB5MGAW';
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		List<user> users = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');
		if (!users.isEmpty()) {
			system.runAs(users[0]) {
				Test.startTest();

				//Create Topic Record
				List<Topic> topics1 = SVNSUMMITS_NewsUtilityTest.createTopic(2000, strNetId);
				system.assertEquals(topics1.size(), 2000);
				//Get Topics for Topic dropdown in List view of news
				Map<string, string> topicMap1 = SVNSUMMITS_NewsController.getTopics();

				//system.assertEquals(topicMap1.size(),2000);
				Test.stopTest();
			}
		}
	}

	@isTest
	static void test_Groups() {
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		List<user> users = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User');
		if (!users.isEmpty()) {
			system.runAs(users[0]) {
				Test.startTest();

				Map<string, string> groupList = SVNSUMMITS_NewsController.getAllGroups();
				system.assertNotEquals(null, groupList);

				Test.stopTest();
			}
		}
	}

	@isTest
	static void test_newsItemWithGroup() {
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				UserRoleId = portalRole.Id,
				LanguageLocaleKey = 'en_US');

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		System.runAs(admin) {
			Test.startTest();

			Id testGroupId = SVNSUMMITS_NewsUtilityTest.createTestGroup('group1234');
			String testGroupIdStr = (String) testGroupId;

			Map<String, String> groupList = SVNSUMMITS_NewsController.getGroups();
			system.assertNotEquals(null, groupList);

			News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNewsWithGroup(strNetId, testGroupIdStr);
			system.assertEquals(testGroupIdStr, newsObj.GroupId__c);
			System.assertEquals(false, newsObj.Private_Group__c);

			News__c newsPrivate = SVNSUMMITS_NewsUtilityTest.createNewsWithGroupPrivate(strNetId, testGroupIdStr);
			system.assertEquals(testGroupIdStr, newsPrivate.GroupId__c);
			system.assertEquals(true, newsPrivate.Private_Group__c);

			Test.stopTest();
		}
	}

	@isTest
	static void test_saveNewsWithGroup() {
		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		//Create Topic Record
		List<Topic> topics = SVNSUMMITS_NewsUtilityTest.createTopic(2, strNetId);

		Test.startTest();

		Id testGroupId = SVNSUMMITS_NewsUtilityTest.createTestGroup('Test group2');
		String testGroupIdStr = (String) testGroupId;

		//create new News Object to pass it to save method to create new news record
		News__c newNewsObj = new News__c(
				Name = 'Test New News',
				Details__c = 'Test Description',
				Publish_DateTime__c = system.today().addDays(5),
				GroupId__c = testGroupIdStr,
				Private_Group__c = false);

		//Call Save method to insert new News record
		News__c savedNews = SVNSUMMITS_NewsController.saveNews(newNewsObj, topics[0].Id);
		system.assertNotEquals(savedNews.Id, null);

		SVNSUMMITS_WrapperNews newsWrapper = SVNSUMMITS_NewsController.getNewsRecord(savedNews.Id);
		system.assertNotEquals(newsWrapper.groupIdToName, null);
		system.assertEquals('Test group2', newsWrapper.groupIdToName.get(testGroupId));

		Test.stopTest();
	}

	@isTest
	private static void test_isRecordEditable() {
        Contact contact = [SELECT Id FROM Contact];
	    Profile p = [SELECT Id FROM Profile WHERE Name like '%Community%' limit 1];

		User user1 = new User(Alias = 'standt', Email = 'standarduser12453@testorg.com',
			EmailEncodingKey = 'UTF-8', LastName = 'stand user', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser1254434@testorg.com' , contactId = contact.id);

		insert user1;
		
		

		SVNSUMMITS_NewsController.networkId = Id.valueOf(strNetId);
		SVNSUMMITS_NewsController.strnetworkId = strNetId;

		Test.startTest();

		News__c newsObj;
		System.runAs(user1) {
			newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = system.today().addDays(-5),
					Author__c = user1.Id, NetworkId__c = strNetId);
			insert newsObj;

			// Evaluates to true, user is owner of record
			System.assertNotEquals(true, SVNSUMMITS_NewsController.isRecordEditable(newsObj.Id));

			// Can user delete
			System.assertNotEquals(true, SVNSUMMITS_NewsController.isRecordDeletable(newsObj.Id));
		}

		
		Test.stopTest();
	}

	@isTest
	static void test_deleteRecord() {
		News__c adminNews = SVNSUMMITS_NewsUtilityTest.createNews();
		User u = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User')[0];

		System.runAs(u) {

			Test.startTest();

			Boolean adminAccess = SVNSUMMITS_NewsController.getUserRecordAccess(UserInfo.getUserId(), adminNews.Id).HasDeleteAccess;
			System.assertEquals(adminAccess, SVNSUMMITS_NewsController.deleteRecord(adminNews.Id));
			if (adminAccess) {
				System.assertEquals(0, [SELECT COUNT() FROM News__c WHERE Id = :adminNews.Id]);
			} else {
				System.assertEquals(1, [SELECT COUNT() FROM News__c WHERE Id = :adminNews.Id]);
			}

			if (SVNSUMMITS_NewsController.isObjectCreatable()) {
				News__c myNews = SVNSUMMITS_NewsUtilityTest.createNews();

				Boolean myAccess = SVNSUMMITS_NewsController.isRecordDeletable(myNews.Id);
				myAccess = SVNSUMMITS_NewsController.getUserRecordAccess(UserInfo.getUserId(), myNews.Id).HasDeleteAccess;

				System.assertEquals(myAccess, SVNSUMMITS_NewsController.deleteRecord(myNews.Id));

				if (myAccess) {
					System.assertEquals(0, [SELECT COUNT() FROM News__c WHERE Id = :myNews.Id]);
				} else {
					System.assertEquals(1, [SELECT COUNT() FROM News__c WHERE Id = :myNews.Id]);
				}
			}

			Test.stopTest();
		}
	}

	@isTest
	static void test_getCurrentUser() {
		User u = SVNSUMMITS_NewsUtilityTest.createUsers(1, 'Customer Community User')[0];

		System.runAs(u) {
			User usr = SVNSUMMITS_NewsController.getCurrentUser();
			System.assertNotEquals(null, usr);
		}
	}

	@isTest
	static void test_isFollowing() {
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

		Profile adminProfile = [
				SELECT Id
				FROM profile
				WHERE Name = 'System Administrator'
				LIMIT 1
		];

		User admin = new User(LastName = 'test user 1',
				Username = 'test.user.1@example.com',
				Email = 'test.1@example.com',
				Alias = 'testu1',
				TimeZoneSidKey = 'GMT',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				ProfileId = adminProfile.Id,
				UserRoleId = portalRole.Id,
				LanguageLocaleKey = 'en_US');

		System.runAs(admin) {
			Test.startTest();

			News__c newsItem = SVNSUMMITS_NewsUtilityTest.createNews();
			Boolean userIsFollowing = SVNSUMMITS_NewsController.isFollowing(newsItem.Id);
			System.assertEquals(false, userIsFollowing);

			userIsFollowing = SVNSUMMITS_NewsController.followRecord(newsItem.Id);
			//System.assertEquals(true, userIsFollowing);

			userIsFollowing = SVNSUMMITS_NewsController.unfollowRecord(newsItem.id);
			//System.assertEquals(true, userIsFollowing);

			Test.stopTest();
		}
	}

	@isTest
	static void test_userAuthorizedToPost() {
		Boolean canPost = SVNSUMMITS_NewsController.userAuthorizedToPost();
		System.assertNotEquals(null, canPost);
		System.debug('test_userAuthorizedToPost = ' + canPost);
	}

	@isTest
	static void test_requireGroupMembership()
	{
		Boolean requireGroup = SVNSUMMITS_NewsController.requireGroupMembership();
		System.assertNotEquals(null, requireGroup);
		System.debug('requireGroupMembership = ' + requireGroup);
	}

	@isTest
	static void test_getNameSpacePrefix() {
		System.assertNotEquals(null, SVNSUMMITS_NewsBaseController.getModel());
	}

	@isTest
	static void test_wrapperCtor() {
		SVNSUMMITS_WrapperNews wrapper = new SVNSUMMITS_WrapperNews('field1', 'error message');
		System.assertEquals('field1', wrapper.field);
	}
}