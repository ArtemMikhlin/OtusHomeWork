import UIKit

func revMinAndMaxNum(numbers:  [Int]) -> [Int] {
    guard let minIndex = numbers.firstIndex(of: numbers.min()!) else { return numbers}
    guard let maxIndex = numbers.firstIndex(of: numbers.max()!) else { return numbers}
    var numbers = numbers
    numbers.swapAt(minIndex, maxIndex)
    return numbers
}

func repeatingSymbols(firstArray:  Set<String>, secondArray:  Set<String>) -> Set<String> {
    let intersectionArray = firstArray.intersection(secondArray)
    return intersectionArray
}

func longPasswords(credential: [String: String]) ->  [String: String] {
    var longPasswordsDict: [String: String] = [:]
    for (key, value) in credential{
        if value.count > 10{
            longPasswordsDict[key] = value
        }
    }
    return longPasswordsDict
}
