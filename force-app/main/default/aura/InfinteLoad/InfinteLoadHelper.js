({
    getData : function(component) {
        var action = component.get("c.getAccount");
        action.setParams({
            "limits": component.get("v.initialRows"),
            "offsets": component.get("v.rowNumberOffset")
        });
        
        action.setCallback(this, function(a) {
            component.set("v.AccountList", a.getReturnValue());
            component.set("v.currentCount", component.get("v.initialRows"));
            
        });
        $A.enqueueAction(action);
    },
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function (component, fieldName, reverse) {
        var data = component.get("v.getAccounts");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.getAccounts", data);
        cosole.log('data'+data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} : function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    fetchData: function(component , rows){
        return new Promise($A.getCallback(function(resolve, reject) {
            var currentDatatemp = component.get("c.getAccount");
            var counts = component.get("v.currentCount");
            console.log('currentDatatemp'+currentDatatemp);
            console.log('counts'+counts);
            currentDatatemp.setParams({
                "limits": component.get("v.initialRows"),
                "offsets": counts 
            });
            currentDatatemp.setCallback(this, function(a) {
                resolve(a.getReturnValue());
                var countstemps = component.get("v.currentCount");
                console.log('countstemps'+countstemps);
                countstemps = countstemps+component.get("v.initialRows");
                component.set("v.currentCount",countstemps);
                console.log('countstemps'+countstemps); 
            });
            $A.enqueueAction(currentDatatemp);  
        }));
    },
    findByName: function(component,event) {  
        var searchKey = event.getParam("searchKey");
        var AccountList = component.get("v.AccountList");
        var action = component.get("c.findByName");
        
        action.setParams({
            "searchKey": searchKey,
            "AccountList" : AccountList
        }); 
        action.setCallback(this, function(a) {
            component.set("v.AccountList", a.getReturnValue());
            //component.set("v.accountsLength", a.getReturnValue().length); 
        });
        $A.enqueueAction(action);
    },
});