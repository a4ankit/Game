({
    readFolder: function(component, event, helper) {
        var files = event.getSource().get("v.files");;
        let imgClassified;
        let arrayClassifiedImg = [];
        let tensorarr = [];
        if (files.length > 0) {
            for (var i = 0; i <= files.length - 1; i++) {
                console.log('fi.files', files.item(i));
                var fname = files.item(i).name;
                var fsize = files.item(i).size;
                imgClassified = new Image(224, 224);
                imgClassified.src = files[i];
                imgClassified.crossOrigin = 'anonymous';
                console.log('imgClassified::::', imgClassified);
                arrayClassifiedImg.push(imgClassified);
                
            }
            component.set("v.classified",arrayClassifiedImg);
        }
        //helper.generateImages(component, event);
        
    },
    doTrainModel : function (cmp, event, helper){
        console.log("You clicked: " + event.getSource().get("v.label"));
        let customModel = cmp.get("v.customModel");
        console.log('customModel::'+customModel);
        helper.getTrainingHelper(cmp, event, customModel);
        
    },
    doTfJs : function (cmp, event, helper){
        console.log('Tesnor Flow Js Loaded');
        
        //create a blank model
        let model;
        model = tf.sequential();
        //Adding Layers to model
        model.add(tf.layers.conv2d({
            inputShape: [224, 224 , 3],
            kernelSize: 5,
            filters: 8,
            strides: 1,
            activation: 'relu',
            kernelInitializer: 'VarianceScaling'
        }));
        model.add(tf.layers.maxPooling2d({poolSize: 2, strides: 2}));
        model.add(tf.layers.maxPooling2d({poolSize: 2, strides: 2}));
        model.add(tf.layers.flatten({}));
        model.add(tf.layers.dense({units: 64, activation: 'relu'}));
        model.add(tf.layers.dense({units: 10, activation: 'softmax'}));
        
        //Compiling Model
        model.compile({
            loss:'meanSquaredError',
            optimizer: 'sgd',
            metrics: ['mse']
        });
        console.log('model:::'+model);
        
        cmp.set("v.customModel", model);
        console.log('Modeldata::'+JSON.stringify(cmp.get("v.customModel")));
    },
    doMl5 : function(cmp, event, helper)
    {
        console.log('in ml5 js');
        var path = $A.get("$Resource.IMAGENET_CLASSES");
        var req = new XMLHttpRequest();
        req.open("GET", path);
        req.addEventListener("load", $A.getCallback(function() {
            cmp.set("v.attribute", req.response);
            var response = req.response;
            var ret = response.replace('const IMAGENET_CLASSES =','');
            console.log(ret[i]);
            var jsonString = ret;
            console.log('jsonString',jsonString);
            console.log('req.response',req.response);
        }));
        req.send(null);
    }
})