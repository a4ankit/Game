global class ProjectCalloutServiceMockFailure {
   //Implement http mock callout failure here 
   global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(400);
        response.setStatus('Bad Request');
        return response; 
    }
}