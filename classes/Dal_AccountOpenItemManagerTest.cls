/**
* Created by 7Summits on 3/7/18
*/
@isTest(SeeAllData=false)
public class Dal_AccountOpenItemManagerTest{
    
    @testSetup
    static void testsetup(){
        Account account = Dal_TestUtils.createTestAccount();
        account.DW_ID__c = '008082001';
        update account;
    }
    
    static testmethod void opeItem1() {  
        
        Account account = [SELECT Id,Name,DW_ID__c FROM Account];
        
        DT_SYS_Open_Item__x dtsys = new DT_SYS_Open_Item__x(
            TransactionType__c ='RV',ReasonCode__c ='1234',AgingCode__c = 'C'
        );
        Integer listLimit = 100;
        Dal_AccountOpenItemManager.mockallOpenItemsList.add(dtsys);
        test.startTest();
        Dal_AccountOpenItemManager cont = new Dal_AccountOpenItemManager(account);   
        Dal_AccountOpenItemManager.getAllOpenItems(account, listLimit);
        Dal_AccountOpenItemManager.getCurrentOpenItems(account, listLimit);
        Dal_AccountOpenItemManager.getPastOpenItems(account, listLimit);
        Dal_AccountOpenItemManager.getReturnsAndCreditsOpenItems(account, listLimit);
        /*List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accManager = Dal_AccountOpenItemManager.getAllOpenItems(account);
        System.assert(true, accManager);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accCurrItem = Dal_AccountOpenItemManager.getCurrentOpenItems(account);
        System.assert(true, accCurrItem);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accPassItem = Dal_AccountOpenItemManager.getPastOpenItems(account);
        System.assert(true, accPassItem);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn = Dal_AccountOpenItemManager.getReturnsAndCreditsOpenItems(account);  
        System.assert(true, accReturn);      */
        test.stopTest();
    }
    static testmethod void opeItem2() {  
        Account account1 = [SELECT Id,Name,DW_ID__c FROM Account];
        
        Account account = new Account();
        account.Name = 'ABC';
        account.DW_ID__c = '000002001';
        account.Division__c = '21';
        insert account;
        
        Integer listLimit = 100; 
        
        DT_SYS_Open_Item__x dtsys = new DT_SYS_Open_Item__x(
            TransactionType__c ='Z2',ReasonCode__c ='1234',AgingCode__c = 'D'
        );
        Dal_AccountOpenItemManager.mockallOpenItemsList.add(dtsys);
        
        test.startTest();
        Dal_AccountOpenItemManager cont = new Dal_AccountOpenItemManager(account); 
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accManager = Dal_AccountOpenItemManager.getAllOpenItems(account1, listLimit);
        System.assert(true, accManager);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accCurrItem = Dal_AccountOpenItemManager.getCurrentOpenItems(account1, listLimit);
        System.assert(true, accCurrItem);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accPassItem = Dal_AccountOpenItemManager.getPastOpenItems(account1, listLimit);
        System.assert(true, accPassItem);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn = Dal_AccountOpenItemManager.getReturnsAndCreditsOpenItems(account1, listLimit);
        System.assert(true, accReturn);       
		List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn1 = Dal_AccountOpenItemManager.queryOpenAccount('test123', '', '12345', '2019-1-23', '2019-1-25', '', 'Past Due', 10);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn2 = Dal_AccountOpenItemManager.queryOpenAccount('test123', '', '12345', '2019-1-23', '2019-1-25', '', 'Current Due', 10);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn3 = Dal_AccountOpenItemManager.queryOpenAccount('test123', '', '12345', '2019-1-23', '2019-1-25', '', 'Credits', 10);
        List<Dal_AccountOpenItemManager.Dal_AccountOpenItemWrapper> accReturn4 = Dal_AccountOpenItemManager.queryOpenAccount('test123', '', '12345', '2019-1-23', '2019-1-25', '', 'Total Due', 10);
            //Dal_AccountOpenItemManager.queryOpenAccount('test123','','','DalTile Sales SBU','2019-1-23','2019-1-25','Past Due',10);
        
        test.stopTest();
    }
}