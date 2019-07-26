trigger UpdateSalesRegionField on Sales__c (before insert, before update) {
	set<String> ids=new set<String>();
	for(Sales__c s:trigger.new){
		ids.add(s.SSC__c);
	}
	SSC__c[] sscs=[Select s.Sales__c, s.Region__r.Name, s.DW_ID__c From SSC__c s where DW_ID__c in:ids and Region__c!=null];
	Map<String, SSC__c> sscmap=new Map<String, SSC__c>();
	for(SSC__c s:sscs){
		sscmap.put(s.DW_ID__c,s);
	}
	for(Sales__c s:trigger.new){
		if(s.SSC__c!=null && s.SSC__c!='' && sscmap.containskey(s.SSC__c)){
			s.Region__c=sscmap.get(s.SSC__c).Region__r.Name;
		}
	}
}