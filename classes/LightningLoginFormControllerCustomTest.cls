@IsTest(SeeAllData = true)
public class LightningLoginFormControllerCustomTest {
    @IsTest
    static void testLoginWithInvalidCredentials() {
        System.assertEquals('Argument 1 cannot be null', LightningLoginFormControllerCustom.login('testUser', 'fakepwd', null));
    }
    
    @IsTest
    static void LightningLoginFormControllerInstantiation() {
        LightningLoginFormControllerCustom controller = new LightningLoginFormControllerCustom();
        System.assertNotEquals(controller, null);
    }
    
    @IsTest
    static void testIsUsernamePasswordEnabled() {
        System.assertEquals(true, LightningLoginFormControllerCustom.getIsUsernamePasswordEnabled());
    }
    
    @IsTest
    static void testIsSelfRegistrationEnabled() {
        System.assertEquals(false, LightningLoginFormControllerCustom.getIsSelfRegistrationEnabled());
    }
    
    @IsTest
    static void testGetSelfRegistrationURL() {
        System.assertEquals(null, LightningLoginFormControllerCustom.getSelfRegistrationUrl());
    }
    /*
    @IsTest
    static void testGetForgotPasswordUrl() {
       	String forgotPasswordUrl = LightningLoginFormControllerCustom.getForgotPasswordUrl();
        System.debug('Test ForgotPassword: '+ forgotPasswordUrl);
        System.assertEquals(forgotPasswordUrl.contains('/ForgotPassword'),true);
    }
    */
    @IsTest
    static void testAuthConfig() {
        Auth.AuthConfiguration authConfig = LightningLoginFormControllerCustom.getAuthConfig();
        System.assertNotEquals(null, authConfig);
    }
}