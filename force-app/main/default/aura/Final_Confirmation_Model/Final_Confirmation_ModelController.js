({
    doSubmitStatusValue : function(component, event) {
        console.log('in cofirmation box');
        var action = component.get("c.doCommittatusUpdate");
        action.setParams({ contactIdsToUpdate : component.get('v.selectedContactIds'),
                          selectedStatusValue : component.get('v.selectedStatusValue') });
        action.setCallback(this, function(response) {
            console.log('satus=='+response.getState());
            console.log('response.getReturnValue()=='+response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.statusPicklistValues", response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    closeModal : function(component){
        component.destroy();
    }
})