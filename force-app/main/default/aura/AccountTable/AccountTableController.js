({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'linkName', type: 'url',typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            { label: 'Account Revenue', fieldName: 'AnnualRevenue', sortable: true,type: 'text'},
            { label: 'Website', fieldName: 'Website',sortable: true,type: 'text'},
            { label: 'Active', fieldName: 'devsfdx__IsActive__c',sortable: true,type: 'boolean'}
        ]);
        var action = cmp.get("c.fetchAccts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                cmp.set('v.objClassController.returnList', records);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    
    Search: function(component, event, helper) {
        var searchField = component.find('searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        // if value is missing show error message and focus on field
        if(isValueMissing) {
            searchField.showHelpMessageIfInvalid();
            
        }else{
            // else call helper function 
            helper.SearchHelper(component, event);
            
        }
    },
    
    onChange: function (cmp, evt, helper) {
        
        cmp.set('v.searchKeyword',null);
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        cmp.set('v.isLoading', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            cmp.set("v.sortedBy", fieldName);
            cmp.set("v.sortedDirection", sortDirection);
            helper.sortData(cmp, fieldName, sortDirection);
            cmp.set('v.isLoading', false);
        }, 0);
    }
    
})