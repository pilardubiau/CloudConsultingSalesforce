public class HoursToAssign {
    private static Integer weekDay(DateTime startDay){
        Integer x;
        String day = startDay.format('E');
        
        switch on day{
            when 'mon' {
                x = 1;
            }
            when 'tue' {
                x = 2;
            }
            when 'wed' {
                x = 3;
            }
            when 'thu' {
                x = 4;
            }
            when 'fri' {
                x = 5;
            }
            when 'sat' {
                x = 6;
            }
            when else {
                x = 7;
            }
        }
        
        return x;
    }
    
    @AuraEnabled
    public static integer totalHours(Date startDate, Date endDate){
        Integer d = startDate.day();
        Integer mo = startDate.month();
        Integer yr = startDate.year();
        DateTime startDateTime = DateTime.newInstance(yr, mo, d);
        Integer day = weekDay(startDateTime);
        Integer totalDays = startDate.daysBetween(endDate);
        Integer i = 0;
        Integer h = 0;
        
        do {
            switch on day{
                when 1 {
                    day++;
                    i++;
                    h++;
                }
                when 2 {
                    day++;
                    i++;
                    h++;
                }
                when 3 {
                    day++;
                    i++;
                    h++;
                }
                when 4 {
                    day++;
                    i++;
                    h++;
                }
                when 5 {
                    day++;
                    i++;
                    h++;
                }
                when 6 {
                    day++;
                    i++;
                }
                when else {
                    day = 1;
                    i++;
                }
            }            
        } while(i < totalDays);
        
        h = h*8;
        
        return h;
    }
    
}