({
    doInit : function(component, event, helper) {
        console.log('Do Init');
        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#imgshow')
                        .attr('src', e.target.result)
                        .width(150)
                        .height(200);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
        
    },
    jsLoaded : function(cmp, event, helper) {

        /*var img1 = new Image(); // Image constructor
        img1.src = $A.get('$Resource.car');
        img1.alt = 'alt';
        document.body.appendChild(img1);
        
        var img2 = document.createElement('img'); // Use DOM HTMLImageElement
        img2.src = $A.get('$Resource.cat');
        img2.alt = 'alt text';
        document.body.appendChild(img2);
		
        alert(document.images[0].src);*/
        
        /*const canvas = document.getElementById('canvas');
        const ctx = canvas.getContext('2d');
        const imageData = ctx.createImageData(100, 100);
        
        // Iterate through every pixel
        for (let i = 0; i < imageData.data.length; i += 4) {
          // Modify pixel data
          imageData.data[i + 0] = 190;  // R value
          imageData.data[i + 1] = 0;    // G value
          imageData.data[i + 2] = 210;  // B value
          imageData.data[i + 3] = 255;  // A value
        }
        
        // Draw image data to the canvas
        ctx.putImageData(imageData, 20, 20);*/
                
        // using first image in the document
       // alert(document.images[0].src);
       //const img = $A.get('$Resource.car');
       //var img =  cmp.find("img").get("v.value");
        console.log('js loaded');
        const img = document.getElementById('img');
        //var gl;
        
		//var gl = canvas.getContext('2d');
        //gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
   
        //var canvas = cmp.find("webgl").getElement();
        alert(img);
        console.log(img);
        cocoSsd.load().then(model => {
            // detect objects in the image.
            model.detect(img).then(predictions => {
            console.log('Predictions: ', predictions);
        });
       });
     },
            
})