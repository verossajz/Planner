
import Foundation
import CoreData
import UIKit

class PriorityDaoImpl: DictDAO, TaskDAO {
    
    typealias SortType = PrioritySortType
    typealias Item = Priority
    
    var items: [Priority]!
    
    // Singleton
    static var current = PriorityDaoImpl()
    private init() {
        getAll(sortType: PrioritySortType.index)
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

enum PrioritySortType: Int {
    case index = 0
    
    func getDesriptor(_ sortType: PrioritySortType) -> NSSortDescriptor {
        switch sortType {
        case .index:
            return NSSortDescriptor(key: #keyPath(Priority.index), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        }
    }
}
