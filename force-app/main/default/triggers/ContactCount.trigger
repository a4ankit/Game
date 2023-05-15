trigger ContactCount on Contact (after insert, after update, after delete, after undelete) {
    Map<Id, List<Contact>> mapAcctIdContactList = new Map<Id, List<Contact>>();
    Map<Id, List<Contact>> mapAcctIdDelContactList = new Map<Id, List<Contact>>();
    Set<Id> AcctIds = new Set<Id>();    
    List<Contact> listCont = new List<Contact>();
    List<Account> listAcct = new List<Account>();
    if(trigger.isInsert) {
        system.debug('In insert::'+trigger.new);
        for(Contact Con : trigger.New) {
            system.debug('Con:::'+Con);
            if(String.isNotBlank(Con.AccountId)) {
                system.debug('Acc ID of Contact=='+(Con.AccountId));
                if(!mapAcctIdContactList.containsKey(Con.AccountId)) {
                    system.debug('Contains key ='+Con.AccountId);
                    mapAcctIdContactList.put(Con.AccountId, new List<Contact>());
                }
                mapAcctIdContactList.get(Con.AccountId).add(Con);
                system.debug('mapAcctIdContactList'+mapAcctIdContactList);
                AcctIds.add(Con.AccountId);
                system.debug('AccIds = = '+AcctIds);
            }   
        }  
    }
    
    if(trigger.isUpdate) {
        system.debug('In update');
        for(Contact Con : trigger.New) {
            system.debug('Contact::'+Con);
            system.debug('String.isNotBlank(Con.AccountId)'+Con.AccountId);
            system.debug('trigger.oldMap.get(Con.Id).AccountId'+trigger.oldMap.get(Con.Id).AccountId);
           /* if(String.isNotBlank(Con.AccountId) && Con.AccountId != trigger.oldMap.get(Con.Id).AccountId) {
                if(!mapAcctIdContactList.containsKey(Con.AccountId)){
                    system.debug('In if mapAcctIdContactList'+mapAcctIdContactList);
                    mapAcctIdContactList.put(Con.AccountId, new List<Contact>());
                    system.debug('After put map'+mapAcctIdContactList);
                }
                mapAcctIdContactList.get(Con.AccountId).add(Con);
                system.debug('After contact got'+mapAcctIdContactList);
                AcctIds.add(Con.AccountId);
                system.debug('AcctIds'+AcctIds);
            }
            
            else if(String.isBlank(Con.AccountId) && String.isNotBlank(trigger.oldMap.get(Con.Id).AccountId)) {
                system.debug('String.isBlank(Con.AccountId)::'+String.isBlank(Con.AccountId)); 
                system.debug('String.isNotBlank(trigger.oldMap.get(Con.Id).AccountId)::'+String.isNotBlank(trigger.oldMap.get(Con.Id).AccountId));
                if(!mapAcctIdDelContactList.containsKey(Con.AccountId)){
                    system.debug('In if mapAcctIdContactList::'+mapAcctIdContactList);
                    mapAcctIdDelContactList.put(Con.AccountId, new List<Contact>());
                    system.debug('In after put mapAcctIdContactList:::'+mapAcctIdContactList);
                }
                mapAcctIdDelContactList.get(Con.AccountId).add(Con);   
                system.debug('mapAcctIdDelContactList::'+mapAcctIdDelContactList);
                AcctIds.add(trigger.oldMap.get(Con.Id).AccountId);
                system.debug('AcctIds::'+AcctIds);
            }*/
            AcctIds.add(trigger.oldMap.get(Con.Id).AccountId);
                system.debug('AcctIds::'+AcctIds);
        }  
    }
    
    if(trigger.isUndelete) {
        for(Contact Con : trigger.new) {
            if(String.isNotBlank(Con.AccountId)){
                if(!mapAcctIdContactList.containsKey(Con.AccountId)){
                    mapAcctIdContactList.put(Con.AccountId, new List<Contact>());
                }
                mapAcctIdContactList.get(Con.AccountId).add(Con);     
                AcctIds.add(Con.AccountId);
            }
        }  
    }      
    
    if(trigger.isDelete) {
        for(Contact Con : trigger.Old) {
            if(String.isNotBlank(Con.AccountId)){
                if(!mapAcctIdDelContactList.containsKey(Con.AccountId)){
                    mapAcctIdDelContactList.put(Con.AccountId, new List<Contact>());
                }
                mapAcctIdDelContactList.get(Con.AccountId).add(Con);    
                AcctIds.add(Con.AccountId); 
            }
        }  
    }   
    
    if(AcctIds.size() > 0) {
        listCont = [SELECT devsfdx__Amount__c, ID, Account.Number_of_Contacts__c,Account.devsfdx__Total_Amount__c , AccountID FROM Contact WHERE AccountId IN : AcctIds];
        AggregateResult[] aggr = [SELECT SUM(devsfdx__Amount__c)aver FROM Contact WHERE AccountId IN : AcctIds];
        listAcct = [SELECT Id, devsfdx__Number_of_Contacts__c, devsfdx__Total_Amount__c FROM Account WHERE Id IN : AcctIds];
        system.debug('listCont++'+listCont);
        system.debug('Contacts++'+listCont.size());
        system.debug('aggr=='+aggr);
        system.debug('listAcct'+listAcct);
        Object amount = 0;
        listAcct[0].Number_of_Contacts__c = listCont.size();
        amount = aggr[0].get('aver');
        system.debug('Amount'+amount);
        listAcct[0].Total_Amount__c = Integer.valueOf(amount);
        
        /*for(Contact acct : listCont) {
            Integer noOfConts = 0;
            Object amount = 0;
            system.debug('acct'+acct.AccountId);
            system.debug('mapAcctIdContactList.containsKey(acct.AccountId)'+mapAcctIdContactList.containsKey(acct.AccountId));
            if(mapAcctIdContactList.containsKey(acct.AccountId)) {
                noOfConts = listCont.size();
                system.debug('noOfConts'+noOfConts);
                //noOfConts += mapAcctIdContactList.get(acct.Id).size();
                //amount = aggr[0].get('aver');
                //system.debug('====='+amount);
            }
            if(mapAcctIdDelContactList.containsKey(acct.Id)) {
                noOfConts -= mapAcctIdDelContactList.get(acct.Id).size();
            }
            //acct.Account.Number_of_Contacts__c = acct.Account.Number_of_Contacts__c == null ? noOfConts : (acct.Account.Number_of_Contacts__c + noOfConts);
            acct.Account.Number_of_Contacts__c = noOfConts;
            acct.Account.Total_Amount__c = acct.devsfdx__Amount__c;
            listContNew.add(acct);
        }*/
        system.debug('listAcct=='+listAcct);
        update listAcct;    
        system.debug('listAcct==++'+listAcct);
    }
}