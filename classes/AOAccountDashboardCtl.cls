public with sharing class AOAccountDashboardCtl {

public Account parentAccount{get;set;}
    public list<Id> allAccounts = new list<id>();
    public boolean showTasks{get;set;}
    public boolean showEvents{get;set;}
    public string allAccountsString{get;set;}
    public Integer LASTYEAR{get;set;}
    public Integer YEAR{get;set;}
    public list<Event>events{get;set;}
    public list<Task>tasks{get;set;}
    
    set<Id>relatedContacts = new set<Id>();
    set<Id>relatedOpptys = new set<Id>();
    
    public AOAccountDashboardCtl(ApexPages.StandardController ctl)
    {
        showTasks = true;
        showEvents = true;
        Date d = System.today();
        LASTYEAR = d.Year() -1;
        YEAR = d.Year();
        
        Account a = [select SBU__c
                          , id
                          , Name
                          , Customer_Base__c
                          , Owner.Name
                          , ParentId
                          , Has_AO_Displays__c 
                          , Has_Displays__c
                          , Display_Types__c
                          , AO_Display_Types__c
                          , Region__c
                       from account 
                      where Id = :((Account) ctl.getRecord()).id];
        
        if(a.parentId != null)
            for(Account ap :  [select SBU__c
                                    , id
                                    , Name
                                    , Customer_Base__c
                                    , Owner.Name
                                    , ParentId
                                    , Has_AO_Displays__c 
                                    , Has_Displays__c
                                    , Display_Types__c
                                    , AO_Display_Types__c 
                                    , Region__c
                                 from account 
                                where Id = :a.parentId])
              parentAccount = ap;
        
        if(parentAccount == null)
           parentAccount = a;
        
        allAccountsString = '';
        
        Id parentId;
        
        if(a.ParentId != null)
           parentId = a.ParentId;
        else
           parentId = parentAccount.Id;
        
        for(Account acct : [select SBU__c, Id 
                              from account 
                             where parentId = :parentId])
        {
         allAccounts.add(acct.Id);
         allAccountsString += '\''+acct.Id+'\',';
        }
         
        allAccounts.add(parentId);
        allAccountsString += '\''+parentId+'\'';
        
        events = initEvents();
        tasks = initTasks();
    }
    
    public string getObjectives()
    {
        
        string ol = '<ol>';
        for(Objective__c o : [Select o.SBU__c, o.Objective__c, o.Name 
                  From Objective__c o 
                 where Region__c = :parentAccount.Region__c])//Need to Clarify how to filter on Account.Customer_Region_Name__c
           ol +='<li>'+o.objective__c+'</li>';
           
        ol +='</ol>';
        return ol;
        
    }
    
    public list<Event> initEvents()
    {
            for(Contact c : [select Id from COntact where AccountId in :allAccounts])
                relatedContacts.add(c.Id);
                for(Opportunity o : [select Id from Opportunity where AccountId in :allAccounts])
                   relatedOpptys.add(o.Id);
                   
            Integer cnt = 0;
            list<Event> events = new list<Event>();
            for(Event e : [ Select e.Subject
                                 , e.StartDateTime
                                 , e.Owner.Name
                                 , e.Id
                                 , e.ActivityDateTime 
                                 , e.Primary_Objective__c
                                 , e.Secondary_Objective__c
                                 , e.Who.Name
                              From Event e
                            where (whatId in:allAccounts or whoId in :relatedContacts or whatId in :relatedOpptys)
                              and ActivityDateTime < TODAY
                              and Type__c = 'Face To Face'
                            order by createdDate desc 
                            ])
            {
                if(cnt == 5)
                  continue;
                  
                events.add(e);
                cnt ++;
            }
            
            if(events.size() < 1)
              showEvents = false;
            else
              showEvents = true;
              
            return events;
    }
    
    public list<Task> initTasks()
    {
         for(Contact c : [select Id from Contact where AccountId in :allAccounts])
                relatedContacts.add(c.Id);
         for(Opportunity o : [select Id from Opportunity where AccountId in :allAccounts])
           relatedOpptys.add(o.Id);
           
        
        Integer cnt = 0;
            list<Task> tasks = new list<Task>();
            for(Task t : [  Select t.Subject
                                 , t.Status
                                 , t.Owner.Name
                                 , t.ActivityDate 
                                 , t.Primary_Objective__c
                                 , t.Secondary_Objective__c
                                 , t.Who.Name
                              From Task t
                             where  (whatId in :allAccounts or whoId in :relatedContacts or whatId in :relatedOpptys)
                               and Task.Status = 'Completed'
                               and Type__c = 'Face To Face'
                            order by createdDate desc 
                            ])
            {
                
                
                if(cnt == 5)
                  continue;
                  
                tasks.add(t);
                cnt ++;
            }
            
            if(tasks.size() < 1)
              showTasks = false;
            else
              showTasks = true;
             
            return tasks;
    }
    
    public string getSalesStatus()
    {
        Date d = System.today();
        Integer YEAR = d.Year();
        list<Double> qTotal = new list<Double>();
        qTotal.add(getQuarterTotal(YEAR,'Q1'));
        qTotal.add(getQuarterTotal(YEAR,'Q2'));
        qTotal.add(getQuarterTotal(YEAR,'Q3'));
        qTotal.add(getQuarterTotal(YEAR,'Q4'));
        qTotal.add(getQuarterTotal(YEAR,''));
        
        
        qTotal.add(getQuarterTotal((YEAR-1),'Q1'));
        qTotal.add(getQuarterTotal((YEAR-1),'Q2'));
        qTotal.add(getQuarterTotal((YEAR-1),'Q3'));
        qTotal.add(getQuarterTotal((YEAR-1),'Q4'));
        qTotal.add(getQuarterTotal((YEAR-1),''));
                
        qTotal.add(getQuarterTotal((YEAR-2),'Q1'));
        qTotal.add(getQuarterTotal((YEAR-2),'Q2'));
        qTotal.add(getQuarterTotal((YEAR-2),'Q3'));
        qTotal.add(getQuarterTotal((YEAR-2),'Q4'));
        qTotal.add(getQuarterTotal((YEAR-2),''));
        
        list<Integer> qPercent = new list<Integer>();
        if(qTotal.get(5) != null && qTotal.get(5) > 0)
          qPercent.add(Integer.ValueOf(qTotal.get(0)/qTotal.get(5) * 100));
        else
           qPercent.add(0);
        if(qTotal.get(5) != null && qTotal.get(6) > 0)
          qPercent.add(Integer.ValueOf(qTotal.get(1)/qTotal.get(6) * 100));
        else
           qPercent.add(0);
        if(qTotal.get(5) != null && qTotal.get(7) > 0)
          qPercent.add(Integer.ValueOf(qTotal.get(2)/qTotal.get(7) * 100));
        else
           qPercent.add(0);
        if(qTotal.get(5) != null && qTotal.get(8) > 0)
          qPercent.add(Integer.ValueOf(qTotal.get(3)/qTotal.get(8) * 100));
        else
           qPercent.add(0);
        if(qTotal.get(5) != null && qTotal.get(9) > 0)
          qPercent.add(Integer.ValueOf(qTotal.get(4)/qTotal.get(9) * 100));
        else
           qPercent.add(0);
        
        
        
        string htmlTable = '<table border="0" cellPadding="0" cellSpacing="0" >';
        htmlTable += '<tr><td width ="100"></td><td align="center" width="100">Q-1</td><td/><td align="center" width="100">Q-2</td><td/><td align="center" width="100">Q-3</td><td/><td align="center" width="100">Q-4</td><td/><td align="right" width="150">Total </td><td/></tr>';
         
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;" style="border-top:2px solid black;">'+YEAR+'   </td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+qTotal.get(0).format()+'</td><td style="border-top:2px solid black;"> '+qPercent.get(0)+'% </td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+qTotal.get(1).format()+'</td><td style="border-top:2px solid black;"> '+qPercent.get(1)+'% </td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+qTotal.get(2).format()+'</td><td style="border-top:2px solid black;"> '+qPercent.get(2)+'% </td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+qTotal.get(3).format()+'</td><td style="border-top:2px solid black;"> '+qPercent.get(3)+'% </td>';
        htmlTable += '<td align="right" style="border-top:2px solid black;"> $'+Decimal.ValueOf(qTotal.get(4)).setScale(2).format()+'</td><td style="border-top:2px solid black;">  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+qPercent.get(4)+'%</td></tr>';
        
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;">'+(YEAR-1)+'   </td>';
        htmlTable += '<td align="center" > $'+qTotal.get(5).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(6).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(7).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(8).format()+'</td><td/>';
        htmlTable += '<td align="right" > $'+qTotal.get(9).format()+'</td><td/></tr>';
               
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;">'+(YEAR-2)+'   </td>';
        htmlTable += '<td align="center" > $'+qTotal.get(10).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(11).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(12).format()+'</td><td/>';
        htmlTable += '<td align="center"> $'+qTotal.get(13).format()+'</td><td/>';
        htmlTable += '<td align="right" > $'+qTotal.get(14).format()+'</td><td/></tr>';
        
        
        htmlTable += '</table>';
        return htmlTable;
    }
    
    public double getQuarterTotal(Integer year, String quarter)
    {
        Double total = 0;
        if(quarter == '')
        {
            for(aggregateResult ar: [Select sum( Net_Sales__c) netSales
                                       From Sales__c 
                                      where Year__c = :year
                                        and Account__c in :allAccounts
                                        and SalesType__c = 'T'
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
                                        and Account__c in :allAccounts
                                        and SalesType__c = 'T'
                                        and Quarter__c = :quarter])
            {
                if(Double.valueOf(ar.get('netSales')) == null)
                  total= 0;
                else
                  total= Double.valueOf(ar.get('netSales'));
            }
        }
        return total;
    }
    
    public string getYtdSalesGrid()
    {  
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
                                      and Account__c in :allAccounts
                                      and SalesType__c = 'T'
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
                                      and Account__c in :allAccounts
                                      and SalesType__c = 'T'
                                      and s.Product_Team__r.Name != null
                                    group by rollup(Product_Team__r.Name)
                                     order by Product_Team__r.Name])
        {
            y2Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
            productSet.add(String.valueOf(ar.get('Name')));
        }
       
        string htmlTable = '<table border="0" cellspacing="3" width="400" ><tr><td colspan="4" style="font-weight:bold; color:white; background-color:darkred;">YTD Product Mix</td></tr>';
        htmlTable += '<tr><td><b><u>Product Mix</u></b></td><td align="right"><b><u>'+(YEAR-1)+'</u></b></td><td  align="right"><b><u>'+YEAR+'</u></b></td><td align="right"><b><u>YTD %</u></b></td></tr>';
        list<String> productList = new List<String>(productSet);
        
        productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '')
            {
                if(y1Map.get(s) != null)
                   htmlTable +='<tr><td>'+s+'</td><td align="right"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                else
                   htmlTable +='<tr><td>'+s+'</td><td align="right">$0.00</td>';
                if(y2Map.get(s) != null)
                   htmlTable +='<td align="right"> $'+ (y2Map.get(s)==null ? '0.00' : y2Map.get(s).format() )+'</td><td  align="right"><b>'+Decimal.ValueOf(((y2Map.get(s)/y2Map.get(null))*100)).setScale(1) +'%</b></td></tr>';
                else
                   htmlTable +='<td align="right"></td><td  align="right">$0.00</td></tr>';
            }
        }
        htmlTable += '<tr><td colspan="4"><hr/></td></tr>';
        htmlTable += '<tr><td></td><td align="right"> $'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )
                                                     +'</td><td align="right"> $'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</td><td align="left"></td></tr>';
        htmlTable += '</table>';
        
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''+productSet) );
        
        return htmlTable;
                                    
    }
    
    public string getYtdSalesByProduct()
    {  
         Date d = System.today();
         Integer YEAR = d.Year();
         map<string, double> y1Map = new map<string, double>();
         map<string, double> y2Map = new map<string, double>();
         Integer Y1_Total;
         Integer Y2_Total;
         set<string> productSet = new set<string>();
         for(aggregateResult ar: [Select s.Product__r.Name , sum( Net_Sales__c) netSales 
                                     From Sales__c s
                                    where CALENDAR_YEAR(s.Sales_Date__c) = :YEAR 
                                      //and s.Account__c in :allAccounts
                                      and s.Customer_Base__c = :parentAccount.Customer_Base__c 
                                      and SalesType__c = 'T'
                                      and s.Product_Team__r.Name != null
                                      and Product__r.New_Product__c = true
                                    group by rollup(Product__r.Name)
                                     order by Product__r.Name])
        {
            y1Map.put(String.valueOf(ar.get('Name')), Double.valueOf(ar.get('netSales')));
            productSet.add(String.valueOf(ar.get('Name')));
        }
        
        
       
        string htmlTable = '<table border="0" cellspacing="3" width="400" ><tr><td colspan="4" style="font-weight:bold; color:white; background-color:darkred;">YTD New Product Sales</td></tr>';
        //htmlTable += '<tr><td><b><u>Product Mix</u></b></td><td align="right"><b><u>'+(YEAR-1)+'</u></b></td><td  align="right"><b><u>'+YEAR+'</u></b></td><td align="right"><b><u>YTD %</u></b></td></tr>';
        list<String> productList = new List<String>(productSet);
        
        productList.sort();
        for(String s : productList)
        {
            
            if(s != null && s.trim() !='null' && s.trim() != '')
            {
                if(y1Map.get(s) != null)
                   htmlTable +='<tr><td>'+s+'</td><td align="right"> $'+ (y1Map.get(s)==null ? '0.00' : y1Map.get(s).format() )+'</td>';
                else
                   htmlTable +='<tr><td>'+s+'</td><td align="right"> - </td>';
                
            }
        }
        htmlTable += '<tr><td colspan="4"><hr/></td></tr>';
        //htmlTable += '<tr><td></td><td align="right"> $'+ (y1Map.get(null)==null ? '0.00' : y1Map.get(null).format() )
        //                                              +'</td><td align="right"> $'+ (y2Map.get(null)==null ? '0.00' : y2Map.get(null).format() )+'</td><td align="left"></td></tr>';
        htmlTable += '</table>';
        
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''+productSet) );
        
        return htmlTable;
                                    
    }
    
    
    
    
    public String getImageId()
    {
        return AccountDashboardGBUImage__c.getInstance(parentAccount.SBU__c).Document_Id__c;
        //'0F0K00000004CaE';//[select Id from Attachment where Attachment.ParentId = '015K00000000YSe'].Id;
    }
    
    public String getAoLogoId()
    {
        return AOAccountDashboardLogo__c.getInstance('Logo').Document_Id__c;
        //'0F0K00000004CaE';//[select Id from Attachment where Attachment.ParentId = '015K00000000YSe'].Id;
    }

}