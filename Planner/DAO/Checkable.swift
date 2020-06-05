
import Foundation

protocol Checkable: class {
    var checked: Bool {get set}
}

extension Priority: Checkable {
    
}

extension Category: Checkable {
    
}
