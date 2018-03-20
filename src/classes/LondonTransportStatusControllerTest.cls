@isTest
private class LondonTransportStatusControllerTest {
    
    @isTest static void testGetCalloutSuccess() {
        
        TFL_Service__c api = new TFL_Service__c();
        api.Name = 'TFL Service Test';
        api.Endpoint_URL__c = 'https://api.tfl.gov.uk';
        api.Application_ID__c = 'fa4bc08c';
        api.Applciation_Keys__c = '42ca0ae864ca9866714305768bb67aed ';
        api.Mode__c = 'tube,dlr,overground';
        api.detail__c = false;
        insert api;
        
        Test.StartTest();
        	// Set mock callout class 
        	Test.setMock(HttpCalloutMock.class, new LondonTransportStatusMock());
        	PageReference pageRef = Page.LondonTransportStatus;
    		Test.setCurrentPage(pageRef);
            
            LondonTransportStatusController controller = new LondonTransportStatusController();
       		controller.getTubeStatus();
        	
        Test.stopTest();
        
        system.assertNotEquals(0, controller.statusWrapper.size());
                 
    }
}