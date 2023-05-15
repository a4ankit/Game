public class googleMaps {
    
    public Decimal distance;
    
    public googleMaps(String address1,String address2) {
        
        String jsonResults = getJsonResults(address1, address2); // hitting google map api
        jsonResults = formatJsonResults(jsonResults); //formatizing response of google map 
        updateJsonSections(jsonResults);
    }
    
    public String getJsonResults(
        String address1,
        String address2) {
            
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            
            req.setMethod('GET');
            
            String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
                + '?origins=' + address1
                + '&destinations=' + address2
                //+ '&mode=driving'
                //+ '&sensor=false'
                + '&language=mi'
                //+ '&units=imperial';//imperial will return distance in miles.
                +'&units=METRIC';	//metric will return distance in Kms.
            
            req.setEndPoint(url);
            
            HTTPResponse resp = http.send(req);
            
            String jsonResults = resp.getBody().replace('\n', '');
            // String jsonResults = resp.getBody();        
            system.debug('++++++jsonResults+++++'+jsonResults);
            return jsonResults;
        }
    
    public String formatJsonResults(String value) {
        
        value = value.replace('{', ', ');
        value = value.replace('}', ', ');
        value = value.replace('[', ', ');
        value = value.replace(']', ', ');
        value = value.replace('"', '');
        //	system.debug('value '+value);
        return value;	
    }
    
    public void updateJsonSections(String jsonResults) {
        
        List<String> jsonSections = jsonResults.split(', ');
        //	system.debug('jsonSections' +JSON.serialize(jsonSections));		
        for (Integer i = 0; i < jsonSections.size(); i++) {
            jsonSections[i] = jsonSections[i].trim();
            
            if (jsonSections[i].contains('distance :')) {
                distance = parseDistance(jsonSections[i + 1]);
                
            }
            
        }	//conversion from miles to Kms.
        //distance=distance*1.609344;
        System.debug('****distance in KM::::'+distance);
        
    }
    
    public Decimal parseDistance(String value) {
        value = value.replace('text : ', '');
        //value = value.replace('mi', '');
        value = value.replace('km', '');
        //	value = value.replace('ft', '');
        //	value = value.replace(',', '');
        //	System.debug('////value'+value);
        value = value.trim();
        //    System.debug('////value'+value);
        
        return Decimal.valueOf(value);
    }
}