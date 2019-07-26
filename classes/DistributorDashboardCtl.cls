public with sharing class DistributorDashboardCtl {

     public Account account;
     public Integer reportYear = Integer.ValueOf(DistributorDashboardSettings__c.getInstance().Run_Year__c 
     											 == null ? System.today().year() : DistributorDashboardSettings__c.getInstance().Run_Year__c);
     public class ytd_sales_to_goal
     {
     	public Decimal minValue{get;set;}
     	public Decimal breakPoint1{get;set;}
     	public Decimal breakPoint2{get;set;}
     	public Decimal maxValue{get;set;}
     	public Decimal actualValue{get;set;} 
     }
     
     public DistributorDashboardCtl(ApexPages.StandardController ctl)
     {
     	for(Account a : [Select Id, Name, Customer_Base__c from Account where Id = :ctl.getId()])
     	{
     		account = a;
     	}
     }
     
     public ytd_sales_to_goal getYtdSalesToGoal()
     {
     	/*
     	 	•	Report Type: Accounts with Sales
			•	Sales Date = Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Sum: Net Sales
			Special Note: Gauge image should automatically fill in the Minimum, Breakpoint 1, Breakpoint 2, Maximum  
			•	Minimum = 0
			•	Breakpoint 1 = the sum  of Sales.Plan_Number__c * 1/3
			•	Breakpoint2 = the sum  of Sales.Plan_Number__c * 2/3
			•	Maximum = the sum  of Sales.Plan_Number__c
     	 
     	 */
     	ytd_sales_to_goal ysg = new ytd_sales_to_goal();
     	ysg.minValue = 0;
     	ysg.actualValue  = 0;
     	ysg.maxValue = 0;
     	ysg.breakPoint1 = 0;
     	ysg.breakPoint2 = 0;
     	
     	for(AggregateResult ar : [Select sum(Net_Sales__c) sales
     	                            from Sales__c 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             //and Plan_Number__c != null
     	                             and Year__c = :reportYear])
     	{
     		ysg.actualValue  = Double.ValueOf(ar.get('sales'));
     	}
     	
     	for(AggregateResult ar : [Select sum(Plan_Number__c) sales
     	                            from Sales__c 
     	                           where (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             and Year__c = :reportYear])
     	{
     		ysg.maxValue = Double.ValueOf(ar.get('sales'))== null ? 0 : Double.ValueOf(ar.get('sales'));
     		ysg.breakPoint1 = ysg.maxValue.divide(3,2);
     		ysg.breakPoint2 = ysg.maxValue.divide(3,2) + ysg.maxValue.divide(3,2);
     	}
     	return ysg;
     }
     
     public class YtdSalesPlanRec
     {
     	public Double Net_Sales{get;set;} 
     	public Double Plan_Nbrs{get;set;} 
     	public Double Difference{get;set;} 
     	public Integer Month{get;set;}
     	public String DateDisplay{get;set;}
     }
     public string getYtdSalesPlanByPeriod()
     {
     	/*
     	 	•	Report Type: Accounts with Sales
			•	Sales Date = Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Sum: Net Sales
			•	Sum: Plan Numbers
			•	Group by: Period Month
     	 
     	  ====================================
	   	   Retur the Chart data in JSON format
	   	  ====================================*/
     	string dataHeader = '[["Context","Net Sales","Plan Nbrs"]\n';
     	string dataRow = '';
     	map<Integer,YtdSalesPlanRec> data = new map<Integer,YtdSalesPlanRec>();
     	
     	for(AggregateResult ar : [Select Period_text__c, sum(Net_Sales__c) net,  sum(Plan_Number__c) plan
     	                            from Sales__c 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                            // and Plan_Number__c != null
     	                             and Year__c = :reportYear
     	                           group by Period_text__c])
     	{
     		Integer recMonth = Integer.ValueOf((String)ar.get('Period_text__c'));
     		if(data.containsKey(recMonth))
     		{
     			YtdSalesPlanRec rec = data.get(recMonth);
     			rec.Net_Sales += Double.ValueOf(ar.get('net')) == null ? 0 :Double.ValueOf(ar.get('net'));
     			rec.Plan_Nbrs += Double.ValueOf(ar.get('plan')) == null ? 0 :Double.ValueOf(ar.get('plan'));
     			rec.Month = recMonth;
     		}
     		else
     		{
     			YtdSalesPlanRec rec = new YtdSalesPlanRec();
     			rec.Net_Sales = Double.ValueOf(ar.get('net')) == null ? 0 :Double.ValueOf(ar.get('net'));
     			rec.Plan_Nbrs = Double.ValueOf(ar.get('plan')) == null ? 0 :Double.ValueOf(ar.get('plan'));
     			rec.Month = recMonth;
     			data.put(recMonth,rec);
     		}
     	}
     	
     	for(YtdSalesPlanRec rec : data.values())
     	{
     	//dataHeader += ',"'+ar.get('Period_Month__c')+'"';
     		dataRow += ',["'+rec.Month+'",'+rec.Net_Sales+','+rec.Plan_Nbrs+']\n';
     	}	
     	
        dataRow+= ']';
        
        return dataHeader + dataRow;
     	
     }
     
     public list<YtdSalesPlanRec> getSalesVsPlanNumbers()
     {
     	/*
     	 	•	Report Type: Accounts with Sales
			•	Sales Date = Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Sum: Net Sales
			•	Sum: Plan Number
			•	Formula: Difference = Net Sales – Plan Number
			•	Group By: Calendar Quarter
         */
     	 
     	list<YtdSalesPlanRec> data = new list<YtdSalesPlanRec>();
     	
     	for(AggregateResult ar : [Select FISCAL_QUARTER(Sales_Date__c) q, sum(s.Net_Sales__c) s, sum(s.Plan_Number__c) plan
     	                            From Sales__c s 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             and Year__c = :reportYear
     	                          group by FISCAL_QUARTER(Sales_Date__c)])
     	{
     		
     		YtdSalesPlanRec rec = new YtdSalesPlanRec();
     		rec.Net_Sales = Double.ValueOf(ar.get('s')) == null ? 0 :Double.ValueOf(ar.get('s'));
     		rec.Plan_Nbrs = Double.ValueOf(ar.get('plan')) == null ? 0 :Double.ValueOf(ar.get('plan'));
     		rec.Difference = rec.Net_Sales - rec.Plan_Nbrs;
     		rec.DateDisplay = 'Q'+String.ValueOf(ar.get('q'))+ ' CY' +System.today().year();
     		data.add(rec);
     	}
     	
     	
        
        return data;
     	
     }
     
     public class ProductSalesRec
     {
     	public Double Net_Sales{get;set;} 
     	public String Product_Name{get;set;}
     }
     public list<ProductSalesRec> getDisplaySampleBoardSales()
     {
     	/*
     	   	•	Report Type: Accounts with Sales
			•	Sales Date = Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Product != charges,freight,recovery,energy surcharge
			•	Sum: Net Sales
			•	Group By: Product
			•	Sort Value Descending
     	*/
     	list<ProductSalesRec> data = new list<ProductSalesRec>();
     	
     	for(AggregateResult ar : [Select s.Product__r.Name, sum(s.Net_Sales__c) s
     	                            From Sales__c s 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c != 'T'
     	                             and Year__c = :reportYear
     	                             and (NOT(s.Product__r.Name in ('charges','freight recovery','energy surcharge')))
     	                          group by s.Product__r.Name])
     	{
     		
     		ProductSalesRec rec = new ProductSalesRec();
     		rec.Net_Sales = Double.ValueOf(ar.get('s')) == null ? 0 :Double.ValueOf(ar.get('s'));
     		rec.Product_Name = String.ValueOf(ar.get('Name'));
     		data.add(rec);
     	}
     	
        return data;
     }
     
     public class PcntOfSalesRec
     {
     	public Double Net_Sales{get;set;}
     	public String Sales_Type{get;set;}
     	public Double Pcnt_Of_Total{get;set;}
     }
     public list<PcntOfSalesRec> getPcntOfTotalSales() 
     {
     	/**
     	 	•	Report Type: Accounts with Sales
			•	Sales Date = Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Product != charges,freight,recovery,energy surcharge
			•	Sum: Net Sales
			•	Formula: % of Total = Net Sales by Type / Net Sales
			•	Group By: Net Sales
     	 */
     	 
     	list<PcntOfSalesRec> data = new list<PcntOfSalesRec>();
     	Double total = 0;
     	
     	for(AggregateResult ar : [Select sum(s.Net_Sales__c) s
     	                            From Sales__c s 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and Year__c = :reportYear
     	                             and (NOT(s.Product__r.Name in ('charges','freight recovery','energy surcharge')))
     	                             ])
     	{
     		total =  Double.ValueOf(ar.get('s')) == null ? 1 :Double.ValueOf(ar.get('s'));
     	}
     	
     	for(AggregateResult ar : [Select SalesType__c, sum(s.Net_Sales__c) s
     	                            From Sales__c s 
     	                           where  (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and Year__c = :reportYear
     	                             and (NOT(s.Product__r.Name in ('charges','freight recovery','energy surcharge')))
     	                          group by s.SalesType__c])
     	{
     		
     		PcntOfSalesRec rec = new PcntOfSalesRec();
     		rec.Net_Sales = Double.ValueOf(ar.get('s')) == null ? 0 :Double.ValueOf(ar.get('s'));
     		rec.Sales_Type = String.ValueOf(ar.get('SalesType__c'));
     		decimal x = rec.Net_Sales;
     		if(total > 0)
     			rec.Pcnt_Of_Total = x.divide(total, 2);
     			
     		data.add(rec);
     	}
     	
     	return data;
     }
     
     public String getSalesByYearByPeriod()
     {
     	/*
     	  	•	Report Type:  Accounts with Sales
			•	Sales Date: Current and Previous 2 Calendar Years
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Group by: Period Month and Year
			•	Sum: Net Sales
     	 */
     	 
     	/*====================================
	   	   Retur the Chart data in JSON format
	   	  ====================================*/
     	string dataHeader = '[["Context"';
     	string dataRow = '';
     	
     	map<Integer,map<Integer,Double>> data = new map<Integer,map<Integer,Double>>();
     	set<Integer> yearSet = new set<Integer>();
     	for(AggregateResult ar : [Select Period_text__c month, CALENDAR_YEAR(Sales_Date__c) year, sum(Net_Sales__c) net
     	                            from Sales__c 
     	                           where  (Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                            // and Plan_Number__c != null
     	                             and CALENDAR_YEAR(Sales_Date__c) >=:(reportYear-2)
     	                             and CALENDAR_YEAR(Sales_Date__c) <=:reportYear
     	                           group by Period_text__c, CALENDAR_YEAR(Sales_Date__c)
     	                           order by Period_text__c, CALENDAR_YEAR(Sales_Date__c)])
     	{
     		Integer recMonth = Integer.ValueOf((String)ar.get('month'));
     		Double net = (Double)ar.get('net');
     		Integer year = (Integer)ar.get('year');
     		yearSet.add(year);
     		if(data.containsKey(recMonth))
     		{
     			map<Integer,Double> rec = data.get(recMonth);
     			
     			if(rec.containsKey(year))
     			{
     			  Double x = rec.get(year);
     			  x +=net;
     			  rec.put(year,x);
     			}
     			else
     				 rec.put(year,net);
     			
     		}
     		else
     		{
     			map<Integer,Double> rec = new map<Integer,Double>();
     			rec.put(year,net);	
     			data.put(recMonth, rec); 
     		}
     	}
     	
     	for(Integer y : yearSet)
     	{
     		dataHeader += ',"'+y+'"';
     	}
     	dataHeader += ']';
     	for(Integer mon : data.keyset())
     	{
     	    
     	    map<Integer, Double> years = data.get(mon);
     	    dataRow += ',["' +mon+'"';
     	    for(Integer yr : yearSet)
     	    {
     			dataRow += ','+ (years.get(yr) == null ? 0 : years.get(yr));
     	    }
     	    dataRow +=']\n';
     	}
     	
        dataRow+= ']';
        
        return dataHeader + dataRow;
     	
     	 
     }
     
     public String getYtdSalesByTeam()
     {
     	/*
     		•	Report Type:  Accounts with Sales
			•	Sales Date: Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Prod Team Name != unknown, samples and miscell
			•	Group by: Product Team Name
			•	Sum: Net Sales
     	 */
     	 
     	 String data = '[["Product Team", "Net Sales"]';
     	 for(AggregateResult ar : [Select Product_Team__r.Name, sum(Net_Sales__c) net
     	                            from Sales__c 
     	                           where (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                            // and Plan_Number__c != null
     	                             and Year__c >=:reportYear
     	                           group by Product_Team__r.Name])
     	{
     		data += ',["'+(String)ar.get('name')+'",'+(Double)ar.get('net')+']';
     	     
     	}
     	
     	return data+']';
     }
     
     public class YTDSales
     {
     	public Double Prior_YTD_Sales{get;set;}
     	public Double YTD_Period_Sales{get;set;}
     	public String Short_Name{get;set;}
     }
     
     public list<YTDSales> getFullPeriodSales()
     {
     	/*
     	    •	Report Type:  Accounts
			•	Customer Base = {Account.Customer_Base__c}
			•	Group by: ShortName
			•	Sum: Account.Prior_YTD_Sales__c
			•	Sum: Account.YTD_Period_Sales__c
     	   
     	 */
     	list<YTDSales> data = new list<YTDSales>();
        //Can't group by Short Name so we need t map
 	    map<String, YTDSales> salesMap = new map<String, YTDSales>();
 	    
     	for(Account a : [Select Short_Name__c, Prior_YTD_Sales__c, YTD_Period_Sales__c
 	                      from Account 
 	                     where Customer_Base__c = :account.Customer_Base__c
 	                       and Customer_Base__c != null
 	                       and Short_Name__c != null])
 	    {
 	    	if(salesMap.containsKey(a.Short_Name__c))
 	    	{
	 	    	YTDSales s = salesMap.get(a.Short_Name__c);
	 	    	s.Prior_YTD_Sales += a.Prior_YTD_Sales__c == null ? 0 : a.Prior_YTD_Sales__c;
	 	    	s.YTD_Period_Sales += a.YTD_Period_Sales__c == null ? 0 : a.YTD_Period_Sales__c;
	 	    }
	 	    else
	 	    {
	 	    	YTDSales s = new YTDSales();
	 	    	s.Short_Name = a.Short_Name__c;
	 	    	s.Prior_YTD_Sales = a.Prior_YTD_Sales__c == null ? 0 : a.Prior_YTD_Sales__c;
	 	    	s.YTD_Period_Sales = a.YTD_Period_Sales__c == null ? 0 : a.YTD_Period_Sales__c;
	 	    	salesMap.put(a.Short_Name__c, s);
	 	    }
 	    }
 	    for(YTDSales y : salesMap.values())
 	    {
 	    	if(y.Prior_YTD_Sales > 0 || y.YTD_Period_Sales > 0)
 	    	  data.add(y);
 	    }
 	    return data;
     }
     
     public list<YTDSales> getNewProductPromoSales()
     {
     	/*
     	 	•	Report Type:  Accounts with Sales
			•	Sales Date: Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	New Product = true
			•	Group by: Product
			•	Sum: Net Sales
     	 	
     	 */
     	 list<YTDSales> data = new list<YTDSales>();
     	 for(AggregateResult ar : [Select Product__r.Name, sum(Net_Sales__c) net
     	                            from Sales__c 
     	                           where (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             and Year__c >=:reportYear
     	                             and Product__r.New_Product__c = true
     	                           group by Product__r.Name])
     	{
     		YTDSales y = new YTDSales();
     		y.Short_Name = (String)ar.get('Name');
     		y.YTD_Period_Sales = (Double)ar.get('net');
     		data.add(y);
     	}
     	return data;
     }
     
     public String getTop15ProductLines()
     {
     	/*
     	 	•	Report Type:  Accounts with Sales
			•	Sales Date: Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Class != DEL
			•	Group by: Product
			•	Sum: Net Sales
     	 */
     	 String data = '[["Product", "Net Sales"]';
     	 Integer cnt = 1;
     	 for(AggregateResult ar : [Select Product__r.Name, sum(Net_Sales__c) net
     	                            from Sales__c 
     	                           where (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             and Year__c >=:reportYear
     	                           group by Product__r.Name
     	                           order by sum(Net_Sales__c) desc])
     	{
     		data += ',["'+(String)ar.get('name')+'",'+(Double)ar.get('net')+']';
     	    cnt ++;
     	    if(cnt == 15) break;
     	}
     	
     	return data+']';
     }
     
     public list<YTDSales> getTop15ProductLinesTable()
     {
     	/*
     	 	•	Report Type:  Accounts with Sales
			•	Sales Date: Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Sales Type = “T”
			•	Class != DEL
			•	Group by: Product
			•	Sum: Net Sales
     	 */
     	 list<YTDSales> data = new list<YTDSales>();
     	 Integer cnt = 1;
     	 for(AggregateResult ar : [Select Product__r.Name, sum(Net_Sales__c) net
     	                            from Sales__c 
     	                           where (Account__c = :account.Id or Customer_Base__c = :account.Customer_Base__c)
     	                             and SalesType__c = 'T'
     	                             and Year__c >=:reportYear
     	                           group by Product__r.Name
     	                           order by sum(Net_Sales__c) desc])
     	{
     		YTDSales y = new YTDSales();
     		y.Short_Name = (String)ar.get('Name');
     		y.YTD_Period_Sales = (Double)ar.get('net');
     		data.add(y);
     		cnt ++;
     	    if(cnt == 15) break;
     	}
     	return data;
     }
     
     public list<YTDSales> getYTDSalesFaceToFace()
     {
     	/*
     	 	•	Report Type:  Accounts with/without Activity (custom report type)
			•	Sales Date: Current Calendar Year
			•	Customer Base = {Account.Customer_Base__c}
			•	Group by: ShortName
			•	Sum: Account.YTD_Sales__c
			•	Sum: Activity.Face2Face__c

     	 	
     	 */
     	 list<YTDSales> data = new list<YTDSales>();
        //Can't group by Short Name so we need to map and add
 	    map<String, YTDSales> salesMap = new map<String, YTDSales>();
 	    
 	    //Accounts
 	    for(Account a : [Select Account.Short_Name__c, YTD_Period_Sales__c
 	                      from Account 
 	                     where (Customer_Base__c = :account.Customer_Base__c or Id = :account.Id)
 	                      // and Account.Short_Name__c != null
 	                       ])
 	    {
 	    	if(salesMap.containsKey(a.Short_Name__c))
 	    	{
	 	    	YTDSales s = salesMap.get(a.Short_Name__c);
	 	    	s.YTD_Period_Sales += a.YTD_Period_Sales__c == null ? 0 : a.YTD_Period_Sales__c;
	 	    }
	 	    else
	 	    {
	 	    	YTDSales s = new YTDSales();
	 	    	s.Short_Name = a.Short_Name__c;
	 	    	s.Prior_YTD_Sales = 0;
	 	    	s.YTD_Period_Sales = a.YTD_Period_Sales__c == null ? 0 : a.YTD_Period_Sales__c;
	 	    	salesMap.put(a.Short_Name__c, s);
	 	    }
 	    }
 	    
 	    //tasks
     	for(Task a : [Select Account.Short_Name__c, Face2Face__c
 	                      from Task 
 	                     where (Account.Customer_Base__c = :account.Customer_Base__c or AccountId = :account.Id)
 	                       and Account.Customer_Base__c != null
 	                       and Account.Short_Name__c != null
 	                       and isClosed = true
 	                       and CALENDAR_YEAR(CreatedDate) = :reportYear])
 	    {
 	    	if(salesMap.containsKey(a.Account.Short_Name__c)) 
 	    	{
	 	    	YTDSales s = salesMap.get(a.Account.Short_Name__c);
	 	    	s.Prior_YTD_Sales += (a.Face2Face__c == null ? 0 : a.Face2Face__c);
	 	    }
 	    }
 	    
 	    //Event
     	for(Event a : [Select Account.Short_Name__c, Face2Face__c
 	                      from Event 
 	                     where (Account.Customer_Base__c = :account.Customer_Base__c or AccountId =: account.Id)
 	                       and Account.Customer_Base__c != null
 	                       and Account.Short_Name__c != null
 	                       and CALENDAR_YEAR(CreatedDate) = :reportYear])
 	    {
 	    	if(salesMap.containsKey(a.Account.Short_Name__c))
 	    	{
	 	    	YTDSales s = salesMap.get(a.Account.Short_Name__c);
	 	    	s.Prior_YTD_Sales += (a.Face2Face__c == null ? 0 : a.Face2Face__c);
	 	    }
 	    }
 	    
 	    for(YTDSales y : salesMap.values())
 	    {
 	    	if(y.Prior_YTD_Sales > 0 || y.YTD_Period_Sales > 0)
 	    	  data.add(y);
 	    }
 	    return data;
     }
     
     @isTest
     static void testThisClass()
     {
     	//create some test data
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
       
	   datetime myDate =System.now();

       Event e  =  new Event     ( Subject  = ' Test'
                                 , StartDateTime = myDate
                                 , DurationInMinutes = 60
                                 , EndDateTime  = myDate.addHours(1)
                                 , ActivityDateTime  = myDate
                                 , Primary_Objective__c = 'x'
                                 , Secondary_Objective__c = 'y'
                                 , whatId = a.Id
                                 );
        insert e;                     
                              
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
                                  , Period_text__c = '1'
                                  , Sales_Date__c = System.Today()
                                  , Gross_Sales__c = 100
                                  , Cost_of_Sales__c =10);  
        Sales__c s2 = new Sales__c (Account__c = a.Id
                                  , SalesType__c = 'T'
                                  , Product_Team__c = pt.Id
                                  , Year__c = year0
                                  , Period_text__c = '1'
                                  , Sales_Date__c = System.Today().addYears(-1)
                                  , Gross_Sales__c = 100
                                  , Cost_of_Sales__c =10);  
        insert s1;
                              
        //invoke the page that runs the controller methods
        Test.setCurrentPage(Page.DistributerDashboard);
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        DistributorDashboardCtl ctl = new DistributorDashboardCtl(sc);
        
        //cover methods not envoked by the page
        ctl.getDisplaySampleBoardSales();  
        ctl.getFullPeriodSales();
        ctl.getNewProductPromoSales();
        ctl.getPcntOfTotalSales();
        ctl.getSalesByYearByPeriod();
        ctl.getSalesVsPlanNumbers();
        ctl.getTop15ProductLines();
        ctl.getTop15ProductLinesTable();
        ctl.getYtdSalesByTeam();
        ctl.getYTDSalesFaceToFace();
        ctl.getYtdSalesPlanByPeriod();
        ctl.getYtdSalesToGoal();      
        
        
        
        
     }
     
}