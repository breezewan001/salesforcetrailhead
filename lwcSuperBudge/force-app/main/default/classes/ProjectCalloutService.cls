public class ProjectCalloutService {

    // create apex action for flow
    @InvocableMethod(label='Post Opportunity to PMS' description='Posts Opportunity to PMS')
    public static void postOpportunityToPMS(List<Id> opportunityIdList) {
        // log opportunityList
        System.debug('opportunityIdList List: ' + opportunityIdList);
        // if opportunityList is not empty, map opportunity to requestBody
        if (!opportunityIdList.isEmpty()) {
            // get opportunity by id
            List<Opportunity> opportunityList = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id = :opportunityIdList[0]];
            // create requestBody
            RequestBody requestBody = new RequestBody();
            // map opportunity to requestBody
            requestBody.opportunityId = opportunityList[0].Id;
            requestBody.opportunityName = opportunityList[0].Name;
            requestBody.accountName = opportunityList[0].Account.Name;
            requestBody.closeDate = String.valueOf(opportunityList[0].CloseDate);
            requestBody.amount = opportunityList[0].Amount.intValue();
            // log requestBody
            System.debug('Request Body: ' + requestBody);
            // create json string
            String jsonBody = JSON.serialize(requestBody);
            // log jsonBody
            System.debug('JSON Body: ' + jsonBody);

            // excute queueable class
            System.enqueueJob(new QueueablePMSCall(jsonBody, opportunityList[0].Id));

        }
    }

    // create queueable class to call callout method
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts{
        // create variables
        String jsonInput;
        Id oppId;
        // create constructor
        public QueueablePMSCall(String jsonInput, Id oppId) {
            this.jsonInput = jsonInput;
            this.oppId = oppId;
        }
        // create execute method
        public void execute(QueueableContext context) {
            System.debug('excute');
            // call callout method
            postToPMS(jsonInput, oppId);
        }
    }

    // create callout method postPMS
    public static void postToPMS(String jsonInput, Id oppId){
        System.debug('excute postToPMS');
        // create http request
        HttpRequest request = new HttpRequest();
        // get token from ServiceToken__c
        ServiceTokens__c serviceToken = ServiceTokens__c.getValues('ProjectServiceToken');
        String token = serviceToken.Token__c;
        // log token
        System.debug('Token: ' + token);
        // get endpoint from named credential ProjectService
        String endpoint = 'callout:ProjectService';
        // set endpoint
        request.setEndpoint(endpoint);
        // set method
        request.setMethod('POST');
        // set body
        request.setBody(jsonInput);
        // set token to request header
        request.setHeader('token', token);
        // set header
        request.setHeader('Content-Type', 'application/json');
        // create http
        Http http = new Http();
        // create http response
        HttpResponse response = http.send(request);
        // log response
        System.debug('Response: ' + response);

        Opportunity opportunitynew = [SELECT Id, Name, Account.Name, CloseDate, Amount, StageName FROM Opportunity WHERE Id = :oppId];

        // if response is successful, update opportunity
        if (response.getStatusCode() == 200) {
            // get opportunity by id
            opportunitynew.StageName = 'Submitted Project';
        } else {
            opportunitynew.StageName = 'Resubmit Project';
        }

        // update opportunity
        update opportunitynew;
        // log opportunity
        System.debug('opportunitynew: ' + opportunitynew);
        
    }


    // create requestbody class
    public class RequestBody {
        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Integer amount;
    }

}