public class wrapperDisplayController {
    @AuraEnabled
    public static wrapperClass initMethod(){
        // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
        Map<String,Contact> contactMap1 = new Map<String,Contact>([select firstName, LastName, Department,LeadSource from contact]);
        system.debug('contactMap1=='+contactMap1);
        Set<String> Keyss;
        Keyss = new Set<String>();
        Keyss = contactMap1.KeySet();
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        returnwrapperClass.lstContact = [SELECT firstName, LastName, Department,LeadSource from contact Limit 25];
        returnwrapperClass.contactCount = returnwrapperClass.lstContact.size(); 
        returnwrapperClass.headerMsg = 'This is Sample Header Msg from Wrapper Class';
		returnwrapperClass.contactMap = contactMap1;
        returnwrapperClass.Keys = Keyss;
        return returnwrapperClass;    
    }
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClass{
        @AuraEnabled public List<contact> lstContact{get;set;}
        @AuraEnabled public Integer contactCount{get;set;}
        @AuraEnabled public String headerMsg {get;set;}
        @AuraEnabled public Map<String,Contact> contactMap{get;set;}
        @AuraEnabled public Set<String> Keys{get;set;}
    }
}