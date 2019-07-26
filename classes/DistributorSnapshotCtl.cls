public with sharing class DistributorSnapshotCtl{

	public Integer LASTYEAR {get;set;}
	public Integer YEAR {get;set;}
	public Integer todayMonth {get;set;}
	public Integer searchYear {get;set;}
	public Integer searchPreviousYear {get;set;}
	public Integer searchFullPeriod {get;set;}
	public Boolean flagPreviousYears {get;set;}
	public Date d {get;set;}
	public Account thisAccount {get;set;}
	public Integer i {get; set;} 
	public LIST <AggregateResult> salesList {get;set;}
	public String varPercentToSale {get;set;}
// 	public PageReference imageLogo {get;set;}

    public String selectedDateVal {get;set;}  

	public DistributorSnapshotCtl(ApexPages.StandardController ctl) {
		d = System.today();
		LASTYEAR = d.Year() - 1;
		YEAR = d.Year();
		todayMonth = d.Month();
		System.debug(LoggingLevel.ERROR, 'DistributorSnapshotCtl...:');
		System.debug(LoggingLevel.ERROR, 'd...:' + d);
		System.debug(LoggingLevel.ERROR, 'LASTYEAR...:' + LASTYEAR);
		System.debug(LoggingLevel.ERROR, 'YEAR...:' + YEAR);
		System.debug(LoggingLevel.ERROR, 'todayMonth...:' + todayMonth);
		
		// issue: when the report is run and it is in January, you get very little data.
		// the rep would rather see the previous years still, and have those to compare against
		// so we check if it is January, and if so, we run all the data to get full periods of previous 2 years
		// and other month returns current year.
		
		Account a = [
			SELECT SBU__c
				,id
				,Name
				,Customer_Base__c
				,OWNER.Name
				,ParentId
				,Has_AO_Displays__c
				,Has_Displays__c
				,Display_Types__c
				,AO_Display_Types__c
				,DW_ID__c
				,GroupKey__c
				,Division__c
			from account
			where Id = : ((Account)ctl.getRecord()).id
		];
		thisAccount = a;
		
		System.debug('thisAccount.GroupKey__c..:' + thisAccount.GroupKey__c);
		System.debug('thisAccount.Division__c..:' + thisAccount.Division__c);
		
		// one query run at page load to pull all the sales data for the page
		// previously they had 2 or 3 queries per report with 11 total queries 
		// this caused signifigant performance issues and timeouts
		// now with this approach, performance is enhanced x100 (not exagerating...its so much faster its silly)

		salesList = searchSales(thisAccount.GroupKey__c,thisAccount.Division__c);
		
		Set <Integer> setCurrentSalesMonths = new Set <Integer> ();
		
		for (AggregateResult ar: salesList) {
			Integer currentMonth = Integer.valueOf(ar.get('month'));
			setCurrentSalesMonths.add(currentMonth);
		}
		
		LIST <Integer> listCurrentSalesMonths = new LIST <Integer> ();
		listCurrentSalesMonths.addAll(setCurrentSalesMonths);
		listCurrentSalesMonths.sort();
		
		
		System.debug(LoggingLevel.ERROR, 'controller listCurrentSalesMonths...:' + listCurrentSalesMonths);		
	}
	
    public List <AggregateResult> searchSales(String varGroupKey, String varDivision){

        List<AggregateResult> listSales = new List<AggregateResult>();
        
		System.debug('searchSales varGroupKey:' + varGroupKey + ' / varDivision:...' + varDivision);
		
		if ( todayMonth == 1 || selectedDateVal == 'Previous Year / All Periods' ) {
		    flagPreviousYears = true;
		} else {
		    flagPreviousYears = false;
		}
		
		System.debug('searchSales + flagPreviousYears..:' + flagPreviousYears);
		
		if ( flagPreviousYears == true ) {
		    searchYear = LASTYEAR;
		    searchPreviousYear = LASTYEAR-1;
            listSales  = [
    			SELECT s.Product_Team__r.Name ptName
    				,s.Product_Line__r.Name plName
    				,SUM(SF_Sold__c) qtSold
    				,Period_text__c periodMonth
    				,calendar_month(Sales_Date__c) month
    				,calendar_year(Sales_Date__c) year
    				,SUM(Net_Sales__c) netSales
    			FROM Sales__c s
    			WHERE  calendar_year(Sales_Date__c) >=: searchYear - 1
    				AND GroupKey__c = : thisAccount.GroupKey__c
    				AND Account__r.Division__c = : thisAccount.Division__c
    			GROUP BY 
    				calendar_month(Sales_Date__c) 
    				,calendar_year(Sales_Date__c) 
    				,Period_text__c 
    				,s.Product_Team__r.Name 
    				,s.Product_Line__r.Name 
    			ORDER BY calendar_year(Sales_Date__c), SUM(SF_Sold__c) DESC
    		];            
		} else {
		    searchYear = YEAR;
		    searchPreviousYear = YEAR-1;
            searchFullPeriod = 1;

            listSales  = [
    			SELECT s.Product_Team__r.Name ptName
    				,s.Product_Line__r.Name plName
    				,SUM(SF_Sold__c) qtSold
    				,Period_text__c periodMonth
    				,calendar_month(Sales_Date__c) month
    				,calendar_year(Sales_Date__c) year
    				,SUM(Net_Sales__c) netSales
    			FROM Sales__c s
    			WHERE  calendar_year(Sales_Date__c) >=: searchYear - 1
    				AND Limit_Prior_YTD_Full_Period__c = : searchFullPeriod
    				AND GroupKey__c = : thisAccount.GroupKey__c
    				AND Account__r.Division__c = : thisAccount.Division__c
    			GROUP BY 
    				calendar_month(Sales_Date__c) 
    				,calendar_year(Sales_Date__c) 
    				,Period_text__c 
    				,s.Product_Team__r.Name 
    				,s.Product_Line__r.Name 
    			ORDER BY calendar_year(Sales_Date__c), SUM(SF_Sold__c) DESC
    		];
		}

        return listSales;
    }

    public PageReference updateSales(){ 
        spin();
        salesList = searchSales(thisAccount.GroupKey__c,thisAccount.Division__c);
        return null;
        
    }

    public List<SelectOption> getDateOptions(){
            List<SelectOption> optns = new List<Selectoption>();
            // before getting here you must populate your queryResult list with required fields
            optns.add(new selectOption('Current Year / Period', 'Current Year / Period'));
            optns.add(new selectOption('Previous Year / All Periods', 'Previous Year / All Periods'));
    
            return optns;
    }

	
	public class Pair {
	        public Decimal value { get; set; }
	        public String key { get; set; }
	        public Pair(Decimal value, String key) {
	            this.value = value;
	            this.key = key;
	        }
	}

	public string getYtdSalesGrid() {
		Map < String,String > salesValueY1Pretty = new Map < String,String > ();
		Map < Integer,Decimal > salesValueY1 = new Map < Integer,Decimal > ();		
		Map < String,String > salesValueY2Pretty = new Map < String,String > ();
		Map < Integer,Decimal > salesValueY2 = new Map < Integer,Decimal > ();		
		map < String,double > y1Map = new map < String,double > ();
		map < String,double > y2Map = new map < String,double > ();
		Integer Y1_Total;
		Integer Y2_Total;
		set < string > productSet = new set < string > ();
        Integer thisYear ;
        String thisPT ;
        String thisSales ;
		List < aggregateResult > salesPYList = new List < aggregateResult > ();
		List < aggregateResult > salesCYList = new List < aggregateResult > ();
		 
        // loop through the sales for the account
        // create maps for current and previous year sales, by product team

		for (aggregateResult ar: salesList) {
            thisYear = Integer.valueOf(ar.get('year'));
            thisPT = String.valueOf(ar.get('ptName'));
            thisSales = String.valueOf(ar.get('qtsOld'));
			if (thisPT != 'Plan Number' && thisPT != 'SAMPLES AND MISCELL') {
			    if (thisYear == searchYear - 1 ) {
    				Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtsOld')));
    				Decimal previousValue = y1Map.get(String.valueOf(ar.get('ptName')));
    				String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
    				if ( previousValue != null)  {
    					String valueSalesValueY1Pretty = getTwoDecimal(Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
    					y1Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					salesValueY1Pretty.put(String.valueOf(ar.get('ptName')), valueSalesValueY1Pretty);	
    				} else {
    					y1Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(ar.get('qtsOld')));
    					salesValueY1Pretty.put(String.valueOf(ar.get('ptName')), currentValuePretty);	
    				}
    				productSet.add(String.valueOf(ar.get('ptName')));
    			} else if (thisYear == searchYear) {
    				Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtsOld')));    				
    				Decimal previousValue = y2Map.get(String.valueOf(ar.get('ptName')));
    				String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
    				if ( previousValue != null)  {
    					String valueSalesValueY2Pretty = getTwoDecimal(Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					y2Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					salesValueY2Pretty.put(String.valueOf(ar.get('ptName')), valueSalesValueY2Pretty);	
    				} else {
    					y2Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(ar.get('qtsOld')));
    					salesValueY2Pretty.put(String.valueOf(ar.get('ptName')), currentValuePretty);	
    				}
    				productSet.add(String.valueOf(ar.get('ptName')));		
    			}
			}
		}		

		string htmlTable = '<table border="0" cellspacing="3" width="400" ><tr><td colspan="4" style="font-weight:bold; color:white; background-color:#8a9ebe; !important;-webkit-print-color-adjust: exact; ">Product Team Purchases SqFt</td></tr>';
		htmlTable += '<tr><td><b><u>Product Team</u></b></td><td align="right"><b><u>' + (searchYear - 1) + '</u></b></td><td  align="right"><b><u>' + searchYear + '</u></b></td><td align="right"><b><u>% PY</u></b></td></tr>';
		list < String > productList = new List < String > (productSet);

		productList.sort();
		for (String s: productList) {
			if (s != null && s.trim() != 'null' && s.trim() != '') {
				if (y1Map.get(s) != null) {
					htmlTable += '<tr><td>' + s + '</td><td align="right">' + (y1Map.get(s) == null ? '0.00' : salesValueY1Pretty.get(s)) + '</td>';
				} else {
					htmlTable += '<tr><td>' + s + '</td><td align="right">0.00</td>';
				}
				if (y2Map.get(s) != null && y1Map.get(s) != null) {
					if (y2Map.get(s) != 0 && y1Map.get(s) == 0) {
						htmlTable += '<td align="right">' + (y2Map.get(s) == null ? '0.00' : salesValueY2Pretty.get(s)) + '</td><td  align="right"><b>' + 0.0 + '%</b></td></tr>';					
					} else { 					
            		    Decimal thisPercentage = Decimal.ValueOf(((y2Map.get(s) / y1Map.get(s)) * 100)).setScale(1);
            			if (thisPercentage > 100 ) {
            			    thisPercentage = 100;
            			}
						htmlTable += '<td align="right">' + (y2Map.get(s) == null ? '0.00' : salesValueY2Pretty.get(s)) + '</td><td  align="right"><b>' + thisPercentage + '%</b></td></tr>';
					}	
				} else {
					htmlTable += '<td align="right"></td><td  align="right">0.00</td></tr>';
				}
			}
		}
		htmlTable += '<tr><td colspan="4"><hr/></td></tr>';
		htmlTable += '<tr><td colspan="4"><i>This report and chart only reflect full / complete periods.</i><hr/></td></tr>';
		htmlTable += '</table>';

		return htmlTable;

	}

	public string getTopFiveGlazeFloor() {
		String htmlTable = '';
		Map <string,String> salesValueY1Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY1 = new Map < Integer,Decimal > ();		
		Map <string,String> salesValueY2Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY2 = new Map < Integer,Decimal > ();	
		List < String > productLineNames = new List < String > ();
		Map < String,Decimal > y1Map = new map < string,Decimal > ();
		Map < String,Decimal > y2Map = new map < string,Decimal > ();
		Map <string, List <AggregateResult>> mapProductTeamNameToSales = new map <string, List <AggregateResult>>();
		Set <String > productLineNamesFullSet = new Set < String > ();
		List <String > productLineNamesFullList = new List < String > ();
		Set <String > productLineNamesMasterSet = new Set < String > ();
		List <String > productLineNamesMasterList = new List < String > ();
		List <AggregateResult> arThisYear = new List < AggregateResult >();
		List <AggregateResult> listProductTeamSales = new List < AggregateResult >();
		String nameGlazeFloor = 'GLAZED FLOOR TILE';
        Integer thisYear ;
		Map <string, Decimal> mapThisYearPreviousValue = new Map <string, Decimal>();
		Map <string, Decimal> mapLastYearPreviousValue = new Map <string, Decimal>();
		
		// get product line names
		for (AggregateResult ar: salesList) {
            thisYear = Integer.valueOf(ar.get('year'));
			if (thisYear == searchYear) {
				listProductTeamSales = mapProductTeamNameToSales.get(nameGlazeFloor);
				if ( String.valueOf(ar.get('ptName')) == nameGlazeFloor) {
					if (String.isBlank(String.valueOf(String.valueOf(ar.get('plName'))))) {
						continue;
					} else {
						productLineNamesFullSet.add(String.valueOf(ar.get('plName')));					
					}
				}
			}
		}		
		productLineNamesFullList.addAll(productLineNamesFullSet);
		
		// get top 5
		i = 0;
		for (String p:productLineNamesFullList) {
			if (productLineNamesMasterSet.size() < 5) {
				productLineNamesMasterSet.add(p);
			}
		}
		productLineNamesMasterList.addAll(productLineNamesMasterSet);	

		// get results for product lines
		for (AggregateResult ar: salesList) {
			for (String pl:productLineNamesMasterList ) {
                thisYear = Integer.valueOf(ar.get('year'));
                String thisPL = String.valueOf(ar.get('plName'));
				if (thisPL == pl) {
					if (thisYear == searchYear - 1) {
						Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtSold')));
						Decimal previousValue = mapLastYearPreviousValue.get(thisPL);
						String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
						if (previousValue != null) {
							String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
							salesValueY1Pretty.put(thisPL, currentValuePretty + previousValuePretty);	
							y1Map.put(thisPL, currentValue + previousValue);	
							mapLastYearPreviousValue.put(thisPL , previousValue + currentValue);	
						} else {
							salesValueY1Pretty.put(thisPL, currentValuePretty);	
							y1Map.put(thisPL, currentValue );	
							mapLastYearPreviousValue.put(thisPL , currentValue);	
						}
					} else if (thisYear == searchYear) {
						Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtSold')));
						Decimal previousValue = mapThisYearPreviousValue.get(thisPL);
						String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
						if (previousValue != null) {
							String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
							salesValueY2Pretty.put(thisPL, currentValuePretty + previousValuePretty);	
							y2Map.put(thisPL, currentValue + previousValue);
							mapThisYearPreviousValue.put(thisPL , previousValue + currentValue);	
						} else {
							salesValueY2Pretty.put(thisPL, currentValuePretty);	
							y2Map.put(thisPL, currentValue );	
							mapThisYearPreviousValue.put(thisPL , currentValue);	
						}
					}				
				}
			}
		}

        // issue: soql query is for previous and current year, and sorted by qtSold ... for both years
        // this causes somee product lines to be sorted above others that may have more sales for the current year, but not fir both years combined
        // solution: develop sorting algorithm to sort product line based on current year value only
		
		Set <String > setValues = y2Map.keySet();
		
		List<Pair> oList = new List<Pair>();
		for (String consultant: setValues) {
			oList.add(new Pair(y2Map.get(consultant), consultant));
		}
		Decimal tmpValue = 0.0;
		String tmpKey = NULL;
		
		// Bubble sort
		for (Integer i = 0; i < oList.size()-1; i++) {
		    for (Integer j = 1; j < oList.size(); j++) {
		        if (oList.get(j-1).value < oList.get(j).value) {
		            // permute
		            tmpValue = oList.get(j-1).value;
		            tmpKey = oList.get(j-1).key;
		            oList.get(j-1).value = oList.get(j).value;
		            oList.get(j-1).key = oList.get(j).key;
		            oList.get(j).value = tmpValue;
		            oList.get(j).key = tmpKey;
		          }
		     }
		}
		
		htmlTable += '<table border="0" cellspacing="3" width="400" ><tr><td colspan="4" style="font-weight:bold; color:white; background-color:#8a9ebe; !important;-webkit-print-color-adjust: exact; ">Top 5 Glazed Floor Tile Products SqFt</td></tr>';
		htmlTable += '<tr><td><b><u>Product Line</u></b></td><td align="right"><b><u>' + searchYear + '</u></b></td><td align="right"><b><u>% PY</u></b></td></tr>';

		for (Pair s: oList) {
			if (String.isNotBlank(s.key) && y2Map.get(s.key) != null) {
				Decimal thisValue = y2Map.get(s.key) == null ? 0.00 : y2Map.get(s.key).setScale(2);
				Decimal thisPercentage = 0;
				if (thisValue != null && thisValue != 0) {
					if (!y1Map.isEmpty() && y1Map.get(s.key) != null) {
						thisPercentage = (thisValue / y1Map.get(s.key) * 100).setScale(1);
					} else {
						thisPercentage = (thisValue * 100).setScale(1);
					}
					if (thisPercentage > 100 ) {
					    thisPercentage = 100;
					}
				}
				htmlTable += '<tr><td>' + s.key + '</td><td align="right">' + getTwoDecimal(thisValue) + '</td><td align="right">' + thisPercentage + '%</td></tr>';
			} else {
				htmlTable += '<tr><td>' + s.key + '</td><td align="right">$0.00</td>';
			}
		}

		htmlTable += '<tr><td colspan="4"><hr/></td></tr>';
		htmlTable += '<tr><td colspan="4"><i>This report only reflects full / complete periods.</i><hr/></td></tr>';
		htmlTable += '</table>';

		return htmlTable;
	}

	public string getTopFivePorcelainTile() {
		String htmlTable = '';
		Map <string,String> salesValueY1Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY1 = new Map < Integer,Decimal > ();		
		Map <string,String> salesValueY2Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY2 = new Map < Integer,Decimal > ();	
		List < String > productLineNames = new List < String > ();
		Map < String,Decimal > y1Map = new map < string,Decimal > ();
		Map < String,Decimal > y2Map = new map < string,Decimal > ();
		Map <string, List <AggregateResult>> mapProductTeamNameToSales = new map <string, List <AggregateResult>>();
		Set <String > productLineNamesFullSet = new Set < String > ();
		List <String > productLineNamesFullList = new List < String > ();
		Set <String > productLineNamesMasterSet = new Set < String > ();
		List <String > productLineNamesMasterList = new List < String > ();
		String namePorcelainTile = 'COLORBODY PORCELAIN';
        Integer thisYear ;
		Map <string, Decimal> mapThisYearPreviousValue = new Map <string, Decimal>();
		Map <string, Decimal> mapLastYearPreviousValue = new Map <string, Decimal>();
		
		// get product line names
		for (AggregateResult ar: salesList) {
            thisYear = Integer.valueOf(ar.get('year'));
			if (thisYear == searchYear) {
				if ( String.valueOf(ar.get('ptName')) == namePorcelainTile) {
					if (String.isBlank(String.valueOf(String.valueOf(ar.get('plName'))))) {
						continue;
					} else {
						productLineNamesFullSet.add(String.valueOf(ar.get('plName')));					
					}
				}
			}
		}		
		productLineNamesFullList.addAll(productLineNamesFullSet);
		
		// get top 5
		i = 0;
		for (String p:productLineNamesFullList) {
			if (productLineNamesMasterSet.size() < 5) {
				productLineNamesMasterSet.add(p);
			}
		}
		productLineNamesMasterList.addAll(productLineNamesMasterSet);		
		// get results for product lines
		for (AggregateResult ar: salesList) {
			for (String pl:productLineNamesMasterList ) {
                thisYear = Integer.valueOf(ar.get('year'));
                String thisPL = String.valueOf(ar.get('plName'));
				if (thisPL == pl) {
					if (thisYear == searchYear - 1) {
						Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtSold')));
						Decimal previousValue = mapLastYearPreviousValue.get(thisPL);
						String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
						if (previousValue != null) {
							String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
							salesValueY1Pretty.put(thisPL, currentValuePretty + previousValuePretty);	
							y1Map.put(thisPL, currentValue + previousValue);	
							mapLastYearPreviousValue.put(thisPL , previousValue + currentValue);	
						} else {
							salesValueY1Pretty.put(thisPL, currentValuePretty);	
							y1Map.put(thisPL, currentValue );	
							mapLastYearPreviousValue.put(thisPL , currentValue);	
						}
					} else if (thisYear == searchYear) {
						Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtSold')));
						Decimal previousValue = mapThisYearPreviousValue.get(thisPL);
						String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
						if (previousValue != null) {
							String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
							salesValueY2Pretty.put(thisPL, currentValuePretty + previousValuePretty);	
							y2Map.put(thisPL, currentValue + previousValue);
							mapThisYearPreviousValue.put(thisPL , previousValue + currentValue);	
						} else {
							salesValueY2Pretty.put(thisPL, currentValuePretty);	
							y2Map.put(thisPL, currentValue );	
							mapThisYearPreviousValue.put(thisPL , currentValue);	
						}
					}				
				}
			}
		}

        // issue: soql query is for previous and current year, and sorted by qtSold ... for both years
        // this causes somee product lines to be sorted above others that may have more sales for the current year, but not fir both years combined
        // solution: develop sorting algorithm to sort product line based on current year value only
		
		Set <String > setValues = y2Map.keySet();
		
		List<Pair> oList = new List<Pair>();
		for (String consultant: setValues) {
			oList.add(new Pair(y2Map.get(consultant), consultant));
		}
		Decimal tmpValue = 0.0;
		String tmpKey = NULL;
		
		// Bubble sort
		for (Integer i = 0; i < oList.size()-1; i++) {
		    for (Integer j = 1; j < oList.size(); j++) {
		        if (oList.get(j-1).value < oList.get(j).value) {
		            // permute
		            tmpValue = oList.get(j-1).value;
		            tmpKey = oList.get(j-1).key;
		            oList.get(j-1).value = oList.get(j).value;
		            oList.get(j-1).key = oList.get(j).key;
		            oList.get(j).value = tmpValue;
		            oList.get(j).key = tmpKey;
		          }
		     }
		}
		
		htmlTable += '<table border="0" cellspacing="3" width="400" ><tr><td colspan="4" style="font-weight:bold; color:white; background-color:#8a9ebe; !important;-webkit-print-color-adjust: exact; ">Top 5 Porcelain Tile Products SqFt</td></tr>';
		htmlTable += '<tr><td><b><u>Product Line</u></b></td><td align="right"><b><u>' + searchYear + '</u></b></td><td align="right"><b><u>% PY</u></b></td></tr>';

		for (Pair s: oList) {
			if (String.isNotBlank(s.key) && y2Map.get(s.key) != null) {
				Decimal thisValue = y2Map.get(s.key) == null ? 0.00 : y2Map.get(s.key).setScale(2);
				Decimal thisPercentage = 0;
				if (thisValue != null && thisValue != 0) {
					if (!y1Map.isEmpty() && y1Map.get(s.key) != null) {
						thisPercentage = (thisValue / y1Map.get(s.key) * 100).setScale(1);
					} else {
						thisPercentage = (thisValue * 100).setScale(1);
					}
					if (thisPercentage > 100 ) {
					    thisPercentage = 100;
					}
				}
				htmlTable += '<tr><td>' + s.key + '</td><td align="right">' + getTwoDecimal(thisValue) + '</td><td align="right">' + thisPercentage + '%</td></tr>';
			} else {
				htmlTable += '<tr><td>' + s.key + '</td><td align="right">$0.00</td>';
			}
		}

		htmlTable += '<tr><td colspan="4"><hr/></td></tr>';
		htmlTable += '<tr><td colspan="4"><i>This report only reflects full / complete periods.</i><hr/></td></tr>';
		htmlTable += '</table>';

		return htmlTable;
	}


	public String getCumulativeSales() {
		Map <string,String> salesValueY1Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY1 = new Map < Integer,Decimal > ();		
		Map <Integer,String> salesValueY2Pretty = new Map < Integer,String > ();
		Map <Integer,Decimal> salesValueY2 = new Map < Integer,Decimal > ();	
		Map < Integer,Decimal > salesValue = new Map < Integer,Decimal > ();
		Map < Integer,String > salesValuePretty = new Map < Integer,String > ();
		List < AggregateResult > salesPlanResults= new List < AggregateResult > ();
		List < Sales__c > salesPlan = new List < Sales__c>();
		List < AggregateResult > agrCurrent = new List < AggregateResult > ();
		Map < Integer,Decimal > planValue = new Map < Integer,Decimal > ();
		Map < Integer,Decimal > previousSalesValue = new Map < Integer,Decimal > ();
		Map <Integer, Decimal> mapThisYearPreviousValue = new Map <Integer, Decimal>();
		Decimal decimalThisYearPreviousValue;
		Map < Integer,Decimal > y2Map = new map < Integer,Decimal > ();
		Map <Integer, Decimal> mapLastYearPreviousValue = new Map <Integer, Decimal>();
		Map <Integer, AggregateResult> mapMonthSales = new Map <Integer, AggregateResult>();
        Decimal currentValue;
        map < Integer,Decimal > mapPreviousYearSalesValue = new map < Integer,Decimal > ();
        Decimal previousYearSalesValue;
        Decimal previousMonthSalesValue;
        Decimal previousPlanValue;
        Decimal updatedPlanValue;
		String namePlan = 'Plan';
		
		Set <Integer> setCurrentSalesMonths = new Set <Integer> ();
		
		for (AggregateResult ar: salesList) {
			Integer currentMonth = Integer.valueOf(ar.get('month'));
			setCurrentSalesMonths.add(currentMonth);
		}
		
		LIST <Integer> listCurrentSalesMonths = new LIST <Integer> ();
		listCurrentSalesMonths.addAll(setCurrentSalesMonths);
		listCurrentSalesMonths.sort();
		
		
		System.debug('listCurrentSalesMonths...:' + listCurrentSalesMonths);
		
		// get Plan
		for (Integer m: listCurrentSalesMonths) {
			for (AggregateResult ar: salesList) {
	            Integer thisYear = Integer.valueOf(ar.get('year'));
				Integer currentMonth = Integer.valueOf(ar.get('month'));
	            String thisPL = String.valueOf(ar.get('plName'));
	            String thisPT = String.valueOf(ar.get('ptName'));
				if (m == currentMonth) {
					if (thisYear == searchYear &&  ar.get('month') != null ) {
					    if (thisPL == namePlan) {
							currentValue = Decimal.valueOf(String.valueof(ar.get('netSales')));
							Decimal previousValue = mapThisYearPreviousValue.get(currentMonth);
							if (previousPlanValue != null) {
								previousPlanValue = previousPlanValue + currentValue;
		        			} else {
								previousPlanValue = currentValue;
		        			}
	        				planValue.put(currentMonth, previousPlanValue);
					    } else if (ar.get('netSales') != null){
							currentValue = Decimal.valueOf(String.valueof(ar.get('netSales')));
							Decimal previousValue = mapThisYearPreviousValue.get(currentMonth);
							String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
							if (previousMonthSalesValue != null) {
								String previousValuePretty = getTwoDecimal((previousMonthSalesValue).setScale(2));
		                		Decimal currentValueUpdated = Decimal.valueOf(String.valueof(currentValue + previousMonthSalesValue));
								String updatedValuePretty = getTwoDecimal((currentValue + previousMonthSalesValue).setScale(2));
								salesValueY2Pretty.put(currentMonth, updatedValuePretty);	
								y2Map.put(currentMonth, currentValue + previousMonthSalesValue);
								mapThisYearPreviousValue.put(currentMonth , previousMonthSalesValue + currentValue);	
								previousMonthSalesValue = previousMonthSalesValue + currentValue;
							} else {
								salesValueY2Pretty.put(currentMonth, currentValuePretty);	
								y2Map.put(currentMonth, currentValue );	
								mapThisYearPreviousValue.put(currentMonth , currentValue);	
								previousMonthSalesValue = currentValue;
							}
					    } 
					} else if (thisYear == searchYear - 1 && thisPL != namePlan  && thisPT != 'Plan Number') {
						if (previousYearSalesValue != null) { 
					        System.debug('thisYear...:' + thisYear + ' / m...:' + m + ' / ar...:' + ar + ' / previousYearSalesValue...:' + previousYearSalesValue);
							currentValue = Decimal.valueOf(String.valueof(ar.get('netSales')));
							Decimal previousValue = mapThisYearPreviousValue.get(currentMonth);
			    			previousSalesValue.put(Integer.valueOf(String.valueOf(ar.get('month'))), previousYearSalesValue + currentValue);
			    			previousYearSalesValue = previousYearSalesValue + currentValue;
			    		} else {
    					    System.debug('thisYear...:' + thisYear + ' / m...:' + m + ' / ar...:' + ar);			    		    
							currentValue = Decimal.valueOf(String.valueof(ar.get('netSales')));
							previousYearSalesValue = currentValue;
			    			previousSalesValue.put(Integer.valueOf(String.valueOf(ar.get('month'))), previousYearSalesValue);
			    			
			    		}
					}
				}  
			}
		}
        
		System.debug('y2Map...:' + JSON.serialize(y2Map));
		System.debug('previousSalesValue...:' + JSON.serialize(previousSalesValue));
		System.debug('salesValueY2Pretty...:' + salesValueY2Pretty);		
		System.debug('salesValueY2Pretty...:' + salesValueY2Pretty);		
		
		String htmlTable = '';
		htmlTable += '<table border="0" cellspacing="3" width="400" ><tr><td colspan="5" style="font-weight:bold; color:white; background-color:#8a9ebe; !important;-webkit-print-color-adjust: exact; ">Cumulative Sales in $</td></tr>';
		htmlTable += '<tr><td><b><u>Period</u></b></td><td align="right"><b><u>Plan</u></b></td><td align="right"><b><u>YTD</u></b></td><td align="right"><b><u>% PY</u></b></td><td align="right"><b><u>% Plan</u></b></td></tr>';
		for (Integer i = 1; i <= 12; i++) {
			for (Integer m: listCurrentSalesMonths) {
				if (m == i) {
					if (salesValueY2Pretty.get(i) != null && salesValueY2Pretty.get(i) != '0' && previousSalesValue.get(i) != 0){
						if (planValue.get(i) != null && planValue.get(i) != 0) {
						    Decimal thisPercentage = (y2Map.get(i) / previousSalesValue.get(i) * 100).setScale(1);
                			if (thisPercentage > 100 ) {
                			    thisPercentage = 100;
                			}
					        System.debug('m...:' + m + ' / previousSalesValue.get(i)...:' + previousSalesValue.get(i));
							htmlTable += '<tr><td>' + getMonthName(i) + '</td><td align="right">' + planValue.get(i).format() + '</td><td align="right">' + salesValueY2Pretty.get(i) + '</td><td align="right">' + thisPercentage + '%</td><td align="right">' + (y2Map.get(i) / planValue.get(i) * 100).setScale(1) + '%</td></tr>';
						} else {
						    Decimal thisPercentage = (y2Map.get(i) / previousSalesValue.get(i) * 100).setScale(1);
                			if (thisPercentage > 100 ) {
                			    thisPercentage = 100;
                			}
							htmlTable += '<tr><td>' + getMonthName(i) + '</td><td align="right"></td></td><td align="right">' + salesValueY2Pretty.get(i) + '</td><td align="right">' + thisPercentage + '%</td><td align="right"></td></tr>';
						}
					} else {
						if (planValue.get(i) != null && planValue.get(i) != 0) {
							htmlTable += '<tr><td>' + getMonthName(i) + '</td><td align="right">' + planValue.get(i) + '</td><td align="right"></td><td align="right"></td><td align="right"></td></tr>';
						} else {
							htmlTable += '<tr><td>' + getMonthName(i) + '</td><td align="right">' + ' - ' + '</td><td align="right"></td><td align="right"></td><td align="right"></td></tr>';
						}
					}
				}
			}
		}
		htmlTable += '<tr><td colspan="5"><hr/></td></tr>';
		htmlTable += '<tr><td colspan="5"><i>This report reflects current year to date sales up to the last full period, comparing full period sales of the previous year.</i><hr/></td></tr>';
		htmlTable += '</table>';

		return htmlTable;
	}


	public String getNewProductPurchases() {
	
		Set <String > productLineNamesFullSet = new Set < String > ();
		List <String > productLineNamesFullList = new List < String > ();
		Set <String > productLineNamesMasterSet = new Set < String > ();
		List <String > productLineNamesMasterList = new List < String > ();
		Map < String,Decimal > y1Map = new map < string,Decimal > ();
		Map < String,Decimal > y2Map = new map < string,Decimal > ();
        Integer thisYear ;
		Map <string, Decimal> mapThisYearPreviousValue = new Map <string, Decimal>();
		Map <string, Decimal> mapLastYearPreviousValue = new Map <string, Decimal>();
		Map <string,String> salesValueY1Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY1 = new Map < Integer,Decimal > ();		
		Map <string,String> salesValueY2Pretty = new Map < string,String > ();
		Map <Integer,Decimal> salesValueY2 = new Map < Integer,Decimal > ();	
		Map < Integer,Decimal > salesValue = new Map < Integer,Decimal > ();
		Map < Integer,String > salesValuePretty = new Map < Integer,String > ();
		
		Map <string, Integer> mapProductLineNameToSales = new map <string, Integer>();
	
		List < Product_Line__c > newProductLinesList = new List < Product_Line__c > ();
		newProductLinesList = [
						SELECT
							Name
						FROM Product_Line__c
						WHERE New_Product__c = TRUE
			];
		Set <String> newProductLinesSet = new Set<String>();
		for (Product_Line__c np:newProductLinesList) {
			newProductLinesSet.add(np.Name);
		}
    	
		List < AggregateResult > newProductSalesList = new List < AggregateResult > ();
		
		// get product line names
		for (AggregateResult ar: salesList) {
            thisYear = Integer.valueOf(ar.get('year'));
			if (thisYear == searchYear) {
            	String thisPL = String.valueOf(ar.get('plName'));
    			if (newProductLinesSet.contains(thisPL)) {
    				if (productLineNamesFullSet.contains(thisPL)) {
    					
    				} else {
		    		// 	System.debug('inner thisPL...:' + thisPL);
						productLineNamesFullSet.add(thisPL);
					}
    			}
			// productLineNamesFull.add(String.valueOf(ar.get('ptName')));
			}
		}		
		productLineNamesFullList.addAll(productLineNamesFullSet);
		
		// get top 15
		i = 0;
		for (String p:productLineNamesFullList) {
			if (productLineNamesMasterSet.size() < 15) {
				productLineNamesMasterSet.add(p);
			}
		}
		productLineNamesMasterList.addAll(productLineNamesMasterSet);	
		
		// get results for product lines
		for (AggregateResult ar: salesList) {
			for (String pl:productLineNamesMasterList ) {
                thisYear = Integer.valueOf(ar.get('year'));
                String thisPL = String.valueOf(ar.get('plName'));
				if (thisPL == pl) {
					if (thisYear == searchYear) {
						Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtSold')));
						Decimal previousValue = mapThisYearPreviousValue.get(thisPL);
						String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
						if (previousValue != null) {
							String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
							salesValueY2Pretty.put(thisPL, currentValuePretty + previousValuePretty);	
							y2Map.put(thisPL, currentValue + previousValue);
							mapThisYearPreviousValue.put(thisPL , previousValue + currentValue);	
						} else {
							salesValueY2Pretty.put(thisPL, currentValuePretty);	
							y2Map.put(thisPL, currentValue );	
							mapThisYearPreviousValue.put(thisPL , currentValue);	
						}
					}				
				}
			}
		}
		
		String htmlTable = '';
		htmlTable += '<table border="0" cellspacing="3" width="400" ><tr><td colspan="2" style="font-weight:bold; color:white; background-color:#8a9ebe; !important;-webkit-print-color-adjust: exact; ">New Product Purchase SqFt</td></tr>';
		htmlTable += '<tr><td><b><u>Product Line</u></b></td><td align="right"><b><u>' + searchYear + '</u></b></td></tr>';

		for (String s: productLineNamesMasterList) {
			if (String.isNotBlank(s) && y2Map.get(s) != null) {
				Decimal thisValue = y2Map.get(s) == null ? 0.00 : y2Map.get(s).setScale(2);
				htmlTable += '<tr><td>' + s + '</td><td align="right">' + getTwoDecimal(thisValue) + '</td></tr>';
			} 
		}
		htmlTable += '<tr><td colspan="5"><hr/></td></tr>';
		htmlTable += '<tr><td colspan="5"><i>This report reflects current year to date sales up to the last full period.</i><hr/></td></tr>';
		htmlTable += '</table>';

		return htmlTable;
	}

	public String getMonthName(Integer m) {
	    
	    // converts month number to name for report
	    
		if (m == 1)
			return 'Jan';
		else if (m == 2)
			return 'Feb';
		else if (m == 3)
			return 'Mar';
		else if (m == 4)
			return 'Apr';
		else if (m == 5)
			return 'May';
		else if (m == 6)
			return 'Jun';
		else if (m == 7)
			return 'Jul';
		else if (m == 8)
			return 'Aug';
		else if (m == 9)
			return 'Sep';
		else if (m == 10)
			return 'Oct';
		else if (m == 11)
			return 'Nov';
		else if (m == 12)
			return 'Dec';
		else
			return null;
	}

    public String getTwoDecimal(Decimal i) {

        // creates a nice looking formatted string, including decimals and trailing zeros
        
		if (i == null)
			return '0.00';
		i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
		String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
		return s.substring(0, s.length() - 1);

	}
	
    public void spin() {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<5000); // Busy loop for 5000 ms
    }	
    
    // Wrapper class
    public class PieWedgeData {

        public String name { get; set; }
        public String percent { get; set; }
        public Integer data { get; set; }

        public PieWedgeData(String name, String percent, Integer data) {
            this.name = name;
            this.percent = percent;
            this.data = data;
        }
    }
    
    public List<PieWedgeData> getSalesByProductPie() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        
		Map < String,String > salesValueY1Pretty = new Map < String,String > ();
		Map < Integer,Decimal > salesValueY1 = new Map < Integer,Decimal > ();		
		Map < String,String > salesValueY2Pretty = new Map < String,String > ();
		Map < Integer,Decimal > salesValueY2 = new Map < Integer,Decimal > ();		
		map < String,double > y1Map = new map < String,double > ();
		map < String,double > y2Map = new map < String,double > ();
		Integer Y1_Total;
		Decimal Y2_Total = 0;
		set < string > productSet = new set < string > ();
        Integer thisYear ;
        String thisPT ;
        String thisSales ;
		List < aggregateResult > salesPYList = new List < aggregateResult > ();
		List < aggregateResult > salesCYList = new List < aggregateResult > ();
		
		 
        // loop through the sales for the account
        // create maps for current and previous year sales, by product team

		for (aggregateResult ar: salesList) {
            thisYear = Integer.valueOf(ar.get('year'));
            thisPT = String.valueOf(ar.get('ptName'));
            thisSales = String.valueOf(ar.get('qtsOld'));
			if (thisPT != 'Plan Number' && thisPT != 'SAMPLES AND MISCELL') {
			    if (thisYear == searchYear - 1 ) {
    				Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtsOld')));
    				Decimal previousValue = y1Map.get(String.valueOf(ar.get('ptName')));
    				String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
    				if ( previousValue != null)  {
    					String valueSalesValueY1Pretty = getTwoDecimal(Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					String previousValuePretty = getTwoDecimal((previousValue).setScale(2));
    					y1Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					salesValueY1Pretty.put(String.valueOf(ar.get('ptName')), valueSalesValueY1Pretty);	
    				} else {
    					y1Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(ar.get('qtsOld')));
    					salesValueY1Pretty.put(String.valueOf(ar.get('ptName')), currentValuePretty);	
    				}
    				productSet.add(String.valueOf(ar.get('ptName')));
    			} else if (thisYear == searchYear) {
    				Decimal currentValue = Decimal.valueOf(String.valueof(ar.get('qtsOld')));    				
    				Decimal previousValue = y2Map.get(String.valueOf(ar.get('ptName')));
    				String currentValuePretty = getTwoDecimal((currentValue).setScale(2));
    				if ( previousValue != null)  {
    					String valueSalesValueY2Pretty = getTwoDecimal(Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					y2Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(previousValue) + Double.valueOf(ar.get('qtsOld')));
    					salesValueY2Pretty.put(String.valueOf(ar.get('ptName')), valueSalesValueY2Pretty);	
    				} else {
    					y2Map.put(String.valueOf(ar.get('ptName')),Double.valueOf(ar.get('qtsOld')));
    					salesValueY2Pretty.put(String.valueOf(ar.get('ptName')), currentValuePretty);	
    				}
    				Y2_Total = Y2_Total + currentValue;
    				productSet.add(String.valueOf(ar.get('ptName')));		
    			}
			}
		}		

		list < String > productList = new List < String > (productSet);

		productList.sort();
		for (String s: productList) {
			if (s != null && s.trim() != 'null' && s.trim() != '') {
				if (y2Map.get(s) != null && y2Map.get(s) != 0) {
				    Decimal varDecimalPercentToSale = ((y2Map.get(s) / Y2_Total) * 100).setScale(2);
				    varPercentToSale = String.valueOf(varDecimalPercentToSale) + '%';
				    System.debug('product:...' + s + ' / varPercentToSale:...' + varPercentToSale);
        			data.add(new PieWedgeData(s, varPercentToSale, y2Map.get(s).intValue()));
				} 
			} 
		}
		if (data.isEmpty()) {
		    data.add(new PieWedgeData( 'No Current Year Sales', ' - ', 0));
		}
        return data;
    }

}