public with sharing class OSF_popupClass {
    public OSF_popupClass(ApexPages.StandardController stdController) {
        
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
