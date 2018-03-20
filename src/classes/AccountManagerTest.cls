@isTest
public class AccountManagerTest {

    @isTest static void testGetAccount() {
        //Create records
        Account a = new Account(Name = 'Adam Ltd');
        insert a;
        Contact c = new Contact(FirstName = 'Adam', LastName = 'Walker', AccountId = a.Id );
        insert c;

    
        
        //create request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://brave-badger-453409-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+ a.Id + '/contacts';
        request.httpMethod = 'Get';
        RestContext.request = request;
        
        // Call the method
        Account myAccount = AccountManager.getAccount();
        
        // Verify results
        System.assert(myAccount != null);
        System.assertEquals(a.Id, myAccount.Id);
    }
}