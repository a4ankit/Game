public class BatchRemoveDuplicateLeads implements Database.Batchable<SObject> , Database.Stateful{
    
    public map<string,list<lead>> leadToWork;
    public list<lead> leadToUpdate;
    public list<lead> leadToDelete;
    
    public set<Id> setOfId;
    public set<string> setOfuniqueField;
    public string fieldCheck;
    
    public BatchRemoveDuplicateLeads(string fieldToCheck ){
        
        setOfId = new set<Id>();
        fieldCheck = fieldToCheck;
        setOfuniqueField = new set<string>();
        
        leadToWork = new map<string,list<lead>>();
        leadToUpdate = new  list<lead>();
        leadToDelete = new list<lead>();
        
    }
    
    public list<sObject> start(Database.BatchableContext BC){
        
        list<lead> scopeList = new list<lead>();
        system.debug('fieldCheck::'+fieldCheck);
        if(fieldCheck.equalsIgnoreCase('email'))   	
            scopeList = database.query('Select Email,Additional_Email__c from Lead where email !=null order by lastModifiedDate');  
        else scopeList = database.query('Select Email,Additional_Email__c, '+ fieldCheck +'  from Lead where '+ fieldCheck +'!=null order by lastModifiedDate');  	
        system.debug('scopeList::'+scopeList);
        return scopeList;    
        
    }    
    public void execute(Database.BatchableContext BC , List<Lead> scope){
        
        for(Lead l : scope)
        {						
            if(leadToWork.containsKey(string.ValueOf(l.get(fieldCheck)))){				
                leadToWork.get(string.ValueOf(l.get(fieldCheck))).add(l);
                setOfId.add(l.Id);
                setOfuniqueField.add(string.ValueOf(l.get(fieldCheck)));
            }
            else{
                leadToWork.put(string.ValueOf(l.get(fieldCheck)),new list<lead>{l});
                setOfId.add(l.Id);
                setOfuniqueField.add(string.ValueOf(l.get(fieldCheck)));
            } 				 										
            
        }
        
        
        list<lead> queryLead = new list<lead>();
        if(fieldCheck.equalsIgnoreCase('email'))
            queryLead = database.query('select id,email,Additional_Email__c from lead where id Not In :setOfId and email In :setOfuniqueField');
        
        else queryLead = database.query('select id,'+fieldCheck+',email,Additional_Email__c from lead where id Not In :setOfId and '+fieldCheck+' In :setOfuniqueField');
        
        for(lead ld : queryLead){
            
            if(leadToWork.get(string.ValueOf(ld.get(fieldCheck))) != null)
                leadToWork.get(string.ValueOf(ld.get(fieldCheck))).add(ld);
        }
        
        for(string uniqueField : leadToWork.keySet()){
            
            list<Lead> leadList = leadToWork.get(uniqueField);
            
            if(!leadList.isEmpty() && leadList.size()>1){
                
                Lead mainLead = leadList[0];
                leadList.remove(0);
                
                for(lead leadInList : leadList){
                    
                    leadToDelete.add(leadInList);
                    
                    if(leadInList.email!=null){
                        
                        if(mainLead.email!=null && mainLead.email!=leadInList.email){
                            
                            if(mainLead.Additional_Email__c !=null){
                                mainLead.Additional_Email__c += ','+leadInList.email;
                            }
                            else{
                                mainLead.Additional_Email__c = leadInList.email;
                            }
                            
                            
                        }else{
                            
                            mainLead.email = leadInList.email;
                            
                        }
                    }
                }
                
                leadToUpdate.add(mainLead);
            }	 			
            
        }
        
        try{
            if(!leadToUpdate.isEmpty())
                system.debug('leadToUpdate::'+leadToUpdate);
            update leadToUpdate;
            if(!leadToDelete.isEmpty())
                system.debug('leadToDelete::'+leadToDelete);
            delete leadToDelete;
        }
        catch(exception e){
        }
    }
    public void finish(Database.BatchableContext BC){
    }
}