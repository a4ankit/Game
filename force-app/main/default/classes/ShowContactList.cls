public class ShowContactList {
    @AuraEnabled
    public static List<Contact> GetContacts(String ListViewType){
        List<Contact> returnContacts = new List<Contact>();
        If(ListViewType == 'All Contacts'){
            returnContacts = [SELECT Id , Name, Email  FROM Contact];
        }
        else If(ListViewType == 'Recent Contacts'){
             returnContacts = [SELECT Id , Name, Email  FROM Contact Order By CreatedDate DESC Limit 10];
        }
        return returnContacts;
    }
}