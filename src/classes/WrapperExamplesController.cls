public class WrapperExamplesController {
    
    public List<tableWrapper> contactList {get;set;}
    
    public WrapperExamplesController(){ 
    contactList = myContacts();
    }
    
    //getter method for contacts
    public List<tableWrapper> myContacts() {
        if(contactList == null) {
            contactList = new List<tableWrapper>();
            for(Contact c : [SELECT Id, Name, Email FROM Contact LIMIT 10]) {
                contactList.add(new tableWrapper(c));
            }
        }
        system.debug('wrapper contents --> ' + contactList);
        return contactList;
    }
    
    //Wrapper Class
    public class tableWrapper {
        public Contact con {get;set;}
        public Boolean selected {get;set;}
        
        public tableWrapper(Contact c){
            this.con = c;
            this.selected = false;
        }
    }

}