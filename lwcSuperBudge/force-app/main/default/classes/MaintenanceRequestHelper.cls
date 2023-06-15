public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> caseList) {

        // create new CaseList
        List<Case> finalCaseList = new List<Case>();
        List<Equipment_Maintenance_Item__c> finalEmiList = new List<Equipment_Maintenance_Item__c>();
        // map for Equipment_Maintenance_Item__c by key id
        Map<Id, List<Equipment_Maintenance_Item__c>> emiMap = new Map<Id, List<Equipment_Maintenance_Item__c>>();

        // create new case id list
        List<Id> caseIdList = new List<Id>();
        for (Case c : caseList) {
            caseIdList.add(c.Id);
        }

        // get all Equipment_Maintenance_Item__c by case id list
        List<Equipment_Maintenance_Item__c> emiList =  
        [SELECT Id, Name, Equipment__c, Maintenance_Request__c, Quantity__c, Equipment__r.Maintenance_Cycle__c
        FROM
        Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :caseIdList];

        // put the Equipment_Maintenance_Item__c into the map
        for (Equipment_Maintenance_Item__c emi : emiList) {
            if (emiMap.containsKey(emi.Maintenance_Request__c)) {
                emiMap.get(emi.Maintenance_Request__c).add(emi);
            } else {
                List<Equipment_Maintenance_Item__c> tempList = new List<Equipment_Maintenance_Item__c>();
                tempList.add(emi);
                emiMap.put(emi.Maintenance_Request__c, tempList);
            }
        }
        

        for (Case c: caseList) {
            // create new  Routine Maintenance case
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Subject = 'Routine Maintenance';
            newCase.Date_Reported__c = Date.today();
            newCase.ProductId=c.ProductId;
            newCase.BackUpId__c = c.Id;
            
            // get templist from map by case id
            List<Equipment_Maintenance_Item__c> emiforCaseList = emiMap.get(c.Id);

            // get the min Maintenance_Cycle__c from the Equipment_Maintenance_Item__c
            Integer minMaintenanceCycle = 0;
            for (Equipment_Maintenance_Item__c emi : emiforCaseList) {
                if (minMaintenanceCycle == 0) {
                    minMaintenanceCycle = (Integer)emi.Equipment__r.Maintenance_Cycle__c;
                } else if ( (Integer)emi.Equipment__r.Maintenance_Cycle__c < minMaintenanceCycle) {
                    minMaintenanceCycle =  (Integer)emi.Equipment__r.Maintenance_Cycle__c;
                }
            }

            // set the new case date_reported__c to the min Maintenance_Cycle__c
            Date today = Date.Today();
            newCase.Date_Due__c = today.addDays(minMaintenanceCycle);
            
            finalCaseList.add(newCase);
            // log the new case
            System.debug('finalCaseList: ' + finalCaseList);
        }

        insert finalCaseList;

        for (Case c : finalCaseList) {
            // get the Equipment_Maintenance_Item__c from the map
            List<Equipment_Maintenance_Item__c> secemiList = emiMap.get(c.BackUpId__c);

            // clone the Equipment_Maintenance_Item__c
            for (Equipment_Maintenance_Item__c emi : secemiList) {
                Equipment_Maintenance_Item__c newEmi = emi.clone(false, true, false, false);
                newEmi.Maintenance_Request__c = c.Id;
                finalEmiList.add(newEmi);
                // log the new Equipment_Maintenance_Item__c
                System.debug('finalEmiList: ' + finalEmiList);
            }
        }

        insert finalEmiList;
    }
    
}