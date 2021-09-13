/**
 * File:        OSF_ContactTriggerHandler.cls
 * Project:     PracticalExercise1
 * Date:        September 7, 2021
 * Created By:  Ege Bagcivan
 * *************************************************************************
 * Description:  Handler of contact trigger
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * September 7, 2021    Ege Bagcivan                         Start a progress according to trigger, Update primary contact and display error Using TriggerHandler
 */
public with sharing class OSF_ContactTriggerHandler {
  
  /**
     * @author Ege Bagcivan
     * @date September 7, 2021
     * @description Async method which updates primary contact phones off all contacts with primary contact's phone.
     * @name contactPhoneUpdate
     * @param contactid id, Accid id
    */
  @future
  public static void contactPhoneUpdate(id contactid,id Accid ){

      List<contact> contactsupdate = new List<contact>();
      List<contact> conlist;
      List<contact> primaryconts;
      try {
        conlist = [select id,AccountId,phone from contact where AccountId=:Accid AND Is_Primary_Contact__c=false ];
        primaryconts = [select id,Is_Primary_Contact__c,phone,Primary_Contact_Phone__c from contact where id=:contactid limit 1];
      } catch (QueryException q) {
        System.debug(q);
      }
      
      for(contact con:conlist){
          for(contact conprm : primaryconts)
            {
              con.Primary_Contact_Phone__c = conprm.phone;
              contactsupdate.add(con);
            }
          }
          try {
            database.update(contactsupdate);
          } catch (DmlException e) {
            System.debug(e);
          }
            
  }
  /**
     * @author Ege Bagcivan
     * @date September 7, 2021
     * @description Checks primary contacts before insert and update and display errors.
     * @name primaryContactCheck
     * @param contacts List<Contact> from Trigger.New
    */
  public static void primaryContactCheck(List<Contact> contacts) {
    Set<Id> accountIds = new Set<Id>();
    for (Contact contact : contacts) {
        accountIds.add(contact.AccountId);
    }
    List<Contact> primaryContacts;
    try {
      primaryContacts = [select id,Is_Primary_Contact__c,phone,Primary_Contact_Phone__c FROM Contact WHERE AccountId IN :accountIds AND Is_Primary_Contact__c = true];
    } catch (QueryException qu) {
      System.debug(qu);
    }

    if(primaryContacts.size()>=1) {
      for (Contact contact : contacts) {
          if(contact.Is_Primary_Contact__c==true)
            contact.addError(System.Label.Primary_Contact_Exists);
        }
     }

  }
}
