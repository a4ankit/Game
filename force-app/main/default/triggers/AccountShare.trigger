trigger AccountShare on Account (after insert) {
    
    if(trigger.isInsert){
        
        List<AccountShare> jobShares = new List<AccountShare>();
        
        for(Account t : trigger.new){
            
            AccountShare studentRecord = new AccountShare();
            
            studentRecord.AccountId = t.Id;
            
            
            studentRecord.UserOrGroupId = t.name;
            
            studentRecord.AccountAccessLevel = 'edit';
            
            studentRecord.RowCause = Schema.AccountShare.RowCause.Manual;
            
            jobShares.add(studentRecord);
        }
        
        Database.SaveResult[] jobShareInsertResult = Database.insert(jobShares,false);
    }
}