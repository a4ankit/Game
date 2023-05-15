public class Merge_Record_Using_Batch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, Name FROM Account where name = 'Test0' or Name = 'Test1' or Name = 'Test2' or Name = 'Test3' or Name = 'Test4' ]);
    }
    public void execute(Database.BatchableContext context, Account[] records) {
        system.debug('records:'+records);
        for(Account record: records) {
            try {
                Database.merge(new Account(Id=records[0].Id), new List<Account>{records[1],records[2],records[3],records[4]});
                //record.Status__c = 'Success';
            } catch(exception e) {
                //record.Status__c = 'Failed';
            }
        }
        update records;
    }
    public void finish(Database.BatchableContext context) {
    }
}