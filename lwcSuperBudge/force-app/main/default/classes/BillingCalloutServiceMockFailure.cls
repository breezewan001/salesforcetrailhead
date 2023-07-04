// create webservice mock BillingCalloutServiceMockFailure class
@isTest
public class BillingCalloutServiceMockFailure implements WebServiceMock{ 
   // create http response mock
   HttpResponse response = new HttpResponse();
   // implement http response mock
   public void doInvoke(
      Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
         BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();
         response_x.status = 'ERROR';
         response.put('response_x', response_x);
   }
}

