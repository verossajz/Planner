import Foundation

extension Date {
    
    var today: Date {
        return rewinDays(0)
    }
    
    //new date
    func rewinDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func offsetFrom(date: Date) -> Int {
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: date)
        let startOftherDay = cal.startOfDay(for: self)
        
        return cal.dateComponents([.day], from: startOfToday, to: startOftherDay).day!
    }
    
}
