public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, Name, LeadSource 
            FROM Lead
            WHERE LeadSource = '' limit 200];
        // Create a task for each opportunity in the list
        for (Lead lead: leads) {
            lead.LeadSource = 'Dreamforce';
        }
        update leads;
    }
}