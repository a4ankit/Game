global class Accountupdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Phone FROM Account ';
        return Database.getQueryLocator(query);
       
    }

    global void execute(Database.BatchableContext BC, List<Account> scope)
        
    {
         
        
        for (Account a : scope)
        {
           a.Phone='123';
            
        }
        update scope;
       // System.debug(scope);
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}