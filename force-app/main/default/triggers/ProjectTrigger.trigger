trigger ProjectTrigger on Project__c (before update, after update, before insert, after insert, before delete, after delete) {
    
    private static final String STATUS_BILLABLE = 'Billable';
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Project__c> filtered = filterStatusChanged(Trigger.oldMap, Trigger.new, STATUS_BILLABLE);
        system.debug('filtered=='+filtered);
        if (!filtered.isEmpty())
            BillingCalloutService.callBillingService(filtered[0].Id);
    }
    
    private static List<Project__c> filterStatusChanged(Map<Id, Project__c> oldMap, List<Project__c> newList, String newStatus) {
        List<Project__c> result = new List<Project__c>();
        system.debug('newList=='+newList);
        for (Project__c newProject : newList) {
            if (newProject.Status__c == newStatus && oldMap.get(newProject.Id).Status__c != newStatus)
                result.add(newProject);
        }
        return result;
    }
}