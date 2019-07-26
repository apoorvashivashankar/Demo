public with sharing class Dal_LiveAgentController {
    
    @AuraEnabled
    public static Contact getContact(Id contactId) {
        Contact c=null;
        User usr = [Select ContactId from User where Id=: UserInfo.getUserId()];
        if(usr.ContactId !=null){
            try{
                c = [
                    SELECT Id, Name, Email, Phone
                    FROM Contact
                    WHERE Id =:usr.ContactId
                ];
            }Catch(QueryException e ){
                System.debug( e.getMessage());
            }     
        }else{
            c = new Contact(FirstName='she');
        }
        return c;
    }
}