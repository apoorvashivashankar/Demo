@isTest(SeeAllData=true)
private class TaskCreator_Test {


    public static testmethod void TaskCreator_Test() {
    
        Task_Creator__c newTaskCreator = new Task_Creator__c();
        
        newTaskCreator.Account_Name_Begins_With__c = 'A;';
        newTaskCreator.ProExchange_Member__c       = 'Exclude';
        newTaskCreator.YTD_Sales_Greater_Than__c   = 50000;

        insert newTaskCreator;
        
        Id taskCreationId = newTaskCreator.Id;
        
        TaskCreator.createTasks(taskCreationId);
        
        TaskCreator.getAccounts(taskCreationId);
        
        TaskCreator.reverseTaskCreation(taskCreationId);
        
        newTaskCreator.Rating__c                         = 'A - Weekly';
        newTaskCreator.My_Team_Accounts__c               = true;
        newTaskCreator.Prior_Year_Sales_Greater_Than__c  = 1;
        newTaskCreator.Prior_Year_Sales_Less_Than__c     = 1;
        newTaskCreator.Auto_Updates__c                   = True;
        newTaskCreator.Business_Type__c                  = 'Builder';
        newTaskCreator.Account_Record_Type__c            = 'Customer Account';
        newTaskCreator.Group_Name_Contains__c            = 'a';
        newTaskCreator.Owner_Role_Contains__c            = 'a';
        
        update newTaskCreator;

        TaskCreator.builSOQL( newTaskCreator ); 
        

        
    }

}