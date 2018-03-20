@isTest
private class DailyLeadProcessorTest  {

    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob() {

        // Create some out of date Opportunity records
        List<Lead> leads = new List<Lead>();
        List<Id> leadIds = new List<Id>();
        for (Integer i=0; i<200; i++) {
            Lead l = new Lead(
                LastName = 'Test Lead ' + i,
                Company = 'Test Class 93829'
            );
            leads.add(l);
        }
        insert leads;
        
        for(lead myLead : leads) {
            leadIds.add(myLead.Id);
        }
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DailyLeadProcessor());         
        
        // Verify the scheduled job has not run yet.
        List<Lead> leadsBefore = [SELECT Id 
            FROM Lead 
            WHERE LeadSource = 'Dreamforce' AND Company = 'Test Class 93829'];
        System.assertEquals(0, leadsBefore.size(), 'Leads are not changed');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
        // Now that the scheduled job has executed,
        // check that our tasks were created
        List<Lead> leadsAfter = [SELECT Id 
            FROM Lead 
            WHERE LeadSource = 'Dreamforce' AND Company = 'Test Class 93829'];
        
        System.assertEquals(leadsAfter.size(), 
            leads.size(), 
            'Leads were amended');

    }
}