({
    init: function (cmp, event, helper) {
        cmp.set('v.mycolumns', [
            { label: 'Product Name', fieldName: 'Name', sortable: true,type: 'text'},
            { label: 'Product Code', fieldName: 'ProductCode', sortable: true,type: 'text'},
            { label: 'Vendor', fieldName: 'devsfdx__Vendor_Name__c',sortable: true,type: 'text'},
            { label: 'Vendor Number', fieldName: 'devsfdx__Vendor_Number__c',sortable: true,type: 'text'}
        ]);
        cmp.find("Id_spinner").set("v.class" , 'slds-show');
        var action = cmp.get("c.productList");  
        action.setCallback(this, function(response) {
            // hide spinner when response coming from server 
            cmp.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set('v.objClassController', storeResponse);
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
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