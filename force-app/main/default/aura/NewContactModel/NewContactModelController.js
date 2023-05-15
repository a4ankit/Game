({
    doInit : function(component, event, helper){
        var action = component.get("c.getPicklist");
        var percent = component.find("PicklistId");
        var opts=[];
        action.setCallback(this, function(response) {
            var allValues = response.getReturnValue();
            console.log('allValues -- >> ' + allValues);
            component.set("v.Pick", allValues);
        });
        $A.enqueueAction(action); 
    },
    
    newPopup : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
    
    saveModal : function(component, event, helper){
        var regForm = component.get("v.accForm");
        var rid = component.get("v.recordId");
        var action = component.get("c.saveDetails");
        action.setParams({regForm1  : regForm, recordId : rid});
        action.setCallback(this, function(response) {
            var state = response.getState();          
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                var cmpTarget = component.find('Modalbox1');
                var cmpBack = component.find('Modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log(response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    closeNewModal : function(component, event, helper){
        component.set("v.accForm",{'LastName':''});
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },
    
    saveNewModal : function(component, event, helper){
        var regForm = component.get("v.accForm");
        var rid = component.get("v.recordId");
        var action = component.get("c.saveDetails");
        action.setParams({regForm1  : regForm, recordId : rid});
        action.setCallback(this, function(response) {
            var state = response.getState();          
            if (state === "SUCCESS") {
                //Do Something
                component.set("v.accForm",{'LastName':''});
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log(response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    isRefreshed: function(component, event, helper) {
        location.reload();
    },
})