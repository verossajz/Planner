
import UIKit

class FiltersController: UITableViewController {

    let filterSection = 0
    
    //MARK: IBOutlet
    @IBOutlet weak var switchEmptyPriorities: UISwitch!
    @IBOutlet weak var switchEmptyCategories: UISwitch!
    @IBOutlet weak var switchEmptyDates: UISwitch!
    @IBOutlet weak var switchCompleted: UISwitch!
    
    //MARK: Property
    var switchEmptyCategoriesValue = PrefsManager.current.showEmptyCategories
    var switchEmptyPrioritiesValue = PrefsManager.current.showEmptyPriorities
    var switchTasksWithoutDatesValue = PrefsManager.current.showTasksWithoutDates
    var switchCompletedTasksValue = PrefsManager.current.showCompletedTasks
    
    var changed: Bool {
        return switchEmptyCategories.isOn != switchEmptyCategoriesValue ||
            switchEmptyPriorities.isOn != switchEmptyPrioritiesValue ||
            switchEmptyDates.isOn != switchTasksWithoutDatesValue ||
            switchCompleted.isOn != switchCompletedTasksValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchEmptyCategories.isOn = switchEmptyCategoriesValue
        switchEmptyPriorities.isOn = switchEmptyPrioritiesValue
        switchEmptyDates.isOn = switchTasksWithoutDatesValue
        switchCompleted.isOn = switchCompletedTasksValue
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == filterSection {
            return "Включенные задачи будут отображаться в общем списке."
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == filterSection {
            return "Выберите значение"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    //MARK: IBActions
    @IBAction func switchedWithoutProperties(_ sender: UISwitch) {
        PrefsManager.current.showEmptyPriorities = sender.isOn
    }
    
    @IBAction func switchedWithoutCategories(_ sender: UISwitch) {
        PrefsManager.current.showEmptyCategories = sender.isOn
    }
    
    @IBAction func switchedWithoutDates(_ sender: UISwitch) {
        PrefsManager.current.showTasksWithoutDates = sender.isOn
    }
     
    @IBAction func switchedCompleted(_ sender: UISwitch) {
        PrefsManager.current.showCompletedTasks = sender.isOn
    }
    
}
