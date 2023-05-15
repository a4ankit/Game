({
	findByName: function(component,event) {  
        //var searchKey = event.getParam("searchKey");
        var locationList = component.get("v.locationList");
        var action = component.get("c.findByName");
        
        action.setParams({
            "searchKey": event.target.value,
            "locationList" : locationList
        }); 
        action.setCallback(this, function(a) {
            component.set("v.locationList", a.getReturnValue());
            //component.set("v.accountsLength", a.getReturnValue().length); 
        });
        $A.enqueueAction(action);
    },
})