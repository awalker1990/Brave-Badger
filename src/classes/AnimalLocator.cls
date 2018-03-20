public class AnimalLocator {
    
    public static String getAnimalNameById(Integer a) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + a);
        request.setMethod('GET');              
        HttpResponse response = http.send(request);
        String strResp = '';
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody() );
            Map<string,object> animals = (map<string,object>) results.get('animal');
            strResp = string.valueOf(animals.get('name'));  
            system.debug('String of animal names: ' + strResp);
        } 
        return strResp;
        
	}
}