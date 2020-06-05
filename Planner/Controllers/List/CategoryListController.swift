import UIKit

class CategoryListController: DictionaryController<CategoryDaoImpl> {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var tapSelectDeselect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.selectDeselectButton = tapSelectDeselect
        super.dictTableView = tableView
        
        DAO = CategoryDaoImpl.current
        initNavBar()
    }
    
    //MARK: Table View

    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? CategoryListCell else {
            fatalError("Fatal error with cell.")
        }
           
        let category = DAO.items[indexPath.row]
        cell.labelCategoryName.text = category.name
        cell.selectionStyle = .none
           
        cell.labelCategoryName.textColor = UIColor.darkGray
        labelHeaderTitle.textColor = UIColor.lightGray
           
        if showMode == .edit {
            selectDeselectButton.isHidden = false
               
            labelHeaderTitle.lineBreakMode = .byWordWrapping
            labelHeaderTitle.numberOfLines = 0
               
            labelHeaderTitle.text = "Вы можете фильтровать задачи с помощью выбора категорий."
               
            if category.checked {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_green"), for: .normal)
            } else {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
            }
               
            tableView.allowsMultipleSelection = true
               
            if indexPath.row == count - 1 {
                updateSelectDeselectButton()
            }
        } else if showMode == .select {
               
            tableView.allowsMultipleSelection = false
               
            selectDeselectButton.isHidden = true
            labelHeaderTitle.text = "Выберите одну категорию для задачи."
               
            if selectedItem != nil && selectedItem == category {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_green"), for: .normal)
                currentCheckedIndexPath = indexPath
            } else {
                cell.buttonCheckCategory.setImage(UIImage(named: "check_gray"), for: .normal)
            }

        }
           
        return cell
    }
    
    override func getAll() -> [Category] {
        return DAO.getAll(sortType: CategorySortType.name)
    }
    
    override func search(_ searchText: String) -> [Category] {
        return DAO.search(text: searchText, sortType: CategorySortType.name)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showMode == .edit {
            editCategory(indexPath: indexPath)
            return
        }
        
        if showMode == .select {
            checkItem(indexPath)
            return
        }
    }
    
    override func addItemAction() {
        showDialog(title: "Новая категория", message: "Введите название") { name in
            
            let cat = Category(context: self.DAO.context)
            
            if self.isEmptyTrim(name) {
                cat.name = "Новая категория"
            } else {
                cat.name = name
            }
            
            self.addItem(cat)
            
        }
    }
    
    func editCategory(indexPath: IndexPath) {
                        
            let currentItem = self.DAO.items[indexPath.row]
            let oldValue = currentItem.name
            
        showDialog(title: "Редактирование", message: "Введите название", initValue: currentItem.name!) { name in
                if !self.isEmptyTrim(name) {
                    currentItem.name = name
                } else {
                    currentItem.name = "Новая категория"
                }
                
                if currentItem.name != oldValue {
                    self.updateItem(currentItem)
                    self.changed = true
                } else {
                    self.changed = false
                }
            }
    }
    
    //MARK: IBAction
    
    @IBAction func tapSelectDeselectButton(_ sender: UIButton) {
        super.selectDeselectItems()
    }
    
    @IBAction func tapCheckCategory(_ sender: UIButton) {
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
}
