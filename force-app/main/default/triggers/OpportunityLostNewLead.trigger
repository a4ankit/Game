//Trigger on Opportunity whenever Opportunity updated from any stage to 'Closed Lost'
trigger OpportunityLostNewLead on Opportunity (after update) {
    List<Opportunity> oppList = new List<Opportunity>();
    For(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Lost'){
            oppList.add(opp); //Adding Ids of Opportunity of stage 'Closed Lost'
        }
    }
    if(!oppList.isEmpty()){
        OpportunityLostNewLeadHandler.createLead(oppList);   //handler which is used to create leads from the opportunity which is converted to Closed Lost Stage
    }
}