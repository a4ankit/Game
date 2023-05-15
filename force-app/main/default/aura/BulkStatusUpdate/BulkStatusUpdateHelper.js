({
    doGetInitData : function(component) {
        // Load all contact data
        var action = component.get("c.getInitContacts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contactList", response.getReturnValue());
                component.set("v.FilteredContactList", response.getReturnValue());
                //Display toast message to indicate load status
                
            }
        });
        $A.enqueueAction(action);
    },
    
    initializeFilterValue : function(component, event){
        var action = component.get("c.getStatusDropdownValue");
        action.setCallback(this, function(response1) {
            var state = response1.getState();
            if (state === "SUCCESS") {
                component.set("v.statusPicklistValues", response1.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.contactList");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        
        // to handel text type fields 
        data.sort(function(a,b){ 
            var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a>b) - (b>a));
        });    
        
        //set sorted data to contactList attribute
        component.set("v.contactList",data);
    },
    performStatusUpdate : function(component, event, selectedContactIds){
        //Dynamic creation of lightningModalChild component and appending its markup in a div
        $A.createComponent( 'c:Status_Value_Model', {
            'headerText' : 'Please select a Status Value to Update',
            'selectedContactIds' : selectedContactIds
        },
            function(modalComponent, status, errorMessage) {
                if (status === "SUCCESS") {
                    //Appending the newly created component in div
                    var body = component.find( 'showChildModal' ).get("v.body");
                    body.push(modalComponent);
                    component.find( 'showChildModal' ).set("v.body", body);
                } else if (status === "INCOMPLETE") {
                	console.log('Server issue or client is offline.');
                } else if (status === "ERROR") {
                	console.log('error');
                }
            }
        );
    }
})