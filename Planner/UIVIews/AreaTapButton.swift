
import UIKit

class AreaTapButton: UIButton {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 10
        
        let area = bounds.insetBy(dx: -margin, dy: -margin)
        
        return area.contains(point) //
    }

}
