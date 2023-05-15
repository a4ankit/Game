trigger accountLimitExample on Account (after delete, after insert, after update) {
    
    System.debug('Total Number of SOQL Queries allowed in this Apex code context: ' +  Limits.getLimitQueries());
    System.debug('Total Number of records that can be queried  in this Apex code context: ' +  Limits.getLimitDmlRows());
    System.debug('Total Number of DML statements allowed in this Apex code context: ' +  Limits.getLimitDmlStatements() );
    System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: ' +  Limits.getLimitCpuTime());
    
    // Query the Opportunity object
    List<Opportunity> opptys =
        [select id, description, name, accountid,  closedate, stagename from Opportunity where accountId IN: Trigger.newMap.keySet()];
    
    System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getQueries());
    System.debug('2. Number of rows queried in this Apex code so far: ' + Limits.getDmlRows());
    System.debug('3. Number of DML statements used so far: ' +  Limits.getDmlStatements());   
    System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
    
    //NOTE:Proactively determine if there are too many Opportunities to update and avoid governor limits
    if (opptys.size() + Limits.getDMLRows() > Limits.getLimitDMLRows()) {
        System.debug('Need to stop processing to avoid hitting a governor limit. Too many related Opportunities to update in this trigger');
        System.debug('Trying to update ' + opptys.size() + ' opportunities but governor limits will only allow ' + Limits.getLimitDMLRows());
        for (Account a : Trigger.new) {
            a.addError('You are attempting to update the addresses of too many accounts at once. Please try again with fewer accounts.');
        }
    }
    
    else{
        System.debug('Continue processing. Not going to hit DML governor limits');
        System.debug('Going to update ' + opptys.size() + ' opportunities and governor limits will allow ' + Limits.getLimitDMLRows());
        for(Account a : Trigger.new){
            System.debug('Number of DML statements used so far: ' +  Limits.getDmlStatements());
            
            
            for(Opportunity o: opptys){
                if (o.accountid == a.id)
                    o.description = 'testing';
            }
            
        }
        update opptys;
        System.debug('Final number of DML statements used so far: ' +  Limits.getDmlStatements());
        System.debug('Final heap size: ' +  Limits.getHeapSize());
    }
}