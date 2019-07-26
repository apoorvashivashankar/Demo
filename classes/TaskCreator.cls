public class TaskCreator {

    public static boolean hasCriteria     = false;

    @AuraEnabled
    public static Task_Creator__c reverseTaskCreation(Id taskCreationId) {
    
        if( taskCreationId != null) {
        
            Task_Creator__c tc = [SELECT tasksReverse__c FROM Task_Creator__c WHERE Id = :taskCreationId ];
            tc.tasksReverse__c = true;

            update tc;
            return tc;
            
        }
        
        return null;
        
    }
    
    @AuraEnabled
    public static Task_Creator__c createTasks(Id taskCreationId) {
    
        if( taskCreationId != null) {
        
            Task_Creator__c tc = [SELECT tasksCreate__c FROM Task_Creator__c WHERE Id = :taskCreationId ];
            tc.tasksCreate__c = true;

            update tc;
            return tc;
            
        }
        
        return null;
        
    }
    

    @AuraEnabled
    public static List <Account> getAccounts(Id recordID) {
    
        Task_Creator__c taskCreator = [SELECT Id, Account_Name_Begins_With__c, Group_Name_Contains__c,
                                        Customer_Type__c, YTD_Sales_Greater_Than__c, YTD_Sales_Less_Than__c,
                                        Prior_Year_Sales_Greater_Than__c, Prior_Year_Sales_Less_Than__c,
                                        Owner_Role_Contains__c, SSC_Number__c, ProExchange_Member__c,
                                        Customer_Class__c, Auto_Updates__c, Rating__c, Project_Acct__c, Division_Name__c,
                                        Mark_For_Deletion__c, My_Team_Accounts__c, Account_Record_Type__c, Business_Type__c
                                        FROM Task_Creator__c WHERE Id = :recordId];
    
        String strSOQL = builSOQL( TaskCreator ) ;     
    
        return Database.query(strSOQL);
        
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
    
    public static String builSOQL( Task_Creator__c currentRecord ) {
        
        String soql;
        
        soql = 'SELECT Id, OwnerId, Name, Owner.Name, DW_ID__c, SSC__r.Name, ShippingCity, Division__c FROM ACCOUNT WHERE IsDeleted = False ';
        
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
    
}