({
	getPredictionHelper : function(cmp, event, label, model, image) {
        console.log('imagehelper:::'+image.src);
        let tensor = this.preprocessImage(image, 'mobilenet');
        console.log('tensor',tensor);
        const resize_image = tf.reshape(tensor, [1, 224, 224, 3],'resize');
        console.log('resize_image',resize_image);
        model = cmp.get("v.attrCustomModel");
        console.log('model111',JSON.stringify(model));
        const setLabel = Array.from(new Set(label));
        
       // window.setInterval(this.showPrediction(model, label, image , setLabel, tensor), 
		//5000,);
		this.showPrediction(model, label, image , setLabel, tensor);
        
	},
    preprocessImage : function (image,modelName){
        let tensor=tf.fromPixels(image)
        .resizeNearestNeighbor([224,224])
        .toFloat();
        console.log('tensor pro', tensor);
        if(modelName==undefined)
        {
            return tensor.expandDims();
        }
        if(modelName=="mobilenet")
        {
            let offset=tf.scalar(127.5);
            console.log('offset',offset);
            return tensor.sub(offset)
            .div(offset)
            .expandDims();
        }
        else
        {
            throw new Error("UnKnown Model error");
        }
    },
    showPrediction : function (model, label, image , setLabel, tensor){
        
        async function getInFunction(){
            console.log('imagesrc41:::'+ image.src);
            console.log('tensor:::'+ tensor);
            console.log('label::'+label);
            console.log('Model:::'+model);
            let prediction =  await model.predict(tensor);
            console.log('prediction:::'+ prediction);
            console.log('prediction:::'+ prediction.max());
            var str = prediction.max().toString();
            var res1 = str.replace("Tensor", "");
            console.log('res1::'+res1);
            pred = prediction.argMax(1).dataSync(); 
            console.log('pred:::'+ pred);
            const labelsPred = Array.from(pred).map(e => setLabel[e]);
            console.log('labelsPred:::'+ labelsPred);
            let top5 = Array.from(prediction)
            .map(function(p,i){
                return {
                    probability: p,
                    className: prediction[i]
                };
            }).sort(function(a,b){
                return b.probability-a.probability;
            }).slice(0,1);
            $("#confidance-value").empty();
            $("#confidance-value").append(res1);
            $("#prediction-list").empty();
            $("#prediction-list").append(labelsPred);
            
        }
        getInFunction();
    }
})