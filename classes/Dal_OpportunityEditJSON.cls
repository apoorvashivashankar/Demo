/**
 * Created by presh on 27-11-2018.
 */

public with sharing class Dal_OpportunityEditJSON {

    public String Name;
    public String StageName;
    public String Bid_Date;
    public String AccountId;
    public String Amount;
    public String Probability;
    public String recordId;
    public String Description;


    public static Dal_OpportunityEditJSON parse(String json) {
        return (Dal_OpportunityEditJSON) System.JSON.deserialize(json, Dal_OpportunityEditJSON.class);
    }
}