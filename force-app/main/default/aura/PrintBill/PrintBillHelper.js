({
    onChangeSearchTextHelper: function (component, event) {
        var searchInput = component.find("searchKnowledgeInput").get("v.value");
        if(searchInput.length > 2){
            if ($A.util.isUndefinedOrNull(searchInput)) {
                searchInput = '';
            }
            var searchResult = [];
            var objectlist = [];
            var retrieveOptions = component.get("c.getProduct");
            retrieveOptions.setParams({searchTerm: searchInput});
            retrieveOptions.setCallback(this, function (response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set('v.issearching', true);
                    setTimeout(function () {
                        component.set('v.issearching', false);
                    }, 2000);
                    searchResult = response.getReturnValue();
                    console.log('searchResult'+JSON.stringify(searchResult));
                    /*for (var i = 0; i < searchResult[0].length; i++){
                        objectlist.push(searchResult[0][i]);
                    }*/
                    component.set('v.errorMessage', '');
                    component.set('v.isTrue', true);
                    component.set('v.searchResult', objectlist);
                    if (objectlist.length == 0) {
                        component.set('v.errorMessage', 'No records found');
                    } else {
                        console.log('results: ', searchResult);
                    }
                    
                }
            });
            $A.enqueueAction(retrieveOptions);
        }
        else{
            component.set('v.searchResult', []);
            component.set('v.errorMessage', 'Please enter at lease 3 characters');
            
        }
    }
})