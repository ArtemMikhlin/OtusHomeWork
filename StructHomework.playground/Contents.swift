import UIKit

struct User {
    var name: String
    let age: Int
    let email: String
    
    func data() -> String {
        return "Name: \(name), Age: \(age), Email: \(email)"
    }
}

func print_data_to_console(user:User){
    print(user.data())
}

var users: [User] = [
    User(name: "Artem", age: 30, email: "Artem@example.com"),
    User(name: "Dima", age: 25, email: "Dima@example.com"),
    User(name: "Ivan", age: 40, email: "Ivan@example.com")
]

print_data_to_console(user: users[1])

users[1].name = "Anton"

for user in users {
    print_data_to_console(user: user)
}

