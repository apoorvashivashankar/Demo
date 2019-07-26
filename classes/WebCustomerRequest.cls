public with sharing class WebCustomerRequest{

  private final Change_Request__c cr;

  public WebCustomerRequest(ApexPages.StandardController controller) {
        this.cr = (Change_Request__c)controller.getRecord();

    }


  // save button is clicked
  public PageReference save() {

    try {
        insert cr; // inserts the new record into the database
        System.debug('::::WebCustomerRequest + save cr::::> ' + cr);
    } catch (DMLException e) {
        return null;
    }

    // if successfully inserted new cr, then displays the thank you page.
    return Page.WebCustomerRequestThanks;
  }

}