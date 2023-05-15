({
    init: function(cmp, event, helper) {
        cmp.set("v.countryOptions", helper.getCountryOptions());
        cmp.set("v.provinceOptions", helper.getProvinceOptions(cmp.get("v.country")));
    },
    updateProvinces: function(cmp, event, helper) {
        cmp.set("v.provinceOptions", helper.getProvinceOptions(cmp.get("v.country")));
    },
    handleClick:function(cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
        var address = cmp.find("myaddress");
        var isValid = address.checkValidity();
        if(isValid) {
            alert("Creating new address");
        }
        else {
            address.showHelpMessageIfInvalid();
        }
    }
})