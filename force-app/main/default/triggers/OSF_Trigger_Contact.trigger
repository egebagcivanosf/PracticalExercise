/**
 * File:        OSF_Trigger_Contact.trigger
 * Project:     PracticalExercise1
 * Date:        September 7, 2021
 * Created By:  Ege Bagcivan
 * *************************************************************************
 * Description:  Before Trigger checks the primary contacts and display an error
 *               After Trigger updates primary contact phone to all Contacts related to the same account.
 * *************************************************************************
 * History:
 * Date:                Modified By:                         Description:
 * September 7, 2021    Ege Bagcivan                         Update primary contact and display error Using TriggerHandler
 */
trigger OSF_Trigger_Contact on Contact (before insert, before update, after insert, after update) {

    //Get Account Ids
    List<id> accid= new List<Id>();
    if (Trigger.isBefore) {
        
        if (Trigger.isInsert || Trigger.isUpdate) {
                OSF_ContactTriggerHandler.primaryContactCheck(Trigger.new);  
    }
}
else if (Trigger.isAfter) {
    if(trigger.isinsert || trigger.isupdate){  
        //If accountid is not null and if it is primary contact get the account id and add it to accid variable
        for(Contact c:trigger.new){
          if(c.Accountid!=null && c.Is_Primary_Contact__c==true){
              accid.add(c.accountid);
              //Send Contact id and account id as a parameter
              OSF_ContactTriggerHandler.contactPhoneUpdate(c.Id,c.accountid);
          }
      }  
  }
}

}