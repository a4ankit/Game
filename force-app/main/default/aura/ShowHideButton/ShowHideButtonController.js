({
    toggle: function (component, event, helper) {
        var sel = component.find("mySelect");
        var nav =	sel.get("v.value");
        if (nav == "INDIA") {     
            component.set("v.toggleGer", true);
        }
        if(nav == "USA"){
            component.set("v.toggleUsa", true);
        }
        if(nav == "GERMAN"){
            component.set("v.toggleGer", true);
        }
    }
})