@isTest
private class AnimalLocatorTest {
    
    @isTest static void testGetCalloutSuccess() {
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        String response = AnimalLocator.getAnimalNameById(3);
        
		string expectedResult='chicken';
        System.assertEquals(response, expectedResult);

                 
    }
}