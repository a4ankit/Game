trigger stopWhenOtherfieldsModified on Account (Before update) {

    Set<Id> recordids = new Set<Id>();
    Account a = new Account();
    for(Account acc: Trigger.new)
    {
        recordids.add(acc.id);
        acc.addError('Your Id');
        if(Trigger.new != Trigger.old)
        {
             acc.addError('You cant change alonge with source field');
        }
       // else(Trigger.new == Trigger.old);
        {
           
        }
    }
    system.debug('recordids'+recordids);
    
       
}