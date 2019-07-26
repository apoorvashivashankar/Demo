@IsTest
public class Dal_OrderJSONTest {	
	static testMethod void testParse() {
		String json = '{'+
		'	\"orderId\": \"a33W0000000FdNQIA0\",'+
		'	\"orderLineList\": ['+
		'		{'+
		'			\"lineno\": 1,'+
		'			\"skuNumber\": \"A88912242P6\",'+
		'			\"quantity\": \"100\",'+
		'			\"unitOfMeasure\": \"SF\",'+
		'			\"sourceOfSupply\": \"PDC Muskogee, OK\",'+
		'			\"requestedShipDate\": \"2018-5-4\",'+
		'			\"priceRecord\": {'+
		'				\"id\": 0,'+
		'				\"label\": \"LAF\",'+
		'				\"value\": 0,'+
		'				\"priceRecordCode\": \"GENPRALLAF\",'+
		'				\"selected\": true'+
		'			},'+
		'			\"estimatedShipDate\": \"2018-05-03\",'+
		'			\"size\": \"1224\",'+
		'			\"color\": \"A889\",'+
		'			\"extendedWeight\": 454,'+
		'			\"unitPrice\": \"1.23\",'+
		'			\"extendedPrice\": \"134.32\",'+
		'			\"productdesc\": \"12X24   FLOOR  A889    WHITE  SERIES  II\"'+
		'		}'+
		'	],'+
		'	\"Account_Address_Name\": \"#1 BRICK BUILDERS LLC\",'+
		'	\"Account_Address_Line1\": \"6 PEBBLE BEACH CT\",'+
		'	\"Account_Address_City\": \"MANVEL\",'+
		'	\"Account_Address_StateProvince\": \"TX\",'+
		'	\"Account_Address_PostalCode\": \"77578-3359\",'+
		'	\"Account_Address_Country\": \"US\",'+
		'	\"FreightTerms\": \"1A1\",'+
		'	\"isShipComplete\": \"No\",'+
		'	\"orderSubTotal\": 134.32,'+
		'	\"PONumber\": \"test\",'+
		'	\"contactName\": \"Sumit\",'+
		'	\"jobName\": \"Demo\",'+
		'	\"contactNumber\": \"1234564542\"'+
		'}';
		Dal_OrderJSON obj = Dal_OrderJSON.parse(json);
		System.assert(obj != null);
	}
}