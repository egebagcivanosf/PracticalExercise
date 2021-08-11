public with sharing class OSF_AccDetailsExtension {
    public OSF_AccDetailsExtension(ApexPages.StandardController stdController) { }
    public String actid {get; set;}
    public Pagereference setPrimary() { 
        List<Contact> primaryct = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true];
        if(primaryct.size() > 0)  {
            Contact a = primaryct.get(0);
            a.Is_Primary_Contact__c = false;
        }
        
        Contact queriedContact = [SELECT Id
                          FROM Contact 
                          WHERE Id = :actid
                          LIMIT 1];
queriedContact.Is_Primary_Contact__c = true;
update queriedContact;
update primaryct;
displayPopup = false;
String var = ApexPages.currentPage().getParameters().get('id');
PageReference retURL = new PageReference('/apex/OSF_AccountDetails?id='+var);
      retURL.setRedirect(true);
      return retURL;
    }   
    public boolean displayPopup {get;set;}
    public void closePopup() 
    {
        displayPopup = false; 
    } 
    public void showPopup() 
    {
        displayPopup = true; 
    } 
}
