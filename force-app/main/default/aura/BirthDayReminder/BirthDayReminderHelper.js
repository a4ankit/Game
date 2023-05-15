({
    getContactHelper : function(component,event,defaultListView) {
        var selected;
        if(defaultListView == null){
            selected = component.find("selectedViewName").get("v.value");
        }else{
            selected = defaultListView;
        }
        var action = component.get("c.getFilteredContacts");
        action.setParams({filterName : selected});        
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert(response.getReturnValue());
            if(state === 'SUCCESS' && component.isValid()){
                var pageSize = component.get("v.pageSize");
                // hold all the records into an attribute named "ContactList"
                component.set('v.ContactList', response.getReturnValue());
                // get size of all the records and then hold into an attribute "totalRecords"
                component.set("v.totalRecords", component.get("v.ContactList").length);
                // set star as 0
                component.set("v.startPage",0);
                
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.ContactList").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PaginationList);
                component.set('v.isSending',false);
            }else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
	},

     next : function(component, event){
        var sObjectList = component.get("v.ContactList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.ContactList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    find : function(component, event,defaultListViews){
        var isselected;
        alert('test==>'+defaultListViews);
        if(defaultListViews == null){
            isselected = component.find("selectedViewName").get("v.value");
        }else{
            isselected = defaultListViews;
        }
        
        var inputNumber = component.get("v.inputSize");
        
        var action = component.get("c.getBirthDayInDaysContacts");
        action.setParams({BirthDayInDays : inputNumber, SelectedListView : isselected});        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                alert(response.getReturnValue());
                component.set('v.ContactList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})