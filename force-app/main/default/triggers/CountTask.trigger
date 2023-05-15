trigger CountTask on Task (after insert, after update,after delete) {
    
    public List<Task> task1 = new List<Task>();
    public List<id> oppid = new list<id>();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) ){
        for(Task t:Trigger.New){
            oppid.add(t.WhatId);
            
        }
        
        System.debug('oppid'+oppid);
        task1 = [select id,Status from task where WhatId IN :oppid];
        
        List<opportunity> opp = new List<opportunity>();
        List<Opportunity> op1 = [select id from Opportunity where id IN :oppid];
        
        for(opportunity o: op1){
            o.Temp_Activity_Count__c = task1.size();
            opp.add(o);  
        }
        update opp;
    }
    if(trigger.isAfter && trigger.isDelete ){
        for(Task t: Trigger.Old){
            oppid.add(t.WhatId);
            
        }
        
        System.debug('oppid'+oppid);
        task1 = [select id,Status from task where WhatId IN :oppid];
        
        List<opportunity> opp = new List<opportunity>();
        List<Opportunity> op1 = [select id from Opportunity where id IN :oppid];
        
        for(opportunity o: op1){
            o.Temp_Activity_Count__c = task1.size();
            opp.add(o);  
        }
        update opp;
        
    }
    
}