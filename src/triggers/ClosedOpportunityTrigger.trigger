trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> tasksToUpdate = new List<Task>();
    
    for(Opportunity opp : [SELECT Id FROM Opportunity WHERE Id IN :trigger.new AND StageName = 'Closed Won']) {
        
    	Task t = new Task();
        t.Subject = 'Follow Up Test Task';
        t.whatId = opp.Id;
        tasksToUpdate.add(t);       
    }
    insert tasksToUpdate;
}