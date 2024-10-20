import UIKit

class Calculate {
    var num1: Int = 0
    var num2: Int = 0
    
    init(num1 : Int, num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
    
    func sum() -> Int{
        num1 + num2
    }
    
    func difference() -> Int{
        num1 - num2
    }
    
    func product() -> Int{
        num1 * num2
    }
    
    func quotient() -> Any{
        if num2 != 0{return num1 / num2}
        else {return("Fatal error: Division by zero")}
    }

}


