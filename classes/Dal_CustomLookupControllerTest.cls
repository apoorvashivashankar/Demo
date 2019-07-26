/**
 * Created by Preshit on 14-05-2019.
 */
@istest
public class Dal_CustomLookupControllerTest {

    static testMethod void testsearchDB(){
        RecordType rt = [SELECT Id,Name from RecordType Where Name = 'National Account' LIMIT 1];
        
        Account acc = new Account();
        acc.Name = 'test Acc';
        acc.RecordTypeId = rt.Id;
        insert acc;

        test.startTest();
        Dal_CustomLookupController.searchDB('Account','Name','Id',5,'Name','test','National Account');
        test.stopTest();
    }
}