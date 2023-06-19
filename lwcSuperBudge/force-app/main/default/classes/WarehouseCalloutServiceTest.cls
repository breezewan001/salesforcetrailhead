@IsTest
public class WarehouseCalloutServiceTest {

    @isTest 
    static void testCalloutMethod() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        // call method to test
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        List<Product2> productList = [SELECT Name, Warehouse_SKU__c FROM Product2 limit 1];
        Test.stopTest();
    }

    // QueueableContext test class
    @isTest 
    static void testQueueable() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService callJob = new WarehouseCalloutService();
        Test.startTest();
        System.enqueueJob(callJob);
        Test.stopTest();
        Product2 equipment = [SELECT ID, Warehouse_SKU__c, Maintenance_Cycle__c FROM Product2 LIMIT 1];
        // log the equipment
        System.debug('Equipment: ' + equipment);

        System.assertEquals('TESTSKU', equipment.Warehouse_SKU__c);
    }
}