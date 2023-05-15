({
    doInit : function(component, event, helper) {
        if(component.get("v.pageReference") != undefined && component.get("v.pageReference") != 'undefined') {
            var code = component.get("v.pageReference").state.code;
            console.log('code@@@@@@'+code);
            if(code != undefined) {
                var action = component.get("c.getAccessToken");
                action.setParams({
                    "code" : code
                });
                action.setCallback(this, function(response){
                    var status = response.getState();
                    if(status === "SUCCESS"){
                        var accessToken = response.getReturnValue();
                        console.log('accessToken222===='+accessToken);
                        component.set("v.accessToken", accessToken);
                    }
                });
                
                $A.enqueueAction(action);
            }
        }
    },
    
    doAuth : function(component, event, helper) {
        
        var action = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleFilesChange : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles==='+uploadedFiles);
        var attachmentId = uploadedFiles[0].documentId;
        console.log('attachmentId==='+attachmentId);
        var code = component.get("v.accessToken");
        console.log('code==='+code);
        var action = component.get("c.uploadFile");
        console.log('action==='+action);
        action.setParams({
            "attachmentId": attachmentId,
            "accessToken" : code
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            console.log('status==='+status);
            if(status === "SUCCESS"){
                var responseCode = response.getReturnValue();
                console.log('responseCode==='+responseCode);
                if(responseCode == '200')
                    console.log('File Uploaded successfully');
                else
                    console.log('There was some error');
            }
        });
        
        $A.enqueueAction(action);
    }
})