/*Copyright © 2016-2018 7Summits, Inc. All rights reserved.*/

@IsTest
public with sharing class Peak_LeaderboardController_Test
{
	static final Integer howMany = 10;

	@IsTest
	private static void testGetCandidates()
	{
		test.startTest();

		String sitePrefix = Peak_LeaderboardController.getSitePrefix();
		System.assertNotEquals(null, sitePrefix);

		String networkId = Network.getNetworkId();
		String total = String.valueOf(howMany);
		List<String> data = Peak_LeaderboardController.getCandidates(false, total, networkId);
		System.assertNotEquals(null, data);

		data = Peak_LeaderboardController.getCandidates(true, total, networkId);
		System.assertNotEquals(null, data);

		test.stopTest();
	}


	@isTest
	private static void testCallout()
	{
		Test.startTest();
		
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Peak_MockHttpResponseGenerator());

		List<String> idList = new List<String>();
		String commaSepIds = String.join(idList, ',');

		HttpResponse data = Peak_LeaderboardController.getDataRequest(commaSepIds);
		system.assertNotEquals(null, data);

		Test.stopTest();
	}

	@IsTest
	private static void testGetData()
	{
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new Peak_MockHttpResponseGenerator());

		String networkId = Network.getNetworkId();
		String total = String.valueOf(howMany);

		String data = Peak_LeaderboardController.getData(false, total);
		system.assertNotEquals(null, data);

		test.stopTest();
	}

}