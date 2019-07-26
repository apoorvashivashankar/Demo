public class Dal_CreateFulfillmentJSON {

	public String SalesOrder;
	public String SalesOrderKey;
	public String FulfilmentMethod;
	public List<LineWrapperList> lineWrapperList;
	public String ShipToAddress_Name;
	public String ShipToAddress_Line1;
	public String ShipToAddress_City;
	public String ShipToAddress_StateProvince;
	public String ShipToAddress_PostalCode;
	public String PickTime;
	public String ContactFirstName;
	public String ContactLastName;
	public String ContactPhMobile;
	public Boolean sendSMS;

	public class LineWrapperList {
		public Integer Quantity;
		public String SalesOrderLine;
		public String SalesOrderLineKey;
	}

	
	public static Dal_CreateFulfillmentJSON parse(String json) {
		return (Dal_CreateFulfillmentJSON) System.JSON.deserialize(json, Dal_CreateFulfillmentJSON.class);
	}
}