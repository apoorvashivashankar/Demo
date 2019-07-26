public class AccountGroupKeySnapshotController {

    public Id accountId {get; set;}
    public Account acct{get; set;}
    public String selectedDateVal {get;set;}  
    public String selectedDivisionVal {get;set;}  
    
    public Boolean bolPrintableView {get;set;}
    
    public String  groupKey  {get;set;} 
    
    public Set<Id> accountIds = new Set<Id>();

    Public list<PieWedgeData> accountPieData = new List<PieWedgeData>();

    public void init() {
     String strPrintableView = ApexPages.currentPage().getParameters().get('print');
     bolPrintableView = (strPrintableView == '1');
    }
    
    public AccountGroupKeySnapshotController(ApexPages.StandardController stdController) {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        system.debug('###### '+accountId);
        
        this.acct = [SELECT Id, Division__c, Groupkey__c FROM Account WHERE Id = :accountId];
        
        selectedDivisionVal = acct.Division__c;
        groupKey            = acct.Groupkey__c;

        selectedDateVal = 'Current Year / Period ';

        String strPrintableView = ApexPages.currentPage().getParameters().get('print');
        bolPrintableView = (strPrintableView == '1');

        if (ApexPages.currentPage().getParameters().get('division') != null) {
            selectedDivisionVal = ApexPages.currentPage().getParameters().get('division');
        }
        if (ApexPages.currentPage().getParameters().get('date') != null) {
            selectedDateVal = ApexPages.currentPage().getParameters().get('date');
        }
        
            
        if (selectedDivisionVal == 'All') {
        
            system.debug('###### ALL selected');
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
        
        }else{
            system.debug('###### Divison: '+selectedDivisionVal);
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Division__c = :selectedDivisionVal AND Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
            
        }
        
    }
    
    public Integer getAccountIdsSize() {
     
        return accountIds.size();
        
    }
    
    public AccountGroupKeySnapshotController( ) {
        
        
        accountId = ApexPages.currentPage().getParameters().get('id');
        system.debug('###### '+accountId);
        
        this.acct = [SELECT Id, Division__c, Groupkey__c FROM Account WHERE Id = :accountId];
        
        groupKey            = acct.Groupkey__c;

        String strPrintableView = ApexPages.currentPage().getParameters().get('print');
        bolPrintableView = (strPrintableView == '1');

        Set<Id> accountIds = new Set<Id>();
            
        if (selectedDivisionVal == 'All') {
        
            system.debug('###### ALL selected');
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
        
        }else{
            system.debug('###### Divison: '+selectedDivisionVal);
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Division__c = :selectedDivisionVal AND Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
            
        }

    }
    
    public List<SelectOption> getDivisionOptions(){
            List<SelectOption> optns = new List<Selectoption>();
            // before getting here you must populate your queryResult list with required fields
            optns.add(new selectOption('All', 'All'));
            optns.add(new selectOption('40', 'DalTile Sales SBU'));
            optns.add(new selectOption('41', 'AO/MZ Sales SBU'));
            
            return optns;
    }
    
    public List<SelectOption> getDateOptions(){
            List<SelectOption> optns = new List<Selectoption>();
            // before getting here you must populate your queryResult list with required fields
            optns.add(new selectOption('Current Year / Period', 'Current Year / Period'));
            optns.add(new selectOption('Previous Year / All Periods', 'Previous Year / All Periods'));
    
            return optns;
    }
    
    public PageReference refreshSales(){ 
    
        //spin();
    
        accountId = ApexPages.currentPage().getParameters().get('id');    
        
        if (selectedDivisionVal == 'All') {
        
            system.debug('###### ALL selected');
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
        
        }else{
            system.debug('###### Divison: '+selectedDivisionVal);
            accountIds.clear();
            for (Account accounts: [SELECT Id FROM Account WHERE Division__c = :selectedDivisionVal AND Groupkey__c = :groupKey ]) {
                system.debug('###### Adding account: '+ accounts.Id);
                accountIds.add(accounts.Id);
            }
            
        }
        
        
        return null;
        
    }
      
    

    public string getSalesStatus() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
        Date d = System.today();
        Integer YEAR = d.Year();

        string htmlTable = '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<thead>';
        
        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="" scope="col">Year</td>';
        htmlTable += '<th class="" scope="col">Q1</td>';
        htmlTable += '<th class="" scope="col">Q2</td>';
        htmlTable += '<th class="" scope="col">Q3</td>';
        htmlTable += '<th class="" scope="col">Q4</td>';
        htmlTable += '<th class="" scope="col">Total</td>';
        htmlTable += '</tr>';
               
        htmlTable += '</thead>';       
        htmlTable += '<tbody>';       
               
        htmlTable +='<tr><td align="right">'+ YEAR +'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal(YEAR,'Q1')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal(YEAR,'Q2')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal(YEAR,'Q3')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal(YEAR,'Q4')+'</td>';
        htmlTable += '<td align="right" > $'+getQuarterTotal(YEAR,'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right" >'+(YEAR-1)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q1')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q2')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q3')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q4')+'</td>';
        htmlTable += '<td align="right" > $'+getQuarterTotal((YEAR-1),'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right">'+(YEAR-2)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q1')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q2')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q3')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q4')+'</td>';
        htmlTable += '<td align="right"> $'+getQuarterTotal((YEAR-2),'')+'</td></tr>';
        
        htmlTable += '</tbody>'; 
        
        htmlTable += '</table>';
        return htmlTable;

    }
    
    public string getQuarterTotal(Integer year, String quarter)
    {
        accountId = ApexPages.currentPage().getParameters().get('id');

        system.debug( '#####  Account Size: ' + accountIds.size()  );
        
        Double total = 0;
        if(quarter == '')
        {
            for(aggregateResult ar: [SELECT sum( Net_Sales__c) netSales
                                         FROM Sales__c 
                                         WHERE Year__c = :year
                                         AND Account__c IN :accountIds
                                         AND (NOT Product_Team__r.Name LIKE '%sample%')
                                    ])
            {
                if(Double.valueOf(ar.get('netSales')) == null)
                  total= 0;
                else
                  total= Double.valueOf(ar.get('netSales'));
            }
        }
        else
        {
            for(aggregateResult ar: [SELECT sum( Net_Sales__c) netSales
                                         FROM Sales__c 
                                         WHERE Year__c = :year
                                         AND Account__c IN :accountIds
                                         AND Quarter__c = :quarter
                                         AND (NOT Product_Team__r.Name LIKE '%sample%')     
                                    ])
            {
                if(Double.valueOf(ar.get('netSales')) == null)
                  total= 0;
                else
                  total= Double.valueOf(ar.get('netSales'));
            }
        }
        return total.format();
    }


 
    //Sales By Product Team
    public string getSalesByProductTeam() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
         Date d = System.today();
         Integer YEAR = d.Year();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }
         
         
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<string> productSet = new set<string>();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
         
             for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c >= :YEAR - 1
                                          and Year__c < :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
            }
            
            for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));     
                
            }
         
         }else{ 
         
             for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c >= :YEAR - 1
                                          and Year__c < :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
            }
            
            for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));     
                
            }
            
        }    
       
        string htmlTable = '<b>Sales By Product Team</b><table class="slds-table slds-table_cell-buffer slds-table_bordered"  style="overflow: visible;">';
        htmlTable += '<thead>';

        String previousYEAR = String.ValueOf(YEAR-1);

        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="" scope="col" width="45%">Product Team</th>';
        htmlTable += '<th class="" scope="col" width="20%">'+previousYEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="20%">'+YEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="15%">% Total</th>';
        htmlTable += '</tr>';

        htmlTable += '</thead>';
        htmlTable += '<tbody>';
        
        

        list<String> productList = new List<String>(productSet);
        
        productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '')
            {
                //pieData.add(new PieWedgeData(s, Integer.ValueOf(y2Map.get(s)) ));
            
                if(y1Map.get(s) != null)
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                else
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right">$0.00</td>';
                if(y2Map.get(s) != null)
                   htmlTable +='<td align="right"> $'+ (y2Map.get(s)==null ? '0.00' : y2Map.get(s).format() )+'</td><td  align="right"><b>'+Decimal.ValueOf(((y2Map.get(s)/y2Map.get(null))*100)).setScale(1) +'%</b></td></tr>';
                else
                   htmlTable +='<td align="right">$0.00</td><td  align="right"></td></tr>';
                   
                   
            }
        }

        htmlTable += '<tr>';
        htmlTable += '<td><b>Totals:</b></td>';
        htmlTable += '<td align="right"> <b>$'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )+'</b></td>';
        htmlTable += '<td align="right"> <b>$'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</b></td>';
        htmlTable += '<td align="left"></td>';
        htmlTable += '</tr>';
        
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        htmlTable += '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<tbody>';
        htmlTable += '<tr>';
        htmlTable += '<td  scope="col" colspan="4">';
        htmlTable += '<div class="slds-grow slds-cell-wrap" style="font-size:80%">';
        htmlTable += 'This report and chart only reflects full / complete periods for this year compared to the same periods for the prior year.';
        htmlTable += '</div>';
        htmlTable += '</td>';
        htmlTable += '</tr>';
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        return htmlTable;
                                    
    }
    
    
    public list<PieWedgeData> getProductTeamPieData() {
        
        Date d = System.today();
        Integer YEAR = d.Year();
        
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }

        list<PieWedgeData> productTeamPieData = new List<PieWedgeData>();
    
        if ( selectedDateVal == 'Previous Year / All Periods') {
        
            for(aggregateResult ar: [Select s.Product_Team__r.Name Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                if (  String.valueOf(ar.get('Name')) != Null && String.valueOf(ar.get('Name')) != '' ) {
                  productTeamPieData.add( new PieWedgeData( String.valueOf(ar.get('Name')), Integer.ValueOf(ar.get('netSales')) ));
                }
                
            }
        
        }else{
        
            for(aggregateResult ar: [Select s.Product_Team__r.Name Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Team__r.Name != null
                                          GROUP BY ROLLUP(Product_Team__r.Name)
                                          ORDER BY Product_Team__r.Name]) {
                if (  String.valueOf(ar.get('Name')) != Null && String.valueOf(ar.get('Name')) != '' ) {
                  productTeamPieData.add( new PieWedgeData( String.valueOf(ar.get('Name')), Integer.ValueOf(ar.get('netSales')) ));
                }
                
            }
        
        }
    
        return productTeamPieData;
    }    
    
   //Sales By Account
    public string getSalesByAccount()
    {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
         Date d = System.today();
         Integer YEAR = d.Year();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }
         
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Double Y1_Total = 0;
         Double Y2_Total = 0;
         set<string> productSet = new set<string>();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
         
             for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c,  sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c >= :YEAR - 1
                                          and Year__c < :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                         GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                         order by Account__r.Alternate_Name__c, Account__r.DW_ID__c ])
            {
                String name = String.valueOf(ar.get('Name')) + '::' + String.valueOf(ar.get('DW_ID__c'));
                
                y1Map.put( name , Double.valueOf(ar.get('netSales')));
                productSet.add(name);
                
                system.debug('#### Added to Y1: '+ name);
                Y1_Total += Double.valueOf(ar.get('netSales'));
            }
            
            for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                         order by Account__r.Alternate_Name__c, Account__r.DW_ID__c ])
            {
            
                String name = String.valueOf(ar.get('Name')) + '::' + String.valueOf(ar.get('DW_ID__c'));
                
                y2Map.put(name, Double.valueOf(ar.get('netSales')));
                productSet.add(name);
                
                system.debug('#### Added to Y2: '+ name);
                
                 Y2_Total += Double.valueOf(ar.get('netSales'));
                 
                 //accountPieData.add( new PieWedgeData( String.valueOf(ar.get('Name')), Integer.ValueOf(ar.get('netSales')) ));
            }
            
        }else{
        
             for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c,  sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c >= :YEAR - 1
                                          and Year__c < :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                         GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                         order by Account__r.Alternate_Name__c, Account__r.DW_ID__c ])
            {
                String name = String.valueOf(ar.get('Name')) + '::' + String.valueOf(ar.get('DW_ID__c'));
                
                y1Map.put( name , Double.valueOf(ar.get('netSales')));
                productSet.add(name);
                
                system.debug('#### Added to Y1: '+ name);
                Y1_Total += Double.valueOf(ar.get('netSales'));
            }
        
            for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                         order by Account__r.Alternate_Name__c, Account__r.DW_ID__c ])
            {
            
                String name = String.valueOf(ar.get('Name')) + '::' + String.valueOf(ar.get('DW_ID__c'));
                
                y2Map.put(name, Double.valueOf(ar.get('netSales')));
                productSet.add(name);
                
                system.debug('#### Added to Y2: '+ name);
                
                 Y2_Total += Double.valueOf(ar.get('netSales'));

            }
        
        
        }    
       
        String previousYEAR = String.ValueOf(YEAR-1);
       
        string htmlTable = '';
        
        //htmlTable += '<b>Sales By Account</b> <br />';
        
        htmlTable += '<b>Sales By Account</b><table class="slds-table slds-table_cell-buffer slds-table_bordered"   style="overflow: visible;">';
        htmlTable += '<thead>';

        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="" scope="col" width="45%">ALT Name</th>';
        htmlTable += '<th class="" scope="col" width="45%">Account</th>';
        htmlTable += '<th class="" scope="col" width="20%">'+previousYEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="20%">'+YEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="15%">% PY</th>';
        htmlTable += '</tr>';

        htmlTable += '</thead>';
        htmlTable += '<tbody>';

        list<String> productList = new List<String>(productSet);
        
        productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '')
            {
                //pieData.add(new PieWedgeData(s, Integer.ValueOf(y2Map.get(s)) ));
                
                String[] accountInfo = s.split('::');
            
                if(y1Map.get(s) != null && y1Map.containskey(s)) {
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+accountInfo[0]+'</div></td>';
                   htmlTable +='<td align="right">'+accountInfo[1]+'</td>';
                   htmlTable +='<td align="right"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                }else{
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+accountInfo[0]+'</div></td>';
                   htmlTable +='<td align="right">'+accountInfo[1]+'</td>';
                   htmlTable +='<td align="right">$0.00</td>';
                   //htmlTable +='<td align="right"></td>';
                }
                   
                if(y2Map.get(s) != null) {
                   htmlTable +='<td align="right"> $'+ (y2Map.get(s)==null ? '0.00' : y2Map.get(s).format() )+'</td>';
                  
                }else {
                   htmlTable +='<td align="right">$0.00</td>';
                }
                
                
                if(y1Map.get(s) != null && y2Map.get(s) != null) {
                
                    htmlTable +='<td  align="right"><b>'+Decimal.ValueOf(((y2Map.get(s)/y1Map.get(s))*100)).setScale(1) +'%</b></td>';
                }else{
                
                    if (y1Map.get(s) == null && y2Map.get(s) != null) {
                        htmlTable +='<td  align="right"><b>100%<b></td>';
                    }else if (y1Map.get(s) != null && y2Map.get(s) == null) {
                        htmlTable +='<td  align="right"><b>-100%<b></td>';
                    }else{
                        htmlTable +='<td  align="right"></td>';
                    }
                }
                
                htmlTable +='</tr>'; 
                   
                   
            }
        }

        htmlTable += '<tr>';
        htmlTable += '<td colspan="2"><b>Totals:</b></td>';
        htmlTable += '<td align="right"> <b>$'+ Y1_Total.format() +'</b></td>';
        htmlTable += '<td align="right"> <b>$'+ Y2_Total.format() +'</b></td>';
        htmlTable += '<td align="left"></td>';
        htmlTable += '</tr>';
        
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        htmlTable += '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<tbody>';
        htmlTable += '<tr>';
        htmlTable += '<td  scope="col" colspan="4">';
        htmlTable += '<div class="slds-grow slds-cell-wrap" style="font-size:80%">';
        htmlTable += 'This report and chart only reflects full / complete periods for this year compared to the same periods for the prior year.';
        htmlTable += '</div>';
        htmlTable += '</td>';
        htmlTable += '</tr>';
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        return htmlTable;
                                    
    }
    
    public list<PieWedgeData> getAccountPieData() {
    
         Date d = System.today();
         Integer YEAR = d.Year();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }
         
         Integer otherTotal = 0;
    
        list<PieWedgeData> accountPieData = new List<PieWedgeData>();
        
        if ( selectedDateVal == 'Previous Year / All Periods') {
    
            for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                         ORDER BY sum( Net_Sales__c) DESC ]) {
                                         
                                         
                if ( ar.get('netSales') != Null && ar.get('Name') != Null ) {
                    if (accountPieData.size() < 14) {
                        accountPieData.add( new PieWedgeData( String.valueOf(ar.get('Name')), Integer.ValueOf(ar.get('netSales')) ));
                    }else{
                        otherTotal +=  Integer.ValueOf(ar.get('netSales'));
                    }
                } 
            }
        
        }else{
        
            for(aggregateResult ar: [Select s.Account__r.Alternate_Name__c Name, s.Account__r.DW_ID__c DW_ID__c, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                        where Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Account__r.Alternate_Name__c != null
                                          AND Account__r.DW_ID__c != Null
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY Account__r.Alternate_Name__c, Account__r.DW_ID__c 
                                          ORDER BY sum( Net_Sales__c) DESC]) {
                                         
                if ( ar.get('netSales') != Null && ar.get('Name') != Null ) {
                    if (accountPieData.size() < 14) {
                        accountPieData.add( new PieWedgeData( String.valueOf(ar.get('Name')), Integer.ValueOf(ar.get('netSales')) ));
                    
                    }else{
                        otherTotal +=  Integer.ValueOf(ar.get('netSales'));
                    }
                } 
                
            }
        
        }
        
        if (otherTotal > 0) {
            accountPieData.add( new PieWedgeData( 'Other', otherTotal ));
        }
    
        return accountPieData;
    }

   //Sales By Product Line
    public string getSalesByProductLine() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
         Date d = System.today();
         Integer YEAR = d.Year();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }
         
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<string> productSet = new set<string>();
         
         set<string> productSet15 = new set<string>();
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
         
             for(aggregateResult ar: [Select s.Product_Line__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Line__r.Name != null
                                        group by Product_Line__r.Name
                                         order by sum( Net_Sales__c) DESC
                                         LIMIT 15 ]) {
                                         
                y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
                system.debug( '##### productSet15 Adding: '+ string.valueOf(ar.get('Name')) );
                productSet15.add( String.valueOf(ar.get('Name')));
                

                
            }
         
             for(aggregateResult ar: [Select s.Product_Line__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR-1 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Line__r.Name != null
                                        group by Product_Line__r.Name
                                         order by sum( Net_Sales__c) DESC
                                         LIMIT 100 ]) {
                                         
                y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
                system.debug( '##### productSet15: '+ productSet15.size() );
                
                if (productSet15.size() < 15 && ! productSet15.contains( string.valueOf(ar.get('Name')) ) ) { 
                
                    productSet15.add( String.valueOf(ar.get('Name')));
                    
                }
                
            }
            

         
         }else{
         
             for(aggregateResult ar: [Select s.Product_Line__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Line__r.Name != null
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                        group by Product_Line__r.Name
                                         order by sum( Net_Sales__c) DESC
                                         LIMIT 15 ]) {
                                         
                y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
                
                productSet15.add( String.valueOf(ar.get('Name')));
                
            }
         
             for(aggregateResult ar: [Select s.Product_Line__r.Name , sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR-1 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Product_Line__r.Name != null
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                        group by Product_Line__r.Name
                                         order by sum( Net_Sales__c) DESC
                                         LIMIT 100 ]) {
                                         
                y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(String.valueOf(ar.get('Name')));
                
                system.debug( '##### productSet15: '+ productSet15.size() );
                
                if (productSet15.size() < 15 && ! productSet15.contains( string.valueOf(ar.get('Name')) ) ) { 
                
                    productSet15.add( String.valueOf(ar.get('Name')));
                    
                }
                
            }
            

        
        }

        String previousYEAR = String.ValueOf(YEAR-1);
       
        string htmlTable = '<b>Sales By Product Line</b><table class="slds-table slds-table_cell-buffer slds-table_bordered"  style="overflow: visible;">';
        htmlTable += '<thead>';

        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="" scope="col" width="60%">Product Line</th>';
        htmlTable += '<th class="" scope="col" width="40%">'+previousYEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="40%">'+YEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="40%">% PY</th>';


        htmlTable += '</thead>';
        htmlTable += '<tbody>';

        list<String> productList = new List<String>(productSet);
        
        //productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '' && productSet15.contains(s) )
            {
                //pieData.add(new PieWedgeData(s, Integer.ValueOf(y2Map.get(s)) ));
            
                if(y1Map.get(s) != null) {
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                }else{
                   htmlTable +='<tr><td><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right">$0.00</td>';
                }   
                if(y2Map.get(s) != null) {
                   htmlTable +='<td align="right"> $'+ (y2Map.get(s)==null ? '0.00' : y2Map.get(s).format() )+'</td>';
                  
                }else {
                   htmlTable +='<td align="right">$0.00</td>';
                }
                
                
                if(y1Map.get(s) != null && y2Map.get(s) != null) {
                
                    htmlTable +='<td  align="right"><b>'+Decimal.ValueOf(((y2Map.get(s)/y1Map.get(s))*100)).setScale(1) +'%</b></td>';
                }else{
                
                    if (y1Map.get(s) == null && y2Map.get(s) != null) {
                        htmlTable +='<td  align="right"><b>100%<b></td>';
                    }else if (y1Map.get(s) != null && y2Map.get(s) == null) {
                        htmlTable +='<td  align="right"><b>-100%<b></td>';
                    }else{
                        htmlTable +='<td  align="right"></td>';
                    }
                }
                
                htmlTable +='</tr>';
                   
            }
        }

        //htmlTable += '<tr>';
        //htmlTable += '<td><b>Totals:</b></td>';
        //htmlTable += '<td align="right"> <b>$'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )+'</b></td>';
        //htmlTable += '<td align="right"> <b>$'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</b></td>';
        //htmlTable += '<td align="left"></td>';
        //htmlTable += '</tr>';
        
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        htmlTable += '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<tbody>';
        htmlTable += '<tr>';
        htmlTable += '<td  scope="col" colspan="4">';
        htmlTable += '<div class="slds-grow slds-cell-wrap" style="font-size:80%">';
        htmlTable += 'This report and chart only reflects full / complete periods for this year compared to the same periods for the prior year.';
        htmlTable += '</div>';
        htmlTable += '</td>';
        htmlTable += '</tr>';
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        return htmlTable;
                                    
    }



   //Sales By Period
    public string getSalesByPeriod() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
         Date d = System.today();
         Integer YEAR = d.Year();
      
         if ( selectedDateVal == 'Previous Year / All Periods') {
             YEAR = YEAR - 1;
         }
         
         map<Integer, double> y1Map = new map<Integer, double>();
         map<Integer, double> y2Map = new map<Integer, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<Integer> productSet = new set<Integer>();
         
         Double runningTotalY1 = 0.0;
         Double runningTotalY2 = 0.0;
         
         if ( selectedDateVal == 'Previous Year / All Periods') {
         
             for(aggregateResult ar: [Select calendar_month(Sales_Date__c) Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR -1
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          GROUP BY rollup( calendar_month(Sales_Date__c) )
                                          ORDER BY calendar_month(Sales_Date__c) 
                                         ]) {
                                         
                y1Map.put(Integer.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(Integer.valueOf(ar.get('Name')));
                
             }
             
             for(aggregateResult ar: [Select calendar_month(Sales_Date__c) Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          GROUP BY rollup( calendar_month(Sales_Date__c) )
                                          ORDER BY calendar_month(Sales_Date__c) 
                                         ]) {
                                         
                y2Map.put(Integer.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(Integer.valueOf(ar.get('Name')));
                
             }
         
         }else{
         
             for(aggregateResult ar: [Select calendar_month(Sales_Date__c) Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR-1 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY rollup( calendar_month(Sales_Date__c) )
                                          ORDER BY calendar_month(Sales_Date__c) 
                                          
                                         ]) {
                                         
                y1Map.put(Integer.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(Integer.valueOf(ar.get('Name')));
                
             }
             
             for(aggregateResult ar: [Select calendar_month(Sales_Date__c) Name, sum( Net_Sales__c) netSales 
                                         From Sales__c s
                                          WHERE Year__c = :YEAR 
                                          AND Account__c IN :accountIds
                                          AND Product_Team__r.Name <> 'SAMPLES AND MISCELL'
                                          AND Limit_Prior_YTD_Full_Period__c = 1
                                          GROUP BY rollup( calendar_month(Sales_Date__c) )
                                          ORDER BY calendar_month(Sales_Date__c) 
                                          
                                         ]) {
                                         
                y2Map.put(Integer.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
                productSet.add(Integer.valueOf(ar.get('Name')));
                
             }
         
         
         }
        
        String previousYEAR = String.ValueOf(YEAR-1);
       
        string htmlTable = '<b>Sales by Period - cumulative</b><table class="slds-table slds-table_cell-buffer slds-table_bordered"  style="overflow: visible;">';
        htmlTable += '<thead>';

        htmlTable += '<tr class="slds-line-height_reset">';
        
        htmlTable += '<th class="" scope="col" width="60%">Month</th>';
        htmlTable += '<th class="" scope="col" width="40%">'+previousYEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="40%">'+YEAR+'</th>';
        htmlTable += '<th class="" scope="col" width="40%">% PY</th>';
        
        htmlTable += '</tr>';

        htmlTable += '</thead>';
        htmlTable += '<tbody>';

        list<Integer> productList = new List<Integer>(productSet);
        
        //productList.sort();
        for(Integer s : productList)
        {
            
            if(s != null)
            {
                //pieData.add(new PieWedgeData(s, Integer.ValueOf(y2Map.get(s)) ));
                
                htmlTable +='<tr>';
            
                if(y1Map.get(s) != null) {
                    htmlTable +='<td><div class="slds-truncate" title="Cloudhub">'+getMonthName(s)+'</div></td>';
                    
                    runningTotalY1 +=  y1Map.get(s);
                    
                    htmlTable +='<td align="right"> $'+ runningTotalY1.format() +'</td>';
                    
                }else{
                   htmlTable +='<td><div class="slds-truncate" title="Cloudhub">'+getMonthName(s)+'</div></td>';
                   htmlTable +='<td align="right">$0.00</td>';
                }
                   
                if(y2Map.get(s) != null) {
                   runningTotalY2 += y2Map.get(s);
                   
                }
                
                htmlTable +='<td align="right"> $'+ runningTotalY2.format() +'</td>';
                

                
                htmlTable +='<td  align="right"><b>'+Decimal.ValueOf(((runningTotalY2/runningTotalY1)*100)).setScale(1) +'%</b></td>';
                
                htmlTable +='</tr>';
                
            }
        }

        //htmlTable += '<tr>';
        //htmlTable += '<td><b>Totals:</b></td>';
        //htmlTable += '<td align="right"> <b>$'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )+'</b></td>';
        //htmlTable += '<td align="right"> <b>$'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</b></td>';
        //htmlTable += '<td align="left"></td>';
        //htmlTable += '</tr>';
        
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        htmlTable += '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<tbody>';
        htmlTable += '<tr>';
        htmlTable += '<td  scope="col" colspan="4">';
        htmlTable += '<div class="slds-grow slds-cell-wrap" style="font-size:80%">';
        htmlTable += 'This report and chart only reflects full / complete periods for this year compared to the same periods for the prior year.';
        htmlTable += '</div>';
        htmlTable += '</td>';
        htmlTable += '</tr>';
        htmlTable += '</tbody>';
        htmlTable += '</table>';
        
        return htmlTable;
                                    
    }
    public List<PieWedgeData> getPieData() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
        List<PieWedgeData> data = new List<PieWedgeData>();
        List<PieWedgeData> pieData = new List<PieWedgeData>();
        
        data.add(new PieWedgeData('CERAMIC MOSAICS', 1000));
        data.add(new PieWedgeData('COLORBODY PORCELAIN', 1000));
        data.add(new PieWedgeData('GLAZED FLOOR TILE', 1000));
        data.add(new PieWedgeData('GLAZED WALL TILE', 1000));
        data.add(new PieWedgeData('INSTALLATION PRODUCT', 1000));
        data.add(new PieWedgeData('NATURAL STONE TILE', 1000));
        
         Date d = System.today();
         Integer YEAR = d.Year();
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<string> productSet = new set<string>();

        
        for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                     From Sales__c s
                                    where Year__c = :YEAR 
                                      and Account__c = :accountId
                                      //and SalesType__c = 'T'
                                      and s.Product_Team__r.Name != null
                                    group by rollup(Product_Team__r.Name)
                                     order by Product_Team__r.Name])
        {
            y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
            productSet.add(String.valueOf(ar.get('Name')));
        }
       

        list<String> productList = new List<String>(productSet);
        
        productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '')
            {
                pieData.add(new PieWedgeData(s, Integer.ValueOf(y2Map.get(s)) ));
        
            }
       }   
       
       //pieData = data;
       //pieData.add(new PieWedgeData('test', 100));
       
       return pieData;  
    }

    // Wrapper class
    public class PieWedgeData {

        public String name { get; set; }
        public Integer data { get; set; }

        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }
    
    public String getMonthName(Integer m) {
      
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
    
}