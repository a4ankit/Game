({
    doInit : function(component, event, helper){        
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ContactListViewList",response.getReturnValue());
                helper.getContactHelper(component,event,response.getReturnValue()[0].Name);
                helper.find(component,event,response.getReturnValue()[0].Name);
            }
        });
        $A.enqueueAction(action); 
    },
    getFilteredContact : function (component, event, helper) {
        helper.getContactHelper(component,event,null);
        helper.find(component, event,null);        
    },
    
    next: function (component, event, helper) {
    	helper.next(component, event);
	},
    previous: function (component, event, helper) {
   	 	helper.previous(component, event);
	},
    find: function (component, event, helper) {
   	 	helper.find(component, event,null);
	},
})