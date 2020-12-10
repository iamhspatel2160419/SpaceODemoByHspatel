import UIKit

class EmptyStateGenericScreen: UIView {

    @IBOutlet weak var emptyStateDesignDescLabel: UILabel!
    @IBOutlet weak var emptyStateDesignTitleLabel: UILabel!
    @IBOutlet weak var emptyStateDesignImageView: UIImageView!
    override init(frame: CGRect) {
            super.init(frame: frame)
            
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
        }

}
