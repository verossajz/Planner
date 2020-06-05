
import Foundation
import CoreData
import UIKit

class CategoryDaoImpl: DictDAO, TaskDAO {
    
    typealias SortType = CategorySortType
    typealias Item = Category
    
    public var items: [Item]!
    
    //Singleton
    static let current = CategoryDaoImpl()
    private init() {
        getAll(sortType: CategorySortType.name)
    }
    
    //MARK: DAO
    
    func getAll(sortType: SortType?) -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        if let sortType = sortType {
            fetchRequest.sortDescriptors = [sortType.getDesriptor(sortType)]
        }
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetching faield")
        }
        
        return items
    }
    
    func delete(_ item: Item) {
        context.delete(item)
        save()
    }
    
    func addOrUpdate(_ item: Item) {
        if !items.contains(item) {
            items.append(item)
        }
        save()
    }
    
    func search(text: String, sortType: SortType?) -> [Item] {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        var predicate = NSPredicate(format: "name CONTAINS[c] %@", text)

        fetchRequest.predicate = predicate

        if let sortType = sortType {
            fetchRequest.sortDescriptors = [sortType.getDesriptor(sortType)]
        }
        
        do {
            items = try context.fetch(fetchRequest)
        } catch {
            fatalError("Fetching Failed")
        }

        return items


    }
}

enum CategorySortType: Int {
    case name = 0
  
    func getDesriptor(_ sortType: CategorySortType) -> NSSortDescriptor {
        switch sortType {
        case .name:
            return NSSortDescriptor(key: #keyPath(Category.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        }
    }
}
