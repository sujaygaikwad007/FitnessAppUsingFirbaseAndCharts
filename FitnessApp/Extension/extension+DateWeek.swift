import Foundation

extension Date{
    //Get todays day
    static var startOfDay:Date{
        Calendar.current.startOfDay(for: Date())
    }
    
    //get first day of week
    static var startOfWeek:Date?{
        let calender  = Calendar.current
        var components = calender.dateComponents([.yearForWeekOfYear,.weekOfYear], from: Date())
        components.weekday  = 2  //Mondaay
        
        return calender.date(from: components)!
    }
}
