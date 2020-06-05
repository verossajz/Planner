import UIKit

class DictionaryController<T:DictDAO>: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    //MARK: Property
    
    var selectDeselectButton: UIButton!
        
    var dictTableView: UITableView!
    var DAO: T! //data base
    var currentCheckedIndexPath: IndexPath! 
    var selectedItem: T.Item!
    var selectedDelegate: ActionResultDelegate!
    var searchController: UISearchController!
    var searchBarText: String!
    var navigationTitle: String!
    var showMode: ShowMode!
    var changed: Bool = false
    var sectionList = 0
    
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    
    var count: Int {
        return DAO.items.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        searchBar.searchBarStyle = .prominent
        
    }
    
    func initNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if showMode == .select {
            createSaveCancelButtons(save: #selector(tapSave), cancel: #selector(tapCancel))
        } else if showMode == .edit {
            createAddCloseButton(add: #selector(tapAdd), close: #selector(tapClose))
        }
        
        self.title = navigationTitle
    }
    
    @objc func tapSave() {
        save()
    }
    
    @objc func tapCancel() {
        cancel()
    }
    
    @objc func tapClose() {
        switch self {
        case is CategoryListController:
            performSegue(withIdentifier: "UpdateTasksCategories", sender: self)
        case is PriorityListController:
            performSegue(withIdentifier: "UpdateTasksPriorities", sender: self)
        default:
            return
        }
        
        
    }
    
    @objc func tapAdd() {
        addItemAction()
    }
    
//    @IBAction func tapSelectDeselectButton(_ sender: UIButton) {
//        if DAO.checkedItem().count > 0 {
//            DAO.items.map(){$0.checked = false}
//        } else {
//            DAO.items.map(){$0.checked = true}
//        }
//        
//        dictTableView.reloadSections([sectionList], with: .none)
//        
//        updateSelectDeselectButton()
//        
//        changed = true
//    }
    
    
    func selectDeselectItems() {
        if DAO.checkedItem().count > 0 {
            DAO.items.map(){$0.checked = false}
        } else {
            DAO.items.map(){$0.checked = true}
        }
               
        dictTableView.reloadSections([sectionList], with: .none)
               
        updateSelectDeselectButton()
               
        changed = true
    }
    
    func updateItem(_ item: T.Item) {
        if let selectedIndexPath = dictTableView.indexPathForSelectedRow {
            DAO.addOrUpdate(item)
            dictTableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
        
    }
    
    
    
    //MARK: tableView
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(indexPath)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.items.count
    }

    //MARK: selectedRows
    func checkItem(_ indexPath: IndexPath) {
        
        //определеяем индекс строки по нажатому компоненту
        
        let item = DAO.items[indexPath.row]
        //если выделенная строка не была выбрана до этого (была без галочки)
        
        switch showMode {
        case .select:
            
            if indexPath != currentCheckedIndexPath {
                selectedItem = item
                
                if let currentCheckedIndexPath = currentCheckedIndexPath {
                    dictTableView.reloadRows(at: [currentCheckedIndexPath], with: .none)
                }
                
                currentCheckedIndexPath = indexPath
                
            } else {
                selectedItem = nil
                currentCheckedIndexPath = nil
            }
            
            searchController.isActive = false
            
        case .edit:
            
            item.checked = !item.checked
            updateItem(item)
            changed = true
            
        default:
            fatalError("error enum type")
        }
        
        updateSelectDeselectButton()
        
        dictTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateSelectDeselectButton() {
        if showMode == .select {
            return
        }
        
        let newTitle: String
        
        if DAO.checkedItem().count > 0 {
            newTitle = "Снять"
        } else {
            newTitle = "Все"
        }
        
        if self.selectDeselectButton.title(for: .normal) != newTitle {
            selectDeselectButton.setTitle(newTitle, for: .normal)
        }
        
        var enabled: Bool
        
        if count > 1 {
            enabled = true
        } else {
            enabled = false
        }
        
        selectDeselectButton.isEnabled = enabled
        
        if !enabled {
            return
        }
        
    }
    
    //MARK: DAO
    func cancel() {
        closeController()
    }
    func save() {
        closeController()
        //уведомить делегата и передать выбранное значение
        selectedDelegate?.done(source: self, data: selectedItem)
    }
    
    func deleteItem(_ indexPath: IndexPath) {
        
        DAO.delete(DAO.items[indexPath.row])
        DAO.items.remove(at: indexPath.row)
        
        if count == 0 {
            dictTableView.deleteSections([sectionList], with: .left)
        } else {
            dictTableView.deleteRows(at: [indexPath], with: .left)
        }
        
        changed = true
    }
    
    func getAll() -> [T.Item] {
        fatalError("not implemented")
    }
    
    func search(_ searchText: String) -> [T.Item] {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("not implemented")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         fatalError("not implemented")
     }
    
    func addItemAction() {
        fatalError("not implemented")
    }
    
    //MARK: SearchControllerSetup
    
    func setupSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = "Начните набирать название"
        searchController.searchBar.backgroundColor = .white
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.showsScopeBar = false
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        
        searchController.searchBar.searchBarStyle = .minimal
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            dictTableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = searchBarText
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.placeholder = "Начните набирать название"
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = ""
        getAll()
        dictTableView.reloadData()
        searchBar.placeholder = "Начните набирать назване"
    }
     
    func updateSearchResults(for searchController: UISearchController) {
        
        if !(searchBar.text?.isEmpty)! {
            searchBarText = searchBar.text!
            search(searchBarText)
            dictTableView.reloadData()
            currentCheckedIndexPath = nil
            searchBar.placeholder = searchBarText
        }
    }
    
    func addItem(_ item: T.Item) {
        
        DAO.addOrUpdate(item)
        
        if count == 1 {
            dictTableView.insertSections([sectionList], with: .top)
        } else {
            let indexPath = IndexPath(row: count - 1, section: sectionList)
            dictTableView.insertRows(at: [indexPath], with: .top)
        }
        
    }
    
    enum ShowMode {
        case edit
        case select
    }
}
