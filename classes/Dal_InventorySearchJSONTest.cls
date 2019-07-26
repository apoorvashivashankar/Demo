@istest
public class Dal_InventorySearchJSONTest {
    static testMethod void testParse() {
        String json = '[{\"sku\":\"J5051224S1P\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"},{\"sku\":\"J5051224F1L\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"}]';
        List<Dal_InventorySearchJSON> obj = Dal_InventorySearchJSON.parse(json);
        System.assert(obj != null);
    }
}