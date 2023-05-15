public with sharing class OpportunityController_AC 
{ 
    @AuraEnabled 
    public static List<Opportunity> getOpportunities() 
    { 
        return [SELECT Id, Name,StageName,CloseDate,Amount FROM Opportunity Where Amount!= Null]; 
    } 
    // This method used for reterived  the list of opportunity records based on the search string 
    @AuraEnabled 
    public static List<Opportunity> getByName(String searchKey) { 
        String name = '%' + searchKey + '%'; 
        return [SELECT id, Name,StageName, CloseDate,Amount FROM Opportunity WHERE name LIKE :name and Amount!= Null]; 
    } 
}