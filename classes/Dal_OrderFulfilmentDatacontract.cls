/**
 * Created by Yadav on 12/3/2018.
 */

public with sharing class Dal_OrderFulfilmentDatacontract {
    public class Response {
        public Dal_OrderFulfilmentDatacontract.Result Result;
        private String[] Result_type_info = new String[]{'Result','http://schemas.datacontract.org/2004/07/DAL_Canonical_OrderFulfilmentSchedule.OM',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/DAL_Canonical_OrderFulfilmentSchedule.OM','true','false'};
        private String[] field_order_type_info = new String[]{'Result'};
    }
    public class Result {
        public String Status;
        public String StatusDesc;
        private String[] Status_type_info = new String[]{'Status','http://schemas.datacontract.org/2004/07/DAL_Canonical_OrderFulfilmentSchedule.OM',null,'0','1','true'};
        private String[] StatusDesc_type_info = new String[]{'StatusDesc','http://schemas.datacontract.org/2004/07/DAL_Canonical_OrderFulfilmentSchedule.OM',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://schemas.datacontract.org/2004/07/DAL_Canonical_OrderFulfilmentSchedule.OM','true','false'};
        private String[] field_order_type_info = new String[]{'Status','StatusDesc'};
    }
}