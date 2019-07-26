public with sharing class OpportunityGroupGateway {
	public static map<String, List<OpportunityTeamMember>> mapOTM = new map<String, List<OpportunityTeamMember>>();

	public static List <OpportunityTeamMember> delOppTeamMembers (Set<Id> setGrpId)
    {
		List<GroupOpportunity__c> gOList =  [SELECT Id, Name, Group_Name__c, Opportunity_Name__c FROM GroupOpportunity__c Where Id IN :setGrpId];
		Map<Id, List<GroupOpportunity__c>> groupOpp = new Map<Id, List<GroupOpportunity__c>>();
		Map<Id, List<GroupOpportunity__c>> groupOppToGroup = new Map<Id, List<GroupOpportunity__c>>();
		for (GroupOpportunity__c gO: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOpp.get(gO.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOpp.put(gO.Opportunity_Name__c, groupOpps);
		  }
		  groupOpps.add(gO);
		}
		System.debug('::::delOppTeamMembers + groupOpp ' + groupOpp);
		for (GroupOpportunity__c gO2: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(gO2.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOppToGroup.put(gO2.Group_Name__c, groupOpps);
		  }
		  groupOpps.add(gO2);
		}
		System.debug('::::delOppTeamMembers + groupOppToGroup ' + groupOppToGroup);

		List<Opportunity> oList =  [SELECT Id, Name, OwnerId FROM Opportunity Where Id IN :groupOpp.Keyset()];
		Map<Id, List<Opportunity>> opp = new Map<Id, List<Opportunity>>();
		Map<Id, List<Opportunity>> oppToOwner = new Map<Id, List<Opportunity>>();
		for (Opportunity o: oList) {
		  List<Opportunity> opps = opp.get(o.Id);
		  if (opps == null)
		  {
			opps = new List<Opportunity>();
			opp.put(o.Id, opps);
			oppToOwner.put(o.OwnerId, opps);
		  }
		  opps.add(o);
		}
		System.debug('::::delOppTeamMembers + opp ' + opp);

		List<Group__c> gList =  [SELECT Id FROM Group__c Where Id IN :groupOppToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('::::delOppTeamMembers + thegroup ' + thegroup);

		List<User_Group_Member__c> ugmList =  [SELECT Id, Name, Group_Member__c, Group_Members__c 
												FROM User_Group_Member__c 
												Where Group_Members__c IN :thegroup.Keyset()];
		Map<Id, List<User_Group_Member__c>> usergroupmem = new Map<Id, List<User_Group_Member__c>>();
		for (User_Group_Member__c ugm: ugmList) {
		  List<User_Group_Member__c> usergroupmems = usergroupmem.get(ugm.Group_Member__c);
		  if (usergroupmems == null)
		  {
			usergroupmems = new List<User_Group_Member__c>();
			usergroupmem.put(ugm.Group_Member__c, usergroupmems);
		  }
		  usergroupmems.add(ugm);
		}
		System.debug('::::delOppTeamMembers + usergroupmem ' + usergroupmem);

		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c 
								FROM Contact
								Where Id IN :usergroupmem.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = contactToUser.get(c.User__c);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('::::delOppTeamMembers + contactToUser ' + contactToUser);

		List<OpportunitySplit> oppSplitList = [SELECT Id, OpportunityId ,SplitOwnerId 
												FROM OpportunitySplit
												WHERE OpportunityId = :opp.keySet()];
		Map<Id , List<OpportunitySplit>> oppSplit = new Map<Id, List<OpportunitySplit>>();
		for (OpportunitySplit oS: oppSplitList) {
			List<OpportunitySplit> oppSplits = oppSplit.get(oS.Id);
			if (oppSplits == null)
			{
				oppSplits = new List<OpportunitySplit>();
				oppSplit.put(oS.SplitOwnerId , oppSplits);
			}
			oppSplits.add(oS);
		}
		System.debug('::::delOppTeamMembers + oppSplit ' + oppSplit);

		List<User> uList = [SELECT Id, IsActive 
							FROM User 
							WHERE Id IN :contactToUser.Keyset() 
							AND ID NOT IN :oppToOwner.keySet()
							AND ID NOT IN :oppSplit.keySet()
							AND IsActive = TRUE];
		Map<Id, List<User>> user = new Map<Id, List<User>>();
		for (User u: uList)	{
		  List<User> users = user.get(u.Id);
		  if (users == null)
		  {
			users = new List<User>();
			user.put(u.Id, users);
		  }
		  users.add(u);
		}
		System.debug('::::delOppTeamMembers + user ' + user);

		List <OpportunityTeamMember> otmDelList = new list <OpportunityTeamMember>();

		List<OpportunityTeamMember> otmList =  [SELECT Id, Name, OpportunityId, TeamMemberRole, UserId 
												FROM OpportunityTeamMember 
												WHERE UserId IN :user.keySet()
												AND OpportunityId IN :groupOpp.Keyset()];
		Map<Id, List<OpportunityTeamMember>> otMems = new Map<Id, List<OpportunityTeamMember>>();
		for (OpportunityTeamMember o: otmList) {
		  List<OpportunityTeamMember> oppsTM = otMems.get(o.OpportunityId);
		  if (oppsTM == null)
		  {
			oppsTM = new List<OpportunityTeamMember>();
			otMems.put(o.Id, oppsTM);
		  }
		  oppsTM.add(o);
		}
		System.debug('::::delOppTeamMembers + otMems ' + otMems);


/*		for (User u: uList) {
			System.debug('::::delOppTeamMembers + u ' + u);
			List<Contact> contacts = contactToUser.get(u.Id);
			If (contacts != NUll) {
				for (Contact cnt: contacts) {
					set<Id> cntId = new Set<Id>{cnt.Id};
					List<User_Group_Member__c> usergroupmems = usergroupmem.get(cnt.Id);
					if (usergroupmems != NULL) {
						for (User_Group_Member__c ugrpm: usergroupmems ) {
							List<Group__c> groups = thegroup.get(ugrpm.Group_Members__c);
							if (groups != NULL) {
								for (Group__c grp: groups) {
									List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(grp.Id);													
									if (groupOpps != NULL) {
										for (GroupOpportunity__c grpop: groupOpps) {
											List<Opportunity> opps = opp.get(grpop.Opportunity_Name__c);
											if (opps != NULL) {
												System.debug('::::delOppTeamMembers + opps ' + opps);
												for (Opportunity op: opps) {
													System.debug('::::delOppTeamMembers + op ' + op);
													List<OpportunityTeamMember> otMembers = otMems.get(op.Id);
													System.debug('::::delOppTeamMembers + otMems ' + otMems);
*/													if  (otmList != NULL) {
														for (OpportunityTeamMember ot: otmList) {
															otmDelList.add(ot);
															System.debug('::::delOppTeamMembers + otmDelList 1' + otmDelList);
														}
/*													} 
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
*/		System.debug('::::delOppTeamMembers + otmDelList 2' + otmDelList);
		return otmDelList;
	} else {return null;}
	}
  
	public static List<Opportunity> updateOpportunity (Set<Id> setGrpId)
    {
    	List<Opportunity> inUseIds = new List<Opportunity>();
		List<GroupOpportunity__c> gOList =  [SELECT Id, Name, Group_Name__c, Opportunity_Name__c, Primary_Group__c
											FROM GroupOpportunity__c
											WHERE Primary_Group__c = TRUE 
											AND Id IN :setGrpId];
		Map<Id, List<GroupOpportunity__c>> groupOpp = new Map<Id, List<GroupOpportunity__c>>();
		Map<Id, List<GroupOpportunity__c>> groupOppToGroup = new Map<Id, List<GroupOpportunity__c>>();
		for (GroupOpportunity__c gO: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOpp.get(gO.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOpp.put(gO.Opportunity_Name__c, groupOpps);
		  }
		  groupOpps.add(gO);
		}
		System.debug('::::OpportunityGroupGateway + groupOpp ' + groupOpp);
		for (GroupOpportunity__c gO2: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(gO2.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOppToGroup.put(gO2.Group_Name__c, groupOpps);
		  }
		  groupOpps.add(gO2);
		}
		System.debug('::::OpportunityGroupGateway + groupOppToGroup ' + groupOppToGroup);

		List<Group__c> gList =  [SELECT Id FROM Group__c Where Id IN :groupOppToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('::::OpportunityGroupGateway + thegroup ' + thegroup);

		List<Opportunity> oList =  [SELECT Id, Name, Opportunity_Group__c
									FROM Opportunity 
									Where Opportunity_Group__c NOT IN :groupOppToGroup.Keyset()
									AND Id IN :groupOpp.Keyset()];
		Map<Id, List<Opportunity>> opp = new Map<Id, List<Opportunity>>();
		for (Opportunity o: oList) {
		  List<Opportunity> opps = opp.get(o.Id);
		  if (opps == null)
		  {
			opps = new List<Opportunity>();
			opp.put(o.Id, opps);
		  }
		  opps.add(o);
		}
		System.debug('::::OpportunityGroupGateway + opp ' + opp);
		System.debug('::::OpportunityGroupGateway + setGrpId: ' + setGrpId);

		for (Group__c grp: gList) {
			List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(grp.Id);													
			if (groupOpps != NULL) {
				for (GroupOpportunity__c grpop: gOList) {
					List<Opportunity> opps = opp.get(grpop.Opportunity_Name__c);
					if (opps != NULL) {
						for (Opportunity op: opps) {
							op.Opportunity_Group__c = grp.Id;
							inUseIds.add(op);
						}
					}
				}
			}
		}
        return inUseIds;
    }


    public static List<OpportunityTeamMember> findGroupMembersToAdd (Set<Id> setGrpId){
		List<GroupOpportunity__c> gOList =  [SELECT Id, Name, Group_Name__c, Opportunity_Name__c FROM GroupOpportunity__c Where Id IN :setGrpId];
		Map<Id, List<GroupOpportunity__c>> groupOpp = new Map<Id, List<GroupOpportunity__c>>();
		Map<Id, List<GroupOpportunity__c>> groupOppToGroup = new Map<Id, List<GroupOpportunity__c>>();
		for (GroupOpportunity__c gO: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOpp.get(gO.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOpp.put(gO.Opportunity_Name__c, groupOpps);
		  }
		  groupOpps.add(gO);
		}
		System.debug('::::OpportunityGroupGateway + groupOpp ' + groupOpp);
		for (GroupOpportunity__c gO2: gOList) {
		  List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(gO2.Group_Name__c);
		  if (groupOpps == null)
		  {
			groupOpps = new List<GroupOpportunity__c>();
			groupOppToGroup.put(gO2.Group_Name__c, groupOpps);
		  }
		  groupOpps.add(gO2);
		}
		System.debug('::::OpportunityGroupGateway + groupOppToGroup ' + groupOppToGroup);

		List<Opportunity> oList =  [SELECT Id, Name FROM Opportunity Where Id IN :groupOpp.Keyset()];
		Map<Id, List<Opportunity>> opp = new Map<Id, List<Opportunity>>();
		for (Opportunity o: oList) {
		  List<Opportunity> opps = opp.get(o.Id);
		  if (opps == null)
		  {
			opps = new List<Opportunity>();
			opp.put(o.Id, opps);
		  }
		  opps.add(o);
		}
		System.debug('::::OpportunityGroupGateway + opp ' + opp);

		List<Group__c> gList =  [SELECT Id FROM Group__c Where Id IN :groupOppToGroup.Keyset()];
		Map<Id, List<Group__c>> thegroup = new Map<Id, List<Group__c>>();
		for (Group__c g: gList) {
		  List<Group__c> groups = thegroup.get(g.Id);
		  if (groups == null)
		  {	
			groups = new List<Group__c>();
			thegroup.put(g.Id, groups);
		  }
		  groups.add(g);
		}
		System.debug('::::OpportunityGroupGateway + thegroup ' + thegroup);

		List<User_Group_Member__c> ugmList =  [SELECT Id, Name, Group_Member__c, Group_Members__c FROM User_Group_Member__c Where Group_Members__c IN :thegroup.Keyset()];
		Map<Id, List<User_Group_Member__c>> usergroupmem = new Map<Id, List<User_Group_Member__c>>();
		for (User_Group_Member__c ugm: ugmList) {
		  List<User_Group_Member__c> usergroupmems = usergroupmem.get(ugm.Group_Member__c);
		  if (usergroupmems == null)
		  {
			usergroupmems = new List<User_Group_Member__c>();
			usergroupmem.put(ugm.Group_Member__c, usergroupmems);
		  }
		  usergroupmems.add(ugm);
		}
		System.debug('::::OpportunityGroupGateway + usergroupmem ' + usergroupmem);

		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name, User_SalesforceID__c, User__c FROM Contact Where Id IN :usergroupmem.Keyset()];
		Map<Id, List<Contact>> contactToUser = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = contactToUser.get(c.User__c);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			contactToUser.put(c.User__c, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('::::OpportunityGroupGateway + contactToUser ' + contactToUser);

		List<User> uList = [SELECT Id, IsActive FROM User WHERE Id IN :contactToUser.Keyset() AND IsActive = TRUE];
		Map<Id, List<User>> user = new Map<Id, List<User>>();
		for (User u: uList)	{
		  List<User> users = user.get(u.Id);
		  if (users == null)
		  {
			users = new List<User>();
			user.put(u.Id, users);
		  }
		  users.add(u);
		}
		System.debug('::::OpportunityGroupGateway + user ' + user);

		List <OpportunityTeamMember> otmlist = new list <OpportunityTeamMember>();

		for (User u: uList) {
			System.debug('::::OpportunityGroupGateway + u ' + u);
			List<Contact> contacts = contactToUser.get(u.Id);
			If (contacts != NUll) {
				for (Contact cnt: contacts) {
					set<Id> cntId = new Set<Id>{cnt.Id};
					List<User_Group_Member__c> usergroupmems = usergroupmem.get(cnt.Id);
					if (usergroupmems != NULL) {
						for (User_Group_Member__c ugrpm: usergroupmems ) {
							List<Group__c> groups = thegroup.get(ugrpm.Group_Members__c);
							if (groups != NULL) {
								for (Group__c grp: groups) {
									List<GroupOpportunity__c> groupOpps = groupOppToGroup.get(grp.Id);													
									if (groupOpps != NULL) {
										for (GroupOpportunity__c grpop: groupOpps) {
											List<Opportunity> opps = opp.get(grpop.Opportunity_Name__c);
											if (opps != NULL) {
												for (Opportunity op: opps) {
													OpportunityTeamMember member = new OpportunityTeamMember();  
													member.OpportunityId = op.Id ;  
													member.UserId = u.Id;  
													member.TeamMemberRole = 'Sales Rep';  
													member.OpportunityAccessLevel = 'Edit';  
													otmlist.add(member);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return otmlist;
	}
}