
import Foundation

protocol TaskDAO: CRUD {
    
    func search(text: String, sortType: SortType?) -> [Item]
    
}
