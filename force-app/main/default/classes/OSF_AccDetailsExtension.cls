public with sharing class OSF_AccDetailsExtension {
    public OSF_AccDetailsExtension(ApexPages.StandardController stdController) { }
    public String actid {get; set;}
    public void setPrimary() { 
        Contact primaryct = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true];
        primaryct.Is_Primary_Contact__c = false;
        Contact queriedContact = [SELECT Id
                          FROM Contact 
                          WHERE Id = :actid
                          LIMIT 1];
queriedContact.Is_Primary_Contact__c = true;
update queriedContact;
update primaryct;
    }   
}
