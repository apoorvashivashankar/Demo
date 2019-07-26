/**
 * Created by presh on 26-11-2018.
 */

public with sharing class Dal_LeadConvert {

    public Boolean sendEmail;
    public Boolean isAccountNew;
    public String selectedAccount;
    public Boolean isContactNew;
    public String selectedContact;
    public String opportunityName;
    public String convertedStatus;
    public String opportunityRating;
    public String recordId;

    public static Dal_LeadConvert parse(String json) {
        return (Dal_LeadConvert) System.JSON.deserialize(json, Dal_LeadConvert.class);
    }

}