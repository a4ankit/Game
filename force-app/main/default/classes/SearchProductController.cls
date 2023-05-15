public with sharing class SearchProductController {
    
    @AuraEnabled public List<String> result{get;set;}
    @AuraEnabled public List < Product2 > returnList{get;set;}
    
    
    @AuraEnabled
    public static SearchProductController productList(){
        SearchProductController obj = new SearchProductController();
        obj.returnList = [select Name,ProductCode,Vendor_Name__c, Vendor_Number__c 
                          from Product2
                         ];
        return obj;
    }
    @AuraEnabled
    public static SearchProductController fetchProductbyName(String searchKeyWord) {
        
        SearchProductController obj = new SearchProductController();
        String searchKey;
        Set < String > returnSetVIds = new Set < String > ();
        List < String > returnListVIds = new List < String > ();
        try
        {
            if(searchKeyWord.contains(','))
            {
                List<String> searchKeyCode = searchKeyWord.split(',') ;
                obj.returnList = [select Name,ProductCode,Vendor_Name__c, Vendor_Number__c 
                                  from Product2
                                  where Name in: searchKeyCode AND IsActive=TRUE LIMIT 500
                                 ];
            }
            else
            {
                
                searchKey = searchKeyWord + '%';
                obj.returnList  = [select Name,ProductCode,Vendor_Name__c,Vendor_Number__c from Product2
                                   where Name LIKE: searchKey AND IsActive=TRUE LIMIT 500];
            }
            for (Product2 prd: obj.returnList) {
                //obj.returnList.add(prd);
                returnListVIds.add(prd.Vendor_Number__c);
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
    public static SearchProductController fetchProductbyCode(String searchKeyWord) {
        
        SearchProductController objCode = new SearchProductController();
        List<String> searchKeyCode;
        Set < String > returnSetVIds = new Set < String > ();
        List < String > returnListVIds = new List < String > ();
        String searchKey;
        try
        {
            if(searchKeyWord.contains(','))
            {
                searchKeyCode = searchKeyWord.split(',') ;
                objCode.returnList = [select Name,ProductCode,Vendor_Name__c,Vendor_Number__c 
                                      from Product2 
                                      where ProductCode in: searchKeyCode AND IsActive=TRUE LIMIT 500
                                     ];  
            }
            
            else
            {
                searchKey = searchKeyWord + '%';
                objCode.returnList = [select Name,ProductCode,Vendor_Name__c,Vendor_Number__c 
                                      from Product2
                                      where ProductCode LIKE: searchKey AND IsActive=TRUE LIMIT 500
                                     ];
            }   
            
            for (Product2 prd: objCode.returnList) {
                returnListVIds.add(prd.Vendor_Number__c);
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