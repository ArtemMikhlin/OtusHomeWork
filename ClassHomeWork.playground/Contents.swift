import UIKit

//Task1
class Calculate {
    var num1: Int = 0
    var num2: Int = 0
    
    init(num1 : Int, num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
    
    func sum() -> Int {
        num1 + num2
    }
    
    func difference() -> Int {
        num1 - num2
    }
    
    func product() -> Int {
        num1 * num2
    }
    
    func quotient() -> Any {
        if num2 != 0{return num1 / num2}
        else {return("Fatal error: Division by zero")}
    }

}

//Task2
class Figure {
    var description: String {
        return "It's figure"
    }
    
    var numberOfAngles: Int {
        return 0
    }
    
    func draw() {
        print("Draw")
    }
}

class Triangle: Figure {
    override var description: String {
        return "It's triangle"
    }
    
    override var numberOfAngles: Int {
        return 3
    }
    
    override func draw() {
        print("Draw triangle.")
    }
}

class Square: Figure {
    override var description: String {
        return "It's square"
    }
    
    override var numberOfAngles: Int {
        return 4
    }
    
    override func draw() {
        print("Draw square.")
    }
}

class Circle: Figure {
    override var description: String {
        return "It's circle"
    }
    
    override var numberOfAngles: Int {
        return 0
    }
    
    override func draw() {
        print("Draw circle.")
    }
}


