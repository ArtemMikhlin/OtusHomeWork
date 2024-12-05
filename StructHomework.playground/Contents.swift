import CoreGraphics

struct ScreenSize {
    var width: CGFloat
    var height: CGFloat
}

struct Model {
    var model: String
}

enum AppleDevice: CustomStringConvertible {
    case iPhone(screenSize: ScreenSize, model: Model)
    case iPad(screenSize: ScreenSize)
    
    var isIPad: Bool {
        switch self {
        case .iPad:
            return true
        case .iPhone:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .iPhone( let size, let model):
            return "iPhone: \(model.model), Screen size: \(size.width)x\(size.height) pixels"
        case .iPad(let size):
            return "iPad: \(size.width)x\(size.height) pixels)"
        }
    }
}

let iPhone14 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1170, height: 2532), model: Model(model:"14"))
let iPhone15 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1179, height: 2556), model: Model(model:"15"))
let iPhone13 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1170, height: 2532), model: Model(model:"13"))
let iPhone12 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1170, height: 2532), model: Model(model:"12"))
let iPhone16 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1170, height: 2532), model: Model(model:"16"))
let iPhone11 = AppleDevice.iPhone(screenSize: ScreenSize(width: 828, height: 1792), model: Model(model:"11"))
let iPhone10 = AppleDevice.iPhone(screenSize: ScreenSize(width: 1125, height: 2436), model: Model(model:"X"))
let iPadPro = AppleDevice.iPad(screenSize: ScreenSize(width: 2048, height: 2732))

