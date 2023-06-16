public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){   	

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setMethod('GET');
        request.setEndpoint(WAREHOUSE_URL);
        HttpResponse response = http.send(request);
        
        List<Product2> lstProduct = new List<Product2>();
        
        if(response.getStatusCode() == 200){
            List<Object> jsonResponse = (List<Object>) Json.deserializeUntyped(response.getBody());
            
            for(Object obj : jsonResponse){
                Map<String, Object> mapJson = (Map<String, Object>) obj;
                Product2 objProduct = new Product2();
                objProduct.Replacement_Part__c = true;
                objProduct.Name = (String) mapJson.get('name'); 
                objProduct.Maintenance_Cycle__c = (Integer) mapJson.get('maintenanceperiod');
                objProduct.Lifespan_Months__c = (Integer) mapJson.get('lifespan');
                objProduct.Cost__c = (Decimal) mapJson.get('cost');
                objProduct.Warehouse_SKU__c = (String) mapJson.get('sku');
                objProduct.Current_Inventory__c = (Integer) mapJson.get('quantity');
                lstProduct.add(objProduct);
            }
            if(lstProduct.size() > 0){
                upsert lstProduct;
            }
        }
    }
    
    public static void execute(QueueableContext context){
        runWarehouseEquipmentSync();
    }
    
    
}