/**
 * Created by presh on 26-11-2018.
 */

@IsTest
public with sharing class Dal_LeadConvertTest {
    static testMethod void testParse() {
            String json = '{\"sendEmail\":false,\"isAccountNew\":true,\"selectedAccount\":\"Test\",\"isContactNew\":false,\"selectedContact\":\"0032900000KmrKMAAZ\",\"opportunityName\":\"Test-Opportunity\",\"convertedStatus\":\"Hot\",\"opportunityRating\":\"Hot\",\"recordId\":\"00Q29000005g5sBEAQ\"}';
        Dal_LeadConvert obj = Dal_LeadConvert.parse(json);
    System.assert(obj != null);
}
}