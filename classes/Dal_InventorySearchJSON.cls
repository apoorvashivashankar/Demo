/**
 * Created by Yadav on 11/9/2018.
 */

public with sharing class Dal_InventorySearchJSON {


        public String sku;
        public String quantity;
        public String uom;
        public String CodeSet;
        public String SupplyplantId;
        public String SupplyplantType;
        public String reqShipdate;


        public static List<Dal_InventorySearchJSON> parse(String json) {
            return (List<Dal_InventorySearchJSON>) System.JSON.deserialize(json, List<Dal_InventorySearchJSON>.class);
        }

}