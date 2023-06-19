// create a global scheduleable class named warehouseSyncSchedule call warehouseService
global class WarehouseSyncSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        // call WarehouseCalloutService runWarehouseEquipmentSync method
        System.enqueueJob(new WarehouseCalloutService());
        // daily 1:00 am run
        String sch = '0 0 1 * * ?';
        // schedule the job
        System.schedule('WarehouseSyncScheduleJob', sch, new WarehouseSyncSchedule());
    }
}
