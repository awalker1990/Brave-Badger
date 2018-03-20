global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, Name, LeadSource 
            FROM Lead 
            WHERE LeadSource = ''
            LIMIT 200];
        
        List<Lead> updateLead = new List<Lead>();
        
        for(Lead l : leads) {
            l.leadSource = 'Dreamforce';
            updateLead.add(l);
        }
        update updateLead;
    }
    
}