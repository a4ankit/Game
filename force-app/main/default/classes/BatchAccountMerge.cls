global class BatchAccountMerge implements Database.Batchable<sobject> {
    
    global  Database.QueryLocator start(Database.BatchableContext ctx) {                  
        return Database.getQuerylocator([SELECT Id, Type, Fax, RecordTypeId, Name, MasterRecordId FROM Account]); 
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accounts ) {
        Map<String, List<Account>> vendorAccountsToMerge = new Map<String, List<Account>>();
        
        
        for (Account account : accounts) {
            
            List<Account> accountsToMerge = vendorAccountsToMerge.get(account.fax);
            if (accountsToMerge == null) {
                accountsToMerge = new List<Account>();
                vendorAccountsToMerge.put(account.name, accountsToMerge);
            }
            
            if (accountsToMerge.size() < 5) {
                accountsToMerge.add(account);
            } else {
                
                System.debug('Maximum of accounts to merge reached.');
            }
            
        }
        System.debug('****vendor and acc map*** '+vendorAccountsToMerge);
        List<account> dupacc = new list<account>();
        
        for (String vendorCode : vendorAccountsToMerge.keySet()) {
            
            List<Account> accountsToMerge = vendorAccountsToMerge.get(vendorCode);
            
            if (accountsToMerge.size() > 1) {  
                
                Account masterAccount;
                List<Id> duplicatedAccounts = new List<Id>();           
                
                for (Account account : accountsToMerge) {
                    
                    if (account.Name == 'Test Account 2') {
                        
                        if (masterAccount == null) {
                            masterAccount = account;
                        } else {
                            System.debug('More than one account with the record type A found. Details:');
                            System.debug('Account Ids: ' + masterAccount + ' ' + account.Id);
                        }
                        
                    } else if (account.Name == 'Test Account 2') {
                        duplicatedAccounts.add(account.Id);
                    }
                    
                }
                
                System.debug('***Master account*** ' + masterAccount);
                System.debug('***Duplicated accounts*** ' + duplicatedAccounts);
                
                Database.MergeResult[] results = Database.merge(masterAccount, duplicatedAccounts, false);
                
                System.debug('***results merged** ' + results);
                
                
            }
            
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        
    }
    
    
}