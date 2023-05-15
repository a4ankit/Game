({
    doInit : function(component, event, helper) {
        // Notice there is no 'import' statement. 'cocoSsd' and 'tf' is
        // available on the index-page because of the script tag above.
        
        var img1 = component.find("img").get("v.value");
        console.log(img1);
        //var img = document.getElementById(img).value;
      //  const img = document.getElementById('img');
        //console.log(img);
         alert('Hi::');
        // Load the model.
       // cocoSsd.load().then(model => {model.detect(img).then(predictions => {console.log('Predictions: ', predictions);});});
   },
    afterScriptsLoaded : function(cmp,evt,helper){
        alert('Hi::');
        var img1 = component.find("id").get("v.img");
        id.cocoSsd.load().then(model => {model.detect(img).then(predictions => {console.log('Predictions: ', predictions);});});
    }                                     
})