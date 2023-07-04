@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  // testsetup method to create test data
  @testSetup static void setupTestData() {
    // create 1 acocunt record
    Account acc = new Account(Name = 'Test Account');
    insert acc;
    // create 1 opportunity record
    Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today(), AccountId = acc.Id);
    insert opp;
    // create 2 test project records
    List<Project__c> projects = new List<Project__c>();
    projects.add(new Project__c(Name = 'Test Project 1', Status__c = 'Billable', ProjectRef__c = '11111', Opportunity__c = opp.Id));
    projects.add(new Project__c(Name = 'Test Project 2', Status__c = 'Running', ProjectRef__c = '22222', Opportunity__c = opp.Id));
    insert projects;

    // create custom setting test record
    ServiceCredentials__c bcs = new ServiceCredentials__c(Name = 'BillingServiceCredential', username__c = 'testUser', password__c = 'testpass');
    insert bcs;

  }

  // create test method for BillingCalloutService.callBillingService
  @isTest static void testCallBillingService() {
    // create mock callout class
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    // get test project records
    List<Project__c> projects = [SELECT Id, Name, Status__c, ProjectRef__c FROM Project__c LIMIT 2];
    // call method to test
    Test.startTest();
    BillingCalloutService.callBillingService(projects);
    Test.stopTest();

    // get updated project records
    List<Project__c> afterprojects = [SELECT Id, Name, Status__c, ProjectRef__c FROM Project__c LIMIT 2];
    // if afterprojects.size>0 
    if (afterprojects.size() > 0) {
      // foreach afterprojects if name = 'Test Project 1' then assert status = 'Billed' and projectRef = '11111'
      for (Project__c p : afterprojects) {
        if (p.Name == 'Test Project 1') {
          System.assertEquals('Billed', p.Status__c);
          System.assertEquals('11111', p.ProjectRef__c);
        }
        // if name = 'Test Project 2' then assert status = 'Billed' and projectRef = '22222'
        if (p.Name == 'Test Project 2') {
          System.assertEquals('Running', p.Status__c);
          System.assertEquals('22222', p.ProjectRef__c);
        }
      }

    }
  }

  // create test method for BillingCalloutService.callBillingService fail
  @isTest static void testCallBillingServiceFail() {
    // create mock callout class
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    // get test project records
    List<Project__c> projects = [SELECT Id, Name, Status__c, ProjectRef__c FROM Project__c LIMIT 2];
    // call method to test
    Test.startTest();
    BillingCalloutService.callBillingService(projects);
    Test.stopTest();

    // get updated project records
    List<Project__c> afterprojects = [SELECT Id, Name, Status__c, ProjectRef__c FROM Project__c LIMIT 2];
    // if afterprojects.size>0 
    if (afterprojects.size() > 0) {
      // foreach afterprojects if name = 'Test Project 1' then assert status = 'Billable' and projectRef = '11111'
      for (Project__c p : afterprojects) {
        if (p.Name == 'Test Project 1') {
          System.assertEquals('Billable', p.Status__c);
          System.assertEquals('11111', p.ProjectRef__c);
        }
        // if name = 'Test Project 2' then assert status = 'Billed' and projectRef = '22222'
        if (p.Name == 'Test Project 2') {
          System.assertEquals('Running', p.Status__c);
          System.assertEquals('22222', p.ProjectRef__c);
        }
      }

    }
  }
}