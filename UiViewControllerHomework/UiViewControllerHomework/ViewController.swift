//
//  ViewController.swift
//  UiViewControllerHomework
//
//  Created by Artem Mikhlin on 25.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    
    var user: User?
    var isFullNameDisplayed: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "defaultProfileImage")
        toggleButton.setTitle("Show only name", for: .normal)
        
        if let user = user {
            nameLabel.text = user.fullName
            positionLabel.text = user.position
            addressLabel.text = user.address
        }
    }
    
    @IBAction func сopyAddress(_ sender: Any) {
        guard let user = user else {
              return
          }
        UIPasteboard.general.string = user.address

        let alert = UIAlertController(title: "Copied", message: "Address is copied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        guard let user = user else {
            return
        }
        isFullNameDisplayed.toggle()
        nameLabel.text = isFullNameDisplayed ? user.fullName : user.firstName
        toggleButton.setTitle(isFullNameDisplayed ? "Show name" : "Show full name", for: .normal)
    }
}

