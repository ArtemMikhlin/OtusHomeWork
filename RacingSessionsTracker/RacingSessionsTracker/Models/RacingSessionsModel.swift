import CoreData

// MARK: - Session Entity
@objc(Session)
public class Session: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var track: Track
    @NSManaged public var car: Car
    @NSManaged public var weather: Weather
    @NSManaged public var lapTimes: NSSet
    @NSManaged public var media: NSSet
}

extension Session {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }
}

// MARK: - Track Entity
@objc(Track)
public class Track: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}

extension Track {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }
}

// MARK: - Car Entity
@objc(Car)
public class Car: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var model: String
    @NSManaged public var horsepower: Int16
}

extension Car {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }
}

// MARK: - Weather Entity
@objc(Weather)
public class Weather: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Double
    @NSManaged public var descriptionText: String
}

extension Weather {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }
}

// MARK: - LapTime Entity
@objc(LapTime)
public class LapTime: NSManagedObject, Identifiable, Comparable {
    @NSManaged public var id: UUID
    @NSManaged public var time: Double

    // Реализация протокола Comparable
    public static func < (lhs: LapTime, rhs: LapTime) -> Bool {
        return lhs.time < rhs.time
    }
}

extension LapTime {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LapTime> {
        return NSFetchRequest<LapTime>(entityName: "LapTime")
    }
}

// MARK: - Media Entity
@objc(Media)
public class Media: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var filePath: String
}

extension Media {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }
}
