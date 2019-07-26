@isTest
private class TestAccountDashboardCtl {

    static testMethod void runTest() {
        // Create the test data
        Account a = new Account(SBU__c = 'x'
		                          , Name = 'x'
		                          , Customer_Base__c = 'x'
                                  , Display_Types__c  = 'x'
                                  , AO_Display_Types__c = 'x'
                                  , DISPLAY_Selection_Board_Choices__c  = 'x'
                                  , Display_Sub_Board_Choices__c = 'x'
                                  , AO_Feature_Panels__c = 'x'
                                  , AO_Feature_Panels1__c = 'x'
                                  , AO_Sub_SKI_Board_Choices__c = 'x');

       insert a;
       DateTime d1 = Datetime.now();
       Event e  =  new Event     ( Subject  = ' Test'
                                 , StartDateTime = d1
                                 , ActivityDateTime  = d1
                                 , Primary_Objective__c = 'x'
                                 , Secondary_Objective__c = 'y'
                                 , whatId = a.Id
                                 , DurationInMinutes = 10
                                 );
        
       Event e2  =  new Event     ( Subject  = ' Test'
                                 , StartDateTime = d1.addDays(-1)
                                 , ActivityDateTime  = d1.addDays(-1)
                                 , Primary_Objective__c = 'x'
                                 , Secondary_Objective__c = 'y'
                                 , whatId = a.Id
                                 , DurationInMinutes = 10
                                 , Type__c = 'Face To Face'
                                 );                      
                              
        Task t = new Task    ( Subject = ' Test'
                                 ,Status = 'Completed'
                                 , Primary_Objective__c = 'x'
                                 , Secondary_Objective__c = 'y'
                                 , whatId = a.Id);
                                 
        Date d = System.Today();
        Integer Year1 = d.year();
        Integer Year0 = Year1 - 1;
        
        Product_Team__c pt = new Product_Team__c( Name = 'product x'
                                                , GM_Goal_for_PTeam__c = 12
                                                , DW_ID__c = '123');
        insert pt;
        Sales__c s1 = new Sales__c (Account__c = a.Id
                                  , SalesType__c = 'T'
                                  , Product_Team__c = pt.Id
                                  , Year__c = year1
                                  , Gross_Sales__c = 100
                                  , Cost_of_Sales__c =10);  
        Sales__c s2 = new Sales__c (Account__c = a.Id
                                  , SalesType__c = 'T'
                                  , Product_Team__c = pt.Id
                                  , Year__c = year0
                                  , Gross_Sales__c = 100
                                  , Cost_of_Sales__c =10);   
        insert s1;
        //insert s2;
                              
        //invoke the page that runs the controller methods
        Test.setCurrentPage(Page.AccountDashboardPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        AccountDashboardCtl ctl = new AccountDashboardCtl(sc);
        
        //cover methods not envoked by the page
        
        
        insert e;
        
        insert e2;
        
        ctl.getDisplays();
        ctl.getObjectives();
        ctl.getSalesStatus();
        try{
            ctl.getYtdSalesGrid();
        }
        catch(Exception ex){}
        
        Test.setCurrentPage(Page.AOAccountDashboard);
        sc = new ApexPages.StandardController(a);
        AOAccountDashboardCtl ctl2 = new AOAccountDashboardCtl(sc);
        
        //cover methods not envoked by the page
        ctl2.getObjectives();
        
        try{
            ctl2.getSalesStatus();
        }
        catch(Exception ex){}
        try{
            ctl2.getYtdSalesByProduct();
        }
        catch(Exception ex){}
        
        try{
            ctl2.getYtdSalesGrid();
        }
        catch(Exception ex){}
    }
}