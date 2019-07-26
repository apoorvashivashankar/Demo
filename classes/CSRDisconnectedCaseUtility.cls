public without sharing class CSRDisconnectedCaseUtility {


    @AuraEnabled
    public static Case createCase(Case newCase) {
        try {        
            String objectName = 'Case';
            String strRecordTypeName = 'CSR Disconnected Call';
            ID caseDisconnectedRecordTypeId;
            caseDisconnectedRecordTypeId = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
            newCase.RecordTypeId = caseDisconnectedRecordTypeId;
            insert newCase;
            System.debug('::::CSRDisconnectedCaseUtility + createCase +  newCase:...' + newCase);  
            return newCase;
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Sorry! Something went wrong: '+ e.getMessage());    
        }
    }
}