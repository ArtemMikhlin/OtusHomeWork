import UIKit

class UserTableViewCell: UITableViewCell {
   
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var positionLabel: UILabel!
   
   func configure(with user: User) {
       nameLabel.text = user.fullName
       positionLabel.text = user.position
   }
}
