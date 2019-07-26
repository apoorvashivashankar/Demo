public without sharing class OpportunityGateway {
    public static boolean firstRun = true;
    
    public static map<String, List<OpportunityTeamMember>> mapOTM = new map<String, List<OpportunityTeamMember>>();
    
    public static List<Profile> getProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];

    public static List<OpportunityTeamMember> updateOppTeam (Set<Id> setOppId) {
        List<Opportunity> oList = [SELECT Id, 
                                        Name, 
                                        OwnerId
                                    FROM Opportunity 
                                    WHERE Opportunity_Group__c != NULL
                                    AND Id IN :setOppId];                               
        Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
        for (Opportunity o: oList) {
            List<Opportunity> opps = oppToOpp.get(o.Id);
            if (opps == null)
            {
                opps = new List<Opportunity>();
                oppToOpp.put(o.Id, opps);
            }
        }
        List<OpportunityTeamMember> listOppTeamMember = new List<OpportunityTeamMember>();

        If (Trigger.isInsert){
            for (Opportunity op: oList) {
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = op.Id;
                otm.UserId = op.OwnerId;
                otm.TeamMemberRole = 'Sales Rep';
                listOppTeamMember.add(otm); 
            }
        } else if (Trigger.isUpdate) {
            for (Opportunity op: oList) {
                Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(op.Id);
                id oldOppOwner = oldOpp.OwnerId;
                id newOppOwner = op.OwnerId;
                if(oldOppOwner != newOppOwner) {
                    OpportunityTeamMember otm = new OpportunityTeamMember();            
                    if(OpportunityGateway.mapOTM != null){
                        List<OpportunityTeamMember> salesTeamMembers =  OpportunityGateway.mapOTM.get(op.Id);
                        if(salesTeamMembers != null) {
                            for(OpportunityTeamMember tm : salesTeamMembers){   
                                otm = tm.clone(false, true);
                                listOppTeamMember.add(otm);
                            }
                        }
                    }
                }
            }
        }
        return listOppTeamMember;
    }

    public static List<OpportunityShare> updateOppShare (Set<Id> setOppId) {
        List<Opportunity> oList = [SELECT Id, 
                                        Name, 
                                        OwnerId
                                    FROM Opportunity 
                                    WHERE Opportunity_Group__c != NULL
                                    AND Id IN :setOppId];                               
        Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
        for (Opportunity o: oList) {
            List<Opportunity> opps = oppToOpp.get(o.Id);
            if (opps == null)
            {
                opps = new List<Opportunity>();
                oppToOpp.put(o.Id, opps);
            }
        }

        List<OpportunityShare> listOppShares = new List<OpportunityShare>();

        If (Trigger.isInsert){
            for (Opportunity op: oList) {
                Id oldOwnerId = op.OwnerId;
                OpportunityShare oppSh = new OpportunityShare(
                    OpportunityId = op.Id,
                    userOrGroupId = oldOwnerId,
                    OpportunityAccessLevel = 'Edit' );                  
                listOppShares.add(oppSh);
            }
        } else if (Trigger.isUpdate) {
            for (Opportunity op: oList) {
                Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(op.Id);
                id oldOppOwner = oldOpp.OwnerId;
                id newOppOwner = op.OwnerId;
                if((oldOppOwner != newOppOwner)&&(OpportunityGateway.mapOTM != null)) {
                    OpportunityTeamMember otm = new OpportunityTeamMember();                              
                    List<OpportunityTeamMember> salesTeamMembers =  OpportunityGateway.mapOTM.get(op.Id);
                    if(salesTeamMembers != null) {
                        for(OpportunityTeamMember tm : salesTeamMembers){   
                           OpportunityShare oppSh = new OpportunityShare(
                            OpportunityId = op.Id,
                            userOrGroupId = tm.userId,
                            OpportunityAccessLevel = tm.OpportunityAccessLevel );                         
                            if(oppSh.OpportunityAccessLevel != 'None')
                                listOppShares.add(oppSh);
                        }
                    }
                }
            }
        }
        return listOppShares;
    }    

    public static List<AccountTeamMember> updateAccountTeam (Set<Id> setOppId) {
        List<Opportunity> oList = [SELECT Id, 
                                        Name, 
                                        AccountId,
                                        OwnerId
                                    FROM Opportunity 
                                    WHERE Opportunity_Group__c != NULL
                                    AND Id IN :setOppId];                               
        Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
        for (Opportunity o: oList) {
            List<Opportunity> opps = oppToOpp.get(o.Id);
            if (opps == null)
            {
                opps = new List<Opportunity>();
                oppToOpp.put(o.Id, opps);
            }
        }
        List<AccountTeamMember> listActTeamMember = new List<AccountTeamMember>();

        If (Trigger.isInsert){
            for (Opportunity op: oList) {  
                if(op.AccountId != null){
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = op.AccountId;
                    atm.UserId = op.OwnerId;
                    atm.TeamMemberRole = 'Sales Rep';
                    //atm.AccountAccessLevel = 'Read';
                    listActTeamMember.add(atm);
                }
            }
        } else if (Trigger.isUpdate) {
            for (Opportunity op: oList) {
                Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(op.Id);
                id oldOppOwner = oldOpp.OwnerId;
                id newOppOwner = op.OwnerId;
                if(oldOppOwner != newOppOwner) {
                    AccountTeamMember atm = new AccountTeamMember();
                    atm.AccountId = op.AccountId;
                    atm.UserId = op.OwnerId;
                    atm.TeamMemberRole = 'Sales Rep';
                    //atm.AccountAccessLevel = 'Read';
                    listActTeamMember.add(atm);
                }
            }
        }
        return listActTeamMember;
    }

    public static List<Opportunity> updateOppportunity (Set<Id> setOppId) {
        List<Opportunity> listOpportunityUpdates = new List<Opportunity>();
        List<Opportunity> oList = [SELECT Id, 
                                        Name, 
                                        Amount,
                                        Estimated_Value__c, 
                                        Manual_Entry__c
                                    FROM Opportunity 
                                    WHERE Id IN :setOppId]; 
        System.debug('::::OpportunityGateway + oList' + oList);                     
        for (Opportunity o: oList) {
            if (o.Estimated_Value__c != NULL)
            {
                o.Manual_Entry__c = TRUE;
                listOpportunityUpdates.add(o);
            }
        }       
        return listOpportunityUpdates;
    }

    public static Boolean validateOpportunity () {
        System.debug('::::OpportunityGateway + validateOpportunity');    
        List <Opportunity> validatedOpportunities = new List <Opportunity> ();
        Boolean hasErrors = false;        
        Decimal aoValue;
        Decimal currentValue;
        Decimal panoramicValue;
        Decimal estimatedValue;
        List <Opportunity> listNewO = new List <Opportunity> ();
        for (SObject so : trigger.new) {
            Opportunity theO = (Opportunity)so;
            listNewO.add(theO);
        }        
        Map<Id,SObject> newmapOpportunityValidation = Trigger.newmap;
        System.debug('::::OpportunityGateway + newmapOpportunityValidation:::>' + newmapOpportunityValidation);
        Map<Id,SObject> oldmapOpportunityValidation = Trigger.oldmap;
        System.debug('::::OpportunityGateway + oldmapOpportunityValidation:::>' + oldmapOpportunityValidation);    
        for (Opportunity o: listNewO) {
            if (o.Amount != null) {
                currentValue = o.Amount;
            } else {
                currentValue = 0;
            }
            if (o.Estimated_Value__c != null) {
                estimatedValue = o.Estimated_Value__c;
            } else {
                estimatedValue = 0;
            }
            if (o.AO_MZ_Amount__c != null) {
                aoValue = o.AO_MZ_Amount__c;
            } else {
                aoValue = 0;
            }
            if (o.Panoramic_Amount__c != null) {
                panoramicValue = o.Panoramic_Amount__c;
            } else {
                panoramicValue = 0;
            }
            
            System.debug('::::OpportunityGateway + currentValue: ' + currentValue);  
            System.debug('::::OpportunityGateway + aoValue: ' + aoValue);  
            System.debug('::::OpportunityGateway + panoramicValue: ' + panoramicValue);  
            if (currentValue < aoValue && estimatedValue < aoValue) {
		        newmapOpportunityValidation.get(o.Id).addError('AO/MZ Amount must be less than the total Opportunity Amount.  Please include the AO/MZ Amount in the Opportunity Amount field.');
                hasErrors = true;  
            } else if (currentValue < panoramicValue && estimatedValue < panoramicValue) {
		        newmapOpportunityValidation.get(o.Id).addError('Panoramic Amount must be less than the total Opportunity Amount.  Please include the AO/MZ Amount in the Opportunity Amount field.');
                hasErrors = true;
            } 
        }
        return hasErrors;
    }

    public static List<opportunitylineitem> updateOppValue (Set<Id> setOppId) {
		if (firstRun) {
			firstRun = false;
			Decimal updateVal = 0;
			List<Opportunity> oList = [SELECT Id, 
											Name, 
											Amount,
											Estimated_Value__c,
											AO_MZ_Amount__c,
											Panoramic_Amount__c,
											Manual_Entry__c
										FROM Opportunity 
										WHERE Estimated_Value__c != NULL
										AND Id IN :setOppId]; 
			System.debug('::::OpportunityGateway + oList' + oList);                              
			Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
			for (Opportunity o: oList) {
				Decimal oldOppestVal = o.Amount;
				Decimal newOppestVal = o.Estimated_Value__c;
				if(oldOppestVal != newOppestVal) {                 
					List<Opportunity> opps = oppToOpp.get(o.Id);
					if (opps == null)
					{
						opps = new List<Opportunity>();
						oppToOpp.put(o.Id, opps);
					}
				}
			}       
			
			List<OpportunityLineItem> pList =  [SELECT Id
													,OpportunityId
													,TotalPrice
													,UnitPrice
													,Product2.Name,Generic_Item__c
												FROM OpportunityLineItem
												WHERE OpportunityId IN :setOppId];
			List<OpportunityLineItem> freeFormItems = new List<OpportunityLineItem>();
			Map<Id, List<OpportunityLineItem>> oppToLineItem = new Map<Id, List<OpportunityLineItem>>();
			Map<String, List<OpportunityLineItem>> nameToLineItem = new Map<String, List<OpportunityLineItem>>();
			Boolean hasGeneric;
			Decimal freeFormValue = 0;
			System.debug('::::OpportunityGateway + pList' + pList);
			if (Trigger.isUpdate || Trigger.oldMap != NULL) {
				for (OpportunityLineItem p: pList) {
					List<OpportunityLineItem> items = oppToLineItem.get(p.OpportunityId);
					if (items == null){
					   items = new List<OpportunityLineItem>();
						oppToLineItem.put(p.OpportunityId, items);
						nameToLineItem.put(p.Product2.Name, items);
					} else {
						System.debug('::::OpportunityGateway + nothing to add to oppToLineItem');
					}
					if (p.Product2.Name == 'Free Frorm' || (p.Product2.Name == 'Free Form' && p.Generic_Item__c != true)) {
						
						freeFormValue = freeFormValue + p.unitprice;
						freeFormItems.add(p);
						System.debug('::::OpportunityGateway + gotta Free Frorm here');
						hasGeneric = true;
					}
					items.add(p);    
				}
			}
			System.debug('::::OpportunityGateway + OpportunityLineItemem' + oppToLineItem);
			
			List<pricebook2>  pb = [select id from pricebook2 where name = 'Standard Price Book'];
			
			Product2 prod = [SELECT 
								Name
								, IsActive
								, ID
							FROM Product2
							WHERE DW_ID__c = 'Free Form'
							LIMIT 1];

			PricebookEntry standardPrice = [SELECT 
								Pricebook2Id
								, Product2Id
								, ID
								, UnitPrice
								, IsActive
							FROM PricebookEntry 
							WHERE Product2Id = :prod.Id
							LIMIT 1];

			List<opportunitylineitem> listOpportunityLineItems = new List<opportunitylineitem>();				
							
			for (Opportunity op: oList) {
			System.debug('::::OpportunityGateway + op: ' + op);
				for (pricebook2 p : pb)    {
					System.debug('::::OpportunityGateway + p: ' + p);
					System.debug('::::OpportunityGateway + prod: ' + prod);
					System.debug('::::OpportunityGateway + standardPrice: ' + standardPrice);               
					List<OpportunityLineItem> oppLineItems = oppToLineItem.get(op.Id);  
					System.debug('::::OpportunityGateway + oppLineItems: ' + oppLineItems);  		
					if (oppLineItems != NULL) {
						Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(op.Id);
						Decimal oldOppestVal = oldOpp.Estimated_Value__c;
						Decimal newOppestVal = op.Estimated_Value__c;
						if(oldOppestVal != newOppestVal) {                             
							opportunitylineitem oli = new opportunitylineitem();
							if (op.Amount != null && op.Estimated_Value__c != null) {
								updateVal = op.Estimated_Value__c - op.Amount;
								System.debug('::::OpportunityGateway + updateVal + 1: ' + updateVal);
							} ELSE IF (op.Amount == null && op.Estimated_Value__c != null) {
								updateVal = op.Estimated_Value__c;
								System.debug('::::OpportunityGateway + updateVal + 2: ' + updateVal);
							} ELSE IF (op.Amount != null && op.Estimated_Value__c == null) {
								updateVal = op.Amount;
								System.debug('::::OpportunityGateway + updateVal + 3: ' + updateVal);
							}   
							if (hasGeneric == true) {
								System.debug('::::OpportunityGateway + hasGeneric == true');
								oli = freeFormItems[0];
								System.debug('::::OpportunityGateway + hasGeneric + oli:...' + oli);
								updateVal =  updateVal + oli.unitprice;
								System.debug('::::OpportunityGateway + hasGeneric + updateVal:...' + updateVal);
							} else {
								oli.opportunityid = op.id;           
								oli.pricebookentryid = standardPrice.Id;                        
							}
							oli.quantity = 1;       
							oli.unitprice = updateVal;  
							listOpportunityLineItems.add(oli);
						}
					} ELSE {
						opportunitylineitem oli = new opportunitylineitem();
						oli.opportunityid = op.id;
						oli.unitprice = op.Estimated_Value__c;
						oli.quantity = 1;        // Don't reference product, but its pricebook entry
						oli.pricebookentryid = standardPrice.Id;
						oli.Description = 'Manual adjustment for Opportunity Amount';
						listOpportunityLineItems.add(oli);
					}
				}
			}
			System.debug('::::OpportunityGateway + updateOppValue + listOpportunityLineItems' + listOpportunityLineItems);
			return listOpportunityLineItems;        
		} else {
			System.debug('Already ran!');
			return NULL;
		}
    }

    public static List<GroupOpportunity__c> newOppGroup (Set<Id> setOppId) {
        List<Opportunity> oList = [SELECT Id, 
                                        Name, 
                                        Opportunity_Group__c
                                    FROM Opportunity 
                                    WHERE Opportunity_Group__c != NULL
                                    AND Id IN :setOppId];                               
        Map<Id, List<Opportunity>> oppToGroup = new Map<Id, List<Opportunity>>();    
        Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
        for (Opportunity o: oList) {
            List<Opportunity> opps = oppToGroup.get(o.Id);
            if (opps == null)
            {
                opps = new List<Opportunity>();
                oppToGroup.put(o.Opportunity_Group__c, opps);
                oppToOpp.put(o.Id, opps);
            }
        }
        
        List<Group__c> gList =  [SELECT Id 
                                FROM Group__c 
                                WHERE Id IN :oppToGroup.keySet()];
        Map<Id, List<Group__c>> oppGroupToGroup = new Map<Id, List<Group__c>>();
        for (Group__c g: gList) {
            List<Group__c> groups = oppGroupToGroup.get(g.Id);
            if (groups == null)
          {
            groups = new List<Group__c>();
            oppGroupToGroup.put(g.Id, groups);
          }
          groups.add(g);                
        }
        
		List<GroupOpportunity__c> gOList =  [SELECT Id, Name, Group_Name__c, Opportunity_Name__c 
		                                      FROM GroupOpportunity__c 
		                                      Where Opportunity_Name__c IN :setOppId
		                                      AND Group_Name__c IN :oppToGroup.keySet()];
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
		
        List<GroupOpportunity__c> inUseIds = new List<GroupOpportunity__c>();
        
        for (Opportunity op: oList) {
            List<Group__c> groups = oppGroupToGroup.get(op.Opportunity_Group__c);                                                   
            if (gOList.isEmpty()) {
                for (Group__c grp: groups) {
                        GroupOpportunity__c go = new GroupOpportunity__c();
                        go.Group_Name__c = grp.Id;
                        go.Opportunity_Name__c = op.Id;
                        inUseIds.add(go);
                }
            } 
        }
        return inUseIds;        
    }   


    public static List <Task> newSwitchedSpec (Set<Id> setOppId){
        Set<Task> mylist = new Set<Task>();
        set<string> myset = new set<string>(); 
        set<Boolean> results = new set<Boolean>(); 
        Set<Id> inUseIds = new Set<Id>();
        List <Task> insertSwitchedSpec = new list <Task>();

        List<Opportunity> oList = [SELECT Id, 
                                        Account_Opportunity_Name__c,
                                        Switched_Spec__c
                                    FROM Opportunity 
                                    WHERE Switched_Spec__c = TRUE
                                    AND Id IN :setOppId];                           
        Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     

        List<Task> tList =  [SELECT WhatId, RecordTypeId,OwnerId,ActivityDate,WhoId 
                                FROM Task  
                                WHERE WhatId IN :setOppId
                                AND Type__c = 'Switched Spec'];                               

        for (Opportunity o: oList) {
            if (tList.size() == 0) {  
                Task tt=new Task();
                tt.WhatID= o.id;
                tt.Goals__c='Switched Spec';
                tt.Type__c='Switched Spec';
                tt.Type='Switched Spec';
                tt.Subject='Switched Spec';
                tt.Primary_Objective__c='Switched Spec';
                tt.ActivityDate=date.today();
                tt.Status='Completed';
                tt.Priority='Normal';
                tt.Description='New Switched Spec on Opportuntiy: ' + o.Account_Opportunity_Name__c;
                insertSwitchedSpec.add(tt);
            }
        }
    return insertSwitchedSpec;
    }

    // public static List <Task> newGalleryTask (Set<Id> setOppId){
    //     String MyProflieName = OpportunityGateway.getProfile[0].Name;
    //     List <Task> insertGalleryTask = new list <Task>();
    //     if ((MyProflieName == 'Gallery User'))  
    //     { 

    //     List<Opportunity> oList = [SELECT Id, 
    //                                     Switched_Spec__c,
    //                                     Account_Opportunity_Name__c
    //                                 FROM Opportunity 
    //                                 WHERE Id IN :setOppId]; 
    //     System.debug('::::OpportunityGateway + oList' + oList);                              
    //     Map<Id, List<Opportunity>> oppToOpp = new Map<Id, List<Opportunity>>();     
        

    //     Id galRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Gallery Task').getRecordTypeId();
    //     System.debug('::::OpportunityGateway + galRecordTypeId: ' + galRecordTypeId);  

    //     List<Task> tList =  [SELECT WhatId, RecordTypeId,OwnerId,ActivityDate,WhoId 
    //                             FROM Task  
    //                             WHERE WhatId IN :setOppId
    //                             AND Type__c = 'Gallery Visit'
    //                             AND ActivityDate = :date.today()];
    //     System.debug('::::OpportunityGateway + tList: ' + tList);   

    //     for (Opportunity o: oList) {
    //         if (tList.isEmpty()) {  
    //             Task gt=new Task();
    //             gt.WhatID=o.id;
    //             gt.RecordTypeId=galRecordTypeId;
    //             gt.Goals__c='Sample Prep';
    //             gt.Type__c='Gallery Visit';
    //             gt.Type='Meeting';
    //             gt.Subject='Gallery Visit';
    //             gt.Primary_Objective__c='Switched Spec';
    //             gt.ActivityDate=date.today();
    //             gt.Status='Completed';
    //             gt.Priority='Normal';
    //             gt.Description='New Gallery Visit on Opportuntiy: ' + o.Account_Opportunity_Name__c;
    //             insertGalleryTask.add(gt);
    //         }
    //     }
    //     System.debug('::::OpportunityGateway + insertGalleryTask' + insertGalleryTask);   
    //     } 
    //     return insertGalleryTask;
    // }

    public static List<Related_Customer__c> newRelatedCustomer (Set<Id> setOppId){
        List <Task> insertRelatedCustomer = new list <Task>();

        List<Opportunity> oList = [SELECT Id, 
                                        AccountId,
                                        Account_Opportunity_Name__c
                                    FROM Opportunity 
                                    WHERE Id IN :setOppId]; 
        System.debug('::::OpportunityGateway + oList' + oList);                              
        Map<Id, List<Opportunity>> oppToRelAcct = new Map<Id, List<Opportunity>>();     
        for (Opportunity o: oList) {
            List<Opportunity> opps = oppToRelAcct.get(o.Id);
            if (opps == null)
            {
                opps = new List<Opportunity>();
                oppToRelAcct.put(o.AccountId, opps);
            }
        }

        Id galRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Gallery Task').getRecordTypeId();
        System.debug('::::OpportunityGateway + galRecordTypeId: ' + galRecordTypeId);  

        List<Related_Customer__c> rcList =  [SELECT Id, Opportunity__c,Related_Account__c 
                                FROM Related_Customer__c  
                                WHERE Opportunity__c IN :setOppId
                                AND Related_Account__c IN :oppToRelAcct.keySet()];
        System.debug('::::OpportunityGateway + rcList: ' + rcList);   

        List<Related_Customer__c> insertOwner= new List <Related_Customer__c>();
        for (Opportunity o: oList) {
            if(rcList.isEmpty()) {
                Related_Customer__c rc=new Related_Customer__c();
                rc.Opportunity__c=o.id;
                rc.Related_Account__c=o.AccountId;
                rc.Role__c='Architect';
                insertOwner.add(rc);
            } 
        }
        return insertOwner;
    }

}