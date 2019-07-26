public with sharing class Related_CustomerGateway {

    public static List<Related_Customer__c> findOtherRelatedAccounts (List<Related_Customer__c> listRelCus){
    	System.debug('::::Related_CustomerGateway + listRelCus ' + listRelCus);

		Map<Id, List<Related_Customer__c>> rCtoO = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> rCtoRc = new Map<Id, List<Related_Customer__c>>();
		for (Related_Customer__c rC3: listRelCus) {
		  List<Related_Customer__c> rCusts = rCtoO.get(rC3.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			rCtoO.put(rC3.Opportunity__c, rCusts);
			rCtoRc.put(rC3.Id, rCusts);
		  }
		  rCusts.add(rC3);
		}
		System.debug('::::Related_CustomerGateway + rCtoRc ' + rCtoRc);

		List<Opportunity> oList =  [SELECT Id, Name FROM Opportunity Where Id IN :rCtoO.Keyset()];
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
		System.debug('::::Related_CustomerGateway + opp ' + opp);

		List<Related_Customer__c> rcList =  [SELECT Id, Contact__c, Related_Account__c, Opportunity__c, Shopping_Cart__c 
											FROM Related_Customer__c 
											Where Opportunity__c IN :opp.Keyset()
											AND Shopping_Cart__c = TRUE
											AND Id NOT IN :rCtoRc.Keyset()];
		Map<Id, List<Related_Customer__c>> rCus = new Map<Id, List<Related_Customer__c>>();
		for (Related_Customer__c r: rcList) {
		  List<Related_Customer__c> rCusts = rCus.get(r.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			rCus.put(r.Id, rCusts);
		  }
		  rCusts.add(r);
		}
		System.debug('::::Related_CustomerGateway + rCus ' + rCus);

		List <Related_Customer__c> oldPrimary = new list <Related_Customer__c>();												

			for (Related_Customer__c rc: rcList) {
				System.debug('::::Related_CustomerGateway + rc ' + rc);
				if (rc != null)		
				{
					rc.Shopping_Cart__c = false;
					oldPrimary.add(rc);
				}
			}

		System.debug('::::Related_CustomerGateway + oldPrimary ' + oldPrimary);
		return oldPrimary;
	}

    public static List<OpportunityContactRole> addOpportunityContact (Set<Id> setRelCus){
		
		List<Related_Customer__c> rCList =  [SELECT Id, Contact__c, Related_Account__c, Opportunity__c, Shopping_Cart__c FROM Related_Customer__c Where Id IN :setRelCus];
		Map<Id, List<Related_Customer__c>> rCtoC = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> oToRc = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> rCtoO = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> rCtoRc = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> groupOppToGroup = new Map<Id, List<Related_Customer__c>>();
		for (Related_Customer__c rC: rCList) {
		  List<Related_Customer__c> rCusts = rCtoC.get(rC.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			rCtoC.put(rC.Contact__c, rCusts);
		  }
		  rCusts.add(rC);
		}
		System.debug('::::Related_CustomerGateway + rCtoC ' + rCtoC);
		
		for (Related_Customer__c rC2: rCList) {
		  List<Related_Customer__c> rCusts = oToRc.get(rC2.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			oToRc.put(rC2.Opportunity__c, rCusts);
		  }
		  rCusts.add(rC2);
		}
		System.debug('::::Related_CustomerGateway + oToRc ' + oToRc);
		
		List<Contact> cList = [SELECT Id, FirstName, LastName, AccountId, Name FROM Contact Where Id IN :rCtoC.Keyset()];
		Map<Id, List<Contact>> cnt = new Map<Id, List<Contact>>();
		for (Contact c: cList) {
		  List<Contact> contacts = cnt.get(c.Id);
		  if (contacts == null)
		  {
			contacts = new List<Contact>();
			cnt.put(c.Id, contacts);
		  }
		  contacts.add(c);
		}
		System.debug('::::Related_CustomerGateway + cnt ' + cnt);

		for (Related_Customer__c rC3: rCList) {
		  List<Related_Customer__c> rCusts = rCtoO.get(rC3.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			rCtoO.put(rC3.Opportunity__c, rCusts);
			rCtoRc.put(rC3.Id, rCusts);
		  }
		  rCusts.add(rC3);
		}
		System.debug('::::Related_CustomerGateway + rCtoO ' + rCtoO);


		List<Opportunity> oList =  [SELECT Id, Name FROM Opportunity Where Id IN :rCtoO.Keyset()];
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
		System.debug('::::Related_CustomerGateway + opp ' + opp);

		List <OpportunityContactRole> oCntlist = new list <OpportunityContactRole>();

		for (Contact cont: cList) {
			List<Related_Customer__c> ContToRC = rCtoC.get(cont.Id);
			If (ContToRC != NUll) {	
				for (Related_Customer__c r: ContToRC) {
					List<Opportunity> rCustToC = opp.get(r.Opportunity__c);
					for (Opportunity op: rCustToC) {
							If (rCustToC != NUll) {	
								OpportunityContactRole oppCR = new OpportunityContactRole();  
				                oppCR.ContactId = cont.Id;
				                oppCR.OpportunityId = op.Id;
				                oppCR.Role = 'Evaluator';
				                If (r.Shopping_Cart__c == TRUE) {
			                		oppCR.IsPrimary = true;
			                	} else {
			                		oppCR.IsPrimary = false;
			                	}
								oCntlist.add(oppCR);
							} 
						}
					}
				}
			}
			return oCntlist;
	}
 
    public static List<Opportunity> deleteRelatedAccountFromOpp (Set<Id> setRelCus){
    	System.debug('::::Related_CustomerGateway + listRelCus ' + setRelCus);

		List<Related_Customer__c> rcList =  [SELECT Id, Contact__c, Related_Account__c, Opportunity__c, Shopping_Cart__c, Account_Role__c, Buying_Customer__c
											FROM Related_Customer__c 
											WHERE Id = :setRelCus];
		Map<Id, List<Related_Customer__c>> rCtoO = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> rCtoRc = new Map<Id, List<Related_Customer__c>>();
		Map<Id, List<Related_Customer__c>> rCus = new Map<Id, List<Related_Customer__c>>();
		for (Related_Customer__c r: rcList) {
		  List<Related_Customer__c> rCusts = rCus.get(r.Id);
		  if (rCusts == null)
		  {
			rCusts = new List<Related_Customer__c>();
			rCus.put(r.Id, rCusts);
			rCtoO.put(r.Opportunity__c, rCusts);
			rCtoRc.put(r.Id, rCusts);
		  }
		  rCusts.add(r);
		}
		
		System.debug('::::Related_CustomerGateway + rCus ' + rCus);
		List<Opportunity> oList =  [SELECT Id, Name FROM Opportunity Where Id IN :rCtoO.Keyset()];
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
		System.debug('::::Related_CustomerGateway + opp ' + opp);

		List <Opportunity> oppsToUpdate = new list <Opportunity>();											
		for (Related_Customer__c r: rcList) {
			for (Opportunity o: oList) {
				System.debug('::::Related_Customerateway + r ' + r);
				if (r.Buying_Customer__c == true)			
				{
					o.Buying_Customer__c = '';
				}				
				if (r.Account_Role__c == 'Tile Contractor')		
				{
					o.Tile_Contractor__c = '';	
				}				
				if (r.Account_Role__c == 'Developer/Owner')		
				{
					o.Developer_Owner__c = '';	
				}				
				if (r.Account_Role__c == 'Architect')		
				{
					o.Architect__c = '';	
				}
				if (r.Account_Role__c == 'General Contractor')		
				{
					o.General_Contractor__c = '';	
				}
				if (r.Account_Role__c == 'Construction Management')		
				{
					o.Construction_Manager__c = '';	
				}
				oppsToUpdate.add(o);
			}
		}
		
		System.debug('::::Related_CustomerGateway + oldPrimary ' + oppsToUpdate);
		return oppsToUpdate;
	}


}