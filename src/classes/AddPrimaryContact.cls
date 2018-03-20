public class AddPrimaryContact implements Queueable {
    
    private Contact myCon;
    private String myState;
    
    public AddPrimaryContact(Contact c, String state) {
        this.myCon = c;
        this.myState = state;
    }

    public void execute(QueueableContext context) {
		
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :myState LIMIT 200];
        List<Contact> insertCons = new List<Contact>();
        
        for(Account a : accounts) {
            Contact newCon = myCon.Clone(false, true, true, true);
            newCon.AccountId = a.Id;
            insertCons.add(newCon);
        }
        insert insertCons;
    }
    
}