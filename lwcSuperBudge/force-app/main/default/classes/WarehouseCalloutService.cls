public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    // create a rest request to the warehouse service
    public static List<Product2> getEquipment() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.

            // log the response body
            System.debug('response.getBody(): ' + response.getBody());
            
            List<Object> externalProducts = (List<Object>) JSON.deserializeUntyped(response.getBody()); //desrialize the json response
            // log the externalProducts
            System.debug('externalProducts: ' + externalProducts);

            List<Product2> newProducts = new List<Product2>();
            
            for(Object p : externalProducts)
            {
                Map<String, Object> productMap = (Map<String, Object>) p;
                Product2 pr = new Product2();
            	//Map the fields in the response to the appropriate fields in the Equipment object
                pr.Replacement_Part__c = (Boolean)productMap.get('replacement');
                pr.Cost__c = (Integer)productMap.get('cost');
                pr.Current_Inventory__c = (Integer)productMap.get('quantity');
                pr.Lifespan_Months__c = (Integer)productMap.get('lifespan') ;
                pr.Maintenance_Cycle__c = (Integer)productMap.get('maintenanceperiod');
                pr.Warehouse_SKU__c = (String)productMap.get('sku');
                pr.ProductCode = (String)productMap.get('_id');
                pr.Name = (String)productMap.get('name');
        
                newProducts.add(pr);
            }

            return newProducts;

        }
        else {
            // If the callout was not successful, create a custom exception to display the error message
            WarehouseCalloutException exception1 = new WarehouseCalloutException('The callout to the warehouse was unsuccessful with status code ' + response.getStatusCode() + ' and message ' + response.getStatus());
            // log the error
            System.debug('Error1: ' + exception1);
            throw exception1;
        }
    }

    // create future method to upsert the getEquipment() function result to product2 using warehouse sku as external id
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        List<Product2> products = getEquipment();
        // log getEquipment() result
        System.debug('getEquipment() result: ' + products);

        if (products.size() > 0) {
            List<Database.UpsertResult> upsertResults = Database.upsert(products, Product2.Fields.Warehouse_SKU__c, false);
            // log upsert result
            System.debug('upsert result: ' + upsertResults);
            for (Database.UpsertResult result : upsertResults) {
                if (!result.isSuccess()) {
                    WarehouseCalloutException exception2 = new WarehouseCalloutException('The product ' + result.getId() + ' was not updated due to the following error: ' + result.getErrors()[0].getMessage());
                    // log the error
                    System.debug('Error2: ' + exception2);
                    throw exception2;
                }
            }
        }
        
    }

    // WarehouseCalloutException class
    public class WarehouseCalloutException extends Exception {}
}