@IsTest
public class Dal_CreateFulfillmentJSON_Test {
	
	static testMethod void testParse() {
		String json = '{  '+
		'   \"SalesOrder\":\"Y121668221\",'+
		'   \"SalesOrderKey\":\"201805211243181241386134\",'+
		'   \"FulfilmentMethod\":\"pickup\",'+
		'   \"lineWrapperList\":[  '+
		'      {  '+
		'         \"Quantity\":50,'+
		'         \"SalesOrderLine\":\"1\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386135\"'+
		'      },'+
		'      {  '+
		'         \"Quantity\":30,'+
		'         \"SalesOrderLine\":\"2\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386136\"'+
		'      },'+
		'      {  '+
		'         \"Quantity\":15,'+
		'         \"SalesOrderLine\":\"3\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386137\"'+
		'      },'+
		'      {  '+
		'         \"Quantity\":10,'+
		'         \"SalesOrderLine\":\"4\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386138\"'+
		'      },'+
		'      {  '+
		'         \"Quantity\":15,'+
		'         \"SalesOrderLine\":\"5\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386139\"'+
		'      },'+
		'      {  '+
		'         \"Quantity\":5,'+
		'         \"SalesOrderLine\":\"6\",'+
		'         \"SalesOrderLineKey\":\"201805211243181241386140\"'+
		'      }'+
		'   ],'+
		'   \"ShipToAddress_Name\":\"SSC Seattle, WA\",'+
		'   \"ShipToAddress_Line1\":\"540 S FRONT ST\",'+
		'   \"ShipToAddress_City\":\"SEATTLE\",'+
		'   \"ShipToAddress_StateProvince\":\"WA\",'+
		'   \"ShipToAddress_PostalCode\":\"98108-3311\",'+
		'   \"PickTime\":\"2018-05-22T07:30:00.000Z\",'+
		'   \"ContactFirstName\":\"Hitesh\",'+
		'   \"ContactLastName\":\"Yadav\",'+
		'   \"ContactPhMobile\":\"9854747847\",'+
		'   \"sendSMS\":false'+
		'}';
		Dal_CreateFulfillmentJSON obj = Dal_CreateFulfillmentJSON.parse(json);
		System.assert(obj != null);
	}
}