({
	doInit : function(component, event, helper) {
		console.log('ModelLoad!!!!');
        // Load all contact data
        var action = component.get("c.getStatusDropdownValue");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.statusPicklistValues", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    doUpdateStatusValue : function(component, event, helper){
        console.log('122'+JSON.stringify(component.get('v.selectedStatusValue')));
        //Dynamic creation of lightningModalChild component and appending its markup in a div
        $A.createComponent( 'c:Final_Confirmation_Model', {
            'headerText' : 'Are you sure for final submit ?',
            'selectedContactIds' : component.get('v.selectedContactIds'),
            'selectedStatusValue' : component.get('v.selectedStatusValue')
        },
            function(modalComponent, status, errorMessage) {
                if (status === "SUCCESS") {
                    //Appending the newly created component in div
                    var body = component.find('showChildModal').get("v.body");
                    body.push(modalComponent);
                    component.find( 'showChildModal' ).set("v.body", body);
                } else if (status === "INCOMPLETE") {
                	console.log('Server issue or client is offline.');
                } else if (status === "ERROR") {
                	console.log('error');
                }
            }
        );
    },
    closeModal : function(component){
        component.destroy();
    }
})