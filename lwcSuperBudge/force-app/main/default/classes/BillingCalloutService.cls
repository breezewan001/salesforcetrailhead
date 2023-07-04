public class BillingCalloutService {
    // create method callBillingServiceProxy
    public static void callBillingService(List<Project__c> projects) {
        // get projectIds from projects
        List<String> projectIds = new List<String>();
        for (Project__c project : projects) {
            // if project status is Billable
            if (project.Status__c == 'Billable') {
                // add project.ProjectRef__c to projectIds
                projectIds.add(project.ProjectRef__c);
            }
        }

        // log projectIds
        System.debug('projectIds: ' + projectIds);
        // if projectIds is not empty
        if (!projectIds.isEmpty()) {
            // call method callBillingServiceProxy
            callBillingServiceProxyFuture(projectIds);
        }
    }

    // create future method allow callout callBillingServiceProxyFuture

    @future(callout=true)
    public static void callBillingServiceProxyFuture(List<String> projectIds) {
        // if projectIds is not empty
        if (!projectIds.isEmpty()) {
            // get projects from projectIds
            List<Project__c> projects = [SELECT Id, Name, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE ProjectRef__c IN :projectIds];

            if (!projects.isEmpty()) {
                // create a new list of Project__c
                List<Project__c> projectsToUpdate = new List<Project__c>();
                // for each project in projects
                for (Project__c project : projects) {
                    // map project to a new BillingServiceProxy.billProject_element
                    BillingServiceProxy.project billProjectElement = new BillingServiceProxy.project();
                    // set the project's ProjectRef__c to the BillingServiceProxy.billProject_element's projectid
                    billProjectElement.projectid = project.ProjectRef__c;
                    // set the project's Billable_Amount__c to the BillingServiceProxy.billProject_element's billAmount
                    billProjectElement.billAmount = project.Billable_Amount__c;
                    // set custom setting ServiceCredentials__c's BillingServiceCredential's username to the billProjectElement's username
                    billProjectElement.username = ServiceCredentials__c.getValues('billProjectElement').username__c;
                    // set custom setting ServiceCredentials__c's BillingServiceCredential's password to the billProjectElement's password
                    billProjectElement.password = ServiceCredentials__c.getValues('billProjectElement').password__c;
    
                    // log the billProjectElement
                    System.debug('billProjectElement: ' + billProjectElement);
    
                    // create a new BillingServiceProxy
                    BillingServiceProxy.InvoicesPortSoap11 BillingServiceProxy = new BillingServiceProxy.InvoicesPortSoap11();
                    // call the BillingServiceProxy method
                    String BillingServiceProxyResponse = BillingServiceProxy.billProject(billProjectElement);
                    // log the BillingServiceProxyResponse
                    System.debug('BillingServiceProxyResponse: ' + BillingServiceProxyResponse);

                    // if BillingServiceProxyResponse is not null and BillingServiceProxyResponse equal 'OK'
                    if (BillingServiceProxyResponse != null && BillingServiceProxyResponse == 'OK') {
                        // set project's Status__c to 'Billed'
                        project.Status__c = 'Billed';
                        // add project to projectsToUpdate
                        projectsToUpdate.add(project);
                    }
                }

                // if projectsToUpdate is not empty
                if (!projectsToUpdate.isEmpty()) {
                    // update projectsToUpdate
                    update projectsToUpdate;
                }
            }
        }
    }
       
}