({
    initialize: function (component, event, helper) {
        debugger;
        var action = component.get("c.getSelectoptions");
        action.setCallback(this, function(response) {
            component.set("v.availableList",response.getReturnValue());
        }),
            $A.enqueueAction(action);
    },
    filterOperators:function (component, event, helper) {
        var action = component.get("c.getFilterOperators");
        action.setCallback(this, function(response) {
            component.set("v.OperatorsList",response.getReturnValue());
        }),
            $A.enqueueAction(action);
    },
    onselectObject: function(component,Field){
        var action = component.get("c.getFieldlist");
        action.setParams({
            'Objname' : component.get("v.objectName")
        });
        action.setCallback(this, function(response) {  
            if (response.getState() == "SUCCESS") {
                var fields = response.getReturnValue();
                console.log(fields);
                component.set("v.availFieldList", fields);
                component.set("v.isSelected", 'true');
                var criteriaList1 = component.get("v.criteriaList");
                if(criteriaList1.length ==0){
                    criteriaList1.push({
                        'FieldName':'',
                        'operators': '',
                        'userValue':''
                    });       
                    component.set("v.criteriaList", criteriaList1);
                    component.set("v.isFilterd", 'true');
                }
            }
        }),
            $A.enqueueAction(action);
    },
    addCriteria:function (component, event, helper) {
        var filter = [];
        var criteriaList1 = component.get("v.criteriaList");
        criteriaList1.push({
            'FieldName': '',
            'operators': '',
            'userValue': ''
        });   
        console.log('criteriaList1=='+criteriaList1.FieldName);
        component.set("v.criteriaList", criteriaList1);
        component.set("v.isFilterd", 'true');
        //Get the selected item index
        /*var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        filter.push(index);
        console.log('Index1==='+filter);*/
        var str;
        for (var i = 1; i <= criteriaList1.length; i++) {
            if (i == 1) {
                str = i;
            } else {
                str = str + " " + 'AND' + " " + i;
            }
        }
        console.log('str'+str);
        component.set("v.filterlogic", str);
    },
    selectField : function (component, event, helper){
        var selectedValue= event.getSource().get("v.value");
        console.log('ids:::'+selectedValue);
        if(selectedValue){
            component.set("v.isOperationVisible", false);            
        }
        var action = component.get("c.getFilterOperators");
        action.setParams({          
            'Objname' : component.get("v.objectName"),
            'fieldName' : selectedValue
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log('response:::'+JSON.stringify(response));
                var labels = [];
                var selectedFieldType ='';
                for(var i=0; i<response.getReturnValue().length ; i++){
                    labels.push(response.getReturnValue()[i].value);
                    selectedFieldType = response.getReturnValue()[i].fieldType;
                }
                console.log('selectedFieldType:::'+selectedFieldType);
                component.set("v.OperatorsList",labels);
                console.log('labels=='+labels);
                component.set("v.selectedFieldType",selectedFieldType);
            }
        }),
            $A.enqueueAction(action);
    },
    doToggle : function(cmp){
        console.log('call');
    },
    deleteRow:function (component, event, helper) {
        //Get the account list
        var criteriaList1 = component.get("v.criteriaList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        criteriaList1.splice(index, 1);
        component.set("v.criteriaList", criteriaList1);
        var str;
        for (var i = 1; i <= criteriaList1.length; i++) {
            if (i == 1) {
                str = i;
            } else {
                str = str + " " + 'AND' + " " + i;
            }
        }
        console.log('str'+str);
        component.set("v.filterlogic", str);
        console.log('criteriaList on delete'+JSON.stringify(criteriaList1));
    },
    getData:function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Id', fieldName: 'Id', type: 'text'},
            {label: 'Account name', fieldName: 'Name', type: 'text'}]);
        var criteriaList1 = component.get("v.criteriaList");
        console.log('criteriaList1'+JSON.stringify(criteriaList1));
        var fieldname1,operator,fildvalue;
        var finalvalue=[];
        var fieldList = [];
        for( var i = 0; i < criteriaList1.length; i++ ){
            fieldname1 = criteriaList1[i].FieldName;
            operator   = criteriaList1[i].operators;
            fildvalue  = criteriaList1[i].userValue;
            console.log('fieldname1'+fieldname1);
            console.log('operator'+operator);
            var  quote_str =  "'" + fildvalue + "'";
            console.log('quote_str'+quote_str);
            console.log('fildvalue'+fildvalue);
            fieldList.push(fieldname1);
            finalvalue.push(fieldname1+' '+operator+' '+quote_str);
            JSON.stringify(finalvalue);
        }
        console.log('finalvalue=='+finalvalue);
        console.log('fieldList=='+fieldList);
        var action = component.get("c.querydata");
        action.setParams({FieldNameList : fieldList,
                          queryList : finalvalue,
                          Objname : component.get("v.objectName")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.data",response.getReturnValue())
                console.log('data=='+component.get("v.data"));
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }, 
})