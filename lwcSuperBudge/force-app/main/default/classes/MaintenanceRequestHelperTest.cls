// create test class for maintenanceRequestHelper.cls
@isTest
public class MaintenanceRequestHelperTest {
    // @testSetup method to create test data
    @testSetup static void setup() {
        // create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;
        // create vehicle with test data   
        Vehicle__c testVehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert testVehicle;
        

        // create 3 lines of testdata in a list for Case
        List<Case> testCaseList = new List<Case>();
        testCaseList.add(new Case(ContactId = testContact.Id, Status = 'New', Subject = 'Test Case 1', Vehicle__c = testVehicle.Id));
        testCaseList.add(new Case(ContactId = testContact.Id, Status = 'New', Subject = 'Test Case 2', Vehicle__c = testVehicle.Id));
        testCaseList.add(new Case(ContactId = testContact.Id, Status = 'New', Subject = 'Test Case 3', Vehicle__c = testVehicle.Id));
        insert testCaseList;

        // create 3 lines of testdata in a list for equipment with different Maintenance_Cycle__c values
        List<Product2> testEquipmentList = new List<Product2>();
        testEquipmentList.add(new Product2(Name= 'Test Pd 1', Maintenance_Cycle__c = 10, Replacement_Part__c  = true));
        testEquipmentList.add(new Product2(Name= 'Test Pd 2', Maintenance_Cycle__c = 20, Replacement_Part__c  = true));
        testEquipmentList.add(new Product2(Name= 'Test Pd 3', Maintenance_Cycle__c = 30, Replacement_Part__c  = true));
        // create 3 lines of testdata in a list for product2 with different Maintenance_Cycle__c values
        insert testEquipmentList;

        // create 3 lines of testdata in a list for Equipment_Maintenance_Item__c related to case1
        List<Equipment_Maintenance_Item__c> testEquipmentMaintenanceItemList = new List<Equipment_Maintenance_Item__c>();
        testEquipmentMaintenanceItemList.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = testCaseList[0].Id, Equipment__c = testEquipmentList[1].Id));
        testEquipmentMaintenanceItemList.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = testCaseList[0].Id, Equipment__c = testEquipmentList[0].Id));
        testEquipmentMaintenanceItemList.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = testCaseList[0].Id, Equipment__c = testEquipmentList[2].Id));
        insert testEquipmentMaintenanceItemList;

    }

    // test method for MaintennanceRequestHelper class updateMaintenanceRequest method
    @isTest
    static void testUpdateMaintenanceRequest() {
        // get setup Case list data
        List<Case> testCaseList = [SELECT Id, Status,Subject,Vehicle__c,ProductId FROM Case WHERE Status = 'New' LIMIT 3];
        System.debug('testCaseList: ' + testCaseList);
        
        // call method to test
        MaintenanceRequestHelper.updateWorkOrders(testCaseList);
        // assert results
        // select count of case object
        Integer caseCount = [SELECT COUNT() FROM Case]; 
        // assert that caseCount is 6
        System.assertEquals(6, caseCount);
    }

    // test method for Trigger
    @isTest
    static void testUpdateMaintenanceRequestStatus() {
        // get setup Case list data
        List<Case> testCaseList = [SELECT Id, Status,Subject,Vehicle__c,ProductId,Type FROM Case WHERE Subject = 'Test Case 1'];
        System.debug('testCaseList: ' + testCaseList);
        testCaseList[0].Status = 'Closed';
        testCaseList[0].Type = 'Routine Maintenance';
        update testCaseList[0];
    }
}