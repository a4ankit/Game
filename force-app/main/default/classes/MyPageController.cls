public with sharing class MyPageController {
    
    public String city {get;set;}
    public String temp {get;set;}
    public String pressure {get;set;}
    public String humidity {get;set;}
    public String temp_min {get;set;}
    public String temp_max {get;set;}
    
    public MyPageController(ApexPages.StandardController stdController) {
        Account account = (Account)stdController.getRecord();
        account = [SELECT Id, ShippingCity FROM Account WHERE Id ='0017F00001e8TOn'];
        
        String accountCity = account.ShippingCity;
        String apiKey = '53d9f8f988b88bdf7dc251a00e7a5aed';
        
        String requestEndpoint = 'http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=53d9f8f988b88bdf7dc251a00e7a5aed';
        // requestEndpoint += '?q=' + accountCity;
        //requestEndpoint += '&appid=' + apiKey;
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            city = String.valueOf(results.get('name'));
            
            Map<String, Object> mainResults = (Map<String, Object>)(results.get('main'));
            temp = String.valueOf(mainResults.get('temp'));
            pressure = String.valueOf(mainResults.get('pressure'));
            humidity = String.valueOf(mainResults.get('humidity')); 
            temp_min = String.valueOf(mainResults.get('temp_min')); 
            temp_max = String.valueOf(mainResults.get('temp_max'));
            
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
            ApexPages.addMessage(myMsg);
        }
        
        
    }
}