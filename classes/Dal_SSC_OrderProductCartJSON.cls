/**
 * Created by Yadav on 1/2/2019.
 */

public with sharing class Dal_SSC_OrderProductCartJSON {

    public String accountCreditRiskCategory;
    public String availableQty;
    public String dateAtSupplyPlant;
    public String dateAtSupplyPlantFinal;
    public List<MilesWrapperList> milesWrapperList;
    public String onTimeFlag;
    public String pricingUOM;
    public Double pricingUOM_NetPrice;
    public String sku;
    public String SOS;
    public String supplyPlant;
    public String supplyPlantId;
    public String totalCartons;
    public String Size;
    public String Description;
    public String Color; 
    public String BaseUOM;
    public Integer ShowTill;
    public List<String> uomList;
    public Integer PiecesPerCarton;
    public Double SquarefeetPerCarton;
    public Decimal updatedQuantity;
    public String updatedBaseUOM;
    public Decimal energySurCharge;

    public class MilesWrapperList {
    }


    public static List<Dal_SSC_OrderProductCartJSON> parse(String json) {
        return (List<Dal_SSC_OrderProductCartJSON>) System.JSON.deserialize(json, List<Dal_SSC_OrderProductCartJSON>.class);
    }
}