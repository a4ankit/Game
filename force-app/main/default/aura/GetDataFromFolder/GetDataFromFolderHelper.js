({
	getTrainingHelper: function(component, event, customModel) {
        
        console.log('Caliing-->getTrainingHelper' + customModel);
        //generate tensor for labels
        //const label = ['Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Store Shelf','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected','Rejected'];
        let label = [];
        for(var k = 0; k< 40; k++){
            label.push('Store Shelf');
        }
        for(var l = 0; l< 5; l++){
            label.push('Rejected');
        }
        
        console.log('label:::'+label);
        var model = customModel;
        var classifiedImgArray = component.get("v.classified");
        var notClassifiedImgArray = component.get("v.notclassifiedImages");
        //var allTypeimages = component.get("v.AllTypeImages");
        console.log('classifiedImgArray:::'+classifiedImgArray.length);
        let tensorarr = [];
        let tensor = '';
        //get Image to convert in tensor
        for (var i = 0; i < classifiedImgArray.length; i++) {
            console.log('allTypeimages' + classifiedImgArray[i]);
            tensor = this.preprocessImage(classifiedImgArray[i], 'mobilenet');
            tensorarr.push(tensor);
        }

        //resize the tensor
        let resize_image = [];
        let resize;
        console.log('tensorarr:::'+tensorarr.length);
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

        console.log('ysarr',ysarr);
        
        console.log('resize_image:::'+resize_image);
        //execute callApexMethod() again after 5 sec each
        this.modelFit(model,resize_image,ysarr,setLabel);

    },
    //This function is used to convert an image object into a Tensor
    preprocessImage: function(image, modelName) {
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
    modelFit: function(model,resize_image,ysarr,setLabel) {
        let tesnor_dim =[];
        let tensr;
        console.log('modelFit::'+resize_image);
         async function awaitFunction(){
            for (var j = 0; j < resize_image.length ; j++) {
                console.log('resize_image', resize_image);
                console.log('model', model);
                console.log('ysarr', ysarr);
                console.log('setLabel', setLabel);
                tensr = tf.expandDims(ysarr[j], 0);
                tesnor_dim.push(tensr);
                console.log('tesnor_dim', tesnor_dim);
                console.log('before resize_image[j]', resize_image[j]);
                console.log('before tesnor_dim[j]', tesnor_dim[j]);
                //for(var k=0; k < 5; k++){
                     await model.fit(resize_image[j], tesnor_dim[j], {epochs: 100}).then((loss) => {
                        //console.log('Final accuracy', loss.history.loss);
                        console.log('Image Pass',j+1);
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
                    //}       
                }
                        //Save Model
                    const saveResults =  await model.save('downloads://my-model-1');
                    console.log(saveResults);
                }
        awaitFunction();      
             
    }
})