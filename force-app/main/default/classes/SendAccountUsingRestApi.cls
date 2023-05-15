public class SendAccountUsingRestApi 
{
String clientId='3MVG9ZL0ppGP5UrAY4RiAZEo8VcTwDbOdOnTIUS652T0VsnMVlmCUxjmJ9mnPQjEZ6wFFaN4aRvCv_Yw2_ECi';
String clientsecret='8405646627149328563';
string username='adarsh@cloud.com';
String password='addys888429';
String accesstoken_url='https://login.salesforce.com/services/oauth2/token';
String authurl='https://login.salesforce.com/services/oauth2/authorize';
public class deserializeResponse
{
    public String id;
    public String access_token;   
}
public String ReturnAccessToken(SendAccountUsingRestApi Acc){
    String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password; // String reqbody='{"grant_type":"password","client_id":clientId,"client_secret":clientSecret,"username":username,"password":password}';
    Http h= new Http();
    HttpRequest req= new HttpRequest();
    req.setBody(reqbody);
    req.setMethod('POST');
   
    req.setEndpoint('https://ap6.salesforce.com/services/oauth2/token'); //Change "ap4" in url to your Target Org Instance 
    HttpResponse res=h.send(req);
    System.debug(res.getBody()+'###1203res');
    deserializeResponse resp1=(deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);
    System.debug(resp1+'###1203deserializeresponse');
    return resp1.access_token;
}

@future(callout=true)
public static void createAccount(String Accname){
    SendAccountUsingRestApi acc1= new SendAccountUsingRestApi();
    String accessToken=acc1.ReturnAccessToken(acc1);
    System.debug(accessToken+'###0012');
    if(accessToken!=null){
        String endPoint='https://ap6.salesforce.com/services/data/v32.0/sobjects/Account'; //Change "ap4" in url to your Target Org Instance 
        String jsonstr='{"Name":"'+ Accname +'"}';
        Http h2= new Http();
        HttpRequest req2= new HttpRequest();
        req2.setHeader('Authorization','Bearer ' + accessToken);
        req2.setHeader('Content-Type','application/json');
        req2.setHeader('accept','application/json');
        req2.setBody(jsonstr);
        req2.setMethod('POST');
        req2.setEndpoint(endPoint);
        HttpResponse res2=h2.send(req2);
        System.debug(res2+'###1203createresp');
        deserializeResponse deresp2=(deserializeResponse)System.JSON.deserialize(res2.getBody(),deserializeResponse.class);
        System.debug('###1203createdeser'+deresp2);
    }
}
}