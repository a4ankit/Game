@isTest
private class AccountManagerTest {

    private static testMethod void getAccountTest() {  
        
        Id recordId = createTestRecord();
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Accounts/'+recordId+'/contacts' ;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // Call the method to test
        Account account = AccountManager.getAccount();
        
        // Verify results
        System.assert(account != null);
    }
    
    static Id createTestRecord() {
        // Create test record
        Account acc = new Account(Name='Test record');
        insert acc;
        return acc.Id;
    }          
}