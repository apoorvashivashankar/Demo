global class BatchUpdateSalesRegionField implements Database.Batchable < SObject > {
	boolean isTest = False;
	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([Select Id, SSC__c from Sales__c where Region__c = null]);
    }
    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        List < Sales__c > sales = (List < Sales__c > ) scope;
        set < String > ids = new set < String > ();
        for (Sales__c s: sales) {
            ids.add(s.SSC__c);
        }
        if (isTest) {
            SSC__c[] sscs = [Select s.Sales__c, s.Region__r.Name, s.DW_ID__c From SSC__c s where DW_ID__c in : ids and Region__c != null limit 50];
            system.debug('this must be a test, should only return 50 records');
            Map < String, SSC__c > sscmap = new Map < String, SSC__c > ();
            for (SSC__c s: sscs) {
                sscmap.put(s.DW_ID__c, s);
            }
            for (Sales__c s: sales) {
                if (s.SSC__c != null && s.SSC__c != '' && sscmap.containskey(s.SSC__c)) {
                    s.Region__c = sscmap.get(s.SSC__c).Region__r.Name;
                }
            }
            if (sales.size() > 0) {
                update sales;
            }
        } ELSE {
            SSC__c[] sscs = [Select s.Sales__c, s.Region__r.Name, s.DW_ID__c From SSC__c s where DW_ID__c in : ids and Region__c != null];
            Map < String, SSC__c > sscmap = new Map < String, SSC__c > ();
            for (SSC__c s: sscs) {
                sscmap.put(s.DW_ID__c, s);
            }
            for (Sales__c s: sales) {
                if (s.SSC__c != null && s.SSC__c != '' && sscmap.containskey(s.SSC__c)) {
                    s.Region__c = sscmap.get(s.SSC__c).Region__r.Name;
                }
            }
            if (sales.size() > 0) {
                update sales;
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
        ScheduleBatchUpdateSalesRegionField s = new ScheduleBatchUpdateSalesRegionField();
    }
    static TestMethod void test() {
        Test.startTest();
        BatchUpdateSalesRegionField ben = new BatchUpdateSalesRegionField();
        ben.isTest = true;
        //ben.start(null);
        ben.execute(null, [Select Id, SSC__c from Sales__c limit 1]);
        ben.finish(null);
        dataBase.executeBatch(ben);
        Test.stopTest();
    }
}