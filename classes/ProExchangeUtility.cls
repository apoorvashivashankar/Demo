public without sharing class ProExchangeUtility {

    @AuraEnabled
    public static Account getAccountByCustomerNumber(String customerNumber){
        String varCleanCustomerNumber = customerNumber.replaceAll('[^a-zA-Z0-9]', '') ;
        List<Account> account = Database.query('SELECT Id, Name, DW_ID__c FROM Account WHERE DW_ID__c=:varCleanCustomerNumber');
		system.debug('ProExchangeUtility + getAccountByCustomerNumber + customerNumber: ' + customerNumber);
		system.debug('ProExchangeUtility + getAccountByCustomerNumber + account: ' + account);
        if(!Peak_Utils.isNullOrEmpty(account)){
            try {
                return account[0];    
            }
            catch (Exception e) {
                // "Convert" the exception into an AuraHandledException
                throw new AuraHandledException('Sorry! Something went wrong: '
                    + e.getMessage());    
            }
            finally {
                // Something executed whether there was an error or not
            }        
        } else {
	        System.debug('::::ProExchangeUtility + getAccountByCustomerNumber +  that account does not exist');      
            throw new AuraHandledException('We could not find an account that matched that number.  Please check your latest sales slip, or ask your account representative.  If you do not have an account select the No Account Number checkbox.');
        }
    }
    
    @AuraEnabled
    public static Case createCase(Case newCase){
        
        System.debug('::::ProExchangeUtility + createCase +  newCase.AccountId:...' + newCase.AccountId); 
        System.debug('::::ProExchangeUtility + createCase +  newCase.AccountNumber__c:...' + newCase.AccountNumber__c); 
        
        if (newCase.AccountId == null && newCase.AccountNumber__c != '' && newCase.AccountNumber__c != null) {
            Account caseAccount = getAccountByCustomerNumber(newCase.AccountNumber__c);
            newCase.AccountId = caseAccount.Id;
            newCase.Origin = 'Web User Request';
        } else {
            newCase.Origin = 'Web Customer Request';
        }
        
        try {        
            System.debug('::::ProExchangeUtility + createCase +  newCase:...' + newCase);  
            upsert newCase;
            System.debug('::::ProExchangeUtility + createCase +  newCase:...' + newCase);  
            return newCase;
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Sorry! Something went wrong: '+ e.getMessage());    
        }

    }
    
    @AuraEnabled
    public static Id getCaseRecordTypeID() {
        String objectName = 'Case';
        String strRecordTypeName = 'ProExchange';
        ID caseProExchangeRecordTypeId;
        caseProExchangeRecordTypeId = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByName().get(strRecordTypeName).getRecordTypeId();
        System.debug('::::ProExchangeUtility + getCaseRecordTypeID +  caseProExchangeRecordTypeId:...' + caseProExchangeRecordTypeId);  
        return  caseProExchangeRecordTypeId;
    }
    
    @AuraEnabled
    public static List<String> getCountries() {
        System.debug('::::ProExchangeUtility + getCountries');  
		List<Country__c> listCountries = new List<Country__c>();
        List<String> listCountryNames = new List<String>();
        listCountries = [ SELECT Name FROM Country__c ORDER BY Sort_Order__c Asc NULLS LAST, NAme];
        for (Country__c c:listCountries) {
            listCountryNames.add(c.Name);
        }
        System.debug('::::ProExchangeUtility + getCountries +  listCountryNames:...' + listCountryNames);  
        return listCountryNames;
    }    
    
    @AuraEnabled
    public static List<String> getStates(String country) {
		List<State__c> listStates = new List<State__c>();
        List<String> listStateNames = new List<String>();
        listStates = [ SELECT Name FROM State__c WHERE Country__r.Code__c = :country ORDER BY Name Asc];
        for (State__c c:listStates) {
            listStateNames.add(c.Name);
        } 
        return listStateNames;
    }   

   @AuraEnabled 
    public static user fetchUser(){
    // query current user information  
    User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled, ContactId FROM User Where id =: userInfo.getUserId()];
    System.debug('::::ProExchangeUtility + oUser:...' + oUser);
    return oUser;
    }


}