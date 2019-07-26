public with sharing class ContactFromAccount {
public Boolean refreshPage {get; set;}
public ContactFromAccount(ApexPages.StandardController Account) {
   refreshPage=false;
}
public string firstName{get;set;}
public string LastName{get;set;}
public string Email{get;set;}
public string phone{get;set;}
public string Title{get;set;}
public String Acctid{get;set;}
public Boolean HasOptedOutOfEmail{get;set;}
public PageReference  save()
{
String Acctid=ApexPages.currentPage().getParameters().get('Id');
system.debug('########'+Acctid);
contact c=new contact(email=email,phone=phone,lastname=LastName,firstName=firstname,Title=Title,HasOptedOutOfEmail=HasOptedOutOfEmail,accountid=Acctid);
insert c;

// Do page refresh

  refreshPage=true;

  return null;
  
}

    
}