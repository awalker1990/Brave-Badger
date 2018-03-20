public class ContactAndLeadSearch {

    public static List<List<SObject>> searchContactsAndLeads(String s) {
        
        List<List<sObject>> searchList = [FIND :s IN Name Fields
                   RETURNING Contact(Name),Lead(Name)];
        return searchList;
    }
}