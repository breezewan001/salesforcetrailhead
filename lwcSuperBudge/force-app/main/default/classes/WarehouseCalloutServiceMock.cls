// create WarehouseCalloutServiceMock class for testing WarehouseCalloutService class
public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"name":"Test Product","maintenanceperiod":12,"lifespan":24,"cost":100.00,"sku":"TESTSKU","quantity":10}]');
        res.setStatusCode(200);
        return res;
    }
}