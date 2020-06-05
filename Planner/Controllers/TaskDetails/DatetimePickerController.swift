
import UIKit
import GCCalendar

class DatetimePickerController: UIViewController, GCCalendarViewDelegate {

    var delegate: ActionResultDelegate!
    var selectedDeadline: Date!
    var initDeadline: Date!
    
    var dateFormatter: DateFormatter!
        
    @IBOutlet weak var calendarView: GCCalendarView!
    @IBOutlet weak var labelMonthName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = createDateFormatter()
        
        calendarView.delegate = self
        calendarView.displayMode = .month
        
        if initDeadline != nil {
            calendarView.select(date: initDeadline)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: GCCalendarViewDelegate
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
        dateFormatter.dateFormat = "LLLL yyyy" //формат даты (месяц + год, без склонения)
        dateFormatter.calendar = calendar
        labelMonthName.text = dateFormatter.string(from: date).capitalized
        
        selectedDeadline = date
    }
    
    
    // MARK: IBAction
    
    @IBAction func tapCancel(_ sender: UIButton) {
        closeController()
    }
    
    @IBAction func tapToday(_ sender: UIButton) {
        calendarView.today()
    }
    
    @IBAction func tapSave(_ sender: Any) {
        closeController()
        delegate.done(source: self, data: selectedDeadline)
    }
    
}
