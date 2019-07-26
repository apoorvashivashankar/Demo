/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */
@isTest
public class Peak_WelcomeMessageControllerTest {

    @isTest
    public static void testGetCurrentUser() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        User user = Peak_TestUtils.createStandardUser();

        insert user;

        system.runAs(user) {
            system.assertEquals(user.Id, Peak_WelcomeMessageController.getCurrentUser().Id);
        }
        }
    }

    @isTest
    public static void testGetAccountInfo() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        User user = Peak_TestUtils.createStandardUser();

        insert user;

        system.runAs(user) {
            system.assertEquals(user.Id, Peak_WelcomeMessageController.getAccountInfo().user.Id);
        }
    }
    }

}