
import UIKit

class TaskDeadlineCell: UITableViewCell {

    
    @IBOutlet weak var buttonDatetimePicker: UIButton!
    @IBOutlet weak var buttonTaskDeadline: AreaTapButton!
    @IBOutlet weak var labelDayDiff: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
