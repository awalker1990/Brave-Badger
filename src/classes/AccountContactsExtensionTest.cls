/* 
** Created by Adam Walker - 4C
** 08-08-17
** Test Class for AccountContactsExtension, an extension for the AccountContacts VF page
*/
@isTest
public class AccountContactsExtensionTest {
    
	@isTest public static void successContactTest() {
        
        //Setup Records
        Account a = new Account(Name = 'Adam Ltd');
        insert a;
        Contact c = new Contact(FirstName = 'Adam', LastName = 'Walker', AccountId = a.Id);
        insert c;

        //Perform Test
		test.startTest();

		//Instantiate the page
		Test.setCurrentPageReference(new PageReference('Page.AccountContacts') );

		//Put the Account ID parameter in the page
		ApexPages.currentPage().getParameters().put('id', a.Id );

		//Instantiate the Standard Controller
		ApexPages.StandardController sc = new ApexPages.StandardController(a);
		AccountContactsExtension controller = new AccountContactsExtension(sc);
        
        //Call the getter method in the page
        controller.getContacts();
        
        //Click the add contact button
        controller.addContact();
        
        //Change the values in the wrapper class
        controller.contactList.get(1).selected = false;
        controller.contactList.get(1).con.FirstName = 'Adam';
        controller.contactList.get(1).con.LastName = 'Walker';
        
        //Click the Save button
        controller.saveContact();
        
        //Select some records and the click delete
        controller.contactList.get(0).selected = true;
        controller.deleteContacts();
        
        
        test.stopTest();	
    
    }
}