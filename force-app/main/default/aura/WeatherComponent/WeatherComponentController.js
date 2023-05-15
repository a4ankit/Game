({
    handleClick : function (cmp, event, helper) {
        console.log("You clicked: " + event.getSource().get("v.label"));
        var city = cmp.get("v.city");
        var startTime = cmp.get("v.startTime");
        var endTime = cmp.get("v.endTime");
        var action = cmp.get("c.getInfo");
        action.setParams({ city : city,
                          startTime: startTime,
                          endTime : endTime
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                cmp.set("v.dataList", response.getReturnValue());
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
    downloadDocument : function(cmp, event, helper){
        var sendDataProc = cmp.get("v.sendData");
        var data = cmp.get("v.dataList");
        console.log('===='+data);
        var jsonData = JSON.parse(JSON.stringify(data));
        var rows=[];
        for (var key in jsonData){
            var curName = key;
            var value = jsonData[key];
            rows.push({currency:curName,amount:value});
        }
        var dataToSend = data;
        sendDataProc(dataToSend, function(){
        });
    }
})