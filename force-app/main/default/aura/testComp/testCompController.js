({
	getOutput : function(component, event, helper) {
        console.log("In Method");
		var fullname1 = component.find("fname").get("v.value");
        console.log("fullname1"+fullname1);
        var fullname2 = component.find("lname").get("v.value");
        console.log("fullname2"+fullname2);
        var full = fullname1 + fullname2 ;
        console.log("full"+full);
        var output = component.find("output").set("v.value",full);
        console.log("output"+output);
	}
})