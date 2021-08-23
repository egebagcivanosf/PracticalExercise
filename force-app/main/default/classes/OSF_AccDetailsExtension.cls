/**
 * File:        OSF_AccDetailsExtension.cls
 * Project:     PracticalExercise1
 * Date:        August 18, 2021
 * Created By:  egebagcivanosf
 * *************************************************************************
 * Description:  Practical Exercise Controller Extension
 * *************************************************************************
 */
public with sharing class OSF_AccDetailsExtension {
    public OSF_AccDetailsExtension(ApexPages.StandardController stdController) {
        list <Contact> ctt = [SELECT Id, Is_Primary_Contact__c FROM Contact];
     }
    
    public String contactId {get; set;}
    public list <Contact> searchContact {get;set;}
    public String searchKey {get;set;}
    public boolean displayPopup {get;set;}
    String accountId = ApexPages.currentPage().getParameters().get('id');
    
    /**
    * @author Ege Bagcivan
    * @date August 18, 2021
    * @description Setting clicked primary contact and unsetting old primary contact for an account.
    * @name setPrimary
    * @param String
    */
    public Pagereference setPrimary() { 
        
        //If there is primary contact make it false first
        List<Contact> primaryct = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true AND Account.Id = :accountId];
        if(primaryct.size() > 0)  {
            Contact a = primaryct.get(0);
            a.Is_Primary_Contact__c = false;
        }
        
        //Get Account Id and set as primary contact
        Contact queriedContact = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
        queriedContact.Is_Primary_Contact__c = true;

        try {
        update queriedContact;
        update primaryct;
        } catch (DmlException e) {
            System.debug(e);
        }
        
        //When process completed close pop-up and refresh the page with associated accountId
        displayPopup = false;
        PageReference retURL = new PageReference('/apex/OSF_AccountDetails?id='+accountId);
        retURL.setRedirect(true);
        return retURL;
    }  
    //Pop-up 
    public void closePopup() {
        displayPopup = false; 
    } 
    public void showPopup() {
        displayPopup = true; 
    }
        
    /**
    * @author Ege Bagcivan
    * @date August 18, 2021
    * @description Search contacts associated with entered name
    * @name Search
    * @param String
    */
    public void search() {
        String key = +'%'+searchKey+'%';
        try {
            searchContact = [select Name,title,phone,Is_Primary_Contact__c,id from contact where Account.Id = :accountId and name like :key];
        } catch (DmlException e) {
            System.debug(e);
        }          
    }
    //Clear search input field
    public void clear() {
        searchContact = null;
    }
}
