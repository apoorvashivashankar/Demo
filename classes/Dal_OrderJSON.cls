public class Dal_OrderJSON {
	
    public class OrderLineList {
		public Integer lineno;
		public String skuNumber;
		public String quantity;
		public String unitOfMeasure;
		public String sourceOfSupply;
        public string supplyplantid;
		public String requestedShipDate;
		public PriceRecord priceRecord;
		public String estimatedShipDate;
		public String size;
		public String color;
		public String extendedWeight;
		public String unitPrice;
		public String extendedPrice;
		public String productdesc;
	}

        public String orderId;
        public List<OrderLineList> orderLineList;
        public String Account_Address_Name;
		public String Account_Address_Name2;
    	public String Account_Address_CareOf;
        public String Account_Address_Line1;
        public String Account_Address_City;
        public String Account_Address_StateProvince;
        public String Account_Address_PostalCode;
        public String Account_Address_Country;
        public String FreightTerms;
        public String isShipComplete;
        public Double orderSubTotal;
        public String PONumber;
        public String contactName;
        public String jobName;
        public String contactNumber;
        public String smallPackage;
        public String Carrier;
        public String defaultPriceCode;
        public String defaultRequestedShipDate;

	public class PriceRecord {
		public Integer id;
		public String label;
		public Integer value;
		public String priceRecordCode;
		public Boolean selected;
	}

	
	public static Dal_OrderJSON parse(String json) {
		return (Dal_OrderJSON) System.JSON.deserialize(json, Dal_OrderJSON.class);
	}
}