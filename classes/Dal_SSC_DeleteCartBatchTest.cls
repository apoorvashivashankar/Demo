@istest
public class Dal_SSC_DeleteCartBatchTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static testmethod void test() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.DW_ID__c = '123464';
        insert acc;
        
        DT_Cart__c cartObj = new DT_Cart__c();
        cartObj.Contact_Name__c = 'Test Contact';
        cartObj.Contact_Number__c = '';
        cartObj.Job_Name__c = '';
        cartObj.Job_Name_Certificate_Id__c = '';
        cartObj.Job_Name_Expiration__c = System.now();
        cartObj.Cart_Account__c = acc.Id;
        cartObj.National_Account__c = null;
        cartObj.Special_Instructions__c = '';
        cartObj.Status__c = 'Draft';
        cartObj.User__c = UserInfo.getUserID();
        insert cartObj;
        
        DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
        cartProduct.DT_Cart__c = cartObj.Id;
        cartProduct.Lift_gate__c = false;
        cartProduct.Quantity__c = 1;
        insert cartProduct; 
        
        String cartJSON = '{"Id":"'+cartObj.Id+'","Status":"Draft","LastModifiedDate":"2019-10-04T17:54:26.000+0000"}';
        DT_Cart__c cart = (DT_Cart__c) JSON.deserialize(cartJSON, DT_Cart__c.class); 
        
        System.debug('Test cart:' + cart.LastModifiedDate); 
        
        cartObj.Id = cart.Id; 
        cartObj.Status__c = 'Draft'; 
        update cartObj; 
        
        Test.startTest();
        
        Dal_SSC_DeleteCartBatch obj = new Dal_SSC_DeleteCartBatch();
        DataBase.executeBatch(obj);
        
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP,new Dal_SSC_DeleteCartBatch()); 
        Test.stopTest();
        System.assertEquals(1, [select count() from DT_Cart__c where Status__c = 'Draft']);
    }
}