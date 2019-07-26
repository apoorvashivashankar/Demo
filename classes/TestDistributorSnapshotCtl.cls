@isTest
private class TestDistributorSnapshotCtl {
    
    @testSetup static void testSetup() {
     	//create some test data
     	Account a = new Account(SBU__c = 'x'
		                          , Name = 'Sales Test Account'
		                          , Customer_Base__c = 'x'
                                  , Display_Types__c  = 'x'
                                  , AO_Display_Types__c = 'x'
                                  , DISPLAY_Selection_Board_Choices__c  = 'x'
                                  , Display_Sub_Board_Choices__c = 'x'
                                  , AO_Feature_Panels__c = 'x'
                                  , AO_Feature_Panels1__c = 'x'
                                  , GroupKey__c = '123'
                                  , Division__c = '1'
                                  , AO_Sub_SKI_Board_Choices__c = 'x');

        insert a;
         
         
     	Account a2 = new Account(SBU__c = 'x'
		                          , Name = 'No Sales Test Account'
		                          , Customer_Base__c = 'xx'
                                  , Display_Types__c  = 'x'
                                  , AO_Display_Types__c = 'x'
                                  , DISPLAY_Selection_Board_Choices__c  = 'x'
                                  , Display_Sub_Board_Choices__c = 'x'
                                  , AO_Feature_Panels__c = 'x'
                                  , AO_Feature_Panels1__c = 'x'
                                  , GroupKey__c = '1213'
                                  , Division__c = '11'
                                  , AO_Sub_SKI_Board_Choices__c = 'x');
 
        insert a2;

        List <Product_Team__c> listProductTeam = new List <Product_Team__c> ();
        
        Product_Team__c pt1 = new Product_Team__c( Name = 'GLAZED FLOOR TILE'
                                                , GM_Goal_for_PTeam__c = 12
                                                , DW_ID__c = '123');
        insert pt1;
        listProductTeam.add(pt1);
         
        Product_Team__c pt2 = new Product_Team__c( Name = 'COLORBODY PORCELAIN'
                                                , GM_Goal_for_PTeam__c = 12
                                                , DW_ID__c = '1234');
        insert pt2;
        listProductTeam.add(pt2);
        Product_Team__c pt3 = new Product_Team__c( Name = 'PLAN'
                                                , DW_ID__c = 'PLAN');
        insert pt3;
        listProductTeam.add(pt3);
        
        List <Product_Line__c> listProductLine = new List <Product_Line__c> ();
        Product_Line__c pl1 = new Product_Line__c  ( Name = 'pl x'
                                                  ,ProductTeam__c = pt1.id
                                                  ,New_Product__c 	= TRUE);
        insert pl1;
        listProductLine.add(pl1);
        Product_Line__c pl2 = new Product_Line__c  ( Name = 'pl xx'
                                                  ,ProductTeam__c = pt2.id
                                                  ,New_Product__c 	= TRUE);
        insert pl2;
        listProductLine.add(pl2);
        Product_Line__c pl3 = new Product_Line__c  ( Name = 'plan'
                                                  ,ProductTeam__c = pt3.id);
        insert pl3;
        listProductLine.add(pl3);
        
        
        
	   datetime myDate =System.now();
         
		Date varToday = System.Today();
		String varThisYear = String.valueOf(varToday.year());
		String varLastYear = String.valueOf(varToday.year() - 1);
		String varTwoYearsAgo = String.valueOf(varToday.year() - 2);
		List <Sales__c> listSales = new List <Sales__c> ();
		List <AggregateResult> listSalesCheck = new List <AggregateResult> ();
		List <String> listYears = new List <String> ();
		listYears.add(varThisYear);
		listYears.add(varLastYear);
		listYears.add(varTwoYearsAgo);
		
        for(Integer i=0;i<24;i++) {
			for(String y:listYears) {
			    for (Product_Team__c pt : listProductTeam) {
			        for (Product_Line__c pl : listProductLine) {
        				String varMonth = String.valueOf(varToday.month() - i);
        				if (Integer.valueOf(varMonth) > -1) {
            				if (Integer.valueOf(varMonth) < 10) {
            				    varMonth = '0' + varMonth;
            				}
            				System.debug('::::testSetup + year ::::> ' + y);
            				System.debug('::::testSetup + varMonth ::::> ' + varMonth);
            				System.debug('::::testSetup + pt ::::> ' + pt);
            				System.debug('::::testSetup + pl ::::> ' + pl);
            				Date varSalesDate = date.newInstance(Integer.valueOf(y), Integer.valueOf(varMonth), 15);
            				// Date varSalesDate = date.parse(y + '-' + varMonth + '-15');
            				Sales__c s = new Sales__c (Account__c = a.Id
            										  , GroupKey__c = '123'
            										  , SalesType__c = 'T'
            										  , SF_Sold__c = 1000
            										  , Product_Line__c = pl.Id
            										  , Product_Team__c = pt.Id
            										  , Gross_Sales__c = 10 + i
            										  , Net_Commisionable__c = 10 + i
            										  , Cost_of_Sales__c = 2
            										  , Year__c = decimal.valueOf(y)
            										  , Period_text__c = '1'
            										  , Sales_Date__c = varSalesDate);  
            				listSales.add(s);
    			        }
			        }
			    }
			}
        }
		
        try {
			insert listSales;
		} catch (Exception e) {
			System.debug('::::issue creating Sales records::::> ' + e.getMessage());
        }  

        listSalesCheck = [
            SELECT s.Product_Team__r.Name ptName
				,s.Product_Line__r.Name plName
				,SUM(SF_Sold__c) qtSold
				,Period_text__c periodMonth
				,calendar_month(Sales_Date__c) month
				,calendar_year(Sales_Date__c) year
				,SUM(Net_Sales__c) netSales
			FROM Sales__c s
			GROUP BY 
				calendar_month(Sales_Date__c) 
				,calendar_year(Sales_Date__c) 
				,Period_text__c 
				,s.Product_Team__r.Name 
				,s.Product_Line__r.Name 
			ORDER BY calendar_year(Sales_Date__c), SUM(SF_Sold__c) DESC
		];
			
		System.debug('listSalesCheck...:' + JSON.serialize(listSalesCheck));

    }
    
