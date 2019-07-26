public without sharing class Dal_MyProfileUpdate {
  
    @AuraEnabled
    public static User getIndividualJobDetail(Id recordId){
      return  [SELECT Id, AboutMe, Phone
               FROM User 
               Where Id =: recordId] ;
    }    
    @AuraEnabled
    public static Id saveUserRecord(User user){
        update user;
        return null;
    }
}