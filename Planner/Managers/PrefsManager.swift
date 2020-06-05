
import Foundation

//default settings
class PrefsManager {
    
    //singlton
    static let current = PrefsManager()
    
    let keyShowEmptyCategories = "showEmptyCategories"
    let keyShowEmptyPriorities = "showEmptyPriorities"
    let keyShowTasksWithoutDates = "showTasksWithoutDates"
    let keyShowCompletedTasks = "showCompletedTasks"
    let keySortType = "sortTypeValue"
    
    
    private init() {
        UserDefaults.standard.register(defaults: [keyShowEmptyCategories : true])
        UserDefaults.standard.register(defaults: [keyShowEmptyPriorities : true])
        UserDefaults.standard.register(defaults: [keyShowTasksWithoutDates : true])
        UserDefaults.standard.register(defaults: [keyShowCompletedTasks : false])
        UserDefaults.standard.register(defaults: [keySortType : 0])
        
    }
    
    //MARK: FilterSetting
    
    var showEmptyCategories: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyShowEmptyCategories)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyShowEmptyCategories)
        }
    }
    
    var showEmptyPriorities: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyShowEmptyPriorities)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyShowEmptyPriorities)
        }
    }
    
    var showTasksWithoutDates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyShowTasksWithoutDates)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyShowTasksWithoutDates)
        }
    }
    
    var showCompletedTasks: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyShowCompletedTasks)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyShowCompletedTasks)
        }
    }
    
    var sortType: Int {
        get {
            return UserDefaults.standard.integer(forKey: keySortType)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keySortType)
        }
    }
    
    
}
