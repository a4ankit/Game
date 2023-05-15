public class DownloadPdf {
    public String PDFData {get; set;} 
    public List<jsonvalue> jsonstring { get; set; }
    public DownloadPdf(){
        PDFData = '';
        system.debug('PDFData==='+PDFData);
        //jsonstring = (List<jsonvalue>) System.JSON.deserialize(PDFData , List<jsonvalue>.class);
        //system.debug('jsonstring==='+jsonstring);
    }    
    public PageReference PDF(){
        System.PageReference pageRef = new System.PageReference('/apex/PDFGenerator');
        pageRef.getHeaders().put('content-disposition', 'attachment; filename=TestPDF.pdf');
        return pageRef;
    }
    public class jsonvalue{
        public String Name {get;set;}
        public String temp {get;set;}
        public String pressure {get;set;}
        public String humidity {get;set;}
        public String temp_min {get;set;}
        public String temp_max {get;set;}
        
    }
}