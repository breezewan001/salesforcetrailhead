public class AnimalLocator {
    
    public static HttpResponse makeGetCallout(String endpoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }

    public static String getAnimalNameById(Integer id) {
        JSON2Apex animalname = new JSON2Apex();
        String baseUrl = 'https://th-apex-http-callout.herokuapp.com/animals/';
        String endpoint = baseUrl + id;
        System.debug('endpoint::' + endpoint);
        HttpResponse response = makeGetCallout(endpoint);
        String animals = '';
        // If the request is successful, parse the JSON response.
        System.debug(response);
        System.debug(response.getBody());
        
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            System.debug('aaa:' + response.getBody());
            animalname = JSON2Apex.parse(response.getBody());
            System.debug('bbb:' + animalname.animal.name);
        }
        return animalname.animal.name;
    }
}