@isTest
private class LeadProcessorTest {

    @testSetup 
    static void setup() {
        List<Lead> leads = new List<lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(FirstName='TestLead123', LastName = 'Lead ' +i,
                               Company = 'Company '+i));
        }
        insert leads;
    }

    static testmethod void test() {        
        Test.startTest();
        LeadProcessor myBatchObject = new LeadProcessor(); 
        Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [SELECT count() FROM Lead WHERE FirstName ='TestLead123']);
    }
    
}