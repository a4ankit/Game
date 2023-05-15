({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text', sortable : true},
            {label: 'Email', fieldName: 'Email', type: 'email'},
            {label: 'Status', fieldName: 'devsfdx__Status__c', type: 'picklist', sortable : true}
        ]);
        helper.doGetInitData(component);
        helper.initializeFilterValue(component, event);
    },
    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedContactList', selectedRows);
        component.set('v.selectedRowsCount', selectedRows.length);
        console.log('selectedRecord::'+JSON.stringify(component.get('v.selectedContactList')));
    },
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    doStatusUpdate : function(component,event,helper){
        var selectedContactRows = component.get('v.selectedContactList');
        var selectedContactIds = [];
        for(var i in selectedContactRows){
            selectedContactIds.push(selectedContactRows[i].Id);
        }
        console.log('selectedContactIds::'+JSON.stringify(selectedContactIds));
        helper.performStatusUpdate(component, event, selectedContactIds)
    },
    doFilterByStatus : function(component, event, helper){
        var onloadData = component.get('v.FilteredContactList');
        component.set("v.contactList",onloadData);
        var availableContactList = component.get('v.contactList');
        var selectedStatusFilterValue = component.get('v.selectedStatusValue');
        var contactFilterList = [];
        console.log('availableContactList12::'+JSON.stringify(availableContactList)+'asdd'+selectedStatusFilterValue);
        for(var i in availableContactList){
            if(selectedStatusFilterValue != '--None--' && availableContactList[i].Status__c == selectedStatusFilterValue){
                console.log('InsideIF:::'+availableContactList[i].Status__c);
                contactFilterList.push(availableContactList[i]);
            }else if(selectedStatusFilterValue == '--None--'){
                contactFilterList.push(availableContactList[i]);
            }
        }
        if(contactFilterList){
            component.set('v.contactList', contactFilterList);
        }
    },
    filterInput : function(component){
        //initialize the datatable
        var onloadData = component.get('v.FilteredContactList');
        component.set("v.contactList",onloadData);
        var data = component.get("v.contactList"),
            term = component.get("v.InputFilterValue"),
            results = data, regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row=>regex.test(row.Name) || regex.test(row.Email));
        } catch(e) {
            // invalid regex, use full list
        }
        component.set("v.contactList", results);
    }
})