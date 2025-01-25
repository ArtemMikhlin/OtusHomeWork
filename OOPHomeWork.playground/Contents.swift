import UIKit
import Foundation

class RacingSession {
    struct SessionInfo {
        let trackName: String
        let bestLapTime: TimeInterval
        let sessionTime: TimeInterval
        let weather: String
    }
    
    var trackName: String
    var bestLapTime: TimeInterval
    var sessionTime: TimeInterval
    var weather: String
    
    init(trackName: String, bestLapTime: TimeInterval, sessionTime: TimeInterval, weather: String) {
        self.trackName = trackName
        self.bestLapTime = bestLapTime
        self.sessionTime = sessionTime
        self.weather = weather
    }
    
    public func sessionInfo() -> String {
        return "Session on track: \(trackName), Duration: \(sessionTime) seconds, Best lap time: \(bestLapTime), Weather: \(weather)"
    }
    
}

class KartRacingSession : RacingSession{
    internal var number: Int
    internal var power: Int
    internal var tiresFresh: Bool
    
    init(trackName: String, bestLapTime: TimeInterval, sessionTime: TimeInterval, weather: String, number: Int, power: Int, tiresFresh: Bool) {
        self.number = number
        self.power = power
        self.tiresFresh = tiresFresh
        super.init(trackName: trackName, bestLapTime: bestLapTime, sessionTime: sessionTime, weather: weather )
    }
    
    override public func sessionInfo() -> String {
        return super.sessionInfo() + ", Kart number: \(number), Power: \(power), Tires fresh: \(tiresFresh)"
    }
    
    
    private func bestLapTimeSameKart(power: Int, for trackName: String, from laps: [SessionInfo]) -> String? {
            let filteredLaps = laps.compactMap { lap in
                return lap.trackName == trackName && self.power == power ? lap : nil
            }
            
            guard let bestLap = filteredLaps.min(by: { $0.bestLapTime < $1.bestLapTime }) else {
                return nil
            }
            
        return "Best lap time on track:  '\(trackName)' with power  \(power) is  \(bestLap.bestLapTime)"
        }
    
    public func displayBestLapTime(from laps: [SessionInfo]) {
        if let bestLapTimeMessage = bestLapTimeSameKart(power: power, for: trackName, from: laps) {
            print(bestLapTimeMessage)
        } else {
            print("No lap times found for track: '\(trackName)' with power: \(power)")
        }
    }
}


class CarRacingSession: RacingSession {
    var carClass: String
    
    init(trackName: String, bestLapTime: TimeInterval, sessionTime: TimeInterval, weather: String, carModel: String) {
        self.carClass = carModel
        super.init(trackName: trackName, bestLapTime: bestLapTime, sessionTime: sessionTime, weather: weather )
    }
    
    override public func sessionInfo() -> String {
        return super.sessionInfo() + ", Car class: \(carClass)"
    }
}
