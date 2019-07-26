/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_GroupsController
@Created by          :
@Description         : Apex class used in Groups Lightning Components
*/
global with sharing class SVNSUMMITS_GroupsController {

	//set default list size and page value for nextPage and previousPage methods of pagination
	private static final Integer DEFAULT_LIST_SIZE = 50;
	private static final Integer DEFAULT_PAGE_VALUE = 1;

	private static final String strObjectName = 'CollaborationGroup';

	//set of group fields to check access on and add in query
	private static final set<string> groupAccessFields = new set<String>{
			'id',
			'collaborationtype',
			'name',
			'description',
			'fullphotourl',
			'membercount',
			'networkid',
			'lastfeedmodifieddate',
			'ownerid'
	};

	//fetch system network Id
	public static Id networkId = System.Network.getNetworkId();

	/*
	@Name          :  getGroups
	@parameters    :  numberOfGroups Integer, sortBy String , searchMyGroups String, searchString String
	@Description   :  used to set attributes of wrapper so that it can be used on components with proper data
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperGroups getGroups(Integer numberOfGroups, String sortBy, String searchMyGroups, String searchString) {
		try {

			//set limit for query from numberOfGroups entered by user in builder
			Integer intLimit = Integer.valueOf(numberOfGroups);

			//Initialise set of groups that contains set of group ids
			set<String> groupIds = new set<String>();

			//fetch query string
			String Query = getSimpleQueryString(String.escapeSingleQuotes(strObjectName));

			//check if query string is not blank
			if (String.isNotBlank(Query)) {

				//check id from network is not null, then add filter condition to query
				Query += networkId != null ? ' Where NetworkId = \'' + networkId + '\'' : ' Where NetworkId = null';

				//check if sorting is applied or search is performed or 'My groups' is checked
				if (searchMyGroups == 'My Groups' ||
						(String.isNotBlank(searchString) && searchString.trim().length() > 0) ||
						(String.isNotBlank(sortBy) && sortBy.trim().length() > 0)) {

					//if 'My Groups' selected fetch all groups id where that user is member
					if (searchMyGroups == 'My Groups') {
						for (CollaborationGroupMember member : [
								SELECT id,CollaborationGroupId, CollaborationGroup.Name
								FROM CollaborationGroupMember
								WHERE MemberId = :userinfo.getuserid()
								LIMIT 1000
						]) {
							groupIds.add(member.CollaborationGroupId);
						}

						Query += ' And Id IN : groupIds';
					}

					//if search is performed, then search for text in group name, description and information title
					if (String.isNotBlank(searchString) && searchString.trim().length() > 0) {
						Query += ' And ( Name LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
						Query += ' OR Description LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
						Query += ' OR InformationTitle LIKE \'%' + String.escapeSingleQuotes(searchString.trim()) + '%\')';
					}

					//Apply sort by (order by) as selected
					if (sortBy == 'Latest Group Activity') {
						Query += ' ORDER BY LastFeedModifiedDate DESC';
					} else if (sortBy == 'Recently Viewed') {
						Query += ' ORDER BY LastViewedDate DESC';
					} else if (sortBy == 'Number Of Members') {
						Query += ' ORDER BY MemberCount DESC';
					} else if (sortBy == 'Date Created : Oldest') {
						Query += ' ORDER BY CreatedDate';
					} else if (sortBy == 'Date Created : Newest') {
						Query += ' ORDER BY CreatedDate DESC';
					}
				}

				return new SVNSUMMITS_WrapperGroups(Query, intLimit, groupIds, false, null, null);
			}

			return null;
		} catch (Exception e) {
			return new SVNSUMMITS_WrapperGroups(e.getMessage());
		}
	}

	/*
   @Name          :  nextPage
   @Description   :  Method used on click of "Next" in pagination to diaplay groups records as per numberOfGroups
   */
	@AuraEnabled
	global static SVNSUMMITS_WrapperGroups nextPage(Integer numberOfGroups, Integer pageNumber, String sortBy, String searchMyGroups, String searchString) {
		Integer listSizeValue = numberOfGroups != null ? Integer.valueOf(numberOfGroups) : DEFAULT_LIST_SIZE ;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE ;

		SVNSUMMITS_WrapperGroups wrapperGroup = getGroups(listSizeValue, sortBy, searchMyGroups, searchString);
		wrapperGroup.pageNumber = pageNumberValue;

		wrapperGroup.nextPage();

		return wrapperGroup;
	}

	/*
	@Name          :  previousPage
	@Description   :  Method used on click of "Previous" in pagination to diaplay groups records as per numberOfGroups
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperGroups previousPage(Integer numberOfGroups, Integer pageNumber, String sortBy, String searchMyGroups, String searchString) {
		Integer listSizeValue = numberOfGroups != null ? Integer.valueOf(numberOfGroups) : DEFAULT_LIST_SIZE ;
		Integer pageNumberValue = pageNumber != null ? Integer.valueOf(pageNumber) : DEFAULT_PAGE_VALUE ;

		SVNSUMMITS_WrapperGroups wrapperGroup = getgroups(listSizeValue, sortBy, searchMyGroups, searchString);
		wrapperGroup.pageNumber = pageNumberValue;

		wrapperGroup.previousPage();

		return wrapperGroup;
	}

	/*
	@Name          :  getSitePrefix
	@Description   :  Method to fetch site prefix so that urls are redirected properly dynamically in any org.
	*/
	@AuraEnabled
	global static String getSitePrefix() {
		return System.Site.getPathPrefix();
	}

	/*
   @Name          :  isNicknameDisplayEnabled
   @Description   :  Method to fetch community setting for nick name to display users name or name as per setting.
   */
	@AuraEnabled
	global static Boolean isNicknameDisplayEnabled() {
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
	global static Boolean isObjectCreatable() {
		//check if user profile has Create and Own New Chatter Groups permission
		Profile userProfile = [Select Id,PermissionsChatterOwnGroups From Profile Where Id = :userinfo.getProfileId()];

		return (userProfile.Id != null && userProfile.PermissionsChatterOwnGroups) || userAuthorizedToCreate() ? true : false;
	}

	// CUSTOM METADATA SETTINGS
	public static Boolean userAuthorizedToCreate() {
		Boolean authorized = false;
		try {
			SVNSUMMITS_Groups_Settings__mdt setting = [
				SELECT PermissionSetName__c
				FROM SVNSUMMITS_Groups_Settings__mdt
				WHERE DeveloperName = 'Default'
			];

			if (setting != null)
			{
				System.debug('userAuthorizedToCreate permission set name = ' + setting.PermissionSetName__c);
				authorized = [
					SELECT count()
					FROM PermissionSetAssignment
					WHERE AssigneeId = :Userinfo.getUserId()
					AND PermissionSet.Name = :setting.PermissionSetName__c
				] > 0;

				System.debug('    Authorized = ' + authorized);
			}
		} catch (Exception e) {
			system.debug(System.LoggingLevel.ERROR, 'SVNSUMMITS_Groups_Settings__mdt not configured');
		}

		return authorized;
	}

	/*
	@Name          :  getFeaturedGroups
	@parameters    :  recordIds of group from 1 to 8
	@Description   :  Method to fetch featured groups records to show on featured components.
	*/
	@AuraEnabled
	global static SVNSUMMITS_WrapperGroups getFeaturedGroups(String recordId1, String recordId2, String recordId3, String recordId4, String recordId5, String recordId6, String recordId7, String recordId8) {
		boolean isFeatured = true;

		//set groups ids to add filter condition of ids in query
		Set<String> groupIds = new set<String>();
		List<string> lstOfIds = new List<string>();

		lstOfIds.addAll(featuredGroupsIds(recordId1));
		lstOfIds.addAll(featuredGroupsIds(recordId2));
		lstOfIds.addAll(featuredGroupsIds(recordId3));
		lstOfIds.addAll(featuredGroupsIds(recordId4));
		lstOfIds.addAll(featuredGroupsIds(recordId5));
		lstOfIds.addAll(featuredGroupsIds(recordId6));
		lstOfIds.addAll(featuredGroupsIds(recordId7));
		lstOfIds.addAll(featuredGroupsIds(recordId8));

		for (String fId : lstOfIds) {
			groupIds.add(fId);
		}
		/*system.debug('****lstOfIds*****'+lstOfIds);*/

		//get query string
		String Query = getSimpleQueryString(String.escapeSingleQuotes(strObjectName));

		if (String.isNotBlank(Query)) {
			Query += ' Where Id IN : groupIds';
			Query += networkId != null ? ' And NetworkId = \'' + networkId + '\'' : ' And NetworkId = null';

			return new SVNSUMMITS_WrapperGroups(Query, 8, groupIds, isFeatured, null, lstOfIds);
		}

		return null;
	}

	/*
	@Name		   : getGroups
	@Description	: Get a list of all the groups this user is a member of
	 */
	@AuraEnabled
	global static Map<String, String> getMembershipGroups(String userId) {
		Map<String, String> groups = new Map<String, String>();

		for (CollaborationGroupMember member : [
				SELECT CollaborationGroupId,
						CollaborationGroup.Name,
						CollaborationGroup.OwnerId,
						CollaborationGroup.CollaborationType
				FROM CollaborationGroupMember
				WHERE MemberId = :userId
				LIMIT 1000
		]) {
			groups.put(member.CollaborationGroupId, member.CollaborationGroup.OwnerId == userId ? 'Owner' : 'Member');
		}

		return groups;
	}

	@AuraEnabled
	global static String joinGroup(String groupId, String userId) {
		CollaborationGroupMember groupMember = new CollaborationGroupMember(
				CollaborationRole = 'Standard',
				MemberId = userId,
				CollaborationGroupId = groupId);

		upsert groupMember;
		return groupMember.Id;
	}

	@AuraEnabled
	global static void leaveGroup(String groupId, String userId) {
		CollaborationGroupMember membership = [SELECT Id FROM CollaborationGroupMember WHERE CollaborationGroupId = :groupId AND MemberId = :userId];
		if (membership != null) {
			delete membership;
		}
	}

	/*
	@Name          :  featuredGroupsIds
	@parameters    :  String recordId
	@Description   :  Method to add ids to map, created method as it was repeated.
	*/
	static public List<string> featuredGroupsIds(String recordId) {
		List<string> lstOfIds = new List<string>();

		if (String.isNotBlank(recordId)) {
			String groupRecordId = validateId(recordId);

			if (String.isNotBlank(groupRecordId)) {
				lstOfIds.add(groupRecordId);
			}
		}

		return lstOfIds;
	}

	/*
	@Name          :  validateId
	@parameters    :  Idparam string
	@Description   :  Method to validate id entered in featured groups component
	*/
	static public String validateId(String Idparam) {
		try {
			String recId = String.escapeSingleQuotes(Idparam);
			return Id.valueOf(recId).getSobjectType() == CollaborationGroup.SobjectType ? recId : null;
		} catch (Exception e) {
			return null;
		}
	}

	/*
	@Name          :  getAccessibleFields
	@Description   :  Method to check all fields used in query are accessible
	*/
	public static List<string> getAccessibleFields(String strObj) {
		if (Schema.getGlobalDescribe().get(strObj).getDescribe().accessible) {

			//get all fields of strObj using getGlobalDescribe method
			Map<String, Schema.SObjectField> strFldNameToFldDesc = Schema.getGlobalDescribe().get(strObj).getDescribe().fields.getMap();

			List<String> objectAccessFields = new List<String>();

			//Iterate over all field map of object
			for (String fieldToCheck : strFldNameToFldDesc.KeySet()) {
				//Add only those fields which are in set and accessible as we do not need all fields of object
				if (groupAccessFields.contains(fieldToCheck)) {
					//check if field is accessible
					if (strFldNameToFldDesc.get(fieldToCheck).getDescribe().isAccessible()) {
						objectAccessFields.add(fieldToCheck);
					}
				}
			}

			//As we need to Query Owner name,CommunityNickname and owner means user so check if user is accessible
			if (Schema.getGlobalDescribe().get('User').getDescribe().accessible) {
				Map<String, Schema.SObjectField> strUserFldNameToFldDesc = Schema.getGlobalDescribe().get('User').getDescribe().fields.getMap();

				//if user name is accessible, add owner.name to accessible fields
				if (strUserFldNameToFldDesc.get('Name').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('owner.name'));
				}

				//if user CommunityNickname is accessible, add Owner.CommunityNickname to accessible fields
				if (strUserFldNameToFldDesc.get('CommunityNickname').getDescribe().isAccessible()) {
					objectAccessFields.add(String.escapeSingleQuotes('Owner.CommunityNickname'));
				}
			}

			return objectAccessFields;
		} else {
			return null;
		}
	}

	/*
	@Name          :  getSimpleQueryString
	@Description   :  Method to generate dynamic query for objects used in process.
					  this method is generating query for Groups as per our requirement
	*/
	public static string getSimpleQueryString(String strObj) {
		List<String> objectAccessFields = getAccessibleFields(String.escapeSingleQuotes(strObj));

		if (!objectAccessFields.isEmpty()) {
			String query = 'SELECT ';
			query += String.join(objectAccessFields, ',');
			query += ' FROM ' + strObj ;

			return query;
		} else {
			return null;
		}
	}
}