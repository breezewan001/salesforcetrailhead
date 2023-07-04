// @restResource annotation is used to expose the class as REST resource
@RestResource(urlMapping='/project/*')
global with sharing class ProjectRESTService {
    // @http annotation is used to specify the HTTP method and the path for the method
    @httpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        // returnMessage is used to return the success/error message
        String returnMessage = '';
        
        // use savepoint to rollback if any error occurs
        Savepoint sp = Database.setSavepoint();
        try {
            String projectId = createProject(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
            // update related opportunity Delivery/Installation Status to in process with project id
            updateOpportunity(OpportunityId, projectId);
            returnMessage = 'OK';
        } catch (Exception ex) {
            // rollback if any error occurs
            Database.rollback(sp);
            returnMessage = 'ERROR';
        }

        // log return message
        System.debug('returnMessage: ' + returnMessage);
        return returnMessage;

    }

    private static String createProject(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Project__c project = new Project__c();
        project.Name = ProjectName;
        project.ProjectRef__c = ProjectRef;
        project.Opportunity__c = OpportunityId;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = status;
        upsert project;
        return project.Id;
    }

    // updateOpportunity method updates the related opportunity Delivery/Installation Status to in process with project id
    private static void updateOpportunity(String OpportunityId, String projectId) {
        Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
        opp.DeliveryInstallationStatus__c = 'In progress';
        update opp;
    }
}


