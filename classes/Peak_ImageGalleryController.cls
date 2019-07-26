public with sharing class Peak_ImageGalleryController {
    @AuraEnabled
    public static Peak_Response getImageGallery(String imageGalleryIDString) {
        List<Peak_Image_Gallery__c> imageGalleries;
        Peak_Response response = new Peak_Response();

        if (!String.isEmpty(imageGalleryIDString)) {
            imageGalleries = [SELECT Id, Default_Image__c, Description__c, (SELECT Image_URL__c, Sort_Order__c, Image_Description__c FROM Gallery_Entries__r ORDER BY Sort_Order__c ASC) FROM Peak_Image_Gallery__c WHERE Id = :imageGalleryIDString];
        }
        response.results = imageGalleries;
        return response;
    }
}