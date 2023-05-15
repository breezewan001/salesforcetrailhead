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
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            animals = (String) results.get('animals');
            System.debug('Received the following animals:');
        }
        return animals;
    }

    public class Animal {
        Integer id;
        String name;
    }
}