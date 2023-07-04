@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  // testsetup method
  @testSetup static void setup() {
    // create opportunity testdata
    Opportunity opp = new Opportunity();
    opp.Name = 'Test Opportunity';
    opp.StageName = 'Prospecting';
    opp.CloseDate = Date.today();
    insert opp;

  }

  // test postProjectData method
  @isTest static void testPostProjectData() {
    // create test data
    Date today = Date.today();
    Opportunity opp = [SELECT Id FROM Opportunity where name = 'Test Opportunity' LIMIT 1];
    String message = ProjectRESTService.postProjectData('a','test1',opp.Id,today,today,0,'');
    
    // assert that project was created
    List<Project__c> proj = [SELECT Id, Name, Opportunity__c, Start_Date__c, End_Date__c FROM Project__c WHERE Name = 'test1' LIMIT 1];
    System.assertEquals(1, proj.size());
    System.assertEquals(opp.Id, proj[0].Opportunity__c);
    // assert opportunity was updated
    Opportunity opp2 = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
    // assert DeliveryInstallationStatus__c
    System.assertEquals('In progress', opp2.DeliveryInstallationStatus__c);
    // assert message Ok
    System.assertEquals('OK', message);
  }

    // test postProjectData method
    @isTest static void testPostProjectDataErr() {
      // create test data
      Date today = Date.today();
      Opportunity opp = [SELECT Id FROM Opportunity where name = 'Test Opportunity' LIMIT 1];
      String message = ProjectRESTService.postProjectData('a','test1','',today,today,0,'');
      // log message
      System.debug(message);
      // assert message Ok
      System.assertEquals('ERROR', message);
    }
}