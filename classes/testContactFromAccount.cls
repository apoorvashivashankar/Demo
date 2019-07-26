@istest
public class testContactFromAccount {

    public static testMethod void testMyController() {
       
      PageReference pageRef = Page.new_contact;
        Test.setCurrentPage(pageRef);
       // Verify that page fails without parameters 
    
        Account newAccount = new Account (name='XYZ Organization');
        insert newAccount;
        Contact myContact = new Contact (FirstName='Captain',LastName='Testperson',Title='King',email='test@jonrust.com',HasOptedOutOfEmail=true,phone='44432323222',AccountId=newAccount.id);

        insert myContact;
        
        ApexPages.StandardController sc = new ApexPages.standardController(newAccount);
        ContactFromAccount myPageCon = new ContactFromAccount(sc);
        myPageCon.firstName= 'Captain';
        myPageCon.LastName='Testperson';
        myPageCon.Title='King';
        myPageCon.email='test@jonrust.com' ;
        myPageCon.HasOptedOutOfEmail=true;
        myPageCon.phone='44432323222'; 
        
        myPageCon.save();
       
    }
}