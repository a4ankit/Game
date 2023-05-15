public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode()== 200){
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('results=='+results);
            List<Product2> LstProduct = new List<Product2>();
            for(Object o : results)
            { 
                Map<String, Object> mapobj = (Map<String, Object>)o;
                Product2 product = new Product2();
                Integer maintenanceperiod = (Integer)mapobj.get('maintenanceperiod');               
                Integer Lifespan = (Integer)mapobj.get('lifespan');
                Integer Cost = (Integer)mapobj.get('cost');
                Boolean replacement = (Boolean)mapobj.get('replacement');
                Integer quantity = ((Integer)mapobj.get('qIntegerntity'));
                product.Name  = (String)mapobj.get('name'); 
                product.devsfdx__Maintenance_Cycle__c = Integer.valueof(maintenanceperiod);
                product.devsfdx__Cost__c = Cost;
                product.devsfdx__Current_Inventory__c = quantity;
                product.devsfdx__Lifespan_Months__c = Lifespan; 
                product.devsfdx__Replacement_Part__c = replacement;
                product.devsfdx__Warehouse_SKU__c = (String) mapobj.get('sku');
                product.ProductCode = (String)mapobj.get('_id');       
                LstProduct.add(product);
            }
            System.debug('LstProduct=='+LstProduct.size());
            upsert LstProduct;  
        }
    }
    
}