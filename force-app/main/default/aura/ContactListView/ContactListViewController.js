({
    myAction : function(component, event, helper) {
        console.log('In my action');
        var selPickListValue = event.getSource().get("v.value");
        console.log('******selPickListValue :'+selPickListValue );
       	var action = component.get("c.getContacts");
    }
})