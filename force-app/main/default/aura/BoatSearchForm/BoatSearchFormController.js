({
    doInit : function(component, event, helper){

        helper.loadBoatTypes(component);
    },

    handleChange : function(component, event, helper){
        console.log(component.find("boatTypes").get("v.value"));
        component.set("v.selectedType", component.find("boatTypes").get("v.value"));
    },

    search : function(component, event, helper){
        var selectedType = component.get("v.selectedType");
        console.log("Search button pressed " + selectedType)
    },

    newBoat : function(component, event, helper){
        var boatTypeId = component.get("v.selectedType");
        console.log("New button pressed " + boatTypeId);
        var requestNewBoat = component.getEvent("launchNewBoatForm");
        requestNewBoat.setParams({"boatTypeId": boatTypeId});
        requestNewBoat.fire();
    },

    handleNewBoatForm: function(component, event, helper){
        console.log("handleNewBoatForm handler called.")
        var boatTypeId = component.get("v.selectedType");

        console.log(boatTypeId);
        var createNewBoat = $A.get("e.force:createRecord");
        createNewBoat.setParams({
            "entityApiName": "Boat__c",
        })
        if(! boatTypeId==""){
            createNewBoat.setParams({
                "defaultFieldValues": {'BoatType__c': boatTypeId}
           })
        }
        createNewBoat.fire();
    },
    //more handlers here
})