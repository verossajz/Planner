
import UIKit

class SideMenuCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //фон для ячейки при нажатии
    @IBInspectable var selectionColor: UIColor = .gray {
        didSet {
            setBackground()
        }
    }
    
    private func setBackground() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
        
    }

}
