public class AccountHandler {

    public static Account insertNewAccount (String n) {
        Account acc = new Account( Name = n);
        
        try {
            insert acc;
            return acc;
        } catch (DmlException e) {
            return null;
        }
    }
}