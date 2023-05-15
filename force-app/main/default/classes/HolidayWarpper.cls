public class HolidayWarpper {
    
    public List<Data> data;
    public String status;
    
    public class Data {
        public String country;
        public Integer coverage;
        public String dateapi;
        public String day;
        public String day_type;
        public String holiday_description;
        public String holiday_duration;
        public String holiday_type;
        public Boolean is_business_day;
        public String language;
        public Double score;
        public Integer timestamp;
    }
    
    
    public static HolidayWarpper parse(String json) {
        return (HolidayWarpper) System.JSON.deserialize(json, HolidayWarpper.class);
    }
}