public class ContactModalOnAcc {
    
    @AuraEnabled
    public static List<String> getPicklist(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.devsfdx__Level__c.getDescribe();
        System.debug('fieldResult---->>> ' + fieldResult);
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        System.debug('pList---->>> ' + pList);
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        System.debug('options---->>> ' + options);
        return options;
    }
    
    @AuraEnabled
    public static void saveDetails (Contact regForm1, String recordId){ 
        regForm1.AccountId = recordId;
        INSERT regForm1;
    }
}