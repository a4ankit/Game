public with sharing class PagingController {
    
    List<categoryWrapper> categories {get;set;}
    list<Account> selectedAcc{get;set;}
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, AccountNumber,Checked__c, Type, Website, Industry FROM Account Order By Name limit 100]));
                // sets the number of records in each page set
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<categoryWrapper> getCategories() {
        categories = new List<categoryWrapper>();
        for (Account category : (List<Account>)con.getRecords())
            categories.add(new CategoryWrapper(category));
        return categories;
    }
    
    // displays the selected items
    public PageReference process() {
        for (CategoryWrapper cw : categories) {
            if (cw.checked)
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.act.name));
        }
        return null;
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // returns the first page of records
    public void first() {
        con.first();
    }
    
    // returns the last page of records
    public void last() {
        con.last();
    }
    
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
    
    // returns the next page of records
    public void next() {
        con.next();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    /* public void cancel() {
con.cancel();
} */
    
    // delete the selected record
    public void deleteSelected() {
        selectedAcc = new list<Account>();
        for(CategoryWrapper checkWrapper : categories ){
            if(checkWrapper.checked == true){
                selectedAcc.add(checkWrapper.act);
            }
        }
        if(selectedAcc.size()>0){
            delete selectedAcc;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'This record ' +selectedAcc[0].Name+ ' is deleted')); 
    }
    // udate the Selected record
    public void updateSelected() {
        selectedAcc = new list<Account>();
        Set<String> names = new Set<String>();
        for(CategoryWrapper checkWrapper : categories ){
            if(checkWrapper.checked == true){
                selectedAcc.add(checkWrapper.act);
            }
        }
        for(Account acc : selectedAcc){
            acc.checked__c =  true;
            names.add(acc.Name);
        }
        if(selectedAcc.size()>0){
            upsert selectedAcc;
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'This record ' +names+ ' is updated')); 
    }
    public class CategoryWrapper {
        
        public Boolean checked{ get; set; }
        public Account act { get; set;}
        
        public CategoryWrapper(){
            act = new Account();
            checked = false;
        }
        public CategoryWrapper(Account c){
            act = c;
            checked = false;
        }
    }
    public PageReference refreshTable() {  
        PageReference curPage = Page.PagingControllerPage;
        curPage.setRedirect(true);
        return curPage;
    } 
     public void check() {  
      
        
          
    }
}