/**
 * Created by Preshit on 21-01-2019.
 */

public with sharing class Dal_SSC_UpdatedCartJSON {

    public String Id;
    public String Name;
    public String specialInstruction;
    public String jobName;
    public String contactName;
    public String contactNumber;
    public Boolean taxExempt; 
    public String status;
    public String po;
    public String nationalAccountId;
    public String nationalAccountIdNew;
    public String nationalAccountNameNew;
    public String nationalAccountName;
    public String certificateId;
    public Datetime expirationDate;


    public static Dal_SSC_UpdatedCartJSON parse(String json) {
        return (Dal_SSC_UpdatedCartJSON) System.JSON.deserialize(json, Dal_SSC_UpdatedCartJSON.class);
    }

}