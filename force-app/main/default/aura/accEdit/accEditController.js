({
    handleSaveRecord: function(cmp, event, helper) 
    {
        alert("Button clicked");
        cmp.find("recordEditor").saveRecord($A.getCallback(function(saveResult) 
                                                           {
                                                               alert("Button clicked");
                                                               if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") 
                                                               {
                                                                   console.log("Save completed successfully.");
                                                                   cmp.set("v.recordSaveError", '');
                                                               } else if (saveResult.state === "INCOMPLETE") 
                                                               {
                                                                   
                                                                   console.log("User is offline, device doesn't support drafts.");
                                                                   cmp.set("v.recordSaveError", '');
                                                               } else if (saveResult.state === "ERROR") {
                                                                   var errMsg = "";
                                                                   // saveResult.error is an array of errors, 
                                                                   // so collect all errors into one message
                                                                   for (var i = 0; i < saveResult.error.length; i++) {
                                                                       errMsg += saveResult.error[i].message + "\n";
                                                                   }
                                                                   cmp.set("v.recordSaveError", errMsg);
                                                               } else {
                                                                   cmp.set("v.recordSaveError", "");
                                                               }
                                                           }));
    }})