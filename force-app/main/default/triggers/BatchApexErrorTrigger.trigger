trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    List<BatchLeadConvertErrors__c> errorList = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent be:Trigger.new){
        BatchLeadConvertErrors__c blc = new BatchLeadConvertErrors__c();
        blc.AsyncApexJobId__c=be.AsyncApexJobId;
        blc.Records__c = be.JobScope;
        blc.StackTrace__c = be.StackTrace;
        errorList.add(blc);
    }
    insert errorList;
}