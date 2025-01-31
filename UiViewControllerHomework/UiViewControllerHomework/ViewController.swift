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
    
    var fullName: String = "Ivan Kozlov"
    var firstName: String = "Ivan"
    var isFullNameDisplayed: Bool = true
    var address: String = "Moscow"
    var position: String = "Developer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "defaultProfileImage")
        nameLabel.text = fullName
        toggleButton.setTitle("Show only name", for: .normal)
        positionLabel.text = position
        addressLabel.text = address
    }
    @IBAction func CopyAddress(_ sender: Any) {
        UIPasteboard.general.string = address
        let alert = UIAlertController(title: "Скопировано", message: "Адрес скопирован в буфер обмена.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        isFullNameDisplayed.toggle()
        nameLabel.text = isFullNameDisplayed ? fullName : firstName
        toggleButton.setTitle(isFullNameDisplayed ? "Show name" : "Show full name", for: .normal)
    }
}

