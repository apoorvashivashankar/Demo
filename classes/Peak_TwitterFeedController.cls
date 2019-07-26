/**
 * Created by francoiskorb on 12/27/17.
 */

public with sharing class Peak_TwitterFeedController
{
	@AuraEnabled
	public  static String getDomain(){
		return System.URL.getSalesforceBaseUrl().toExternalForm();
	}
}