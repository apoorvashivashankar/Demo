public class Dal_OrderFulfilmentJSON {

	public class lineWrapperList {
		public String Quantity;
		public String SalesOrderLine;
		public String SalesOrderLineKey;

	}

        public String SalesOrder;
        public List<lineWrapperList> lineWrapperList;
        public String SalesOrderKey;
        public String FulfilmentMethod;// pickup  - PICK and delivery - SHP
        public String ShipToAddress_Name;
        public String ShipToAddress_Line1;
        public String ShipToAddress_City;
        public String ShipToAddress_StateProvince;
        public String ShipToAddress_PostalCode;
        public String ContactFirstName;
        public string ContactLastName;
        public String ContactPhMobile;
        public String sendSMS;
        public String PickTime;
        public String ScheduleTime; //one field if PICK date + time. if SHP only date
	
	public static Dal_OrderFulfilmentJSON parse(String json) {
        
		return (Dal_OrderFulfilmentJSON) System.JSON.deserialize(json, Dal_OrderFulfilmentJSON.class);
        
	}
  
}