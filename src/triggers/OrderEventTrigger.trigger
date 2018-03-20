trigger OrderEventTrigger on Order_Event__e  (after insert) {    
    
    // List to hold all cases to be created.
    List<Task> tasks = new List<Task>();
       
    // Iterate through each notification.
    for (Order_Event__e  event : Trigger.New) {
        if (event.Has_Shipped__c == true) {
            // Create Task to dispatch new team.
            Task t = new Task();
            t.Priority = 'Medium';
            t.Status = 'New';
            t.ActivityDate  = date.today();
            t.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
            t.OwnerId = '0050Y000000VAb3';
            tasks.add(t);
        }
   }
    
    // Insert all Tasls corresponding to events received.
    insert tasks;
}