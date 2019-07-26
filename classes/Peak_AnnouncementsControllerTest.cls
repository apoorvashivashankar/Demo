@isTest
public with sharing class Peak_AnnouncementsControllerTest {
    
    @isTest
    public static void testResults() {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            // Create user
            User testUser = Peak_TestUtils.createStandardUser();
            insert testUser;
            // Insert test announcement
            Community_Announcement__c testAnnouncement = new Community_Announcement__c(Start_Date_Time__c = Date.newInstance(1990, 1, 1), End_Date_Time__c = Date.newInstance(2090, 1, 1), Name = 'Test Announcement', Announcement_Body__c = 'This is a test.', Announcement_Type__c = 'info', Announcement_Channel__c = 'Default');
            insert testAnnouncement;
            
            // Test
            System.runAs(testUser){
                System.assertEquals(Peak_AnnouncementsController.getActiveAnnouncements('1', 'Default', 'All', '').results.size(),1);
            }
        }
    }
    
    @isTest
    public static void testNoResults() {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            // Create user
            User testUser = Peak_TestUtils.createStandardUser();
            insert testUser;
            // Test
            System.runAs(testUser){
                System.assertEquals(Peak_AnnouncementsController.getActiveAnnouncements('3', 'Default', 'All', '').results.size(),0);
            }
        }
        
    }
    
    @isTest
    public static void testGetValues(){
        Peak_AnnouncementChannels channels = new Peak_AnnouncementChannels();
        system.assert(channels.getDefaultValue() != null);
        system.assert(channels.getValues() != null);
    }
    
    @isTest
    public static void testGetPrefix() {
        system.assert(Peak_AnnouncementsController.getSitePrefix() != null);
    }
    
    @isTest
    public static void testGetUserId() {
        system.assert(Peak_AnnouncementsController.getUserId() != null);
    }
}