trigger UpdateInventory on devsfdx__Order_Entry__c (after update) {
    Set<Id> orderEtrIds = new Set<ID>();
    Set<Id> orderAssIds = new Set<Id>();
    Integer quantity = 0;
    List<devsfdx__Inventory__c> invUpdateList = new List<devsfdx__Inventory__c>();
    for(devsfdx__Order_Entry__c objOE :  Trigger.new){
        if(objOE.devsfdx__Quantity__c != Null && objOE.devsfdx__Product__c != Null){
            orderEtrIds.add(objOE.Id);
            orderAssIds.add(objOE.devsfdx__Order__r.devsfdx__Associate__c);
            quantity = quantity + Integer.valueOf(objOE.devsfdx__Quantity__c);
        }
    }
    for(devsfdx__Inventory__c objInv : [SELECT Id FROM devsfdx__Inventory__c 
                                        WHERE devsfdx__Status__c = 'Assigned' AND devsfdx__Associate__c IN : orderAssIds 
                                        ORDER BY CreatedDate DESC 
                                        LIMIT : quantity]){
                                            objInv.devsfdx__Status__c = 'Sold';
                                            invUpdateList.add(objInv);
                                        }
    update invUpdateList;
}