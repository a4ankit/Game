public with sharing class WeatherController {
    public static String apiKey = '53d9f8f988b88bdf7dc251a00e7a5aed';
    public Static String requestEndpoint = 'http://api.openweathermap.org/data/2.5/weather';
    
    @AuraEnabled    
    public static List<devsfdx__Weather_History__c> getInfo(String city, DateTime startTime, DateTime endTime) {
        requestEndpoint += '?q=' + city;
        requestEndpoint += '&appid=' + apiKey;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        WeatherWrapper wrpObj = new WeatherWrapper();
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            wrpObj.city = String.valueOf(results.get('name'));
            Map<String, Object> mainResults = (Map<String, Object>)(results.get('main'));
            wrpObj.temp = String.valueOf(mainResults.get('temp'));
            wrpObj.pressure = String.valueOf(mainResults.get('pressure'));
            wrpObj.humidity = String.valueOf(mainResults.get('humidity')); 
            wrpObj.temp_min = String.valueOf(mainResults.get('temp_min')); 
            wrpObj.temp_max = String.valueOf(mainResults.get('temp_max'));   
            
            devsfdx__Weather_History__c obj = new devsfdx__Weather_History__c();
            obj.Name = wrpObj.city;
            obj.devsfdx__Tempreture__c = wrpObj.temp;
            obj.devsfdx__pressure__c = wrpObj.pressure;
            obj.devsfdx__humidity__c = wrpObj.humidity;
            obj.devsfdx__temp_min__c = wrpObj.temp_min;
            obj.devsfdx__temp_max__c = wrpObj.temp_max;
            
            insert obj;
            
        }
        List<devsfdx__Weather_History__c> history = new List<devsfdx__Weather_History__c>();
        For(devsfdx__Weather_History__c objList : [SELECT Id, Name, 
                                                   devsfdx__Tempreture__c, 
                                                   devsfdx__pressure__c, 
                                                   devsfdx__humidity__c, 
                                                   devsfdx__temp_min__c, 
                                                   devsfdx__temp_max__c,
                                                   CreatedDate
                                                   FROM devsfdx__Weather_History__c 
                                                   WHERE (CreatedDate >=: startTime AND CreatedDate <=: endTime)
                                                   ORDER BY CreatedDate DESC]){
                                                       history.add(objList);
                                                   }
        return history;
    }
    public class WeatherWrapper{
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String temp{get;set;}
        @AuraEnabled public String pressure{get;set;}
        @AuraEnabled public String humidity{get;set;}
        @AuraEnabled public String temp_min{get;set;}
        @AuraEnabled public String temp_max{get;set;}
    }
}