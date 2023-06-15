trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    // trigger in case of status change to "Closed"
    
    if (Trigger.isUpdate) {
        // after trigger
        if (Trigger.isAfter) {
            // create new Case List
            List<Case> caseList = new List<Case>();
            // loop through all cases
            for (Case c : Trigger.new) {
                // check if type is 'Repair' or 'Routine Maintenance'
                if (c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                    // check if status changed to "Closed"
                    if (c.Status == 'Closed') {
                        caseList.add(c);
                    }
                }   
            }

            // call helper method
            MaintenanceRequestHelper.updateWorkOrders(caseList);
        }
    }
}

    



