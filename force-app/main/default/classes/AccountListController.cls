public class AccountListController {
    
    @AuraEnabled
    public static List < Account > fetchAccts() {
        return [ SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account ORDER BY Name ASC];
    }
    @AuraEnabled
    public static List < Account > fetchTypeAccts(String searchKeyWord) {
        return [ SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account WHERE Type =: searchKeyWord ORDER BY Name ASC];
    }
    @AuraEnabled
    public static List < Account > fetchTypeSourceAccts(String searchKeyWord, String searchKeywordSource) {
        return [ SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account WHERE Type =: searchKeyWord AND AccountSource =: searchKeywordSource ORDER BY Name ASC];
    }
    @AuraEnabled
    public static List < Account > fetchTypeIndustryAccts(String searchKeyWord, String searchKeywordIndustry) {
        return [ SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account WHERE Type =: searchKeyWord AND Industry =: searchKeywordIndustry ORDER BY Name ASC];
    }
    @AuraEnabled
    public static List<Account> saveAccount(String Id) {
        List<Account> accountList = new List<Account>();
        Boolean flag = False;
        For(Account acc : [SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account WHERE Id = :Id ]){
            if(acc.Name == 'Burlington Textiles Corp of America'){
                flag = True;
            }
            else{
                acc.IsActive__c = true;
                accountList.add(acc);
            }
        }
        try{
            update accountList;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        finally {
        }
        return [ SELECT Id, Name, Industry,AccountSource, Type, AnnualRevenue,Website, IsActive__c FROM Account ORDER BY Name ASC];
    }    
}