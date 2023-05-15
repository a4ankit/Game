({
    getSearchBoat : function(component, event, helper){
        console.log("event received by BoatSearchController.js");
        var formData = event.getParam("getSearchBoat");
        console.log(fromData);        
        var boatTypeId = formData.boatTypeId;
        console.log(boatTypeId);
        var BSRcmp = component.find("BSRcmp");
        console.log(BSRcmp);
        var auraMethodResult = BSRcmp.search(boatTypeId);
        console.log("event received by BoatSearchController.js");
        console.log("auraMethodResult: " + auraMethodResult);
    },
    
})