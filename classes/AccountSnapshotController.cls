public class AccountSnapshotController {



    public Id accountId {get; set;}

    public Account acct{get; set;}
    
    public Boolean bolPrintableView {get;set;}


    public void init() {
     String strPrintableView = ApexPages.currentPage().getParameters().get('print');
     bolPrintableView = (strPrintableView == '1');
    }

    public AccountSnapshotController(ApexPages.StandardController stdController) {
    
        this.acct = (Account)stdController.getRecord();
        
        accountId = ApexPages.currentPage().getParameters().get('id');
        system.debug('###### '+accountId);
        
        String strPrintableView = ApexPages.currentPage().getParameters().get('print');
        bolPrintableView = (strPrintableView == '1');
        
    }
    
    public AccountSnapshotController() {
    
        String strPrintableView = ApexPages.currentPage().getParameters().get('print');
        bolPrintableView = (strPrintableView == '1');

    }
    
    //1 
    public List<Sales_Growth_Plan__c> getSalesGrowthPlan() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
    
        List<Sales_Growth_Plan__c> results = [SELECT Id, Objective_Name__r.Name, Status__c, LastActivityDate, LastModifiedDate
                                                FROM Sales_Growth_Plan__c
                                                WHERE Private__c <> true
                                                AND Status__c <> 'Successful'
                                                AND Status__c <> 'Failed'
                                                AND Account_Name__c = :accountId
                                                ORDER BY CreatedDate DESC
                                                LIMIT 5
                                                ];
        
        return results;
 
    }   
    
    public  List<Wrapper> getActivity() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
    
        
        
        wrappers = new List<Wrapper>();
        
        
        for (Task t : [Select Id, ActivityDate, Subject, WhatId, OwnerId, LastModifiedDate, Sales_Growth_Plan_Lookup__r.Name, Type,
                           Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name, Status,
                           (SELECT Relation.Name FROM TaskWhoRelations) 
                           FROM Task 
                           WHERE  (AccountId = :accountId OR whatId = :accountId )
                           AND (NOT Subject like 'Email: %')
                           ORDER BY createdDate desc 
                           LIMIT 5
                           ]) {
        
        
            String contactName = '';
            
            if ( t.TaskWhoRelations.size() > 0 ) {
                contactName = t.TaskWhoRelations[0].Relation.Name;
            }else{
                contactName = '';
            }
            
            //taskEventList.add(new eEventTTask(t.ActivityDate, t.Subject, t.WhatId, t.OwnerId, t.LastModifiedDate, t.Id));
            //wrappers.add(new Wrapper(t));
            wrappers.add(new Wrapper(t.ActivityDate, t.Subject, t.WhatId, t.OwnerId, t.LastModifiedDate, t.Id, t.Status, t.Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name, contactName));
        }
        
        for (Event e : [Select Id, ActivityDate, Subject, WhatId, OwnerId, LastModifiedDate, Sales_Growth_Plan_Lookup__r.Name,
                            Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name, 
                            (SELECT Relation.Name FROM EventWhoRelations)
                            From Event
                            WHERE (AccountId = :accountId OR whatId = :accountId )
                            ORDER BY createdDate desc 
                            LIMIT 5
                            ]) {
                            
            String contactName = '';
            
            if ( e.EventWhoRelations.size() > 0 ) {
                contactName = e.EventWhoRelations[0].Relation.Name;
            }else{
                contactName = '';
            }
            
            // taskEventList.add(new eEventTTask( e.ActivityDate, e.Subject, e.WhatId, e.OwnerId,e.LastModifiedDate, e.Id));
            //wrappers.add(new Wrapper(e));
            wrappers.add(new Wrapper(e.ActivityDate, e.Subject, e.WhatId, e.OwnerId, e.LastModifiedDate, e.Id, '', e.Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name, contactName));
        }
        
        wrappers.sort();
    
        return wrappers;
    
    }
   
    
    
    //New
    public class Wrapper implements Comparable {
    
       public Date activityDate { get; set;}
       public String subject { get; set; }
       public Id whatId { get; set; }
       public Id ownerId { get; set; }

       public DateTime lastModified { get; set;}
       public Id activityId { get; set;}
       
       public String status { get; set;}
       
       public String objective { get; set;}
       public String contact { get; set;}

        public Wrapper(Date VactivityDate, String Vsubject, Id VwhatId, Id VownerId, DateTime VlastModified, Id VactivityId , String Vstatus, String Vojective, String VContactName  ) {
        
            activityDate = VactivityDate;
            subject      = Vsubject;
            whatId       = VwhatId;
            ownerId      = VownerId;
            lastModified = VlastModified;
            activityId   = VactivityId;
            status       = Vstatus;
            objective    = Vojective;
            contact      = VContactName;
        }
        /*
        public Wrapper(Date VactivityDate, String Vsubject, Id VwhatId, Id VownerId, DateTime VlastModified, Id VactivityId , String Vstatus, String Vojective) {
        
            activityDate = VactivityDate;
            subject      = Vsubject;
            whatId       = VwhatId;
            ownerId      = VownerId;
            lastModified = VlastModified;
            activityId   = VactivityId;
            status       = Vstatus;
            objective    = Vojective;
            
        }
        */

        public Integer compareTo(Object other) {
        
            Wrapper that = (Wrapper)other;

            if (this.activityDate < that.activityDate) return 1;
            if (this.activityDate > that.activityDate) return -1;

            return 0;
            
        }
    }

    public List<Wrapper> wrappers { get; private set; }
    
    
    public list<Task> getTasks() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
    
            system.debug('JJJJJJJ '+accountId);
            
            list<Task> tasks = new list<Task>([SELECT Id, Subject, Status, ActivityDate, Sales_Growth_Plan_Lookup__r.Name, Type,
                                                Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name,
                                                (SELECT Relation.Name FROM TaskWhoRelations)
                                                FROM Task 
                                                WHERE  (AccountId = :accountId OR whatId = :accountId )
                                                AND (NOT Subject like 'Email: %')
                                                ORDER BY createdDate desc 
                                                LIMIT 5
                                                ]);

            
            system.debug('### Task Size: '+ tasks.size());
            return tasks;
    }
    
    public list<Event> getEvents() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
                
            list<Event> events = new list<Event>([ Select Subject, ActivityDateTime, Sales_Growth_Plan_Lookup__r.Name,
                                                      Sales_Growth_Plan_Lookup__r.Objective_Name__r.Name,
                                                      (SELECT Relation.Name FROM EventWhoRelations)
                                                      From Event
                                                      WHERE (AccountId = :accountId OR whatId = :accountId )
                                                      ORDER BY createdDate desc 
                                                      LIMIT 5
                                                       ]);

            
            system.debug('### Event Size: '+events.size());
              
            return events;
    }


    public string getSalesStatus() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
    
        Date d = System.today();
        Integer YEAR = d.Year();

        string htmlTable = '<table class="slds-table slds-table_cell-buffer slds-table_bordered">';
        htmlTable += '<thead>';
        
        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="PrintFont" scope="col">Year</td>';
        htmlTable += '<th class="PrintFont" scope="col">Q1</td>';
        htmlTable += '<th class="PrintFont" scope="col">Q2</td>';
        htmlTable += '<th class="PrintFont" scope="col">Q3</td>';
        htmlTable += '<th class="PrintFont" scope="col">Q4</td>';
        htmlTable += '<th class="PrintFont" scope="col">Total</td>';
        htmlTable += '</tr>';
               
        htmlTable += '</thead>';       
        htmlTable += '<tbody>';       
               
        htmlTable +='<tr><td align="right" class="PrintFont">'+ YEAR +'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal(YEAR,'Q1')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal(YEAR,'Q2')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal(YEAR,'Q3')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal(YEAR,'Q4')+'</td>';
        htmlTable += '<td align="right" class="PrintFont"> $'+getQuarterTotal(YEAR,'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right" class="PrintFont">'+(YEAR-1)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-1),'Q1')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-1),'Q2')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-1),'Q3')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-1),'Q4')+'</td>';
        htmlTable += '<td align="right" class="PrintFont"> $'+getQuarterTotal((YEAR-1),'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right" class="PrintFont">'+(YEAR-2)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-2),'Q1')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-2),'Q2')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-2),'Q3')+'</td>';
        htmlTable += '<td align="center" class="PrintFont"> $'+getQuarterTotal((YEAR-2),'Q4')+'</td>';
        htmlTable += '<td align="right" class="PrintFont"> $'+getQuarterTotal((YEAR-2),'')+'</td></tr>';
        
        htmlTable += '</tbody>'; 
        
        htmlTable += '</table>';
        return htmlTable;

    }
    
    public string getQuarterTotal(Integer year, String quarter)
    {
        accountId = ApexPages.currentPage().getParameters().get('id');
        
        Double total = 0;
        if(quarter == '')
        {
            for(aggregateResult ar: [Select sum( Net_Sales__c) netSales
                                       From Sales__c 
                                      where Year__c = :year
                                        and Account__c = :accountId
                                        and prod_team_code__c <> '0031'
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
            for(aggregateResult ar: [Select sum( Net_Sales__c) netSales
                                       From Sales__c 
                                      where Year__c = :year
                                        and Account__c = :accountId
                                        and prod_team_code__c <> '0031'
                                        and Quarter__c = :quarter])
            {
                if(Double.valueOf(ar.get('netSales')) == null)
                  total= 0;
                else
                  total= Double.valueOf(ar.get('netSales'));
            }
        }
        return total.format();
    }


    //YTD Product Mix
    public string getYtdSalesGrid()
    {
    
        accountId = ApexPages.currentPage().getParameters().get('id');
        
         Date d = System.today();
         Integer YEAR = d.Year();
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<string> productSet = new set<string>();
         for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                     From Sales__c s
                                    where Year__c >= :YEAR - 1
                                      and Year__c < :YEAR 
                                      and Account__c = :accountId
                                      and prod_team_code__c <> '0031'
                                      and s.Product_Team__r.Name != null
                                    group by rollup(Product_Team__r.Name)
                                     order by Product_Team__r.Name])
        {
            y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
            productSet.add(String.valueOf(ar.get('Name')));
        }
        
        for(aggregateResult ar: [Select s.Product_Team__r.Name , sum( Net_Sales__c) netSales 
                                     From Sales__c s
                                    where Year__c = :YEAR 
                                      and Account__c = :accountId
                                      and prod_team_code__c <> '0031'
                                      and s.Product_Team__r.Name != null
                                    group by rollup(Product_Team__r.Name)
                                     order by Product_Team__r.Name])
        {
            y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
            productSet.add(String.valueOf(ar.get('Name')));
        }
       
        string htmlTable = '<table class="slds-table slds-table_cell-buffer slds-table_bordered"  style="overflow: visible;">';
        htmlTable += '<thead>';

        htmlTable += '<tr class="slds-line-height_reset">';
        htmlTable += '<th class="PrintFont" scope="col" width="45%">Product Mix</th>';
        htmlTable += '<th class="PrintFont" scope="col" width="20%">Prior</th>';
        htmlTable += '<th class="PrintFont" scope="col" width="20%">Current</th>';
        htmlTable += '<th class="PrintFont" scope="col" width="15%">YTD %</th>';
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
                   htmlTable +='<tr><td class="PrintFont"><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right" class="PrintFont"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                else
                   htmlTable +='<tr><td class="PrintFont"><div class="slds-truncate" title="Cloudhub">'+s+'</div></td><td align="right" class="PrintFont">$0.00</td>';
                if(y2Map.get(s) != null)
                   htmlTable +='<td align="right" class="PrintFont"> $'+ (y2Map.get(s)==null ? '0.00' : y2Map.get(s).format() )+'</td><td  align="right" class="PrintFont"><b>'+Decimal.ValueOf(((y2Map.get(s)/y2Map.get(null))*100)).setScale(1) +'%</b></td></tr>';
                else
                   htmlTable +='<td align="right" class="PrintFont"></td><td  align="right" class="PrintFont">$0.00</td></tr>';
                   
                   
            }
        }

        htmlTable += '<tr>';
        htmlTable += '<td class="PrintFont"><b>Totals:</b></td>';
        htmlTable += '<td align="right" class="PrintFont"> <b>$'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )+'</b></td>';
        htmlTable += '<td align="right" class="PrintFont"> <b>$'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</b></td>';
        htmlTable += '<td align="left" class="PrintFont"></td>';
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
                                      and prod_team_code__c <> '0031'
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
    
    

    public List<Opportunity> getOpportunitiesClosedWon() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');

        List<Opportunity> oppresults = [Select Id,CloseDate,Amount,StageName,Name 
                                            from Opportunity 
                                            where IsClosed = True
                                            AND IsWon = True
                                            AND Id IN (SELECT Opportunity__c FROM Related_Customer__c WHERE Won_Bid__c = true AND Related_Account__c = :accountId )
                                            ORDER BY CloseDate DESC 
                                            LIMIT 5

                                            ];

        return oppresults;

    }

    public List<Opportunity> getOpportunitiesOpen() {
    
        accountId = ApexPages.currentPage().getParameters().get('id');

        List<Opportunity> oppresults = [Select Id,CloseDate,Amount,StageName,Name 
                                            from Opportunity 
                                            where IsClosed = false
                                            AND IsWon = false
                                            AND Id IN (SELECT Opportunity__c FROM Related_Customer__c WHERE Related_Account__c = :accountId )
                                            ORDER BY CloseDate DESC 
                                            LIMIT 5 
                                            ];

        return oppresults;

    }
     
    
}