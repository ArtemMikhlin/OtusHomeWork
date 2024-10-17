import UIKit
import Foundation

func findFirstDuplicateIndexInRandomArray(size: Int, min: Int, max: Int) -> Int{
    var randomArray: [Int] = []
    for _ in 0..<size {
        let randomNumber = Int.random(in: min...max)
        randomArray.append(randomNumber)
    }
    return findFirstDuplicateIndex(array: randomArray)
}
   

func findFirstDuplicateIndex(array: [Int]) -> Int {
    var seenNumbers: [Int: Int] = [:]
    for (index, number) in array.enumerated() {
        if let existingIndex = seenNumbers[number] {
            return existingIndex
        } else {
            seenNumbers[number] = index
        }
    }
    return -1
}





