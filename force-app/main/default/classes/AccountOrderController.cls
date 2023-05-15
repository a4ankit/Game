public with sharing class AccountOrderController {
    public List<orderWrapper> wrapOrderList {get; set;}
    public List<Order> selectedOrders {get;set;}
    public Boolean displayPopup {get;set;}
    public Id selectedAccId{get;set;} 
    public Boolean OrderListRender{get;set;}
    
    public AccountOrderController(){
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
    public void processSelected() {
        selectedOrders = new List<Order>();
        for(orderWrapper wrapObj : wrapOrderList) {
            if(wrapObj.Checkbox == true) {
                selectedOrders.add(wrapObj.ord);
                system.debug('selectedOrders=='+selectedOrders);
            }
        }
    }
    
    public PageReference orderValNew()
    {        
        List<Order> orderTemp = new List<Order>();
        System.debug('selectedAccId--->>>' + selectedAccId);
        if(selectedAccId!=null)
        {
            wrapOrderList = new List<OrderWrapper>();
            for(Order a: [Select Id,Status,Name , AccountId from Order where AccountId =: selectedAccId]) {
                wrapOrderList.add(new OrderWrapper(a));
            }
            
        }
        System.debug('wrapOrderList---->>>>>' + wrapOrderList);
        if(wrapOrderList.isEmpty())
        {
            OrderListRender = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'No Order Record Exist Regarding this Account'));
        }
        return null;
    }
    
    
    @AuraEnabled @RemoteAction
    public static List<Order> getInitOrders(){
        String availableFieldsForTable = 'Name,Status__c,Email';
        String targetObject = 'Order';
        String dmlType = 'Query';
        if(CheckAccessibilityUtill.checkFieldLevelSecurity(targetObject, availableFieldsForTable, dmlType)){
            return  (List<Order>)(database.query('select Name, Email, Status from Order LIMIT 300'));
        }else{
            throw new AuraException('Current user is not Permitted for contact Object/Fields');
        }
    }
    
    @RemoteAction @AuraEnabled @ReadOnly
    public static String doCommittatusUpdate(String [] OrderIdsToUpdate, String selectedStatusValue){
        system.debug('OrderIdsToUpdate=='+OrderIdsToUpdate);
        if(!OrderIdsToUpdate.isEmpty()){
            List<Order> lstConToUpdate = new List<Order>();
            lstConToUpdate = [select Id, Status from Order where id in : OrderIdsToUpdate];
            system.debug('lstConToUpdate=='+lstConToUpdate);
            if(!lstConToUpdate.isEmpty()){
                delete lstConToUpdate;
                system.debug('lstConToUpdateeffs=='+lstConToUpdate);
            }else{
                throw new AuraException('No Order record found with selected rows!!!');
            }
            return 'Records Successfully Deleted!!';
        }else{
            throw new AuraException('Selected Ids not found!!!');
        }
    }
    
    public class orderWrapper{
        public order ord{get;set;}
        public Boolean checkbox{get;set;} 
        public orderWrapper(Order a){
            ord = a;
            checkbox = false;
        }
    }
    
}