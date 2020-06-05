
import UIKit

class PriorityListCell: UITableViewCell {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var checkButtonPriority: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
