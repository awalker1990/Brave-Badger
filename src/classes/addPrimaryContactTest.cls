@isTest
public class addPrimaryContactTest {

    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add 50 Accounts accounts
        for (Integer i = 0; i < 100; i++) {
            if(i<50){
            accounts.add(new Account(
                name='Test Account'+i, BillingState = 'NY'
            ));
            } else {
                 accounts.add(new Account(
                name='Test Account'+i, BillingState = 'CA'
            ));
            }
            
        }
        insert accounts;
    }
    
    static testmethod void testQueueable() {
        
        //Create contact to pass into queue method
        Contact myCon = new Contact(FirstName = 'Test', LastName = 'Test LN');
        insert myCon;
      
        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(myCon , 'CA');
        
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();        
        // Validate the job ran. Check if record have correct parentId now
        System.assertEquals(50, [SELECT count() FROM Contact WHERE Account.BillingState = 'CA' AND FirstName = 'Test' AND LastName = 'Test LN']);
    }
    
}