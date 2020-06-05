
import UIKit

class PriorityListController: DictionaryController<PriorityDaoImpl> {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonSelectedDeselected: UIButton!
    
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    
    let priorityDAO = PriorityDaoImpl.current
    var selectedPriority: Priority!
    var delegate: ActionResultDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.selectDeselectButton = buttonSelectedDeselected
        super.dictTableView = tableView
        
        DAO = PriorityDaoImpl.current
        
        initNavBar()
        
    }
    
    //MARK: Table View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellPriority", for: indexPath) as? PriorityListCell else {
            fatalError("fatal error with cell")
        }
        
        cell.selectionStyle = .none

        let priority = priorityDAO.items[indexPath.row] //получает каждую категорию по индексу из массива, чтобы отобразить название
        
        cell.priorityLabel.text = priority.name
        cell.selectionStyle = .none
        
        cell.priorityLabel.textColor = UIColor.darkGray
        labelHeaderTitle.textColor = UIColor.lightGray
        
        if showMode == .edit {
            
            buttonSelectedDeselected.isHidden = false
            
            labelHeaderTitle.lineBreakMode = .byWordWrapping
            labelHeaderTitle.numberOfLines = 0
            
            labelHeaderTitle.text = "Вы можете фильтровать задачи с помощью выбора галочки."
            
            if priority.checked {
                cell.checkButtonPriority.setImage(UIImage(named: "check_green"), for: .normal)
            } else {
                cell.checkButtonPriority.setImage(UIImage(named: "check_gray"), for: .normal)
            }
            tableView.allowsMultipleSelection = true
            
            if indexPath.row == count - 1{
                updateSelectDeselectButton()
            }
            
        } else if showMode == .select {
            
            tableView.allowsMultipleSelection = false
            
            buttonSelectedDeselected.isHidden = true
            
            labelHeaderTitle.text = "Выберите приоритет для задачи."
            
            if selectedItem != nil && selectedItem == priority {
                
                cell.checkButtonPriority.setImage(UIImage(named: "check_green"), for: .normal)
                
                currentCheckedIndexPath = indexPath
            } else {
                
                cell.checkButtonPriority.setImage(UIImage(named: "check_gray"), for: .normal)
                
            }
            
            
        }
        
        return cell
    }
    
    //MARK: IBActions
    
    @IBAction func tapSelectDeselect(_ sender: UIButton) {
        super.selectDeselectItems()
    }
    
    @IBAction func tapCheckPriority(_ sender: UIButton) {
        let viewPosition = sender.convert(CGPoint.zero, to: dictTableView)
        let indexPath = dictTableView.indexPathForRow(at: viewPosition)!

        checkItem(indexPath)
    }
       
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        cancel()
    }
       
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        save()
    }
    
    override func getAll() -> [Priority] {
        return DAO.getAll(sortType: PrioritySortType.index)
    }
    
    override func search(_ searchText: String) -> [Priority] {
        return DAO.search(text: searchText, sortType: PrioritySortType.index)
    }
}
