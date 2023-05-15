public class ImageVFPageController {
    //get,set the input value of vf page
    public boolean bb {get;set;}
    public ImageVFPageController(){
        bb=false;
    }
    public String cid{get;set;}
    public String tempimg {get;set;}
    public pagereference show(){
        bb=true;
        ImageVFPageController.displayImage(cid);            
        return null;
    }
    @RemoteAction
    public static Contact displayImage(string conid){
        //bb=true;
        //con.pic__c will return a string value
        String sourcepath;
        //SOQL to fetch the pic(Text Area(Rich)) from contact
        //Contact con=[Select id,pic__c from contact where name='june2018'];
        // String query1='Select id,pic__c from contact where lastname=\''+conname+'\'';
        String query2='Select id,photourl, pic__c from contact where name=\''+conid+'\'';
        Contact con=Database.query(query2);
        //holding the string value into a variable
        String pichold=con.pic__c;
        //System.debug('pic__c:');
        //System.debug('***************'+pichold);
        //con.pic__c returns null if there is no pic
        //fetching source of image ex. src="exjnj/dhm.png"
        sourcepath=pichold.substringBetween('src="','"');
        //return the src path        
        return con;
    }
}