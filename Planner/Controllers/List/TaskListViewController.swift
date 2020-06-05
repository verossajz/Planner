
import UIKit
import CoreData
import SideMenu

class TaskListViewController: UITableViewController, ActionResultDelegate {
    
    //MARK: Property
    
    let taskDAO = TaskDaoImpl.current
    let categoryDAO = CategoryDaoImpl.current
    let priorityDAO = PriorityDaoImpl.current
    var searchController: UISearchController!
    let taskQuickSection = 0
    let taskListSection = 1
    let sectionCount = 2
    var textQuickTask: UITextField!
    
    var taskCount: Int {
        return taskDAO.items.count
    }
    
    var dateFormatter: DateFormatter!
    var currentScopeIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = createDateFormatter()
        
        currentScopeIndex = PrefsManager.current.sortType
        
        setupSearchController()
        taskDAO.getAll(sortType: TaskSortType(rawValue: currentScopeIndex)!)
        
        initSideMenu()
        
    }
        
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case taskQuickSection:
            return 1
        case taskListSection:
            return taskCount
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case taskQuickSection:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellQuickTask", for: indexPath) as? QuickTaskCell else {
                fatalError("No type or empty cell")
            }
            textQuickTask = cell.textQuickTask
            textQuickTask.placeholder = "Введите название задачи"
            
            return cell
            
        case taskListSection:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask", for: indexPath) as? TaskListCell else {
                fatalError("No type or empty cell")
            }

            let task = taskDAO.items[indexPath.row]
            
            cell.labelTaskName.text = task.name
            cell.labelTaskCategory.text = (task.category?.name ?? "(без категории)")
            cell.labelTaskCategory.textColor = UIColor.lightGray
            
            if task.info == nil || (task.info?.isEmpty)! {
                cell.buttonInfo.isHidden = true
            } else {
                cell.buttonInfo.isHidden = false
            }
            
            if let priority = task.priority {
                switch priority.index {
                case 1 :
                    cell.labelTaskPriority.backgroundColor = UIColor(named: "low")
                case 2 :
                    cell.labelTaskPriority.backgroundColor = UIColor(named: "normal")
                case 3 :
                    cell.labelTaskPriority.backgroundColor = UIColor(named: "hight")
                default :
                    cell.labelTaskPriority.backgroundColor = UIColor.white
                }
            } else {
                cell.labelTaskPriority.backgroundColor = UIColor.white
            }
            
            cell.labelTaskDeadline.textColor = .lightGray
            
            handleDaysOff(task.daysLeft(), label: cell.labelTaskDeadline)
            
            //completed task style
            if task.completed {
               
                cell.labelTaskDeadline.textColor = .lightGray
                cell.labelTaskName.textColor = .lightGray
                cell.labelTaskCategory.textColor = .lightGray
                cell.labelTaskPriority.textColor = .lightGray
                
                cell.buttonComlete.setImage(UIImage(named: "check_green"), for: .normal)
                cell.selectionStyle = .none
                cell.buttonInfo.isEnabled = false
                cell.buttonInfo.imageView?.image = UIImage(named: "note_gray")
                
            } else {
                
                cell.selectionStyle = .default
                cell.buttonInfo.isEnabled = true
                cell.buttonInfo.imageView?.image = UIImage(named: "note")
                cell.labelTaskName.textColor = .darkGray
                cell.buttonComlete.setImage(UIImage(named: "check_gray"), for: .normal)
                cell.buttonInfo.isEnabled = true
                
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case taskQuickSection:
            return 40
        default:
            return 60
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == taskQuickSection {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteTask(indexPath)
            
        } else if editingStyle == .insert {
            
        }
        
    }
    
    //go to edit
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if taskDAO.items[indexPath.row].completed == true {
            return
        }
        
        if indexPath.section != taskQuickSection {
            performSegue(withIdentifier: "UpdateTask", sender: tableView.cellForRow(at: indexPath))
            
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier! {
        case "UpdateTask":
            
            let selectedCell = sender as! TaskListCell
            
            let selectedIndex = (tableView.indexPath(for: selectedCell)?.row)!
            let selectedTask = taskDAO.items[selectedIndex]
            
            guard let controoler = segue.destination as? TaskDetailsViewController else {
                fatalError("error")
            }
            
            controoler.title = "Редактирование"
            controoler.task = selectedTask
            controoler.delegate = self
            

        case "CreateTask":
            
            guard let controoler = segue.destination as? TaskDetailsViewController else {
                fatalError("error")
            }
            
            controoler.title = "Новая задача"
            controoler.task = Task(context: taskDAO.context) //передача задачи в целевой контроллер
            controoler.delegate = self
            
        default:
            return
        }
        
    }
    
    //MARK: ActionResultDelegate
    
    func done(source: UIViewController, data: Any?) {
        
        if source is TaskDetailsViewController {
            if let selectedIndexPatch = tableView.indexPathForSelectedRow {
                taskDAO.save()
            } else {
                let task = data as! Task
                createTask(task)
            }
            
            updateTable()
        }
        
    }
    
    //MARK: Function for tasks
    
    func updateTable() {
        
        let sortType = TaskSortType(rawValue: currentScopeIndex)!
        
        if searchController.searchBar.showsScopeBar && searchController.searchBar.text != nil && !(searchController.searchBar.text?.isEmpty)! {
            
            taskDAO.search(text: searchController.searchBar.text, categories: categoryDAO.checkedItem(), priorities: priorityDAO.checkedItem(),  sortType: sortType, showTasksEmptyCategories: PrefsManager.current.showEmptyCategories, showTasksEmptyPriorities: PrefsManager.current.showEmptyPriorities, showTasksWithoutDates: PrefsManager.current.showTasksWithoutDates, showCompletedTasks: PrefsManager.current.showCompletedTasks)
            
        } else {
            
            taskDAO.search(text: nil,categories: categoryDAO.checkedItem(), priorities: priorityDAO.checkedItem(), sortType: sortType, showTasksEmptyCategories: PrefsManager.current.showEmptyCategories, showTasksEmptyPriorities: PrefsManager.current.showEmptyPriorities, showTasksWithoutDates: PrefsManager.current.showTasksWithoutDates, showCompletedTasks: PrefsManager.current.showCompletedTasks)
                        
        }
        
        tableView.reloadData()
        
    }
    
    func deleteTask(_ indexPath: IndexPath) {
        taskDAO.delete(taskDAO.items[indexPath.row])
        
        taskDAO.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
    }
    
    func createTask(_ task: Task) {
        taskDAO.addOrUpdate(task)
        
        let indexPath = IndexPath(row: taskCount-1, section: taskListSection)
        
        tableView.insertRows(at: [indexPath], with: .top)
    }
    
    func completeTask(_ indexPath: IndexPath) {
        
        //принимаем вызов только из TaskList
        guard (tableView.cellForRow(at: indexPath) as? TaskListCell) != nil else {
            fatalError("Cell type.")
        }
        
        //обновляем вид строки
        let task = taskDAO.items[indexPath.row]
        
        task.completed = !task.completed
        
        taskDAO.addOrUpdate(task)
        
        //анимация обновления строки
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            
            if !PrefsManager.current.showCompletedTasks {
                self.taskDAO.items.remove(at: indexPath.row)

                if self.taskDAO.items.isEmpty {
                    self.tableView.deleteSections(IndexSet([self.taskListSection]), with: .top)
                } else {
                    self.tableView.deleteRows(at: [indexPath], with: .top)
                }
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        
    }
    
    //MARK: Actions
      
    @IBAction func updateTasks(segue: UIStoryboardSegue) {
        if let source = segue.source as? FiltersController, source.changed, segue.identifier == "FilterTasks" {
            updateTable()
        }
        if let source = segue.source as? CategoryListController, source.changed, segue.identifier == "UpdateTasksCategories" {
            updateTable()
        }
          
        if let source = segue.source as? PriorityListController, source.changed, segue.identifier == "UpdateTasksPriority" {
            updateTable()
        }
    }
      
    @IBAction func completeFromTaskDetails(segue: UIStoryboardSegue) {
        if let selectedIndexPatch = tableView.indexPathForSelectedRow {
            completeTask(selectedIndexPatch)
        }
    }
      
    @IBAction func delegateFromTaskDetails(segue: UIStoryboardSegue) {
          
        guard segue.source is TaskDetailsViewController else {
            fatalError("Return from unknown source.")
        }
          
        if segue.identifier == "DeleteTaskFromDetail", let selectedIndexPath = tableView.indexPathForSelectedRow {
              
            deleteTask(selectedIndexPath)
              
        }
    }
      
    @IBAction func tapCompleteTask(_ sender: UIButton) {
        let viewPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = self.tableView.indexPathForRow(at: viewPosition)!
        completeTask(indexPath)
    }
    
    @IBAction func textBeginEditing(_ sender: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
      
    @IBAction func quickTaskAdd(_ sender: UITextField) {
          
        navigationItem.rightBarButtonItem?.isEnabled = true

        var task = Task(context:taskDAO.context)

        if let name = textQuickTask.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            task.name = name
        } else {
            task.name = "Новая задача"
        }
          
        createTask(task)
          
        updateTable()
          
        textQuickTask.text = ""
          
    }
}

// MARK: Search Bar Setup
extension TaskListViewController: UISearchBarDelegate {
    
    func setupSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = "Поиск по названию"
        searchController.searchBar.backgroundColor = .white
        
        searchController.searchBar.scopeButtonTitles = ["А-Я", "Приоритет", "Дата"]
        
        searchController.searchBar.selectedScopeButtonIndex = currentScopeIndex
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.showsScopeBar = false
        
        //add search bar
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsScopeBar = true
        //searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         updateTable()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchController.searchBar.showsScopeBar{
            searchController.searchBar.showsScopeBar = false
        }
        
        //searchBarActive = false
        searchController.searchBar.text = ""
        
        updateTable()
    }
    
    //change sort type
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if currentScopeIndex == selectedScope {
            return
        }
         
        currentScopeIndex = selectedScope
        PrefsManager.current.sortType = currentScopeIndex

        updateTable()
        
    }
    
    //MARK: Side Menu
    func initSideMenu() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
            
    }
    
}
