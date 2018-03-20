public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer n, String lName) {
        
        List<Contact> contactInsert = new List<Contact>();   
            for(Integer i=0; i<n; i++) {
                Contact c = new Contact(FirstName = 'Test ' + i, LastName = lName);
                contactInsert.add(c);
            }
        return contactInsert;
    }

}