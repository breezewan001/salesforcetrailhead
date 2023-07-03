// create test class for project callout service
@isTest
private class ProjectCalloutServiceTest {

  // setup test data
  @testSetup static void setup() {
    // create account testdata
    Account acc = new Account();
    acc.Name = 'Test Account';
    acc.BillingStreet = '123 Test Street';
    acc.BillingCity = 'Test City';
    acc.BillingState = 'Test State';
    acc.BillingPostalCode = '12345';
    acc.BillingCountry = 'Test Country';
    insert acc;

    // create opportunity testdata
    Opportunity opp = new Opportunity();
    opp.Name = 'Test Opportunity';
    opp.StageName = 'Closed Won';
    opp.CloseDate = Date.today();
    opp.AccountId = acc.Id;
    opp.amount = 5000;

    insert opp;

    //create the Custom Settings
    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = 'b36b7416-b02c-49a3-a95d-c22abde69624';
    insert servToken;
  }

  //Implement mock callout tests here
  @isTest static void testpostOpportunityToPMSEmpty() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    // create new opportunity id list
    List<Id> oppIds = new List<Id>();
    // starttest
    Test.startTest();
    // Call method to test
    ProjectCalloutService.postOpportunityToPMS(oppIds);
    // stoptest
    Test.stopTest();
    // assert opportunity stage has not updated
    System.assertEquals('Closed Won', [SELECT StageName FROM Opportunity WHERE name = 'Test Opportunity'].StageName);
  }

  // test postOpportunityToPMS method success
  @isTest static void testpostOpportunityToPMSSuccess() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    // create new opportunity id list
    List<Id> oppIds = new List<Id>();
    // add opportunity id to list
    oppIds.add([SELECT Id FROM Opportunity WHERE name = 'Test Opportunity'].Id);
    // starttest
    Test.startTest();
    // Call method to test
    ProjectCalloutService.postOpportunityToPMS(oppIds);
    System.debug('success excute future0::' + System.Limits.getFutureCalls());
    // stoptest
    Test.stopTest();
    System.debug('success excute future1::' + System.Limits.getFutureCalls());
    // assert opportunity stage has updated
    System.debug('result::' + [SELECT StageName FROM Opportunity WHERE name = 'Test Opportunity']);
    System.assertEquals('Submitted Project', [SELECT StageName FROM Opportunity WHERE name = 'Test Opportunity'].StageName);
  }

  // test postOpportunityToPMS method failure
  @isTest static void testpostOpportunityToPMSFailure() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    // create new opportunity id list
    List<Id> oppIds = new List<Id>();
    // add opportunity id to list
    oppIds.add([SELECT Id FROM Opportunity WHERE name = 'Test Opportunity'].Id);
    // starttest
    Test.startTest();
    // Call method to test
    ProjectCalloutService.postOpportunityToPMS(oppIds);
    System.debug('fail excute future0::' + System.Limits.getFutureCalls());
    // stoptest
    Test.stopTest();
    System.debug('fail excute future1::' + System.Limits.getFutureCalls());
    // assert opportunity stage has not updated
    System.assertEquals('Resubmit Project', [SELECT StageName FROM Opportunity WHERE name = 'Test Opportunity'].StageName);
  }

}