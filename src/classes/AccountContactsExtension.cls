/* 
** Created by Adam Walker - 4C
** 08-08-17
** Extension for AccountContacts VF page
*/
public without sharing class AccountContactsExtension {
    
    private final Account acc;
    public List<WrapperContact> contactList   {get;set;}
    
    //Initialise the constructor
    public AccountContactsExtension(ApexPages.StandardController stdController) {
        this.acc = (Account)stdController.getRecord();
    }
    
    //Getter method to display contacts of the account on Load of the page
    public List<WrapperContact> getContacts() {
        
        if(contactList == null) {
            contactList = new List<WrapperContact>();
            for(Contact c: [SELECT FirstName, LastName, Email, Phone FROM Contact WHERE accountId = :acc.Id]) {
                
                // As each contact is processed we create a new cContact object and add it to the contactList
                contactList.add(new WrapperContact(c));
            }
        }
        return contactList;
    }
    
    //Method to save and update records
    public PageReference saveContact() {
        
        //New list of contacts to update
        List<Contact> contactUpdates = new List<Contact>();
        
        if(!contactList.isEmpty()) {
            for(WrapperContact wCon : contactList ) {
                contactUpdates.add(wCon.con);
            }
            try {
                upsert contactUpdates;
                ApexPages.message success = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Records Saved');
                ApexPages.addmessage(success);
                
            } catch (dmlException e) {
                ApexPages.message err = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() );
                ApexPages.addmessage(err);
            }
        }
        return null;
    }
    
    //Method to delete contacts and clear the wrapper
    public PageReference deleteContacts() {
        system.debug('enter deleteContacts');
        List<Contact> selectedContacts = new List<Contact>();
        
        //iterate over the list of contacts and see which ones are selected        
        for(WrapperContact wCon : contactList ) {
            if(wCon.selected == true && wCon.con.Id != null) {
                selectedContacts.add(wCon.con);		
            }
        }
        try {
            system.debug('try selected Contacts --> ' + selectedContacts);
            if(!selectedContacts.isEmpty() ){
                delete selectedContacts;
                ApexPages.Message successMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Selected Contacts Deleted');
                ApexPages.addmessage(successMsg);   
            }
            
            
        } catch (dmlException e) {
            
        }         
        system.debug('no try catch');
        contactList = null;
        system.debug('contact list --> ' + contactList);
        return null;          
    }
    
    //Method to add a new line in the table by instantiating a new wrapper object
    public pageReference addContact() {
        
        Contact c = new Contact(AccountId = acc.Id);
        contactList.add(new WrapperContact(c));
        return null;
    }
    
    
    //Wrapper Class for table in VF page, Contains the contact and some checkboxes
    public class WrapperContact {
        
        public Boolean selected     {get; set;}
        public Contact con          {get; set;}
        
        public WrapperContact(Contact c) {
            con = c;
            selected = false;
        }
    }
    
}