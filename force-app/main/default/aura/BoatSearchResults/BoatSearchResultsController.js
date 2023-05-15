({
    doSearch : function(component, event, helper) {
        alert(component.get("v.boatTypeId")); //<---here I am getting undefined
        helper.onSearch(component); //calling helper method
    },
    search: function(component, event, helper){
        var params = event.getParam('arguments');
        alert(params.boatTypeId); //<---getting proper value
        alert(component.set("v.boatTypeId", params.boatTypeId)); //<---here I am getting undefined
        var a = component.get('c.doSearch');
        $A.enqueueAction(a);
    }
})