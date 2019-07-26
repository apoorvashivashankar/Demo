public with sharing class newPersonAccountExt {


    Account a;
    ApexPages.StandardController controller;
    public newPersonAccountExt(ApexPages.StandardController controller) {
        this.controller = controller;
        a = (Account) Controller.getRecord(); 
    }
    
    public list<SelectOption> getRecordTypes() {
        list<SelectOption> options = new list<SelectOption>();
        for (list<RecordType> rts : [SELECT ID, 
                                            name 
                                    FROM RecordType 
                                    WHERE SObjectType = 'Account' 
                                    AND Name='Person Account'
                                    ORDER BY name]) {
            for (RecordType rt : rts) {
                options.add(new SelectOption(rt.ID, rt.Name));
            } 
        }
        return options;
    }


}