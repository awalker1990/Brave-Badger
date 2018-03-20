/*
** Created by Adam Walker - 4c
** 08-08-17
** Extension for ReparentContacts VF page
*/
public without sharing class ReparentContactsExtension {
    
    ApexPages.StandardSetController setCon;          
    Public Contact myCon                            {get;set;}
    
    //Initialize the Standard Set Controller
    public ReparentContactsExtension(ApexPages.StandardSetController controller) {
        this.setCon = controller;
        this.myCon = new Contact();
    }
    
    //Method that reparents selected contacts
    public PageReference moveAccounts(List<Contact> sc) {
        
        List<Contact> updatedContacts = new List<Contact>();
        
        for(Contact c : sc ) {
            c.AccountId = myCon.AccountId;
            updatedContacts.add(c);
        }
        update updatedContacts;
        
        //return the record detail page
        PageReference accDetail = new PageReference('/' + myCon.AccountId);
        return accDetail;
    }
    
    //VF calls this method from the Move to Account button to check if any records have been selected, if not go back to list view... if so process the contacts
    public PageReference processContacts() {
        
        //Get the set controller into a list of contacts
        List<Contact> selectedContacts = setCon.getSelected();
        system.debug('myCon --> ' + myCon);
        if(myCon.accountId != null){
            if(!selectedContacts.isEmpty() ){
                //Reparent and go to Account Detail
                PageReference accDetail = moveAccounts(selectedContacts);
                return accDetail;
                
            } else {
                //Go back to contacts
                PageReference goBack = new PageReference('/003/o');
                return goBack;
            } 
        } else {
            ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select an Account first!');
            ApexPages.addmessage(err);   
        }
        return null;
        
        
        
        
    }
}