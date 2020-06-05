import Foundation
import CoreData

//API для работы с сущностями (общии операции для всех объетов)
protocol CRUD {
    
    //generic
    associatedtype Item: NSManagedObject
    associatedtype SortType
    
    var items: [Item]! {get set}
    
    func addOrUpdate(_ item: Item)
    
    func getAll(sortType: SortType?) -> [Item]
    
    func delete(_ item: Item) 
    
}
