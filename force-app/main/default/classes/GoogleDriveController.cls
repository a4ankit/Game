public class GoogleDriveController{
    private static String key = '1054819925585-bbhk1147rmvvet2tuv34oturo4tfosmj.apps.googleusercontent.com';
    private Static String secert = 'zTDk-L03expIC-Neu0e6hYyZ';
    private Static string redirect_uri = 'https://adyadav42-dev-ed.lightning.force.com/lightning/n/AuthTAB';
    
    @AuraEnabled
    public static String createAuthURL() {
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&access_type=offline';
        return authuri;
    }
    
    @AuraEnabled
    public static String getAccessToken(String code) {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secert+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ;
        String token = String.valueOf(responseMap.get('access_token'));
        return token;
        
    }
    
    @AuraEnabled
    public static String uploadFile(String attachmentId, String accessToken) {
        system.debug('attachmentId==='+attachmentId);
        system.debug('accessToken===='+accessToken);
        List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        Blob myBlob = cvFile[0].VersionData;
        String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
        string authorizationHeader = 'Bearer ' + accessToken;
        Integer contentSize = myBlob.size();
        HttpRequest req = new HttpRequest();
        req.setheader('Authorization',authorizationHeader);
        req.setheader('Content-Length',String.valueOf(contentSize));
        req.setheader('Content-Type','image/'+cvFile[0].FileType);
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setBodyAsBlob(myBlob);
        Http h = new Http();
        
        Httpresponse resp = h.send(req);
        //After file was successfully upload we delete the file
        delete new ContentDocument(Id = cvFile[0].ContentDocumentId);
        return String.valueOf(resp.getStatuscode());
    }
    
}