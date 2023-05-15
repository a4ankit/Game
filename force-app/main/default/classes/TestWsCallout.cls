public class TestWsCallout{
    
    Account myAccount;
   
    public PageReference InsertRecord() {
        myAccount = new Account(name = 'Test Account');
        insert myAccount;
        // Calling a Web Service here would throw an exception
        return null;
    }
    
    public PageReference CallWebService() {
        
        // Execute a call to a Web Service
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://ankit96-dev-ed.my.salesforce.com?id=' + myAccount.Id);
        req.setMethod('GET');
        HttpResponse response = new Http().send(req);
        
        // Simulate an update
        myAccount.Name = 'Test Account 2';
        update myAccount;        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'WebService Called on New Account: ' + myAccount.Name));
        return null;
    }
}