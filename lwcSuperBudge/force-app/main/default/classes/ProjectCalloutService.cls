public class ProjectCalloutService {

    // create apex action for flow
    @InvocableMethod(label='Post Opportunity to PMS' description='Posts Opportunity to PMS')
    public static void postOpportunityToPMS(List<Opportunity> opportunityList) {
        // log opportunityList
        System.debug('Opportunity List: ' + opportunityList);

    }



    OpportunityId, OpportunityName, AccountName, CloseDate, and Amount.

Use the preconfigured ProjectService Named Credential previously defined.

Match the name and type of the fields based on the following sample JSON mapped to the Opportunity record.

    public class JSON2Apex {

        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Integer amount;

        
        public static JSON2Apex parse(String json) {
            return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
        }
    }



        // // create a queueable class named QueueablePMSCall
        // QueueablePMSCall q = new QueueablePMSCall();
        // // call the queueable class
        // System.enqueueJob(q);
    
    
    

    // // create a queueable class named QueueablePMSCall
    // public class QueueablePMSCall implements Queueable {

    // }
}