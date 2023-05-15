({
	myAction : function(component, event, helper) {
        var action = component.get('c.getContentDocs');
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('statte==',response.getState());
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                console.log(records);
                component.set("v.Documents", records);
            }
        });
        $A.enqueueAction(action);
	}
})