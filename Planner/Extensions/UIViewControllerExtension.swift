
import Foundation
import UIKit

extension UIViewController {
   
    func createDateFormatter() -> DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
        
    }
    
    func closeController() {
        
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        } else if let controller = navigationController {
            controller.popViewController(animated: true)
        } else {
            fatalError("Can't close controller.")
        }
    }
    
    func handleDaysOff(_ diff: Int?, label: UILabel) {
        
        label.textColor = .lightGray
        
        var text: String = ""
        
        if let diff = diff {
            
            switch diff {
            case 0:
                text = "Сегодня"
            case 1:
                text = "Завтра"
            case 1...:
                text = "\(diff) дн."
            case ..<0:
                text = "\(diff) дн."
                label.textColor = .red
            default:
                text = ""
            }
        }
        
        label.text = text
    }
    
    
    func confirmAction(text: String, actionClosure: @escaping () -> Void) {
        
        let dialogMessage = UIAlertController(title: "Подтверждение", message: text, preferredStyle: .actionSheet)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            actionClosure()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func createSaveCancelButtons(save: Selector, cancel: Selector = #selector(cancelExt)) {
        
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: cancel)
        navigationItem.leftBarButtonItem = buttonCancel
        
        let buttonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: save)
        navigationItem.rightBarButtonItem = buttonSave
        
    }
    
    func createAddCloseButton(add: Selector, close: Selector = #selector(cancelExt)) {
        
        let buttonClose = UIBarButtonItem()
        buttonClose.target = self
        buttonClose.action = close
        buttonClose.title = "Закрыть"
        navigationItem.leftBarButtonItem = buttonClose
        
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: add)
        navigationItem.rightBarButtonItem = buttonAdd
        
    }
    
    @objc func cancelExt() {
        closeController()
    }
    
    func isEmptyTrim(_ str: String?) -> Bool {
        if let value = str?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func showDialog(title: String, message: String, initValue: String = "", actionClosure: @escaping (String) -> Void) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?[0].clearButtonMode = .whileEditing
            alert.textFields?[0].text = initValue
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                actionClosure(alert.textFields?[0].text ?? "")
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
