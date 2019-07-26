public with sharing class TaskCreatorGateway {

    public static boolean hasCriteria     = false;



    public static void processTaskCreator( List <Task_Creator__c> listTaskCreator ) {
    
        for (Task_Creator__c currentRecord : listTaskCreator) {
        
        
            String strSOQL    = builSOQL(currentRecord);
            
            
            if ( ! hasCriteria ) {
            
                currentRecord.addError('You must add one criteria to save the record.');
                return;
                
            }
            
    
            List<Account> taskAccounts = Database.query(strSOQL);
            
            currentRecord.Tasks_To_Be_Created__c = taskAccounts.Size();
            
            strSOQL                              = strSOQL.Left(131072);
            
            currentRecord.SOQL__c                = strSOQL;
            
            if (taskAccounts.Size() >= 701) {
            
                currentRecord.addError('The number of tasks cannot exceed 700 at one time. Please limit the data more using the filters. Ex. Account name starts with A,B,C.');
                return;
                
            }
            
            Task_Creator__c oldRecord;
            
            if (Trigger.IsUpdate) {
            
                oldRecord = (Task_Creator__c) Trigger.oldMap.get( currentRecord.Id );
                
            }
            
            if (Trigger.IsUpdate && currentRecord.tasksCreate__c == true && oldRecord.tasksCreate__c == false ) {
            
                Integer iCreatedCount = 0;
                
                if ( taskAccounts.Size() == 0 ) {
                
                }else{
                    List<Task> createTasks = new List<Task>();
                    
                    
                    
                    for ( Account currentAccount : taskAccounts ) {
                    
                        iCreatedCount = iCreatedCount + 1;
                    
                        Task t            = new Task();
                        t.OwnerId         = currentAccount.OwnerId;
                        t.Subject         = currentRecord.Task_Subject__c;
                        t.Description     = currentRecord.Task_Description__c;
                        t.ActivityDate    = currentRecord.Task_Due_Date__c;
                        t.Goals__c        = currentRecord.Task_Goals__c;
                        t.Status          = 'Not Started';
                        t.Priority        = 'High';
                        t.RecordTypeID    = '012F0000000mpvW';
                        t.Type__c         = 'Face To Face';
                        t.Type            = 'Face To Face';
                        t.WhatId          = currentAccount.Id;
                        t.Task_Creator__c = currentRecord.Id;
                        
                        createTasks.add(t);
                        
                        if (createTasks.size() == 200) {
                        
                            insert createTasks;
                            createTasks.clear();
                        
                        }
                        
                
                    }
                
                    if (createTasks.size() > 0) {
                        
                        insert createTasks;
                        createTasks.clear();
                        
                    }
                
                }
                
                currentRecord.tasksCreate__c   = false;
                currentRecord.Tasks_Created__c = iCreatedCount; 
                currentRecord.Status__c        = 'Completed'; 

            }else if (Trigger.IsUpdate && currentRecord.tasksReverse__c == true && oldRecord.tasksReverse__c == false ) {
            
                Set<Id> deleteIds = new Set<Id>();
                
                Task[] tasks = [Select id FROM Task WHERE Status = 'Not Started' AND Task_Creator__c = :currentRecord.Id LIMIT 200];
                
                delete tasks;
                
                tasks = [Select id FROM Task WHERE Status = 'Not Started' AND Task_Creator__c = :currentRecord.Id LIMIT 200];
                
                delete tasks;
                
                tasks = [Select id FROM Task WHERE Status = 'Not Started' AND Task_Creator__c = :currentRecord.Id LIMIT 200];
                
                delete tasks;
                
                tasks = [Select id FROM Task WHERE Status = 'Not Started' AND Task_Creator__c = :currentRecord.Id LIMIT 200];
                
                delete tasks;
                    
                currentRecord.tasksReverse__c  = false;
                currentRecord.Tasks_Created__c = 0; 
                currentRecord.Status__c        = 'Creating Tasks'; 
                
            }
            
        }
    
    }
    
   public static String buildPickListMultiQuery ( String picklistValues) {
    
        List<String> vals = picklistValues.split(';');
    
        string condition = '';
    
        for(string val : vals) {
    
           condition += ',\'' + val + '\'';
    
        }
    
        condition = condition.substring(1, condition.length() );

    
        return condition;
    }
    
    public static String builSOQL( Task_Creator__c currentRecord ) {
        
        String soql;
        
        soql = 'SELECT Id, OwnerId FROM ACCOUNT WHERE IsDeleted = False ';
        
        //Account Name Begins With
        if (currentRecord.Account_Name_Begins_With__c <> Null) {
        
            hasCriteria = true;
            
            List<String> vals = currentRecord.Account_Name_Begins_With__c.split(';');
            
            soql += 'AND ( ';
            
            for(string val : vals) {
        
               soql += 'Name LIKE \'' + val + '%\' OR ';
        
            }
            
            soql = soql.substring(0, soql.length() - 4 );
            
            soql += ')';
        
        }
        
        //Group Name
        if (currentRecord.Group_Name_Contains__c <> Null) {
        
            hasCriteria = true;
                        
            String tempSOQL = 'SELECT Account_Name__c FROM GroupAccount__c WHERE GroupNAME__c LIKE \'%'+currentRecord.Group_Name_Contains__c+'%\'';
        
            List<GroupAccount__c> accountGroups =  Database.query(tempSOQL);
            
            if ( accountGroups.Size() == 0 ) {
            
            }else{
            
                soql += ' AND ( ';

                for ( GroupAccount__c currentGroupAccount : accountGroups ) {
                
                   soql += 'Id = \'' + currentGroupAccount.Account_Name__c + '\' OR ';
                
                }
                
                soql = soql.substring(0, soql.length() - 4 );
                
                soql += ')';
            
            }
            
        }
        
        //Custom Type
        if (currentRecord.Customer_Type__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Customer_Type__c = \''+currentRecord.Customer_Type__c+'\'';
        }
        
        //YTD Sales Greater Than
        if (currentRecord.YTD_Sales_Greater_Than__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND YTD_Sales__c > '+currentRecord.YTD_Sales_Greater_Than__c+''; 
        }
        
        //YTD Sales Less Than
        if (currentRecord.YTD_Sales_Less_Than__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND YTD_Sales__c < '+currentRecord.YTD_Sales_Less_Than__c+''; 
        }
        
        //Prior Year Sales Greater Than
        if (currentRecord.Prior_Year_Sales_Greater_Than__c <> Null) {
        
            hasCriteria = true;
            
            soql += 'AND Prior_YTD_Sales__c > '+currentRecord.Prior_Year_Sales_Greater_Than__c+''; 
        }
        
        //Prior Year Sales Less Than
        if (currentRecord.Prior_Year_Sales_Less_Than__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Prior_YTD_Sales__c < '+currentRecord.Prior_Year_Sales_Less_Than__c+''; 
        }
        
        //Owner Role
        if (currentRecord.Owner_Role_Contains__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Owner.UserRole.Name LIKE \'%'+currentRecord.Owner_Role_Contains__c+'%\' ';

        }
        
        //SSC Number
        if (currentRecord.SSC_Number__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND SSC__c = \''+currentRecord.SSC_Number__c+'\''; 
        }
        
        //Customer Type
        if (currentRecord.Customer_Type__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Customer_Type__c = \''+currentRecord.Customer_Type__c+'\''; 
        }
        
        //ProExchange Member
        if (currentRecord.ProExchange_Member__c != Null) {
        
            hasCriteria = true;
            if (currentRecord.ProExchange_Member__c == 'Include') {
                soql += ' AND Communities_Member__c = true';
            }else{
                soql += ' AND Communities_Member__c = false';
            }
            
        }
        
        //Custom Class
        if (currentRecord.Customer_Class__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Customer_Class__c = \''+currentRecord.Customer_Class__c+'\''; 
        }
        
        //Auto-Updates
        if (currentRecord.Auto_Updates__c == true) {
        
            hasCriteria = true;
            
            soql += ' AND Auto_Updates__c = true'; 
        }
        
        //Rating
        if (currentRecord.Rating__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Rating = \''+currentRecord.Rating__c.left(1)+'\''; 
        }
        
        //Exclude Project Acct
        if (currentRecord.Project_Acct__c == true) {
        
            hasCriteria = true;
            
            soql += ' AND Project_Acct__c <> true'; 
        }
        
        //Division Name
        if (currentRecord.Division_Name__c <> Null) {
        
            hasCriteria = true;
            
            soql += ' AND Division_Name__c = \''+currentRecord.Division_Name__c+'\''; 
        }
        
        //Exclude Mark For Deletion
        if (currentRecord.Mark_For_Deletion__c == true) {
        
            hasCriteria = true;
            
            soql += ' AND Mark_For_Deletion__c <> true'; 
        }
        
        //My Teams Accounts
        if (currentRecord.My_Team_Accounts__c == true) {
        
            hasCriteria = true;
            
            String currentUserRoleId = UserInfo.getUserRoleId();
            
            if (currentUserRoleId <> '') {
            
                Set<Id> userIdSet = new Set<Id>();
                userIdSet.add(currentUserRoleId);
                
                Set<ID> myTeamOwnerIds = getAllSubRoleIds(userIdSet);
                
                myTeamOwnerIds.add( UserInfo.getUserRoleId() );
                
                soql += ' AND Owner.UserRoleId IN ( ';
                
                for (Id roleId : myTeamOwnerIds ) {
                
                    soql += '\''+roleId+'\',';
                    
                }
                
                soql = soql.substring(0, soql.length() - 1 );
                
                soql += ')';
            
            }
            
        }
        
        //Exclude Account Record Type
        if (currentRecord.Account_Record_Type__c <> Null) {
        
            hasCriteria = true;
            
            List<String> vals = currentRecord.Account_Record_Type__c.split(';');
            
            soql += ' AND ( ';
            
            for(string val : vals) {
        
               soql += 'RecordType.Name <> \'' + val + '\' AND ';
        
            }
            
            soql = soql.substring(0, soql.length() - 5 );
            
            soql += ')';
        
        }
        
        //Business Type
        if (currentRecord.Business_Type__c <> Null) {
        
            hasCriteria = true;
            
            List<String> vals = currentRecord.Business_Type__c.split(';');
            
            soql += ' AND ( ';
            
            for(string val : vals) {
        
               soql += 'Business_Type__c = \'' + val + '\' OR ';
        
            }
            
            soql = soql.substring(0, soql.length() - 4 );
            
            soql += ')';
        
        }
        
        system.debug('######' + soql );
        
        return soql;
        
    }
    
    // To get all sub roles.
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
    
        // get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id from UserRole where ParentRoleId 
             IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }
    
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
    
        return currentRoleIds;
    }
    // To get all Parent Roles.
    public static Set<ID> getParentRoleId(Set<ID> roleIds) {

        Set<ID> currentRoleIds = new Set<ID>();
    
        
        // get all of the parent roles.
        for(UserRole ur :[select Id, ParentRoleId from UserRole where Id IN: roleIds]) {
            currentRoleIds.add(ur.ParentRoleId);
        }
    
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getParentRoleId(currentRoleIds));
        }
    
        return currentRoleIds;
    }    

}