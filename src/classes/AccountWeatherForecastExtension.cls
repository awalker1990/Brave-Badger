public without sharing class AccountWeatherForecastExtension {

    //Integration Variables
    public String API_KEY    = 'c16e07a7235b670d218d04a74bf669cb';
    public String ENDPOINT  = 'http://api.openweathermap.org/data/2.5/forecast'; 

    public Map<String, AverageWrapper> weatherMap {get;set;}
    public List<DataWrapper> forecast    {get;set;}

    public AccountWeatherForecastExtension(ApexPages.StandardController stdController) {
        weatherService((Account)stdController.getRecord());
    }

    public void weatherService(Account acc) {

        //Get the city code
        String cityCode = [SELECT Id, Id__c FROM Weather_City_Codes__c WHERE City__c = :acc.BillingCity LIMIT 1].Id__c;

        //Make Call
        String url = ENDPOINT + '?' + 'id=' + cityCode + '&APPID=' + API_KEY;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);

        String jsonString = res.getBody().replace('list', 'myList');
        AccountWeatherForecastHelper jsonObject = (AccountWeatherForecastHelper)JSON.deserialize(jsonString, AccountWeatherForecastHelper.class);
        List<AccountWeatherForecastHelper.cls_List> weatherList = (List<AccountWeatherForecastHelper.cls_List>)jsonObject.myList;

        weatherMap = new Map<String, AverageWrapper>();
        Integer i = 0;

        for(AccountWeatherForecastHelper.cls_list l : weatherList) {

            AccountWeatherForecastHelper.Main main = (AccountWeatherForecastHelper.Main)l.main;
            String key = l.dt_txt.left(10);
            Decimal temp = main.temp-273.15;
            Integer humid = main.humidity;

            if(!weatherMap.containsKey(key) ) {

                weatherMap.put(key, new AverageWrapper(key, temp, humid));
                } else {
                    weatherMap.get(key).iterator ++;
                    weatherMap.get(key).totalTemp += temp;
                    weatherMap.get(key).totalHumid += humid;

                }
            }

            forecast = new List<DataWrapper>();
            for(AverageWrapper a : weatherMap.values()) {
                forecast.add(new DataWrapper(a.plotDate, a.totalTemp/a.iterator, a.totalHumid/a.iterator));
            }

        }

        public class AverageWrapper {
            public String plotDate      {get;set;}
            public Decimal totalTemp    {get;set;}
            public Integer totalHumid   {get;set;}
            public Integer iterator     {get;set;}

            public AverageWrapper(String pD, Decimal aT, Integer aH) {
                this.plotDate = pD;
                this.totalTemp = aT;
                this.totalHumid = aH;
                this.iterator = 1;
            }
            
            public Integer calculateAverage() {
            	return 1;
            }
        }

        public class DataWrapper {
            public String plotTime      { get; set; }
            public Decimal temp         { get; set; }
            public Integer humid        { get; set; }

            public DataWrapper(String dt, Decimal t, Integer h) {
                this.plotTime = formatDate(dt);
                this.temp = t;
                this.humid = h;
            }

            public String formatDate(String dateValue) {
                Date myDate = Date.ValueOf(dateValue);
                DateTime myDateTime = (DateTime) myDate;
                String dayOfWeek = myDateTime.format('E');
                return dayOfWeek;
            }

        }


    }