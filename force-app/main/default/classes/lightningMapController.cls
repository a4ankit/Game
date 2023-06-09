public with sharing class lightningMapController {
    @AuraEnabled
    public static list<accountLocationWrapper> getLocation(){
        list<accountLocationWrapper> lstALW = new list<accountLocationWrapper>();
        /*Query accounts records with billing address information */  
        for(account acc : [Select Name,description, BillingCountry, BillingCity, BillingPostalCode, BillingStreet, BillingState
                           From Account
                           limit 10]){
                               // first create "locationDetailWrapper" instance and set appropriate values
                               locationDetailWrapper oLocationWrap = new locationDetailWrapper();
                               oLocationWrap.Street = acc.BillingStreet;
                               system.debug('oLocationWrap.Street-->'+oLocationWrap.Street);
                               oLocationWrap.PostalCode = acc.BillingPostalCode;
                               system.debug('oLocationWrap.PostalCode-->'+oLocationWrap.PostalCode);
                               oLocationWrap.City = acc.BillingCity;
                               system.debug('oLocationWrap.City-->'+oLocationWrap.City);
                               oLocationWrap.State = acc.BillingState;
                               system.debug('oLocationWrap.State-->'+oLocationWrap.State);
                               oLocationWrap.Country = acc.BillingCountry;
                               system.debug('oLocationWrap.Country-->'+oLocationWrap.Country);
                               // create "accountLocationWrapper" instance, set values and add to final list. 
                               accountLocationWrapper oWrapper = new accountLocationWrapper();
                               oWrapper.icon = 'utility:location'; // https://www.lightningdesignsystem.com/icons/#utility
                               oWrapper.title = acc.Name;
                               system.debug('oWrapper.title-->'+oWrapper.title);
                               oWrapper.description = acc.description;
                               system.debug('oWrapper.description-->'+oWrapper.description);
                               oWrapper.location = oLocationWrap;
                               system.debug('oWrapper.location-->'+oWrapper.location);
                               lstALW.add(oWrapper);
                           }
        // retrun the "accountLocationWrapper" list
        system.debug('lstALW-->'+lstALW);
        return lstALW;
    }
    /* wrapper class to store required properties for "lightning:map" component' */ 
    public class accountLocationWrapper{
        @AuraEnabled public string icon{get;set;} 
        @AuraEnabled public string title{get;set;} 
        @AuraEnabled public string description{get;set;} 
        @AuraEnabled public locationDetailWrapper location{get;set;} 
    }
    /* sub wrapper class to store location details for "accountLocationWrapper" location property.*/ 
    public class locationDetailWrapper{
        @AuraEnabled public string Street{get;set;}
        @AuraEnabled public string PostalCode{get;set;}
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string State{get;set;}
        @AuraEnabled public string Country{get;set;}
    }
}