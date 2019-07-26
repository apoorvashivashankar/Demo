/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_GroupsUtility
@Created by          :
@Description         : Apex Utility class used for creating test records
*/

@isTest
public class SVNSUMMITS_GroupsUtility {

	public static user usr = createUser();
	//public static User admin = createAdminUser();

	//create collaboration group
	public static List<CollaborationGroup> createGroup(Integer noOfGroups) {
		List<CollaborationGroup> collGroupLst = new List<CollaborationGroup>();

		for (Integer i = 0; i < noOfGroups; i++) {
			CollaborationGroup c_group = new CollaborationGroup();
			c_group.Name = 'Test Group' + i;
			c_group.Description = 'Test Description';
			c_group.collaborationType = 'Private';
			collGroupLst.add(c_group);
		}

		insert collGroupLst;
		return collGroupLst;
	}

	//create user record
	public static User createUser() {
		Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		User u = new User(Alias = 'stuser1',
				Email = 'standarduser123@testorg.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'standuser',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				ProfileId = p.Id,
				TimeZoneSidKey = 'America/Chicago',
				UserName = 'standarduser1234@testorg.com');
		insert u;
		return u;
	}

	public static User createAdminUser() {
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

		system.assertNotEquals(null, admin);

		insert admin;
		return admin;
	}
}