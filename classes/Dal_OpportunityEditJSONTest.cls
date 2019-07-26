/**
 * Created by presh on 27-11-2018.
 */

@IsTest
public with sharing class Dal_OpportunityEditJSONTest {

    static testMethod void testParse() {
        String json = '{\"Name\":\"Test-Opportunity Preshit\",\"StageName\":\"3 - Bidding\",\"Bid_Date\":\"2018-11-07\",\"AccountId\":\"0012900000Mb00aAAB\",\"Amount\":\"5000\",\"Probability\":\"50\",\"recordId\":\"00629000007MSv5AAG\"}';
        Dal_OpportunityEditJSON obj = Dal_OpportunityEditJSON.parse(json);
        System.assert(obj != null);
    }
}