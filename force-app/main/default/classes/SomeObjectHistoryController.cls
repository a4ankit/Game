public with sharing class SomeObjectHistoryController {
    //Protected Members
    private static final DescribeSObjectResult oSomeObjectSchema = Schema.SObjectType.Account;
    private static final Map<string, Schema.SObjectField> mapFields = oSomeObjectSchema.fields.getMap();
    
    //Properties
    public Id SomeObjectId {get;set;}
    public integer PageSize {get;set;}
    public boolean AllowShowMore {get;set;}
    
    public List<SomeObjectHistory> SomeObjectHistories {
        get { return getSomeObjectHistory(SomeObjectId); }
    }
    
    public SomeObjectHistoryController() {
        PageSize = 5;   
        AllowShowMore = true;
    }
    
    //Public Methods
    public void showMore() {
        PageSize += 5;
    }
    
    //Private Methods
    
    private List<SomeObjectHistory> getSomeObjectHistory(Id SomeObjectId) {
        List<SomeObjectHistory> listSomeObjectHistory = new List<SomeObjectHistory>();
        
        if (SomeObjectId != null) {
            DateTime dLastCreatedDate = null;
            
            integer limitPlusOne = PageSize + 1;
            
            List<AccountHistory> listEntityHistory = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedById, CreatedBy.Name FROM AccountHistory WHERE Id = '0017F00001e8TOn' ORDER BY CreatedDate DESC, Id DESC LIMIT :limitPlusOne];
            AllowShowMore = (listEntityHistory.size() == limitPlusOne);
            
            for (AccountHistory oHistory : listEntityHistory) {
                SomeObjectHistory oSomeObjectHistory = new SomeObjectHistory(oHistory);
                
                if (mapFields.containsKey(oHistory.Field)) {
                    oSomeObjectHistory.FieldLabel = mapFields.get(oHistory.Field).getDescribe().Label;
                }
                
                if (dLastCreatedDate == oHistory.CreatedDate) {
                    oSomeObjectHistory.ShowDateAndUser = false;
                }
                else {
                    oSomeObjectHistory.ShowDateAndUser = true;
                }
                
                listSomeObjectHistory.add(oSomeObjectHistory);
                dLastCreatedDate = oHistory.CreatedDate;
                
                if (listSomeObjectHistory.size() == PageSize) break;
            }
        }
        
        return listSomeObjectHistory;
    }
    
    public class SomeObjectHistory {
        //Properties
        public boolean ShowDateAndUser {get;set;}
        public string FieldLabel {get;set;}
        public AccountHistory History {get; private set;}
        
        public string ActionFormat {
            get { return getActionFormat(); }
        }
        
        public SomeObjectHistory(AccountHistory oHistory) {
            History = oHistory;
        }
        
        //Constructors
        public SomeObjectHistory() {
            showDateAndUser = true;
        }
        
        //Private Methods
        private string getActionFormat() {
            string sActionFormat = '';
            
            if (History != null) {
                sActionFormat = 'Record {0}.';
                
                if (History.newValue != null && History.oldValue == null) {
                    sActionFormat = 'Changed <strong>{1}</strong> to <strong>{3}</strong>.';    
                }
                else if (History.newValue != null && History.oldValue != null) {
                    sActionFormat = 'Changed <strong>{1}</strong> from {2} to <strong>{3}</strong>.';   
                }
                else if (History.Field != null && History.Field.equalsIgnoreCase('created')) {
                    sActionFormat = 'Created.';
                }
            }
            
            return sActionFormat;
        }
    }
}