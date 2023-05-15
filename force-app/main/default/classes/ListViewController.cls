public with sharing class ListViewController {
    // Method to get all list view option available for the Contact object 
    @AuraEnabled
    public static List<ListView> getListViews(){
        List<ListView> listviews = new List<ListView>();
        list<string> listViewStr = new list<string>{'All Contacts','My Contacts'};
        for(ListView lstObj : [SELECT Id, Name FROM ListView WHERE SobjectType = 'Contact' and Name IN : listViewStr order by name ASC]){
            listviews.add(lstObj);
        }
        return listviews; 
    }
    // Method to get the Contact records based on the selected list view
    @AuraEnabled  
    public static List<Contact> getFilteredContacts(String filterName){
        System.debug('filterName=====1'+filterName);
       
        List<Contact> ContactList = new List<Contact>();
        if(filterName == 'All Contacts'){
            for(Contact ContactObj : [select id,Name,Birthdate from contact where Birthdate != null Limit 90]){
                ContactList.add(ContactObj);
            } 
        } 
        else if(filterName == 'My Contacts'){
            for(Contact ContactObj : [select id,Name,Birthdate from contact where Birthdate != null AND OwnerId = :userinfo.getUserId() Limit 90]){
                ContactList.add(ContactObj);
            } 
        } 
        
        return ContactList;        
    }
    @AuraEnabled  
    public static List<Contact> getBirthDayInDaysContacts(string BirthDayInDays, String SelectedListView){
        List<Contact> lstResults = new List<Contact>();
        if(BirthDayInDays != null ){
            system.debug('SelectedListView--'+SelectedListView+'BirthDayInDays==='+BirthDayInDays);
            if(SelectedListView == 'All Contacts'){
                for(Contact objCon : [Select id ,Name,Birthdate from Contact where Birthdate != null LIMIT 90]){
                    //lstResults = new List<Contact>();
                    system.debug('!!!!!!!!'+objCon.Birthdate);
                    string RemainDaysToBirthday = string.valueOf((system.today()).daysBetween(objCon.Birthdate));
                    system.debug('RemainDaysToBirthday--'+RemainDaysToBirthday+'---'+BirthDayInDays);
                    
                    if(Integer.valueOf(BirthDayInDays) > Integer.valueOf(RemainDaysToBirthday)){
                        lstResults.add(objCon);
                        system.debug('22222222222'+lstResults);
                    }
                   
                }
                 return lstResults ;
            }else{
                for(Contact ContactObj : [select id,Name,Birthdate from contact where Birthdate != null AND OwnerId = :userinfo.getUserId() Limit 90]){
                   // lstResults = new List<Contact>();
                    string RemainDaysToBirthday = string.valueof((system.today()).daysBetween(ContactObj.Birthdate));
                    system.debug('RemainDaysToBirthday==='+RemainDaysToBirthday);
                    if(Integer.valueOf(BirthDayInDays) > Integer.valueOf(RemainDaysToBirthday)){
                        lstResults.add(ContactObj);
                    }
                }
                system.debug('lstResults==='+lstResults);
                return lstResults ;              
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static String fetchit(){
        string urler = URL.getSalesforceBaseUrl().toString();
        return (urler);
    }

}