    @isTest
    public static void testDistributorSnapshot() {     
	   
        Account a = [SELECT ID, GroupKey__c, DW_ID__c FROM ACCOUNT WHERE Name = 'Sales Test Account'];
    
        //invoke the page that runs the controller methods
        Test.setCurrentPage(Page.DistributerDashboard);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        DistributorSnapshotCtl ctl = new DistributorSnapshotCtl(sc);
        
        //cover methods not envoked by the page
        ctl.getYtdSalesGrid();
        ctl.getTopFiveGlazeFloor();
        ctl.getTopFivePorcelainTile();
        ctl.getCumulativeSales();
        ctl.getNewProductPurchases();
        ctl.getTwoDecimal(1.1);     
        ctl.updateSales();
        ctl.getSalesByProductPie();
        
    
        for(Integer i=0;i<12;i++) {        
            ctl.getMonthName(i);
        }
        
    }
     
     
    @isTest
    public static void testDistributorSnapshotAccountNoSales() {     
	   
        Account a = [SELECT ID, GroupKey__c, DW_ID__c FROM ACCOUNT WHERE Name = 'No Sales Test Account'];

       //invoke the page that runs the controller methods
        Test.setCurrentPage(Page.DistributerDashboard);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        DistributorSnapshotCtl ctl = new DistributorSnapshotCtl(sc);
        
        //cover methods not envoked by the page
        ctl.getYtdSalesGrid();
        ctl.getTopFiveGlazeFloor();
        ctl.getTopFivePorcelainTile();
        ctl.getCumulativeSales();
        ctl.getNewProductPurchases();
        ctl.getTwoDecimal(null);     
        
     }    
    
}