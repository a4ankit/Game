public class AccountOrderController11 {
    public List<orderWrapper> wrapOrderList {get; set;}
    public List<SelectOption> Orderlist{set;get;}
    public Boolean OrderListRender{get;set;}
    public Id selectedAccId{get;set;} 
    public AccountOrderController11()
    {
        orderlist = new List<SelectOption>();        
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
    
    public PageReference orderValNew()
    {        
        orderlist.clear();
        List<Order> orderTemp = new List<Order>();
        System.debug('selectedAccId--->>>' + selectedAccId);
        if(selectedAccId!=null)
        {
            if(wrapOrderList == null) {
                wrapOrderList = new List<OrderWrapper>();
                for(Order a: [Select Id,Status,Name , AccountId from Order where AccountId =: selectedAccId]) {
                    wrapOrderList.add(new OrderWrapper(a));
                }
            }
        }
        System.debug('wrapOrderList---->>>>>' + wrapOrderList);
        if(wrapOrderList.isEmpty())
        {
            OrderListRender = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Order Record Exist Regarding this Account'));
        }
        else{
            for(Order ord : orderTemp)
            {
                OrderListRender = true;
                orderlist.add(new SelectOption(ord.Id, ord.Status));
                System.debug('orderlist--->>>>' + orderlist);
            }
        }
        return null;
    }
    public List<SelectOption> getorderlist()
    {
        return orderlist;
    }
    public Boolean getOrderListRender()
    {
        return OrderListRender;
    }
    public class OrderWrapper{
        public Order con{get;set;}
        public Boolean checkbox{get;set;} 
        public OrderWrapper(Order a){
           // Order = a;
            checkbox = false;
        }
    }
}