import UIKit

func revMinAndMaxNum(numbers:  [Int]) -> [Int] {
    guard let minIndex = numbers.firstIndex(of: numbers.min()!) else { return numbers}
    guard let maxIndex = numbers.firstIndex(of: numbers.max()!) else { return numbers}
    var numbers = numbers
    numbers.swapAt(minIndex, maxIndex)
    return numbers
}
