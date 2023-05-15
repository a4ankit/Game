({
    onChange: function (cmp, evt, helper) {
        var newButton = component.find("b1");
        $A.util.toggleClass(newButton, "slds-hide");
    }
});