public with sharing class OSF_AccDetailsExtension {
    public OSF_AccDetailsExtension(ApexPages.StandardController stdController) { }
    
    public String actid {get; set;}
    public list <Contact> acc {get;set;}
    public String searchKey {get;set;}
    String var = ApexPages.currentPage().getParameters().get('id');
    public Pagereference setPrimary() { 
        //If there is primary contact make it false first
        List<Contact> primaryct = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true AND Account.Id = :var];
        if(primaryct.size() > 0)  {
            Contact a = primaryct.get(0);
            a.Is_Primary_Contact__c = false;
        }
        
        //Get Account Id and set as primary contact
        Contact queriedContact = [SELECT Id
                          FROM Contact 
                          WHERE Id = :actid
                          LIMIT 1];
        queriedContact.Is_Primary_Contact__c = true;

        update queriedContact;
        update primaryct;
        //When process completed close pop-up
        displayPopup = false;

        //When process complete refresh page witch associated accountId
        PageReference retURL = new PageReference('/apex/OSF_AccountDetails?id='+var);
        retURL.setRedirect(true);
        return retURL;
    }  
    //Pop-up 
    public boolean displayPopup {get;set;}
    public void closePopup() 
    {
        displayPopup = false; 
    } 
    public void showPopup() 
    {
        displayPopup = true; 
    }
        
    public void search(){
        String varId = ApexPages.currentPage().getParameters().get('id');
        String key = +'%'+searchKey+'%';
        acc = [select Name,title,phone,Is_Primary_Contact__c,id from contact where Account.Id = :varId and name like :key];
    }
    public void clear(){
        acc.clear();
    }
}
