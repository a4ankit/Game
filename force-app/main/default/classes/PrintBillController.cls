public class PrintBillController {
    @AuraEnabled
    public static List<SObject> getProduct(String searchTerm){
        List<SObject> searchList = [SELECT Id, Name, ProductCode, Family, UnitPrice__c From Product2 WHERE Name Like '%searchTerm%'];
        return searchList;
    }
}