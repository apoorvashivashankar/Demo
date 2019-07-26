/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francoiskorb on 10/10/16.
 */

@isTest
public with sharing class SVNSUMMITS_Ideas_CommonTest {

    @isTest
    static void test_SVNSUMMITS_Ideas_Common() {
        SVNSUMMITS_Ideas_Common common = new SVNSUMMITS_Ideas_Common();

        // custom settings
        System.assertNotEquals(null, common);
        System.assertEquals(null, common.allowDownVoting);
        System.assertEquals(null, common.debugMode);
        System.assertEquals(null, common.portalAccountId);
    }
}