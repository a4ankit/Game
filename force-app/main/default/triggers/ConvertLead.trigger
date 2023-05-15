trigger ConvertLead on Lead (after update, after insert) {
    List<Lead> leadList = new List<Lead>();
    for (Lead l : Trigger.new)  {
        leadList.add(l);
        system.debug('leadList'+leadList);
    }
    if(!leadList.isEmpty() && leadList.size()>0 && leadList != Null){
        system.debug('In if');
        if(leadList[0].status == 'Closed - Not Converted' && leadList[0].id != null ){
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadList[0].id);
            system.debug('lc'+lc);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            system.debug('lc'+lc);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            
        }    
    }
}