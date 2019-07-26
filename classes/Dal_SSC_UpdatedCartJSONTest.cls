/**
 * Created by Preshit on 21-01-2019.
 */

@IsTest
public with sharing class Dal_SSC_UpdatedCartJSONTest {
    static testMethod void testParse() {
        String json = '{\"Id\":\"a3v29000000PkBoAAK\",\"Name\":\"DC-000009\",\"User__c\":\"00529000002bGFAAA2\",\"Special_Instructions__c\":\"test\",\"Job_Name__c\":\"Job\",\"Contact_Name__c\":\"test\",\"Contact_Number__c\":1234567890,\"Tax_Exempt__c\":false,\"Status__c\":\"Draft\",\"po\":\"123\",\"National_Account_Field\":\"test\"}';
        Dal_SSC_UpdatedCartJSON obj = Dal_SSC_UpdatedCartJSON.parse(json);
        System.assert(obj != null);
    }

}