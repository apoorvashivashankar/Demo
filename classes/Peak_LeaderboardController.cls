/*Copyright © 2016-2018 7Summits, Inc. All rights reserved.*/
public without sharing class Peak_LeaderboardController {

	@AuraEnabled
	public static String getSitePrefix()
	{
		return Peak_Utils.getSitePrefix();
	}

	@AuraEnabled
	public static Boolean isReputationEnabled()
	{
		Boolean enabled = false;

		for (Network nw : [SELECT OptionsReputationEnabled FROM Network])
		{
			enabled = nw.OptionsReputationEnabled;
		}

		system.debug('Options Reputation enabled: ' + enabled);

		return enabled;
	}

	@AuraEnabled
	public static String getData(Boolean hideInternal, String recordNum)
	{
		String networkId    = Network.getNetworkId();
		List<String> idList = getCandidates(hideInternal, recordNum, networkId);
		String commaSepIds  = String.join(idList, ',');

		HttpResponse res = getDataRequest(commaSepIds);
		return res.getBody();
	}

	public static HttpResponse getDataRequest(String commaSepIds)
	{
		String networkId = Network.getNetworkId();
		HttpRequest req  = new HttpRequest();
		String baseUrl   = System.URL.getSalesforceBaseUrl().toExternalForm().toLowerCase();
		String url       = baseUrl + '/services/data/v40.0/connect/communities/'+networkId+'/chatter/users/batch/'+commaSepIds;

		req.setEndpoint(url);
		String userSessionId = UserInfo.getSessionId();
		system.debug(userSessionId);

		req.setHeader('Authorization', 'OAuth ' + userSessionId);
		req.setMethod('GET');

		Http h = new Http();
		HttpResponse res = h.send(req);

		return res;
	}

	public static List<String> getCandidates(Boolean hideInternal, String recordNum, String networkId)
	{
		List<String> idList = new List<String>();
		Integer recordLimit = Integer.valueOf(recordNum);

		if (hideInternal){
			for(NetworkMember per : [
					SELECT ReputationPoints, memberId
					FROM NetworkMember n
					WHERE networkId = :networkId AND n.Member.isActive = true AND n.Member.Usertype != 'Standard'
					ORDER by ReputationPoints DESC
					LIMIT :recordLimit]) { idList.add(per.memberId);}
		} else {
			for (NetworkMember per : [
					SELECT ReputationPoints, memberId
					FROM NetworkMember n
					WHERE networkId = :networkId AND n.Member.isActive = true
					ORDER by ReputationPoints DESC
					LIMIT :recordLimit]) { idList.add(per.memberId);}
		}

		return idList;
	}
}