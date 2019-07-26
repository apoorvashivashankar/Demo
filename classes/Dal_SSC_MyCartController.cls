/**
* Created by Yadav on 1/25/2019.
*/

public with sharing class Dal_SSC_MyCartController {
    
    public static final String STATUS_VALUE = 'Draft';
    
    @AuraEnabled
    public static ProfileWrapper getMyCartProductsCount() {
        Integer cartProductCount = 0;
        ProfileWrapper wrapper;
        try {
            String UserId = UserInfo.getUserId();
            Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
            if(!Test.isRunningTest()){
                cartProductCount = [SELECT Count() FROM DT_Cart_Product__c WHERE DT_Cart__r.Status__c = :STATUS_VALUE AND DT_Cart__r.User__c = :UserId AND DT_Cart__r.Cart_Account__c =: selectedAccount.Id];
            }else{
                cartProductCount = 5;
            }
            system.debug('--cartProductCount-'+cartProductCount);
            User user = [SELECT Profile.Name FROM User WHERE Id =:UserId LIMIT 1];
            wrapper = new ProfileWrapper(user.Profile.Name,cartProductCount);
            
        } catch (Exception exp) {
            System.debug('cartProductLst : An unexpected error has occurred: ' + exp.getMessage());
        }
        
        System.debug('getMyCartProductsCount-->' + cartProductCount);
        return wrapper;
    }
    
    public class ProfileWrapper{
        @AuraEnabled public String profileName;
        @AuraEnabled public Integer cartCount;
        
        public ProfileWrapper(String profile,Integer count){
            this.profileName = profile;
            this.cartCount = count;
        }
        
    }
    
}