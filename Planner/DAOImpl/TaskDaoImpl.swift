
import Foundation
import CoreData
import UIKit

class TaskDaoImpl: TaskSearchDAO {
    
    typealias SortType = TaskSortType
    typealias Item = Task
    
    let categoryDAO = CategoryDaoImpl.current
    let priorityDAO = PriorityDaoImpl.current
    
    //Singleton
    static var current = TaskDaoImpl()
    public init() {}
    
    var items: [Item]!
    
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
    
    func search(text: String?, categories: [Category], priorities: [Priority], sortType: SortType?, showTasksEmptyCategories: Bool, showTasksEmptyPriorities: Bool, showTasksWithoutDates: Bool, showCompletedTasks: Bool) -> [Item] {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        var predicates = [NSPredicate]()
        
        if !showTasksEmptyCategories {
            predicates.append(NSPredicate(format: "(category IN %@ and category!=nil)", categories))
        } else {
            predicates.append(NSPredicate(format: "(category IN %@ or category=nil)", categories))
        }
        
        if !showTasksEmptyCategories{
            predicates.append(NSPredicate(format: "(priority IN %@ and priority!=nil)", priorities))
        }else{
            predicates.append(NSPredicate(format: "(priority IN %@ or priority=nil)", priorities))
        }
        
        if !showTasksEmptyPriorities {
            predicates.append(NSPredicate(format: "priority != nil"))
        }
        

        if !showTasksWithoutDates {
            predicates.append(NSPredicate(format: "deadline != nil"))
        }
        
        if !showCompletedTasks {
            predicates.append(NSPredicate(format: "completed != true"))
        }
        
        let allPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        
        fetchRequest.predicate = allPredicates
        
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

enum TaskSortType: Int {
    case name = 0
    case priority
    case deadline
    
    func getDesriptor(_ sortType: TaskSortType) -> NSSortDescriptor {
        switch sortType {
        case .name:
            return NSSortDescriptor(key: #keyPath(Task.name), ascending: true,  selector: #selector(NSString.caseInsensitiveCompare))
        case .deadline:
            return NSSortDescriptor(key: #keyPath(Task.deadline), ascending: true)
        case .priority:
            return NSSortDescriptor(key: #keyPath(Task.priority.index), ascending: false)

        }
    } 
}
