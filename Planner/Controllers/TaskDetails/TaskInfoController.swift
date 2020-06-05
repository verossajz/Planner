
import UIKit

class TaskInfoController: UIViewController {

    @IBOutlet weak var textViewTaskInfo: UITextView!
    
    var taskInfo: String!
    var selectedDelegate: ActionResultDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Дополнительная информация"
        
        textViewTaskInfo.becomeFirstResponder()
        textViewTaskInfo.text = taskInfo
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: IBAction
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        closeController()
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        closeController()
        selectedDelegate.done(source: self, data: textViewTaskInfo.text) //уведомить делегат и передать изменения
    }

}
