global class CRPendingCount implements Database.Batchable<sobject>
{
public CRPendingcount(){}
global List <Change_Request__c> CRS1;
//crs1 = new List<Change_Request__c>();
global String Query;
global CRPendingCount(String q)
{
Query=q;
}

global Database.QueryLocator start(Database.BatchableContext BC)
{
return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC,List<sobject> scope)
{
List <Change_Request__c> CRS=[select id from change_request__c where Change_Request_Age__c>2 OR Age2__c>2];
system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..'+crs.size());
If(CRS.size()>0){
                //Send an email to the User after your batch completes
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'susan.nortridge@daltile.com'};
mail.setToAddresses(toAddresses);
mail.setSubject('Apex Batch Job is done');
mail.setPlainTextBody('Following are the change requests pending  more than two days. Please click on the link https://cs11.salesforce.com/a1a?fcf=00BZ0000000ZLuj');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}

}

global void finish(Database.BatchableContext BC)
{
}

static testmethod void testm1()
    {
     /*   test.startTest();
        database.executebatch(new CRPendingcount());
        test.stopTest();*/
        CRPendingcount bc = new CRPendingcount();
        bc.query = 'select id from change_request__c where Change_Request_Age__c>2';
        
        Test.startTest();
        Database.executeBatch(bc, 200);
        Test.stopTest();
        
    }


}