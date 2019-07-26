/**
 * Created by francoiskorb on 12/27/17.
 */

@isTest
public with sharing class Peak_TwitterFeedControllerTest
{
	@isTest
	static void test_getDomain() {
		String domain = Peak_TwitterFeedController.getDomain();
		System.assertNotEquals(null, domain);
	}
}