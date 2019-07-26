/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_GroupsControllerTest
@Created by          :
@Description         : Apex Test class for SVNSUMMITS_GroupsController
*/
@isTest
public class SVNSUMMITS_GroupsControllerTest {

	@isTest
	static void test_Groups() {
		//Create Groups
		List<CollaborationGroup> cgroup = SVNSUMMITS_GroupsUtility.createGroup(8);

		//Fetch Groups with sort by as 'Latest Group Activity'
		SVNSUMMITS_WrapperGroups groupsWrapper = SVNSUMMITS_GroupsController.getGroups(10, 'Latest Group Activity', null, null);
		system.assertEquals(groupsWrapper.groupsList.size(), 8);
		System.assertEquals(8, groupsWrapper.groupMembership.size());

		//Fetch Groups with sort by as 'Date Created : Oldest'
		SVNSUMMITS_WrapperGroups groupsWrapper1 = SVNSUMMITS_GroupsController.getGroups(10, 'Date Created : Oldest', null, null);
		system.assertEquals(groupsWrapper1.groupsList.size(), 8);

		//Fetch Groups with Search Term as 'Test' and sort by as 'Date Created : Newest'
		SVNSUMMITS_WrapperGroups groupsWrapper2 = SVNSUMMITS_GroupsController.getGroups(10, 'Date Created : Newest', null, 'Test');
		system.assertEquals(groupsWrapper2.groupsList.size(), 8);

		//Fetch My Groups
		SVNSUMMITS_WrapperGroups groupsWrapper3 = SVNSUMMITS_GroupsController.getGroups(10, 'Date Created : Newest', 'My Groups', null);
		system.assertEquals(groupsWrapper3.groupsList.size(), 8);

		//Fetch Groups with filter of 'search term' and sort by as 'Date Created : Newest'
		SVNSUMMITS_WrapperGroups groupsWrapperSearch = SVNSUMMITS_GroupsController.getGroups(10, null, null, 'Test Group1');
		system.assertEquals(groupsWrapperSearch.groupsList.size(), 1);

		//Fetch Groups to process next for pagination
		SVNSUMMITS_WrapperGroups groupsWrapperNext = SVNSUMMITS_GroupsController.nextPage(2, 1, 'Recently Viewed', null, null);
		System.assertEquals(2, groupsWrapperNext.pageNumber);

		//Fetch Groups to process next for pagination
		SVNSUMMITS_WrapperGroups groupsWrapperNext1 = SVNSUMMITS_GroupsController.nextPage(2, 2, 'Recently Viewed', null, null);
		System.assertEquals(3, groupsWrapperNext1.pageNumber);

		//Fetch Groups to process Previous for pagination
		SVNSUMMITS_WrapperGroups groupsWrapperPrev = SVNSUMMITS_GroupsController.previousPage(2, 2, 'Number Of Members', null, null);
		System.assertEquals(1, groupsWrapperPrev.pageNumber);

		//call method to get sit Prefix
		String strSitePathPrefix = SVNSUMMITS_GroupsController.getSitePrefix();
		system.assertEquals(strSitePathPrefix, System.Site.getPathPrefix());

		//call method to check if "display community nick name" is true or false in community
		SVNSUMMITS_GroupsController.isNicknameDisplayEnabled();

		//call method to check if object is creatable to show hide "Add new" button on header in list view page
		SVNSUMMITS_GroupsController.isObjectCreatable();

		//Fetch Featured Groups
		SVNSUMMITS_WrapperGroups featuredGroupsWrapper = SVNSUMMITS_GroupsController.getFeaturedGroups(cgroup[0].Id, cgroup[1].Id, cgroup[2].Id, cgroup[3].Id, cgroup[4].Id, cgroup[5].Id, cgroup[6].Id, cgroup[7].Id);
		system.assertEquals(featuredGroupsWrapper.groupsList.size(), 8);

		//Fetch Featured Groups with one invalid id
		SVNSUMMITS_WrapperGroups featuredGroupsWrapper1 = SVNSUMMITS_GroupsController.getFeaturedGroups(cgroup[0].Id, cgroup[1].Id, cgroup[2].Id, cgroup[3].Id, cgroup[4].Id, cgroup[5].Id, cgroup[6].Id, '13212324');
		system.assertEquals(featuredGroupsWrapper1.groupsList.size(), 7);

		SVNSUMMITS_WrapperGroups msgTest = new SVNSUMMITS_WrapperGroups('message 1');
		System.assertEquals('message 1', msgTest.errorMsg);
	}

	@IsTest
	static void testGroupMembership() {
		User adminUser = SVNSUMMITS_GroupsUtility.createAdminUser();
		System.runAs(adminUser) {
			List<CollaborationGroup> testGroups = SVNSUMMITS_GroupsUtility.createGroup(8);
			Map<String, String> groupList = SVNSUMMITS_GroupsController.getMembershipGroups(adminUser.Id);
			System.debug('Admin Groups: ' + groupList);
			system.assertNotEquals(null, groupList);
			System.assertEquals(8, groupList.size());

			CollaborationGroup testGroup = testGroups[0];
			User testUser = SVNSUMMITS_GroupsUtility.usr;

			// Join
			String collaborationId = SVNSUMMITS_GroupsController.joinGroup(testGroup.Id, testUser.Id);
			System.assertNotEquals(null, collaborationId);
			groupList = SVNSUMMITS_GroupsController.getMembershipGroups(testUser.Id);
			System.debug('TestUser Groups: ' + groupList);
			System.assertEquals(1, groupList.size());

			// Leave
			SVNSUMMITS_GroupsController.leaveGroup(testGroup.Id, testUser.Id);
			groupList = SVNSUMMITS_GroupsController.getMembershipGroups(testUser.Id);
			System.debug('TestUser Groups: ' + groupList);
			System.assertEquals(0, groupList.size());
		}
	}
}