({
    loadData: function(component, event, helper) {
        //call apex class method
        var action = component.get('c.initMethod');
        var conMap = component.get('v.conMap');
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                component.set('v.wrapperList', response.getReturnValue());
                var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    custs.push({value:conts[key], key:key});
                }
                console.log(JSON.stringify(custs));
                component.set("v.conMap", custs)
            }
        });
        $A.enqueueAction(action);
    },
})