public with sharing class AccountTableController {
    
    @AuraEnabled public List<String> result{get;set;}
    @AuraEnabled public List <Account> returnList{get;set;}
    
    @AuraEnabled
    public static AccountTableController fetchAccts() {
        AccountTableController obj = new AccountTableController();
        obj.returnList = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c,Type
                          from Account
                         ];
        return obj;
        
    }
    @AuraEnabled
    public static AccountTableController productList(){
        AccountTableController obj = new AccountTableController();
        obj.returnList = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c,Type
                          from Account
                         ];
        return obj;
    }
    @AuraEnabled
    public static AccountTableController fetchProductbyName(String searchKeyWord) {
        
        AccountTableController obj = new AccountTableController();
        String searchKey;
        Set < String > returnSetVIds = new Set < String > ();
        List < String > returnListVIds = new List < String > ();
        try
        {
            if(searchKeyWord.contains(','))
            {
                List<String> searchKeyCode = searchKeyWord.split(',') ;
                obj.returnList = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c 
                                  from Account
                                  where Type in: searchKeyCode AND devsfdx__IsActive__c=TRUE LIMIT 500
                                 ];
            }
            else
            {
                
                searchKey = searchKeyWord + '%';
                obj.returnList  = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c, Industry, Type
                                   from Account
                                   where Type LIKE: searchKey AND devsfdx__IsActive__c=TRUE LIMIT 500];
            }
            for (Account prd: obj.returnList) {
                //obj.returnList.add(prd);
                returnListVIds.add(prd.Industry);
            }
            system.debug(returnListVIds);
            returnSetVIds.addAll(returnListVIds);
            system.debug(returnSetVIds);
            obj.result = new List<String>();
            obj.result.addAll(returnSetVIds); 
            return obj;
        }
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Something went wrong: '
                                           + e.getMessage());    
        }
    }
    
    @AuraEnabled
    public static AccountTableController fetchProductbyCode(String searchKeyWord) {
        
        AccountTableController objCode = new AccountTableController();
        List<String> searchKeyCode;
        Set < String > returnSetVIds = new Set < String > ();
        List < String > returnListVIds = new List < String > ();
        String searchKey;
        try
        {
            if(searchKeyWord.contains(','))
            {
                searchKeyCode = searchKeyWord.split(',') ;
                objCode.returnList = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c, Industry, AccountSource,type
                                      from Account
                                      where Type in: searchKeyCode AND devsfdx__IsActive__c=TRUE LIMIT 500
                                     ];  
            }
            
            else
            {
                searchKey = searchKeyWord + '%';
                objCode.returnList = [select Name,AnnualRevenue,Website, devsfdx__IsActive__c, Industry, AccountSource
                                      from Account
                                      where Type LIKE: searchKey AND devsfdx__IsActive__c=TRUE LIMIT 500
                                     ];
            }   
            
            for (Account prd: objCode.returnList) {
                returnListVIds.add(prd.AccountSource);
            }
            
            returnSetVIds.addAll(returnListVIds);
            objCode.result = new List<String>();
            objCode.result.addAll(returnSetVIds); 
            return objCode;
        }
        
        catch (Exception e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Something went wrong: '
                                           + e.getMessage());    
        }
    }
    
}