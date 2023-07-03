// create mock callout failure class
@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
       // Implement this interface method
   global HTTPResponse respond(HTTPRequest req) {
      // Create a fake response
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"Status":"Internal Server Error"}');
      res.setStatusCode(500);
      return res;
   }
}
