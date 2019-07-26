/**
 * Created by Yadav on 11/22/2018.
 */

public with sharing class Dal_LeadJSON {


        public String FirstName;
        public String LastName;
        public String Salutation;
        public String Company;
        public String Street;
        public String Job_Title; 
        public String City;
        public String Phone;
        public String State;
        public String MobilePhone;
        public String PostalCode; 
        public String Email;
        public String Country;
        public String Call_Source;
        public String Lead_Score;
        public String Status;
        public String Disqual_Reason;
        public Name Name;
    	public String Description;
        public String recordId;
        public String LeadSource;

        public class Name {
            public Object displayValue;
            public Object value;
        }


        public static Dal_LeadJSON parse(String json) {
            return (Dal_LeadJSON) System.JSON.deserialize(json, Dal_LeadJSON.class);
        }

}