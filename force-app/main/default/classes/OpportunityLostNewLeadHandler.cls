public class OpportunityLostNewLeadHandler {
    public static void createLead(List<Opportunity> oppList){
        List<Lead> newLeadList = new List<Lead>();
        for(Opportunity opp : oppList){
            Lead ld = new Lead();
            ld.FirstName = [SELECT Id, Contact.FirstName FROM OpportunityContactRole WHERE OpportunityId =: opp.Id LIMIT 1].Contact.FirstName;  //Getting FirstName of contact which is created earlier by that lead
            ld.LastName = [SELECT Id, Contact.LastName FROM OpportunityContactRole WHERE OpportunityId =: opp.Id LIMIT 1].Contact.LastName;  ////Getting LastName of contact which is created earlier by that lead
            ld.Status = 'Open - Not Contacted';
            ld.Company = opp.Name;
            ld.Opportunity__c = opp.Id; //Providing the opportunity id in newly created lookup field
            newLeadList.add(ld);
        }
        insert newLeadList;   // insert new leads records
    }
}