({	
    doTfJs : function(component, event, helper) {
        console.log('do doTfJs-->TensorFLowJS_Loaded');
        let model;
        let cutomModelJson;
        let cutomModelbin;
        $("#load").change( async function(){
            for (var i = 0; i < $(this).get(0).files.length; ++i) {
                console.log('AllFiles:::'+JSON.stringify($(this).get(0).files[i]));
                if($(this).get(0).files[i].name == 'my-model-1.json'){
                    cutomModelJson = $(this).get(0).files[i];
                }else{
                    cutomModelbin = $(this).get(0).files[i];
                }
            }
            console.log('cutomModelJson::'+cutomModelJson.name+'cutomModelbin::'+cutomModelbin.name);
            
            model = await tf.loadModel(tf.io.browserFiles([cutomModelJson, cutomModelbin]));
            console.log('model222'+JSON.stringify(model));
            component.set("v.attrCustomModel",model);
        });
        
    },
    doPrediction : function(component, event, helper) {
        console.log('In do prediction');
        let model;
        let cutomModelJson;
        let cutomModelbin;
        let image = component.get("v.selectedImage");
        console.log('imageControllerPre:::'+ JSON.stringify(image));
        console.log('imagesrc:::'+ image.src);
        console.log('imageControllerPost:::'+ JSON.stringify(image));
        
        let label = [];
        for(var k = 0; k<41; k++){
            label.push('Classified');
        }
        for(var l = 0; l<12; l++){
            label.push('Not Classified');
        }
        
        console.log('label:::'+label);
        
        helper.getPredictionHelper(component, event, label, model, image);
    },
    doLoadJquery : function(component, event, helper) { 
        console.log('In doLoadJquery');
        $("#image-selector").change(function(){
            let reader = new FileReader();            
            reader.onload = function(){
                let dataURL = reader.result;
                $("#selected-image").attr("src",dataURL);
                $("#prediction-list").empty();
                $("#confidance-value").empty();
            }
            let file = $("#image-selector").prop('files')[0];
            reader.readAsDataURL(file);
            var imgtag1 = $("#selected-image").get(0);
            component.set("v.selectedImage",imgtag1);
            console.log('imgtag1:::'+imgtag1.src);
        });
        var imgtag = $("#selected-image").get(0);
        console.log('imgtag2:::'+JSON.stringify(imgtag));
    }
})