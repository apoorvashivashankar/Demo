/**
 * Created by Yadav on 11/22/2018.
 */

@IsTest
public with sharing class Dal_LeadJSONTest {


    static testMethod void testParse() {
            String json = '{\"FirstName\":\"Hitesh\",\"LastName\":\"yadav\",\"Salutation\":\"Mr.\",\"Company\":\"MTX Group Inc.\",\"Street\":\"28320 PLYMOUTH RD\",\"Job_Title__c\":\"Architect\",\"City\":\"Bean’s Purchase\",\"Phone\":\"2484767850\",\"State\":\"Cheshire\",\"MobilePhone\":\"2484767850\",\"PostalCode\":\"48150\",\"Email\":\"hitesh.yadav@mtxb2b.com\",\"Country\":\"India\",\"Call_Source__c\":\"Customer Request\",\"Lead_Score__c\":\"Warm\",\"Status\":\"Unqualified\",\"Disqual_Reason__c\":\"No Decision\",\"Name\":{\"displayValue\":null,\"value\":null},\"recordId\":null}';
        Dal_LeadJSON obj = Dal_LeadJSON.parse(json);
    System.assert(obj != null);
    }
}