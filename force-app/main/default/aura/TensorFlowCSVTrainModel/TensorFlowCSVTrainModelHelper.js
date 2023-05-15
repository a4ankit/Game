({
    generateImages : function(component, event) {
        var classified = component.get("v.classified");
        console.log('classified::'+JSON.stringify(classified)+'size__'+classified.length);
        //console.log('notclassified::'+JSON.stringify(notclassified)+'size__'+notclassified.length);       
        //get All classified images
        var arrayClassifiedImg = [];
        var imgClassified;
        let allImages = [];
        for (var i=0; i< classified.length; i++) {
            imgClassified = new Image();
            imgClassified.src = classified[i];
            imgClassified.width = 224;
            imgClassified.height = 224;
            imgClassified.crossOrigin= 'anonymous';
            console.log('imgClassified',imgClassified);
            arrayClassifiedImg.push(imgClassified);
            allImages.push(imgClassified);
        }
        component.set("v.ClassifiedImages",arrayClassifiedImg);
        console.log('arrayClassifiedImg',arrayClassifiedImg);
        console.log('atr3:'+component.get("v.ClassifiedImages"));
        
        //get All Non-Classified images
        var notclassified = component.get("v.notclassified");
        var arrayNonClassifiedImg = [];
        var imgNonClassified;
        for (var i=0; i< notclassified.length; i++) {
            imgNonClassified = new Image();
            imgNonClassified.src = notclassified[i];
            imgNonClassified.width = 224;
            imgNonClassified.height = 224;
            imgNonClassified.crossOrigin= 'anonymous';
            console.log('imgNonClassified',imgNonClassified);
            arrayNonClassifiedImg.push(imgNonClassified);
            allImages.push(imgNonClassified);
        }
        component.set("v.allImages",allImages);
        console.log('allImages',allImages.length);
        component.set("v.notclassifiedImages",arrayNonClassifiedImg);
        //console.log('arrayNonClassifiedImg',arrayNonClassifiedImg);
    },
    getPredictionHelper: function(component, event, classifier){
        var classifiedImgArray = component.get("v.allImages");
        console.log('getPredictionHelper',classifiedImgArray);
        console.log('Length ',classifiedImgArray.length);
        var model = classifier;
        let tensorarray = [];
        let tensor;
        let offsetarray = [];
        let offset;
        var offsetData;

        
        for(var i=0; i<classifiedImgArray.length; i++){
            tensor = tf.fromPixels(classifiedImgArray[i])
            .resizeNearestNeighbor([224,224])
            .toFloat();
            offset=tf.scalar(127.5);
            console.log('offset:::',offset);
            offsetData = tensor.sub(offset)
            .div(offset)
            .expandDims();
            tensorarray.push(tensor);
        }
        let resize_image = [];
        let resize;
        for(var i=0; i<tensorarray.length; i++)
        {
            resize = tf.reshape(tensorarray[i], [1, 224, 224, 3],'resize');
            console.log('resize:::',resize);
            resize_image.push(resize);
        }
        console.log('resize_image',resize_image);
        // Labels
        let Clabel =[];
        let Rlabel =[];
        let allLabel = [];
        for(var l=0;l<9;l++){
            //Clabel.push('Rack Display');
            allLabel.push('Rack Display');
		}
        console.log('Clabel',Clabel);
        for(var q=0;q<9;q++){
            //Rlabel.push('Rejected');
            allLabel.push('Rejected');
		}
        //console.log('Rlabel',Rlabel);
        console.log('allLabel',allLabel);
        //const label = ['CAT','CAT','CAT','CAT','CAR','CAR','CAR','CAR'];        
        const setLabel = Array.from(new Set(allLabel));
        let ysarr =[];
        const ys = tf.oneHot(tf.tensor1d(allLabel.map((a) => setLabel.findIndex(e => e === a)), 'int32'), 10)
        console.log('ys:::'+ys);
        const y = tf.reshape(ys, [-1]);
        y.print();
        let d;
        for(var x=0;x<18;x++){
            d= y.slice([x*10], [10]);
            d.print();
            ysarr.push(d);
        }
        console.log('ysarr',ysarr);
        
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
            loss: 'meanSquaredError',
            optimizer : 'sgd'
        })
        console.log('model:::'+model);
        let tesnor_dim =[];
        let tensr;
        for(var j=0; j<18; j++){
            tensr = tf.expandDims(ysarr[j], 0);
            tesnor_dim.push(tensr);
        }
        console.log('Before async',tesnor_dim);
        async function f(){
            // Train the model using the data.
            console.log('In async');
            for(var j=0; j<18; j++){
                //Train Model
                console.log('resize_image[j]',resize_image[j]);
                console.log('tesnor_dim[j]',tesnor_dim[j]);
                await model.fit(resize_image[j], tesnor_dim[j], {epochs: 100}).then((loss) => {          
                    console.log('Images pass',j);
                    const t = model.predict(resize_image[j]);
					console.log('Prediction:::'+t);
					pred = t.argMax(1).dataSync(); // get the class of highest probability
					const labelsPred = Array.from(pred).map(e => setLabel[e]);
					console.log('labelsPred:::'+labelsPred);
					}).catch((e) => {                                                                  
                    console.log(e.message);
                })
              }
                    const saveResults = model.save('downloads://my-model-1');
                    console.log(saveResults);
      		}
        f();
     }                     
})