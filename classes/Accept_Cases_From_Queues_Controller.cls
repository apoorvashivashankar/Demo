public with sharing class Accept_Cases_From_Queues_Controller {
    private final case mysObject;
    List<Case> listOfCasesToUpdate {get; set;}
    
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public Accept_Cases_From_Queues_Controller(ApexPages.StandardSetController stdController) {
        this.mysObject = (Case)stdController.getRecord();
        List<Case> caseRecords = (List<Case>)stdController.getSelected();
        listOfCasesToUpdate = new List<case>([SELECT Id, OwnerId FROM Case WHERE Id IN :caseRecords]);
    }
    
    public PageReference save(){
        if(listOfCasesToUpdate.size() > 0){
            for(Case cas : listOfCasesToUpdate){
                cas.OwnerId = UserInfo.getUserId();
            }
            update listOfCasesToUpdate;
        }
        
        PageReference pageRef = new PageReference('/' + Case.SObjectType.getDescribe().getKeyPrefix() + 
                                                  '?fcf=' + Label.Accept_Case_Redirect_Listview_Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}