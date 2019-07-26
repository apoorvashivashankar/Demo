/**
 * Created by ranja on 26-12-2018.
 *
 * Storing frontend values in a Wrapper and passing this wrapper to other components
 *
 */

public with sharing class Dal_SSC_CreateOrderJSON {

    @AuraEnabled public String selectedCategory {get;set;}
    @AuraEnabled public String selectedBrand {get;set;}
    @AuraEnabled public String selectedProductType {get;set;}
    @AuraEnabled public String selectedSeries {get;set;}
    @AuraEnabled public String selectedProduct {get;set;}
    @AuraEnabled public String selectedColor {get;set;}
    @AuraEnabled public String selectedFinish {get;set;}
    @AuraEnabled public String selectedSize {get;set;}
    @AuraEnabled public String skuKeyword {get;set;}
    @AuraEnabled public String selectedVendor {get;set;}
    @AuraEnabled public Integer pageOrderCreate {get;set;}
    @AuraEnabled public Integer pageOrderCart {get;set;}
    @AuraEnabled public List<ProductSeries__c> listOfSeries {get;set;}
    @AuraEnabled public List<String> listOfProducts {get;set;}
    @AuraEnabled public List<String> listOfSizes {get;set;}
    @AuraEnabled public List<String> listOfProductType {get;set;}
    @AuraEnabled public List<String> listOfFinish {get;set;}
    @AuraEnabled public List<Object> listOfVendors {get;set;}
    @AuraEnabled public Boolean isChecked {get;set;}
    @AuraEnabled public Decimal updatedQuantity {get;set;}
    @AuraEnabled public String updatedBaseUOM {get;set;}
    @AuraEnabled public String updatedStoreLocation {get;set;}
    @AuraEnabled public String sortByName {get;set;}
    @AuraEnabled public String sortByColor {get;set;}


    public Dal_SSC_CreateOrderJSON() {
        selectedCategory = 'Branded Product';
        selectedBrand = '';
        selectedProductType = '';
        selectedSeries = '';
        selectedProduct = '';
        selectedFinish = '';
        selectedSize = 'all';
        selectedColor = 'all';
        skuKeyword = '';
        updatedStoreLocation = '';
        updatedBaseUOM = ''; 
        updatedQuantity = 1;
        pageOrderCreate = 1;
        pageOrderCart = 1;
        sortByName = 'A';
        sortByColor = 'A';
        selectedVendor = 'All';
        listOfSeries = new List<ProductSeries__c>();
        listOfProducts = new List<String>();
        listOfProductType = new List<String>();
        listOfFinish = new List<String>();
        listOfSizes = new List<String>();
        listOfVendors = new List<Object>();
        isChecked = false;
    }

    public static List<Dal_SSC_CreateOrderJSON> parse(String json) {
        return (List<Dal_SSC_CreateOrderJSON>) System.JSON.deserialize(json, List<Dal_SSC_CreateOrderJSON>.class);
    }
}