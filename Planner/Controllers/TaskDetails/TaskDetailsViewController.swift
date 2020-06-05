
import UIKit

class TaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActionResultDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelDayDiff: UILabel!
    
    var taskName: String?
    var taskInfo: String?
    var taskPriority: Priority?
    var taskCategory: Category?
    var taskDeadline: Date?
    
    let taskNameSection = 0
    let taskCategorySection = 1
    let taskPrioritySection = 2
    let taskDeadlineSection = 3
    let taskInfoSection = 4
        
    var buttonDatetimePicker: UIButton!
    
    var task: Task!
    var dateFormatter: DateFormatter!
    var delegate: ActionResultDelegate!
    var textTaskName: UITextField!
    var textTaskInfo: UITextView!
    
    override func loadView() {
        super.loadView()
        
        dateFormatter = createDateFormatter()
        
        if let task = task {
            taskName =  task.name
            taskInfo = task.info
            taskPriority = task.priority
            taskCategory = task.category
            taskDeadline = task.deadline
        }
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case taskNameSection:
            return "Название"
        case taskCategorySection:
            return "Категория"
        case taskPrioritySection:
            return "Приоритет"
        case taskDeadlineSection:
            return "Дата"
        case taskInfoSection:
            return "Доп. инфо"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 120
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case taskNameSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskName", for: indexPath) as? TaskNameCell else {
                fatalError("cell type")
            }
            cell.textTaskName.text = taskName
            
            if (cell.textTaskName.text?.isEmpty)! {
                cell.textTaskName.becomeFirstResponder()
            }
            
            textTaskName = cell.textTaskName
            return cell
            
        case taskCategorySection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskCategory", for: indexPath) as? TaskCategoryCell else {
                fatalError("cell type")
            }
            
            let value: String
            
            
            if let category = taskCategory?.name {
                value = category
                cell.labelTaskCategory.textColor = UIColor.darkText
            } else {
                value = "Не выбрано."
                cell.labelTaskCategory.textColor = UIColor.lightGray
            }
            
            cell.labelTaskCategory.text = value
            return cell
            
        case taskPrioritySection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskPriority", for: indexPath) as? TaskPriorityCell else {
                fatalError("cell type")
            }
            let value: String
            
            if let priority = taskPriority?.name {
                value = priority
            } else {
                value = "Не выбрано."
            }
            
            cell.labelTaskPriority?.text = value
            
            return cell
            
        case taskDeadlineSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskDeadline", for: indexPath) as? TaskDeadlineCell else {
                fatalError("cell type")
            }
            
            cell.selectionStyle = .none
            
            buttonDatetimePicker = cell.buttonDatetimePicker
            
            var value: String
            
            if let date = taskDeadline {
                value = dateFormatter.string(from: date)
                cell.buttonDatetimePicker.setTitleColor(UIColor.darkText, for: .normal)
                cell.buttonDatetimePicker.isHidden = false
            } else {
                value = "Не задана."
                cell.buttonDatetimePicker.setTitleColor(UIColor.darkText, for: .normal)
                cell.buttonTaskDeadline.isHidden = true
            }
            
            cell.buttonDatetimePicker.setTitle(value, for: .normal)
            handleDaysOff(taskDeadline?.offsetFrom(date: Date().today), label: cell.labelDayDiff)
            return cell
            
        case taskInfoSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTaskInfo", for: indexPath) as? TaskInfoCell else {
                fatalError("cell type")
            }
            
            cell.textTaskInfo.text = taskInfo
            textTaskInfo = cell.textTaskInfo
            
            return cell
            
        default:
            fatalError("cell type")
        }
    }
    
//    func confirmAction(text: String, identifire: String) {
//        let dialogMessage = UIAlertController(title: "Подтверждение", message: text, preferredStyle: .actionSheet)
//        
//        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.performSegue(withIdentifier: identifire, sender: self)
//        }
//        
//        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//        
//        self.present(dialogMessage, animated: true, completion: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            return
        }
        
        switch segue.identifier {
        case "SelectCategory": //переход в контроллер для выбора категории
            if let controller = segue.destination as? CategoryListController {
                controller.selectedItem = taskCategory //передаем текущее значение категории
                controller.selectedDelegate = self
                controller.showMode = .select
                controller.navigationTitle = "Выберите категорию"
            }
        case "SelectPriority": //переход в контроллер для выбора категории
            if let controller = segue.destination as? PriorityListController {
                controller.selectedPriority = taskPriority //передаем текущее значение категории
            }
        case "EditTaskInfo": //переход в контроллер для ред. доп. инф.
             if let controller = segue.destination as? TaskInfoController {
                controller.taskInfo = taskInfo
                controller.selectedDelegate = self
            }
        case "SelectDatetime":
            if let controller = segue.destination as? DatetimePickerController {
                controller.initDeadline = taskDeadline
                controller.delegate = self
            }
        default:
            return
        }
    }
    
    //MARK: ActionResultDelegate
    
    func done(source: UIViewController, data: Any?) {
        
        switch source {
        case is CategoryListController:
            taskCategory = data as? Category
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskCategorySection)], with: .fade) //обновить
            
        case is PriorityListController:
            taskPriority = data as? Priority
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskPrioritySection)], with: .fade)
            
        case is TaskInfoController:
            taskInfo = data as? String
            textTaskInfo.text = taskInfo
            
        //tableView.reloadRows(at: [IndexPath(row: 0, section: taskInfoSection)], with: .fade)
        case is DatetimePickerController:
            taskDeadline = data as? Date
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: taskDeadlineSection)], with: .fade)
            
        default:
            print()
        }

    }
    
    //MARK: IBActions
    
    @IBAction func tapDeleteTask(_ sender: Any) {
        confirmAction(text: "Действительно хотите удалить задачу?") {
            self.performSegue(withIdentifier: "DeleteTaskFromDetail", sender: self)
        }
    }
    
    @IBAction func tapCompleteTask(_ sender: UIButton) {
        confirmAction(text: "Действительно хотите завершить задачу?") {
            self.performSegue(withIdentifier: "CompleteTaskFromDetails", sender: self)
        }
    }
            
    @IBAction func tapDatetimePicker(_ sender: UIButton) {
        
    }
    
    @IBAction func tapClearDeadline(_ sender: UIButton) {
        taskDeadline = nil
        tableView.reloadRows(at: [IndexPath(row: 0, section: taskDeadlineSection)], with: .fade)
    }
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        closeController()
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        
        if let taskName = taskName, !taskName.isEmpty {
            task.name = taskName
        } else {
            task.name = "Новая задача"
        }
        
        task.info = textTaskInfo.text
        task.deadline = taskDeadline
        task.priority = taskPriority
        task.category = taskCategory
        
        delegate.done(source: self, data: task)
        
        closeController()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func taskTextChanged(_ sender: UITextField) {
        taskName = sender.text
    }
    
}

