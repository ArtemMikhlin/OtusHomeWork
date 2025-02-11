import UIKit

class ViewController: UIViewController {

    let label1 = UILabel()
    let label2 = UILabel()
    let imageView = UIImageView()
    
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        label1.text = "Name"
        label1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)

        label2.text = "last name"
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)

        imageView.image = UIImage(named: "Image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        setupConstraints()
    }

    func setupConstraints() {
        portraitConstraints = [
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.bounds.height / 10),
            label1.trailingAnchor.constraint(equalTo: label2.leadingAnchor, constant: -20),
            label1.widthAnchor.constraint(equalTo: label2.widthAnchor, multiplier: 1, constant: 0),
            label1.heightAnchor.constraint(equalToConstant: 50),
            
            label2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.bounds.height / 10),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label2.heightAnchor.constraint(equalTo: label1.heightAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label1.topAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        landscapeConstraints = [
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label1.trailingAnchor.constraint(equalTo: label2.leadingAnchor, constant: -20),
            label1.heightAnchor.constraint(equalToConstant: 50),

            label2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label2.heightAnchor.constraint(equalTo: label1.heightAnchor),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label1.topAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(portraitConstraints)

        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func orientationChanged() {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }

        view.layoutIfNeeded()
    }
}
