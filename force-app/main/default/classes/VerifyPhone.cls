public class VerifyPhone {
    
    public String mobileNo { get; set; }
    public String password { get; set; }
    String accountSid;
    string token;
    String fromPhNumber;
    errorResponseWrapper erw;
    
    public  VerifyPhone(){
        //mobileNo =Apexpages.currentpage().getparameters().get('mobileNo');
        System.debug('##### Inside Constructor');
        accountSid = 'AC467a79ce07846e9a4ab68a87170c88ba';
        token = 'e34922a080ab10ef5eedb907417b6a97';
        fromPhNumber = '+9142237078';
        //mobileNo ='+917042114685';
        //password='123456';
    }   
    public void processSms(){
        //mobileNo =Apexpages.currentpage().getparameters().get('mobileNo');
        System.debug('#### accountSid = '+ accountSid);
        System.debug('#### token = '+ token);
        System.debug('#### fromPhNumber = '+ fromPhNumber);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json');
        req.setMethod('POST');
        String VERSION  = '3.2.0';
        req.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        req.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid+':' +token)));
        
        System.debug('#### mobileNo = '+ mobileNo);
        System.debug('#### fromPhNumber = '+ fromPhNumber);
        System.debug('#### password = '+ password);
        
        req.setBody('To='+EncodingUtil.urlEncode(mobileNo,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+password);
        System.debug('##### req = ' + req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('##### res = ' + res);
        System.debug('##### Body = '+res.getBody());
        if(res.getStatusCode()==201)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'SMS Sent Successfully'));
        else{
            erw =(errorResponseWrapper)json.deserialize(res.getBody(),errorResponseWrapper.class);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,erw.message));
        }
    }
    
    public String generateOTP(){
        
        Integer rndnum = Math.round(Math.random()*10000);
        String otp = string.valueOf(rndnum);
        System.debug('otp '+otp);
        
        return otp;
    }
    
    public class errorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
}