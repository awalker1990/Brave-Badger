@isTest
private class TestRestrictContactByName {
    
    @isTest static void testContact1() {
        
        Test.StartTest();
        Contact c = new Contact(FirstName = 'Adam', LastName = 'INVALIDNAME');
        insert c;
        Test.stopTest();
        
    }

}