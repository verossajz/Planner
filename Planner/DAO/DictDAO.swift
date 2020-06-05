
import Foundation

protocol DictDAO: CRUD where Item: Checkable {
    func checkedItem() -> [Item]
}

extension DictDAO {
    
    func checkedItem() -> [Item] {
        return items.filter(){$0.checked == true}
    }
    
}
