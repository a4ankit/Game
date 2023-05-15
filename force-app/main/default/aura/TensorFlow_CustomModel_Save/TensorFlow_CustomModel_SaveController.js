({
    readCSV: function(component, event, helper) {
        var filename = event.getSource().get("v.files");
        var textdata;
        var reader = new FileReader();
        
        reader.onload = function() {
            var text = reader.result; 
            textdata = text;
            var infolst = [];
            var classified = [];
            var notclassified = [];
            var allImages =[];
            var rows = textdata.split('\n'); 
            var fileHeader = rows[0];
            var arryHeader = fileHeader.split(',');
            console.log('arryHeader:::'+arryHeader);
            var finalLabel =[] ;
            for(var i1=0; i1< arryHeader.length ; i1++){
                if(!arryHeader[i1].includes("S.No")){
                    finalLabel.push(arryHeader[i1]);
                }
            }
            console.log('123'+finalLabel.length);
            
            if(finalLabel.length >0){
                component.set("v.fileHeader",finalLabel);
                if(rows.length >1){
                	component.set("v.fileColumnLength",rows.length-1);
                }
            }
            
            console.log('rows.length:::'+rows.length);
            console.log('finalLabel:::'+finalLabel);
            console.log('finalLabel12:::'+component.get("v.fileColumnLength"));
            
            for(var i=0; i< rows.length; i = i+1){
                var cells = rows[i].split(',');
                console.log('cells:::'+cells);
                //Get All rows except header
                if(cells.length!=1){
                    var labelSRC = cells[1].split('\r');
                    //get All classified and non-Classified coloumn
                    for(var col=0; col<cells.length; col++){
                        if(cells[col].startsWith("https://") || cells[col].startsWith("http://")){
                            var cellinfo = {
                                'Index': cells[col],
                                'Classified': cells[col]
                            };
                            allImages.push(cells[col]);
                        }
                    }
                    
                }
            }
            console.log('allImages::::'+allImages);
            component.set("v.classified",allImages);
            console.log('classified:::::'+component.get("v.classified").length);
            //component.set("v.notclassified",notclassified);
            //console.log('notclassified:::::'+component.get("v.notclassified").length);
            helper.generateImages(component, event);
        }
        
        
        if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
            reader.readAsText(filename[0]);
        }
    }, 
    doTrainModel : function (cmp, event, helper){
        console.log("You clicked: " + event.getSource().get("v.label"));
        let customModel = cmp.get("v.customModel");
        console.log('customModel::'+customModel);
        helper.getTrainingHelper(cmp, event, customModel, helper);
        
    },
    doTfJs : function (cmp, event, helper){
        console.log('mlLoaded');
        
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
            loss: 'meanSquaredError',
            optimizer : 'sgd'
        })
        console.log('model:::'+model);
        
        cmp.set("v.customModel", model);
        console.log('Modeldata::'+JSON.stringify(cmp.get("v.customModel")));
               
    },
    doLoadJquery : function(cmp, event, helper){
        //Choose and set the images for training
        $("#image-selector").change(function(){
            
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#selected-image0').attr('src', e.target.result);
                    $("#prediction-list").empty();
                }
                reader.readAsDataURL(this.files[0]);
            }
            if (this.files && this.files[1]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#selected-image1').attr('src', e.target.result);
                    $("#prediction-list").empty();
                }
                reader.readAsDataURL(this.files[1]);
            }
            if (this.files && this.files[2]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#selected-image2').attr('src', e.target.result);
                    $("#prediction-list").empty();
                }
                reader.readAsDataURL(this.files[2]);
            }
            
        });
        var imgtag = $("#selected-image").get(0);
        console.log('imgtag2:::'+JSON.stringify(imgtag));
    }
})