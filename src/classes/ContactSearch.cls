public class ContactSearch {

    public static list<Contact> searchForContacts(String lname, String pc) {
        List<Contact> matchingContacts = [SELECT Name FROM Contact
                                         WHERE LastName = :lname
                                         AND
                                         MailingPostalCode = :pc];
        return matchingContacts;
    }
}