public with sharing class AccountDashboardCtl {
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
    
    
    public AccountDashboardCtl(ApexPages.StandardController ctl)
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
                          , DW_ID__c
                       from account 
                      where Id = :((Account) ctl.getRecord()).id];

           parentAccount = a;
         allAccounts.add(a.Id);
        allAccountsString += '\''+a.Id+'\'';
        
        allAccountsString = '';
        
        Id parentId;
        
        // if(a.ParentId != null)
        //   parentId = a.ParentId;
        // else
        //   parentId = parentAccount.Id;
        
        // for(Account acct : [select SBU__c, Id 
        //                       from account 
        //                      where parentId = :parentId])
        // {
        //  allAccounts.add(acct.Id);
        //  allAccountsString += '\''+acct.Id+'\',';
        // }
         
        // allAccounts.add(parentId);
        // allAccountsString += '\''+parentId+'\'';
        
        events = initEvents();
        tasks = initTasks();
    }
    
    public string getObjectives()
    {
        string ol = '<ol>';
        for(Objective__c o : [Select o.SBU__c, o.Objective__c, o.Name 
                  From Objective__c o 
                 where SBU__c = :parentAccount.SBU__c
                 and Region__c = '' ])
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
                                 , e.Goals__c 
                                 , e.Primary_Objective__c
                                 , e.Secondary_Objective__c
                              From Event e
                            where (whatId in:allAccounts or whoId in :relatedContacts or whatId in :relatedOpptys)
                              and ActivityDateTime < TODAY
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
         for(Contact c : [select Id from COntact where AccountId in :allAccounts])
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
                                 , t.Goals__c
                              From Task t
                             where  (whatId in :allAccounts or whoId in :relatedContacts or whatId in :relatedOpptys)
                               and Task.Status = 'Completed'
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

        
        string htmlTable = '<table border="0" cellPadding="0" cellSpacing="0">';
        htmlTable += '<tr><td width ="100"></td><td align="center" width="100">Q-1</td><td align="center" width="100">Q-2</td><td align="center" width="100">Q-3</td><td align="center" width="100">Q-4</td><td align="right" width="150">Total&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>';
               
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;">'+ YEAR +'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+getQuarterTotal(YEAR,'Q1')+'</td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+getQuarterTotal(YEAR,'Q2')+'</td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+getQuarterTotal(YEAR,'Q3')+'</td>';
        htmlTable += '<td align="center" style="border-top:2px solid black;"> $'+getQuarterTotal(YEAR,'Q4')+'</td>';
        htmlTable += '<td align="right" style="border-top:2px solid black;"> $'+getQuarterTotal(YEAR,'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;">'+(YEAR-1)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q1')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q2')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q3')+'</td>';
        htmlTable += '<td align="center" > $'+getQuarterTotal((YEAR-1),'Q4')+'</td>';
        htmlTable += '<td align="right" > $'+getQuarterTotal((YEAR-1),'')+'</td></tr>';
        
        htmlTable +='<tr><td align="right" style="border-right:2px solid black;">'+(YEAR-2)+'&nbsp;&nbsp;&nbsp;</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q1')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q2')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q3')+'</td>';
        htmlTable += '<td align="center"> $'+getQuarterTotal((YEAR-2),'Q4')+'</td>';
        htmlTable += '<td align="right"> $'+getQuarterTotal((YEAR-2),'')+'</td></tr>';
        htmlTable += '</table>';
        return htmlTable;

    }
    
    public string getQuarterTotal(Integer year, String quarter)
    {
        Double total = 0;
        if(quarter == '')
        {
            for(aggregateResult ar: [Select sum( Net_Sales__c) netSales
                                       From Sales__c 
                                      where Year__c = :year
                                        and Account__c in :allAccounts
                                        //and SalesType__c = 'T'
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
                                        //and SalesType__c = 'T'
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
                                      //and SalesType__c = 'T'
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
                                      //and SalesType__c = 'T'
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
    
    
    
    public set<string> getDisplays()
    {
        set<string> displayset = new set<string>();
        for(Account a : [  select SBU__c
                                , Has_AO_Displays__c 
                                , Has_Displays__c
                                , Display_Types__c
                                , AO_Display_Types__c
                                , DISPLAY_Selection_Board_Choices__c 
                                , Display_Sub_Board_Choices__c
                                , AO_Feature_Panels__c
                                , AO_Feature_Panels1__c
                                , AO_Sub_SKI_Board_Choices__c
                             from account 
                            where Id in :allAccounts])
       {
        /*If any value was chosen for Display Selection Board Choices show the text "Display Selection Board Choices" with the values selected for (a).
          If any value was chosen for Display Sub Board Choices show the text "Display Sub Board Choices" with the values selected for (a).
          If any value was chosen for AO Feature Panels show the text "AO Feature Panels" with the values selected for (a).
          If any value was chosen for AO Display Sub/Ski Board Choices show the text "AO Display Sub/Ski Board Choices" with the values selected for (a)*/
          if(a.Display_Types__c != null)
             displayset.addAll(a.Display_Types__c.split(';'));
          
          if(a.AO_Display_Types__c != null)
             displayset.addAll(a.AO_Display_Types__c.split(';'));
          
          if(a.DISPLAY_Selection_Board_Choices__c != null )
            displayset.add('Display Selection Board Choices');
            
          if(a.Display_Sub_Board_Choices__c != null )
            displayset.add('Display Sub Board Choice');
            
          if(a.AO_Feature_Panels1__c != null )
            displayset.add('AO Feature Panels');
           
          if(a.AO_Feature_Panels__c != null )
            displayset.add('AO Display Sub/Ski Board Choices');
            
       }
       return displayset;
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
                                      //and SalesType__c = 'T'
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

}