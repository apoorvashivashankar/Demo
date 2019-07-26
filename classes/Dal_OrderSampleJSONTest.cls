/**
 * Created by Yadav on 8/24/2018.
 */
@IsTest
public with sharing class Dal_OrderSampleJSONTest {

    static testMethod void testParse() {
        String json = '{\"productOrderLines\":[{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"10.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":2.78,\"isAdded\":true,\"OnHandQty\":\"10.000\",\"productId\":\"01t0G000004TaDKQA0\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"10X14 SAMPLE    BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951014SAM1P2\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"},{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"7.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":4.17,\"isAdded\":true,\"OnHandQty\":\"8.000\",\"productId\":\"01t0G000004TlqrQAC\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"12X24 SAM       BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951224PSAM1P6\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"}],\"orderDetails\":{\"selectedAddress\":{\"name\":\"Ray Test Dist 8082001\",\"isActive\":true,\"isPrimary\":true},\"freightTerms\":\"Prepaid\",\"isShipComplete\":\"no\",\"carrier\":\"UPS Ground\",\"isSmallPackage\":\"yes\",\"poNumber\":\"po\",\"jobName\":\"job\"},\"cumulativeOrderWeight\":\"6.95\"}';
        Dal_OrderSampleJSON obj = Dal_OrderSampleJSON.parse(json);
        System.assert(obj != null);
    }
}