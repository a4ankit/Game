public with sharing class BulkStatusUpdateController {
    public List<contactWrapper> wrapContactList {get; set;}
    public List<Contact> selectedContacts {get;set;}
    public Boolean displayPopup {get;set;}
    public BulkStatusUpdateController(){
        if(wrapContactList == null) {
            wrapContactList = new List<contactWrapper>();
            for(Contact a: [select Name, Email, Status__c from Contact LIMIT 300]) {
                wrapContactList.add(new contactWrapper(a));
            }
        }
    }
    public void processSelected() {
        selectedContacts = new List<Contact>();
        for(contactWrapper wrapConObj : wrapContactList) {
            if(wrapConObj.Checkbox == true) {
                selectedContacts.add(wrapConObj.con);
                system.debug('selectedContacts=='+selectedContacts);
            }
        }
    }
    public void closePopup(){
        displayPopup = false;
    }
    public void showPopup(){
        displayPopup = true;
    }
    @RemoteAction
    public List<SelectOption> getDropdowns{
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Contact.devsfdx__Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
    @AuraEnabled @RemoteAction
    public static List<Contact> getInitContacts(){
        String availableFieldsForTable = 'Name,Status__c,Email';
        String targetObject = 'Contact';
        String dmlType = 'Query';
        if(CheckAccessibilityUtill.checkFieldLevelSecurity(targetObject, availableFieldsForTable, dmlType)){
            return  (List<Contact>)(database.query('select Name, Email, Status__c from Contact LIMIT 300'));
        }else{
            throw new AuraException('Current user is not Permitted for contact Object/Fields');
        }
    }
    //get contact's status field dropdown values
    @AuraEnabled @RemoteAction
    public static List<String> getStatusDropdownValue(){
        String availableFieldsForTable = 'devsfdx__Status__c';
        String targetObject = 'Contact';
        String dmlType = 'Query';
        if(CheckAccessibilityUtill.checkFieldLevelSecurity(targetObject, availableFieldsForTable, dmlType)){
            List<String> pickListValuesList = new List<String>();
            pickListValuesList.add('--None--');
            Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(targetObject);
            Schema.DescribeSObjectResult res = convertToObj.getDescribe();
            Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(availableFieldsForTable).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }     
            system.debug('pickListValuesList: ' + pickListValuesList);
            return pickListValuesList;
        }else{
            throw new AuraException('Current user is not Permitted for contact Status Field');
        }
    }
    @RemoteAction @AuraEnabled @ReadOnly
    public static String doCommittatusUpdate(String [] contactIdsToUpdate, String selectedStatusValue){
        system.debug('contactIdsToUpdate=='+contactIdsToUpdate);
        if(!contactIdsToUpdate.isEmpty()){
            List<contact> lstConToUpdate = new List<Contact>();
            lstConToUpdate = [select devsfdx__Status__c from contact where id in : contactIdsToUpdate];
            for(Contact objCon : lstConToUpdate){
                objCon.devsfdx__Status__c = (String) selectedStatusValue;
            }
            system.debug('lstConToUpdate=='+lstConToUpdate);
            if(!lstConToUpdate.isEmpty()){
                update lstConToUpdate;
                system.debug('lstConToUpdateeffs=='+lstConToUpdate);
            }else{
                throw new AuraException('No Contact record found with selected rows!!!');
            }
            return 'Records Successfully Updated!!';
        }else{
            throw new AuraException('Selected Ids not found!!!');
        }
    }
    
    public class contactWrapper{
        public contact con{get;set;}
        public Boolean checkbox{get;set;} 
        public contactWrapper(Contact a){
            con = a;
            checkbox = false;
        }
    }
    
}