({
    readCSV: function(component, event, helper) {
        var filename = event.getSource().get("v.files");
        var textdata;
        var reader = new FileReader();
        //var classified = [];
        //var notclassified = [];
        reader.onload = function() {
            var text = reader.result; /*Get the data stored in file*/
            textdata = text;
            var infolst = [];
            var classified = [];
            var notclassified = [];
            var rows = textdata.split('\n'); /*Spilt based on new line to get each row*/
            for(var i=0; i< rows.length; i = i+1){
                var cells = rows[i].split(',');
                //Get All rows except header
                if(cells.length!=1){
                    var labelSRC = cells[1].split('\r');
                    //get All classified coloumn
                    if(cells[1].startsWith("https://")){
                        var cellinfo = {
                            'Index': cells[0],
                            'Classified': cells[1]
                        };
                        classified.push(cells[1]);
                        component.set("v.classified",classified);
                        console.log('classified:::::'+component.get("v.classified"));
                    }
                    //get All Non-classified coloumn
                    if(cells[2].startsWith("https://")){
                        var cellinfo = {
                            'Index': cells[0],
                            'Not Classified': cells[2]
                        };
                        notclassified.push(cells[2]); 
                        component.set("v.notclassified",notclassified);     
                    }                                   
                }
            }
            helper.generateImages(component, event);
        }
        
        
        if (filename[0] !== undefined && filename[0] !== null && filename[0] !== '') {
            reader.readAsText(filename[0]);
        }
    },
    getPrediction : function (cmp, event, helper){
        console.log("You clicked: " + event.getSource().get("v.label"));
        let classifier = cmp.get("v.data");
        console.log('classifier::'+classifier);
        helper.getPredictionHelper(cmp, event, classifier);
        
    },
    doML5js : function (cmp, event, helper){
        console.log('tfjs loaded');
        let model = tf.sequential();
        console.log('model', JSON.stringify(model));
        cmp.set("v.data", model);
        console.log('data::'+cmp.get("v.data"));
    },
})