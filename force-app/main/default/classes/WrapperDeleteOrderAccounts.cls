public class WrapperDeleteOrderAccounts
{
    List<WrapOrders> ordListWrap ;
    List<Account> accounts ;
    List<Order> orders ;
    List<Order> delOrders;
    public Id selectedAccId{get;set;} 
    public Id contratId{get;set;} 
    Public Boolean orderSize{get;set;}
    public list<Order> searchResults {get;set; }
    
    public WrapperDeleteOrderAccounts()
    {
        ordListWrap = new List<WrapOrders>();
        accounts = new List<Account>();
        orders = new List<Order>();
        delOrders = new List<Order>();
        orderSize = false;
    }
    public List<SelectOption> AccountList
    {
        get
        {
            List<Account> accTemp = new List<Account>();
            accTemp = [Select Id,Name from Account];
            AccountList = new List<SelectOption>();
            for(Account acc : accTemp)
            {
                AccountList.add(new SelectOption(acc.Id, acc.Name));
            }
            return AccountList;
        }
        set;
    }
    public string searchtext
    {
        get
        {
            if(searchtext==null) 
                searchtext='';
            return searchtext;
        }
        set;
    }
    
    public List<WrapOrders> search()
    {
        if(searchResults == null)
        {
            system.debug('searchResults in if'+searchResults);
            searchResults = new List<order>();
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter correct value'));
            system.debug('searchResults in else'+searchResults);
            searchResults.Clear();
            return null;
        }
        
        String qry = 'Select Id, Name from order where name like \'%'+searchtext+'%\' Order By Name';
        searchResults = Database.query(qry);
        for(Order c : searchResults)
        {
            ordListWrap.add(new WrapOrders(c));
        }
        return ordListWrap;
    }
    public class WrapOrders
    {
        public Order ord {get;set;}
        public Boolean check {get;set;}
        public WrapOrders(Order c)
        {
            ord = c;
            check = false;
        }
    }
    public List<WrapOrders> getOrders()
    {
        ordListWrap.clear();
        Orders = [SELECT Id, Name,Status, OrderNumber,TotalAmount, AccountId, Account.Name FROM Order WHERE AccountId  =: selectedAccId LIMIT 100];
        for(Order c : Orders)
        {
            system.debug('Orders.isEmpty()=='+Orders.isEmpty());
            if(!Orders.isEmpty()){
                orderSize = true;
            }
            
            else{
                orderSize = false;
                
            }
            ordListWrap.add(new WrapOrders(c));
            
        }
        return ordListWrap;
        
    }
    
    public PageReference deleteOrders()
    {
        PageReference PageRefer = new PageReference('/apex/ShowData');
        PageRefer.setRedirect(true);
        delOrders = new List<Order>();
        for(WrapOrders c : ordListWrap)
        {
            if(c.check == true)
            {
                delOrders.add(c.ord);
            }
        }
        try
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Order Deleted'));
            delete delOrders;
        }
        catch(Exception e)
        {
            System.debug('m====='+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return PageRefer;
    }
    public PageReference newOrders()
    {
        PageReference PageRefer = new PageReference('/apex/ShowData');
        PageRefer.setRedirect(true);
        try
        {
            Order n = new Order();
            n.accountId = selectedAccId;
            n.status ='Saved';
            n.EffectiveDate = system.today();
            insert n;
        }
        catch(Exception e)
        {
            System.debug('m====='+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return PageRefer;
    }
    public PageReference orderValNew()
    {   
        return null;
    }
}