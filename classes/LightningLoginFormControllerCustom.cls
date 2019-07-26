global class LightningLoginFormControllerCustom {

    public LightningLoginFormControllerCustom() {

    }

    @AuraEnabled
    public static String login(String username, String password, String startUrl) {
        try{
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            aura.redirect(lgn);
            return null;
        }
        catch (Exception ex) {
            String exMessage = ex.getMessage();
            
            String newLogErr = 'Your login attempt has failed. Make sure your email address and password are correct.';
            String prevLogErr = 'Your login attempt has failed. Make sure the username and password are correct.';
            
			String prevUNError = 'Enter a value in the User Name field.';
            String newUNError = 'Enter a value in the Email field.';
            
            if(exMessage.equalsIgnoreCase(prevLogErr)) {
                return newLogErr;
            } else if(exMessage.equalsIgnoreCase(prevUNError)) {
				return newUNError;                
            }
             
            return exMessage;
        }
    }

    @AuraEnabled
    public static Boolean getIsUsernamePasswordEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getUsernamePasswordEnabled();
    }

    @AuraEnabled
    public static Boolean getIsSelfRegistrationEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getSelfRegistrationEnabled();
    }

    @AuraEnabled
    public static String getSelfRegistrationUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        if (authConfig.getSelfRegistrationEnabled()) {
            return authConfig.getSelfRegistrationUrl();
        }
        return null;
    }

    @AuraEnabled
    public static String getForgotPasswordUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        System.debug('authConfig: '+ authConfig);
        return authConfig.getForgotPasswordUrl();
    }

    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
    }
/*
    @AuraEnabled
    global static String setExperienceId(String expId) {
        // Return null if there is no error, else it will return the error message
        try {
            if (expId != null) {
                Site.setExperienceId(expId);
            }
            return null;
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }
*/
}