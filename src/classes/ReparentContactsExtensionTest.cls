/*
** Created by Adam Walker - 4c
** 08-08-17
** Test class for ReparentContactsExtension
*/
@isTest
public class ReparentContactsExtensionTest {
    
    @isTest public static void selectedAccounts() {
        
        //Setup records
        Account a1 = new Account(Name = 'a1');
        insert a1;
        Account a2 = new Account(Name = 'a2');
        insert a2;
        
        List<Contact> sc = new List<Contact>();
        Contact c1 = new Contact(FirstName = 'Adam', LastName = 'Walker', AccountId = a2.Id);
        sc.add(c1);
        insert sc;     
        
        //Perform Test
        test.startTest();
        
        	//Instantiate the set controller and set the list of contacts created
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(sc);
            setCon.setSelected(sc); 
            
        	//Instantiate the extension and pass in the set
            ReparentContactsExtension extension = new ReparentContactsExtension(setCon);    
            extension.myCon = c1;
        	extension.processContacts();
        
        //Make assertions
        system.assertEquals('/'+ a2.Id, extension.processContacts().getURL() );
        system.assertEquals(a2.Id, c1.AccountId);
            
        test.stopTest();
        
    }
    
    @isTest public static void unSelectedAccounts() {
        
        //Setup records
        Account a1 = new Account(Name = 'a1');
        insert a1;
        Account a2 = new Account(Name = 'a2');
        insert a2;
        
        List<Contact> sc = new List<Contact>();    
        
        //Perform Test
        test.startTest();
        
        	//Instantiate the set controller and set the list of contacts created
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(sc);
            setCon.setSelected(sc); 
                    
            
        	//Instantiate the extension and pass in the empty set
            ReparentContactsExtension extension = new ReparentContactsExtension(setCon); 
        	extension.myCon = new Contact(LastName = 'walker', AccountId = a2.Id);
            extension.processContacts();
        
        //Make Assertions
        system.assertEquals('/003/o', extension.processContacts().getURL() );
       
        test.stopTest();      
    }
}