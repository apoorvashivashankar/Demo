/*Copyright © 2016-2018 7Summits, Inc. All rights reserved.*/

@isTest
global class Peak_MockHttpResponseGenerator implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		// Optionally, only send a mock response for a specific endpoint
		// and method.
		System.assertEquals(System.URL.getSalesforceBaseUrl().toExternalForm()+ '/services/data/v40.0/connect/communities/null/chatter/users/batch/', req.getEndpoint());
		System.assertEquals('GET', req.getMethod());

		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"foo":"bar"}');
		res.setStatusCode(200);
		return res;
	}
}