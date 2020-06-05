
import Foundation

//task seatch filter
protocol TaskSearchDAO: CRUD {
    
    associatedtype CategoryItem: Category
    associatedtype PrioritiesItem: Priority
    
    func search(text: String?, categories: [CategoryItem], priorities: [PrioritiesItem], sortType: SortType?, showTasksEmptyCategories: Bool, showTasksEmptyPriorities: Bool, showTasksWithoutDates: Bool, showCompletedTasks: Bool) -> [Item]
    
}
