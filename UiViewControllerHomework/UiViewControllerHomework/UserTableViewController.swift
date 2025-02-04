import UIKit

class UserTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        users = [
            User(id: 1, fullName: "John Doe", firstName: "John",address: "Moscow", position: "developer" ),
            User(id: 2, fullName: "Jane Smith", firstName: "Jane", address: "Dubai", position: "developer"),
            User(id: 3, fullName: "Michael Johnson",  firstName: "Michael", address: "Andora", position: "qa"),
            User(id: 4, fullName: "Emily Davis", firstName: "Emily", address: "Moscow", position: "data analist")
        ]
    }
}

extension UserTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destination = segue.destination as? ViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destination.user = users[indexPath.row]
        }
    }
}
