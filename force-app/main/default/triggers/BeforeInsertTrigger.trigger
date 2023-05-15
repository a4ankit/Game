trigger BeforeInsertTrigger on Account (before insert) {
 
    set<id> sid = new set<id>();
 
    for(Account A :trigger.new){
 
        sid.add(A.Id);
 
        system.debug('sid :'+sid);
 
        Account Acc = trigger.newMap.get(A.Id);
 
        system.debug('Acc :'+Acc);
 
    }
 
}