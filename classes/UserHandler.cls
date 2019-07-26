public class UserHandler implements ITrigger {
    
    private List <User> listSetUserPassword = new List<User>();
    private List <Case> listUpdateCase = new List<Case>();
    private List <Contact> listNewUserContacts = new List<Contact>();
    private List <Account> listUpdatedAccounts = new List<Account>();
    private List <User_to_Location__c> listUserToLocation = new List<User_to_Location__c>();
    
    private Set<ID> newUserId = new Set<ID>();
 
    public void bulkBefore()
    {
        if (Trigger.isInsert || Trigger.isUpdate) {
            UserGateway.validate();
        }
    }
 
    public void bulkAfter()
    {
        if (Trigger.isInsert) {
            // listSetUserPassword = UserGateway.setUserPassword(Trigger.New);
            listUpdateCase = UserGateway.updateProExchCase(Trigger.newMap.keySet());
            listUserToLocation = UserGateway.createUserToLocation(Trigger.New);
        }
        if (Trigger.isInsert || Trigger.isUpdate) {
            UserGateway.updateUserContact(Trigger.new, Trigger.old); 
        }
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
 
    public void beforeDelete(SObject so)
    {
    }
 
    public void afterInsert(SObject so)
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {          
        
        // if(listSetUserPassword.size()>0){
        //     for (User u : listSetUserPassword) {
    		  //  String varPassword = u.LastName + u.Primary_Account_Number__c;
    	   //     System.Debug('listSetUserPassword + setting user password + varPassword...: ' + varPassword);
        //         try {
        //             System.setPassword(u.id,varPassword);        
    	   //         System.Debug('listSetUserPassword + Success!  Username:...' +  u.UserName + ' + varPassword:...' + varPassword);
        //         } catch (Exception e) {
        //             System.Debug('listSetUserPassword + Issue setting user password + e ...: ' + e);
        //         }
        //     }
        // }
    
        if(listUpdateCase.size()>0){
            update listUpdateCase;
        }      
        if(listUserToLocation.size()>0){
            upsert listUserToLocation;
        }      
    }
}