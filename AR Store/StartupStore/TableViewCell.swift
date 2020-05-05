
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var stepperQuantity: GMStepper!
    @IBOutlet weak var labelSubtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepperQuantity.labelFont =
            UIFont.boldSystemFont(ofSize: 18)
    }

    override func setSelected(_ selected: Bool,
                              animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
