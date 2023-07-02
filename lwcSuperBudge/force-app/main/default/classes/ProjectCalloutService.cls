public class ProjectCalloutService {

    // create apex action for flow
    @InvocableMethod(label='Post Opportunity to PMS' description='Posts Opportunity to PMS')
    public static void postOpportunityToPMS(List<Opportunity> opportunityList) {
        // log opportunityList
        System.debug('Opportunity List: ' + opportunityList);
        // if opportunityList is not empty, map opportunity to requestBody
        if (!opportunityList.isEmpty()) {
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
            // create http request
            HttpRequest request = new HttpRequest();
            // get endpoint from custom setting ProjectCalloutService__c
            ProjectCalloutService__c projectCalloutService = ProjectCalloutService__c.getOrgDefaults();
            // log projectCalloutService
            System.debug('Project Callout Service: ' + projectCalloutService);
            // get endpoint from projectcalloutservice
            String endpoint = projectCalloutService.Endpoint__c;
            // set endpoint
            request.setEndpoint(endpoint);
            // set method
            request.setMethod('POST');
            // set body
            request.setBody(jsonBody);
            // set header
            request.setHeader('Content-Type', 'application/json');
            // create http
            Http http = new Http();
            // create http response
            HttpResponse response = http.send(request);
            // log response
            System.debug('Response: ' + response);

        }


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