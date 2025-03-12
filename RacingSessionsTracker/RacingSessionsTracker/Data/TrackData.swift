import Foundation

struct TrackData: Hashable {
    let name: String
    let latitude: Double
    let longitude: Double
    let imageURL: String
}

extension TrackData {
    static let districts: [TrackData] = [
        TrackData(name: "Mayak 1.0", latitude: 56.1008, longitude: 37.3054, imageURL: "https://kudamoscow.ru/uploads/46953de5d570138e2179cf7deefbee31.jpg"),
        TrackData(name: "ЦТВС", latitude: 55.3914, longitude: 37.4034, imageURL: "https://avatars.mds.yandex.net/get-altay/2356223/2a0000017328e3fc4533f2b5308ff71ae238/L_height"),
        TrackData(name: "ADM", latitude: 55.5647, longitude: 37.9896, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDwmkv6e9SEjZ8ccm7Sx4RDsjtO7Nuah1Cdg&s"),
        TrackData(name: "Ижорец", latitude: 59.7594, longitude: 30.6062, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoUQO6gWvSeAxdclDL-wIDjI4VNGksYOLh7A&s"),
        TrackData(name: "Сириус", latitude: 43.4009, longitude: 39.9524, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQB4yXPRr1G7onxUXrsuxCSmFCWuyeAZnnHgQ&s"),
        TrackData(name: "Max Motors Sochi", latitude: 43.6668, longitude: 39.7605, imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgmTI_QLF2cYBHgsJxzjV9tbmTdSPM9n8Q3g&s"),
    ]
}
