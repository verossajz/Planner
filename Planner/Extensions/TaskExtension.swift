import Foundation

extension Task {

    func daysLeft() -> Int! {
        if self.deadline == nil {
            return nil
        }
        
        return (self.deadline?.offsetFrom(date: Date().today))!
    }
}
