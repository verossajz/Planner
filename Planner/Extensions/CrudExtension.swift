
import Foundation
import CoreData
import UIKit

extension CRUD {
    
    //context for data base
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    //save all context changes
    func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
 
