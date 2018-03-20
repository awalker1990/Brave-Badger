@isTest
public class FileClaimControllerTest {
    
    @isTest public static void testMethod1() {
        
        //Create records
        Account a = new Account(Name = 'United Airlines');
        insert a;
        
        //Perform Test
        
        Test.setCurrentPageReference(new PageReference('/apex/FileClaim') );
        FileClaimExtension controller = new FileClaimExtension();
        controller.c.FirstName = 'Adam';
        controller.c.LastName = 'Walker';
        controller.c.Email = 'adam.walker@weare4c.com';
        
        controller.step1();
        
        controller.claim.Reason__c = 'Car Accident';
        controller.claim.Type__c = 'Customer Fault';
        controller.claim.status__c = 'Not Started';
        
        controller.step2();
        
        controller.step1();
        
        controller.claim.Reason__c = 'It was there fault';
        controller.claim.type__c = 'Undecided';
        controller.claim.status__c = 'Completed';
        
        controller.step2();
        
		controller.startAgain();
        
    }

}