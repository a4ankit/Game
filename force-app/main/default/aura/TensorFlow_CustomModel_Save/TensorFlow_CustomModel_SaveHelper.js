({
    generateImages: function(component, event) {
        var classified = component.get("v.classified");
        console.log('AllImageURL::' + JSON.stringify(classified));
        console.log('AllImageURL_Length::'+ 'size__' + classified.length);
        
        //get All classified and Non-classified images(Rack or Display or Store Shelf)
        var arrayClassifiedImg = [];
        var imgClassified;
        let arrayAllImages =[];
        for (var i = 0; i < classified.length; i++) {
            imgClassified = new Image(224, 224);
            imgClassified.src = classified[i];
            imgClassified.crossOrigin = 'anonymous';            
            console.log('imgClassified::::', imgClassified);
            arrayClassifiedImg.push(imgClassified);
            arrayAllImages.push(imgClassified);
        }
        console.log('arrayAllImages123::::' + arrayAllImages.length);
        component.set("v.AllTypeImages", arrayAllImages);

        console.log('AllTypeImages:' + component.get("v.AllTypeImages"));

        
    },
    getTrainingHelper: function(component, event, customModel, helper) {
        console.log('Caliing-->getTrainingHelper' + customModel);
        //generate tensor for labels
        var CustomSet = component.get("v.listCustomSettingVariable");
       
        
        var model = customModel;
        let label = [];
        var dataOccurrence = component.get("v.fileColumnLength");
        var fileAllHeader = component.get("v.fileHeader");
        console.log('fileAllHeader:::'+fileAllHeader);
        var LableString = fileAllHeader.join();
        console.log('LableString'+LableString);
        var arrayOfHeader = [];
        if(fileAllHeader){
            arrayOfHeader = fileAllHeader.toString().split(',')
        }
        console.log('arrayOfHeader:::'+arrayOfHeader);
        
        for(var allHeader = 0; allHeader<arrayOfHeader.length ; allHeader++){
            for(var colLength = 0; colLength< dataOccurrence; colLength++){
                label.push(arrayOfHeader[allHeader]);
            }
        }
        var action = component.get("c.saveCustomSet");
        console.log('Action::'+action);
        action.setParams({ Header : LableString });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--'+state);            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.listCustomSettingVariable", response.getReturnValue());
                console.log('response=='+response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        console.log('label123:::'+label);
        
        var classifiedImgArray = component.get("v.ClassifiedImages");
        var notClassifiedImgArray = component.get("v.notclassifiedImages");
        var allTypeimages = component.get("v.AllTypeImages");
        console.log('allTypeimages:::'+allTypeimages.length);
        let tensorarr = [];
        let tensor ;
        var modelName = 'mobilenet';
        //get Imagea to convert in tensor
        for (var i = 0; i < allTypeimages.length; i++) {
            console.log('allTypeimages' + allTypeimages[i]);
            tensor = helper.preprocessImage(allTypeimages[i],modelName);
            tensorarr.push(tensor);
        }   
        

        //resize the tensor
        let resize_image = [];
        let resize;
        console.log('tensorarr:::'+tensorarr.length);
        console.log('label::::'+label.length);
        for (var i = 0; i < tensorarr.length; i++) {
            resize = tf.reshape(tensorarr[i], [1, 224, 224, 3], 'resize');
            console.log('resize:::', resize);
            resize_image.push(resize);
        }
		
        const setLabel = Array.from(new Set(label));
        let ysarr =[];
        const ys = tf.oneHot(tf.tensor1d(label.map((a) => setLabel.findIndex(e => e === a)), 'int32'), 10)
        console.log('ys:::'+ys);
        const y = tf.reshape(ys, [-1]);
        y.print();
        
        let d;
        for(var m=0; m<label.length ;m++){
            d = y.slice([m*10], [10]);
            d.print();
            ysarr.push(d);
        } 
        
        console.log('ysarr:::',ysarr.length);
        
        let tesnor_dim =[];
        let tensr;
        console.log('resize_image:::'+resize_image);
        //execute callApexMethod() again after 5 sec each
        helper.modelFit(model,resize_image,tesnor_dim,ysarr,setLabel, helper);
        

    },
    //This function is used to convert an image object into a Tensor
    preprocessImage: function(image, modelName, helper) {
        let tensor = tf.fromPixels(image)
            .resizeNearestNeighbor([224, 224])
            .toFloat();
        console.log('tensor pro:::', tensor);
        if (modelName == undefined) {
            return tensor.expandDims();
        }
        if (modelName == "mobilenet") {
            let offset = tf.scalar(127.5);
            console.log('offset:::', offset);
            return tensor.sub(offset)
                .div(offset)
                .expandDims();
        } else {
            throw new Error("UnKnown Model error");
        }
    },
    
    //This function is used to convert an image object into a Tensor
    modelFit: function(model,resize_image,tesnor_dim,ysarr,setLabel, helper) {
        console.log('modelFit::'+resize_image);
        tesnor_dim =[];
        async function awaitFunction(){
            for (var j = 0; j < resize_image.length ; j++) {
                console.log('resize_image', resize_image);
                tensr = tf.expandDims(ysarr[j], 0);
                tesnor_dim.push(tensr);
                console.log('tesnor_dim', tesnor_dim);
                console.log('before resize_image[j]', resize_image[j]);
                console.log('before tesnor_dim[j]', tesnor_dim[j]);
               
                    await model.fit(resize_image[j], tesnor_dim[j], {epochs: 100}).then((loss) => {
                        console.log('resize_image.get[j]',resize_image[j]);
                        console.log('tesnor_dim[j]',tesnor_dim[j]);
                        console.log('loss',loss);
                        const t = model.predict(resize_image[j]);
                        console.log('Prediction:::'+t);
                        pred = t.argMax(1).dataSync(); // get the class of highest probability
                        const labelsPred = Array.from(pred).map(e => setLabel[e]);
                        console.log('labelsPred:::'+labelsPred);
                        
                        }).catch((e) => {
                            console.log(e.message);
                        })
                   
                    
                }    //Save Model
                    const saveResults = model.save('downloads://my-model-1');
                    console.log(saveResults);   
                }
        awaitFunction();      
             
    }
})