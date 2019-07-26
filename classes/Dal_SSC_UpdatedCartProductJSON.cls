/**
 * Created by Preshit on 21-01-2019.
 */

public with sharing class Dal_SSC_UpdatedCartProductJSON {

    public String availableQuantity;
    public String availableUOM;
    public String baseUOM;
    public String cartId;
    public List<CartLst> cartLst;
    public Double energySurcharge;
    public String fulfillmentType;
    public Boolean liftGate;
    public String productId;
    public String productName;
    public String productSKU;
    public Decimal quantity;
    public String shippingName;
    public String shippingCity;
    public String shippingState;
    public String shippingStreet;
    public String shippingCountry;
    public String shippingZIPCode;
    public String supplyPlantCity;
    public String supplyPlantCountry;
    public String supplyPlantId;
    public String supplyPlantName;
    public String supplyPlantState;
    public String supplyPlantStreet_Address;
    public String supplyPlantZip_Code;
    public String totalCarton;
    public Double unit;
    public String UOM;
    public String updatedQuantity;
    public String updatedUOM;
    public List<String> listOfUOM;

    public class CartLst {
        public String Id;
        public String Name;
        public String User;
        public String Special_Instructions;
        public String Job_Name;
        public String Contact_Name;
        public String Contact_Number;
        public String Status;
    }


    public static List<Dal_SSC_UpdatedCartProductJSON> parse(String json) {
        return (List<Dal_SSC_UpdatedCartProductJSON>) System.JSON.deserialize(json, List<Dal_SSC_UpdatedCartProductJSON>.class);
    }

}