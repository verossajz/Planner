
import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet weak var labelTaskName: UILabel!
    @IBOutlet weak var labelTaskCategory: UILabel!
    @IBOutlet weak var labelTaskDeadline: UILabel!
    @IBOutlet weak var labelTaskPriority: UILabel!
    @IBOutlet weak var buttonInfo: UIButton!
    @IBOutlet weak var buttonComlete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
