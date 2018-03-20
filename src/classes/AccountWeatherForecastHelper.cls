public class AccountWeatherForecastHelper{
    
    public List<cls_List> myList             {get;set;}
    public Map<Date, Main > dailyAverages    {get;set;}

    public class cls_list {
        public Integer dt                     {get;set;}
        public String dt_txt                  {get;set;}
        public Main main                      {get;set;}
        //public rain r                       {get;set;}
    
    }

    public class Main {
        public Decimal temp                   {get;set;}
        public Integer humidity               {get;set;}

    }

    public class rain {
        public Integer mm                     {get;set;}
    }


    //public void calculateDailyAverages() {

    //    dailyAverages = new Map<Date, Main>();
        
    //    for(cls_List l : myList) {

    //        Date key = calculateDate(l.dt);

    //        if(!dailyAverages.containsKey(key)) {
    //            dailyAverages.put(key, new Main() );
    //        } else {
    //            dailyAverages.get(key).temp = l.main.temp-273.15;
    //            dailyAverages.get(key).humidity = l.main.humidity;
    //        }
    //    }
    //}

    //public Date calculateDate(Integer unix) {

    //    DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
    //    String dateTimeValue = dateInstance.addSeconds(unix).format();
    //    String dateStringValue = dateTimeValue.left(10);
    //    Date dateValue = date.parse(dateStringValue);
    //    return dateValue;
    //}

    //public class DayForecast {
    //    public Decimal temp     {get;set;}
    //    public Integer humid    {get;set;}

    //    public DayForecast(Decimal t, Integer h) {
    //        this.temp = t;
    //        this.humid = h;
    //    }
    //}

}