({
    fetchAccounts : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'linkName', sortable: true, type: 'url', 
             typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Annual Revenue', fieldName: 'AnnualRevenue',sortable: true, type: 'currency'},
            {label: 'Active', fieldName: 'devsfdx__IsActive__c', type: 'Boolean'},
            {label: 'Website', fieldName: 'Website', type: 'url' , typeAttributes: {label: { fieldName: 'Website' }, target: '_blank'}}
        ]);
        var action = component.get("c.fetchAccts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var Types = new Set();
            var Sources = new Set();
            var Industries = new Set();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    Types.add(record.Type);
                    if(record.AccountSource != null && record.AccountSource != '' && record.AccountSource != undefined){
                    Sources.add(record.AccountSource);  
                    }
                    if(record.Industry != null && record.Industry != '' && record.Industry != undefined){
                    Industries.add(record.Industry);   
                    }
                });
                component.set("v.acctList", records);
                component.set("v.Types", Array.from(Types));
                component.set("v.Sources", Array.from(Sources));
                component.set("v.Industries", Array.from(Industries));  
            }
        });
        $A.enqueueAction(action);
    },
    onChange: function (component, evt, helper) {
        component.set("v.searchKeyword", component.find('select').get('v.value'));
        var action = component.get("c.fetchTypeAccts");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var Types = new Set();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    Types.add(record.Type);
                });
                component.set("v.acctList", records);
                if(component.find('select').get('v.value') == "Customer - Direct"){
                    component.set("v.showIndustry", false);
                    component.set("v.showSource", true);
                }
                else{
                    component.set("v.showIndustry", true);
                    component.set("v.showSource", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    onChangeSource : function (component, evt, helper) {
        component.set("v.searchKeywordSource", component.find('Source').get('v.value'));
        component.set("v.searchKeyword", component.find('select').get('v.value'));
        var action = component.get("c.fetchTypeSourceAccts");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            'searchKeywordSource': component.get("v.searchKeywordSource")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var Types = new Set();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.acctList", records);
                component.set("v.showSource", false);
            }
        });
        $A.enqueueAction(action);
        
    }, 
    onChangeIndustry : function (component, evt, helper) {
        component.set("v.searchKeywordIndustry", component.find('Industry').get('v.value'));
        component.set("v.searchKeyword", component.find('select').get('v.value'));
        var action = component.get("c.fetchTypeIndustryAccts");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            'searchKeywordIndustry': component.get("v.searchKeywordIndustry")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var Types = new Set();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                console.log('records==',JSON.stringify(records));
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.acctList", records);
                component.set("v.showIndustry", false);
            }
        });
        $A.enqueueAction(action);
        
    },
    updateSelectedText: function (component, event) {
        component.set("v.showActivate", false);
        var selectedRows = event.getParam('selectedRows');
        component.set("v.onSelectedRows",selectedRows);
    },
    handleSave: function (component, event, helper) {
        var selectedRows = component.get("v.onSelectedRows");
        console.log(selectedRows);
        var action = component.get("c.saveAccount");
        for(var i=0; i < selectedRows.length ; i++){
            action.setParams(
                { Id : selectedRows[i].Id}
            );
        }
        action.setCallback(this, function(response){
            var state = response.getState();
            var Types = new Set();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                console.log('records==',JSON.stringify(records));
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.acctList", records);
                component.set("v.showActivate", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Record Updated Succesfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: errors[0].message,
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
            
        });
        $A.enqueueAction(action)
    }
})