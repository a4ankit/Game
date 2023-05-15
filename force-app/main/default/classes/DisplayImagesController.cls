public class DisplayImagesController
{
    //Parent Contact
    private String ContactId ;
    //Image selected from UI
    public String selectedImage {get; set;}
    
    public DisplayImagesController()
    {
        //Fetching contact Id
        ContactId = ApexPages.CurrentPage().getParameters().get('Id') ;
        selectedImage = '' ;
    }
    
    public boolean validateImage(String image)
    {
        String Regex = '([^\\s]+(\\.(?i)(jpg|png|gif|bmp))$)';
        Pattern MyPattern = Pattern.compile(Regex);
        Matcher MyMatcher = MyPattern.matcher(image);
        return MyMatcher.matches() ;
    }
    
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        
        //All attachments related to contact
        List<Attachment> attachLst = [SELECT Id , Name FROM Attachment WHERE ParentId =: ContactId] ;
        
        //Creating option list
        for(Attachment att : attachLst)
        {
            String imageName = att.name.toLowerCase() ;
            if(validateImage(imageName))
            {
                options.add(new SelectOption(att.Id , att.Name));
            }
        }
        
        return options ;
    }
    
    public PageReference SaveImage()
    {
        //Contact to update
        List<Contact> conToUpdate = new List<Contact>() ;
        conToUpdate = [select id,StoreImageUrl__c from contact where id =: ContactId] ;

        //Inserting image parth
        if(conToUpdate.size() > 0)
        {
            conToUpdate[0].StoreImageUrl__c = 'https://ankit96-dev-ed.my.salesforce.com/servlet/servlet.FileDownload?file=' + selectedImage ;
            update conToUpdate[0] ;
        }
        return null ;
    }
}