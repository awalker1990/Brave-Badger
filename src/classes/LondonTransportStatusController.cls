public class LondonTransportStatusController {
	
	private String apiURL;
	public List<TubeWrapper> statusWrapper 		{get;set;}

	public LondonTransportStatusController() {
		setupCall();
		request();
		
	}

	//Getter for VF page
	public List<TubeWrapper> getTubeStatus() {   
		return statusWrapper;
	}

	public void setupCall() {

		//Get Custom setting and combine to form URL
		TFL_Service__c api = TFL_Service__c.getall().values();
		String url = api.Endpoint_URL__c;
		String mode = api.mode__c;
		String detail = string.valueOf(api.detail__c);
		apiURL = url + '/Line/Mode/' + mode + '/status?detail=' + detail;


	}

	public void request() {

		//Setup the call
		HttpRequest req = new HttpRequest();
		req.setEndpoint(apiURL);
		req.setMethod('GET');

        //Gather the response
        Http http = new Http();
        HTTPResponse res = http.send(req);

        //Replace restricted keywords
        String jsonResponse = res.getBody().replace('$type', 'apiType');
        jsonResponse = jsonResponse.replace('id', 'apiId');

        //Deserialize into TFLHelper class
        List<TFLHelper.Line> lines = (List<TFLHelper.Line>) JSON.deserialize(jsonResponse, List<TFLHelper.Line>.Class);

        //Instantiate a new Wrapper for the VF page
        statusWrapper = new List<TubeWrapper>();

        //iterate over the list of objects in helper and put the values into the wrapper
        for(TFLHelper.Line line : lines) {
        	statusWrapper.add(new TubeWrapper(line.name, line.linestatuses.get(0).statusSeverityDescription ) );
        }

    }

    public class TubeWrapper {
    	public String tubeLine 		{get;set;}
    	public String tubeStatus 	{get;set;}

    	public TubeWrapper(String t, String ts) {
    		tubeline = t;
    		tubestatus = ts;
    	}
    }




}