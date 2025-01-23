import UIKit


func sum(first_num: Int, second_num: Int) -> Int{
    return first_num + second_num
}

func toString(person: (age: Int, name: String)) -> (age: String, name: String){
    return (String(person.age), person.name)
}


func completeClosure(completion: (() -> Void)?, num: Int) {
        if (num > 0){
            completion?()
        }
    }
    
func checkLeapYear(year: Int) -> Bool {
    if year % 4 == 0 {
        if year % 100 == 0 {
            return year % 400 == 0
        }
        return true
    }
    return false
}

