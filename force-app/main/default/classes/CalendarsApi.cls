/** This class is used to make callout whenever we execute this class by country and year this will create events for that country */
public class CalendarsApi {
    public static String API_KEY = '2KMBIOzLgHlJT1jrROF82aUSYXBejLDqRWCQD081n3yFkqlig9aX0Z3ML3ts';          // Api Key of Holiday Oracle Account for a user
    public static HolidayWarpper createCalenderData(String country, String year){
        Http h= new Http();
        HttpRequest req= new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization','Bearer ' + API_KEY);
        req.setHeader('Content-Type','application/json');
        req.setEndpoint('https://holidayoracle.io/api/v1/date/holidays?country='+country+'&year='+year); //URL which used to get holiday information of the country and year 
        HttpResponse res=h.send(req);
        HolidayWarpper resp1=(HolidayWarpper)JSON.deserialize(res.getBody(),HolidayWarpper.class);
        List<Event> eventList = new List<Event>();
        for(HolidayWarpper.Data obj : resp1.Data){ //creating events for the coming response from holiday api
            Event E = new Event();
            E.Subject = obj.holiday_description;
            E.Type = 'Email';
            E.Description = obj.holiday_description; //string
            E.OwnerId = UserInfo.getUserId(); //user id
            E.WhatId = '0067F00000esvM5QAI'; //record id
            E.StartDateTime = Datetime.now();
            E.EndDateTime = Datetime.now();
            eventList.add(E);
        }
        upsert eventList; //upserting events
        return resp1;
    }
    
}