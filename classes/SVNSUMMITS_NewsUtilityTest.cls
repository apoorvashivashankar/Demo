/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsUtilityTest
@Created by          :
@Description         : Apex Utility class used for creating test records
*/
@isTest
global class SVNSUMMITS_NewsUtilityTest
{

	global static user userObj = createUser();
	//global static String strNetworkId = '0DB36000000PB5MGAW';

	global static String strNetworkId
	{
		get
		{
			return [SELECT Id from Network LIMIT 1][0].Id;
		}
	}

	//create News__c record
	global static News__c createNews()
	{
		News__c newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = system.today().addDays(-5),
			Author__c = userObj.Id, NetworkId__c = strNetworkId);

		system.assertNotEquals(null, newsObj);
		insert newsObj;
		return newsObj;
	}

	//create News__c record with the NetworkID
	global static News__c createNews(String strNetId)
	{
		News__c newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = system.today().addDays(-5),
			Author__c = userObj.Id, NetworkId__c = strNetId);

		system.assertNotEquals(null, newsObj);
		insert newsObj;
		return newsObj;
	}

	global static News__c createNewsWithGroup(String strNetId, String groupId)
	{
		News__c newsObj = new News__c(Name = 'Test News', Publish_DateTime__c = system.today().addDays(-5),
			Author__c = userObj.Id, NetworkId__c = strNetId, GroupId__c = groupId);

		system.assertNotEquals(null, newsObj);
		insert newsObj;

		return newsObj;
	}

	global static News__c createNewsWithGroupPrivate(String strNetId, String groupId)
	{
		News__c newsObj = new News__c(
			Name = 'Test News',
			Publish_DateTime__c = system.today().addDays(-5),
			Author__c = userObj.Id,
			NetworkId__c = strNetId,
			GroupId__c = groupId,
			Private_Group__c = true);

		system.assertNotEquals(null, newsObj);
		insert newsObj;

		return newsObj;
	}

	//create News__c record for the Bulk Insertion check
	global static List<News__c> createBulkNews(Integer howmany, String strNetId)
	{
		List<News__c> objNewzList = new List<News__c>();

		for (Integer i = 0; i < howMany; i++)
		{
			News__c newsObj = new News__c(Name = 'Test News' + i, Publish_DateTime__c = system.today().addDays(-5),
				Author__c = userObj.Id, NetworkId__c = strNetId);

			objNewzList.add(newsObj);
		}

		system.assertNotEquals(null, objNewzList);
		insert objNewzList;
		return objNewzList;
	}

	//create Topic record
	global static Topic createTopic()
	{

		return null;
	}

	//Create Topics in Bulk with the Network Id
	global static List<Topic> createTopic(Integer howMany, String strNetId)
	{
		List<topic> topics = new List<topic>();

		for (Integer i = 0; i < howMany; i++)
		{
			Topic topicObj = new Topic(Name = 'Test Topic' + i, Description = 'Test Topic', NetworkId = strNetId);
			topics.add(topicObj);
		}

		if (!topics.isEmpty())
		{
			insert topics;
		}
		system.assertNotEquals(null, topics);
		return topics;
	}

	//Assign Topic , create TopicAssignment with TopicId and entittId to which topic is to be assigned
	global static TopicAssignment createTopicAssignment(String strTopicId, String strEntityId)
	{
		TopicAssignment topicAssigmnt = new TopicAssignment(EntityId = strEntityId, TopicId = strTopicId);

		system.assertNotEquals(null, topicAssigmnt);

		insert topicAssigmnt ;
		return topicAssigmnt ;
	}

	//create user record
	global static User createUser()
	{
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		User u = new User(Alias = 'standt', Email = 'standarduser123@testorg.com',
			EmailEncodingKey = 'UTF-8', LastName = 'stand user', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser1234@testorg.com');

		system.assertNotEquals(null, u);

		insert u;
		return u;
	}

	global static User createAdminUser()
	{
		UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];

		Profile adminProfile =
		[
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

		system.assertNotEquals(null, admin);

		insert admin;
		return admin;
	}

	static final global Id MY_ID = UserInfo.getUserId();
	// Profiles
	static final global String COMPANY_COMMUNITY_PROFILE_NAME = 'Customer Community User';
	static global Id COMPANY_COMMUNITY_PROFILE_Id
	{
		get
		{
			if (COMPANY_COMMUNITY_PROFILE_Id == null)
			{

				List<Profile> profiles = [select Id from Profile where Name like '%Community%'];
				COMPANY_COMMUNITY_PROFILE_Id = profiles[0].id;
			}
			system.assertNotEquals(null, COMPANY_COMMUNITY_PROFILE_Id);
			return COMPANY_COMMUNITY_PROFILE_Id;
		}
		set
		{
			COMPANY_COMMUNITY_PROFILE_Id = value;
			system.assertEquals(value, COMPANY_COMMUNITY_PROFILE_Id);
		}
	}

	static global String THIS_COMMUNITY_NAME
	{
		get
		{
			String commName = '';
			commName = [select Id,Name from Network][0].Name;
			system.assertNotEquals(null, commName);
			return commName;
		}
	}

	// this is for standard user to know
	static global String NETWORK_ID
	{
		get
		{
			if (NETWORK_ID == null)
			{
				NETWORK_ID = [select Id from Network where Name = :THIS_COMMUNITY_NAME][0].Id;
			}
			system.assertNotEquals(null, NETWORK_ID);
			return NETWORK_ID;

		}
		set
		{
			NETWORK_ID = value;
			system.assertEquals(value, NETWORK_ID);
		}

	}

	// Used to create more than 1 user at a time...
	private static Integer userCount = 0;

	//Create Community User
	//As we are using custom object News, we have created user with the custom Community Profile,
	//Because standard community profile do not allow to give permissions to such custom objects.
	global static User createCommunityUsers(String profileName)
	{
		userCount++;

		Account a = new Account(name = 'TestAccount123') ;
		insert a;

		Contact c = new Contact(LastName = 'testCon', AccountId = a.Id);
		insert c;

		Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];

		User u = new User(alias = 'Com', email = 'testtestCommunity@test.com', communitynickname = c.LastName + userCount,
			emailencodingkey = 'UTF-8', lastname = 'Test', languagelocalekey = 'en_US',
			localesidkey = 'en_US', profileid = p.Id, ContactId = c.Id,
			timezonesidkey = 'America/Los_Angeles', username = 'testtestCommunity@test.com' + userCount);

		system.assertNotEquals(null, u);
		insert u;
		return u;
	}

	//Create User with given Profile name
	global static List<User> createUsers(Integer howMany, String profileName)
	{
		Account a = new Account(name = 'TestAccount123') ;
		insert a;

		List<Contact> listOfContacts = new List<Contact>();
		Map<Integer, Contact> mapCont = new Map<Integer, Contact>();

		for (Integer i = 0; i < howMany; i++)
		{
			Contact c = new Contact(LastName = 'testCon' + i, AccountId = a.Id);
			listOfContacts.add(c);
			mapCont.put(i, c);
		}
		insert listOfContacts;

		// by default bidders
		Id profileId;
		// to make user unique
		String type;
		if (profileName == COMPANY_COMMUNITY_PROFILE_NAME)
		{
			profileId = COMPANY_COMMUNITY_PROFILE_Id;
			type = 'com';
		}

		List<User> listOfUsers = new List<User>();

		for (Integer key : mapCont.keySet())
		{
			User u = new User(alias = type + key, email = key + 'testtest@test.com', communitynickname = key + mapCont.get(key).LastName,
				emailencodingkey = 'UTF-8', lastname = 'Test' + type + key, languagelocalekey = 'en_US',
				localesidkey = 'en_US', profileid = profileId, ContactId = mapCont.get(key).Id,
				timezonesidkey = 'America/Los_Angeles', username = key + type + '@test.com');

			listOfUsers.add(u);

		}

		system.assertNotEquals(null, listOfUsers);

		insert listOfUsers;
		return listOfUsers;
	}

	global static Id createTestGroup(Id ownerId, String groupName, List<User> users)
	{
		CollaborationGroup g = new CollaborationGroup(Name = groupName, CollaborationType = 'Public');
		g.OwnerId = ownerId;

		insert g;

		List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();

		for (User user : users)
		{
			CollaborationGroupMember member = new CollaborationGroupMember();
			member.MemberId = user.Id ;
			member.CollaborationGroupId = g.Id ;
			groupMembers.add(member);
		}

		system.assertNotEquals(null, groupMembers);

		insert groupMembers;
		return g.Id ;
	}

	global static Id createTestGroup(String groupName)
	{
		CollaborationGroup myGroup = new CollaborationGroup();
		myGroup.Name = groupName;
		myGroup.CollaborationType = 'Public'; //can be 'Public' or 'Private'

		system.assertNotEquals(null, myGroup);
		insert myGroup;

		return myGroup.Id;
	}

	global static void addTestGroupMember(String groupId, String userId)
	{
		CollaborationGroupMember groupMember = new CollaborationGroupMember();

		groupMember.CollaborationGroupId = groupId;
		groupMember.MemberId = userId;

		system.assertNotEquals(null, groupMember);

		insert groupMember;
	}
}