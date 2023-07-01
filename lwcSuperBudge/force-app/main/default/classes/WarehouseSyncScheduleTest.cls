@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here

    // create WarehouseSyncSchedule Test Class
    @isTest static void testWarehouseSyncSchedule() {
        Test.startTest();
        String sch = '0 0 2 * * ?';
        String jobID = System.schedule('WarehouseSyncSchedule', sch, new WarehouseSyncSchedule());
        Test.stopTest();
        List<Product2> equipList = [SELECT  ID, Warehouse_SKU__c FROM Product2];
        System.assertEquals(0, equipList.size());
    }
}