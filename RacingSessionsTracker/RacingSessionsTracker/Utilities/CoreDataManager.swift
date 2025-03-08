import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        // Создаем модель вручную
        let model = NSManagedObjectModel()
        
        // Описание сущностей
        let sessionEntity = NSEntityDescription()
        sessionEntity.name = "Session"
        sessionEntity.managedObjectClassName = "Session"
        
        let trackEntity = NSEntityDescription()
        trackEntity.name = "Track"
        trackEntity.managedObjectClassName = "Track"
        
        let carEntity = NSEntityDescription()
        carEntity.name = "Car"
        carEntity.managedObjectClassName = "Car"
        
        let weatherEntity = NSEntityDescription()
        weatherEntity.name = "Weather"
        weatherEntity.managedObjectClassName = "Weather"
        
        let lapTimeEntity = NSEntityDescription()
        lapTimeEntity.name = "LapTime"
        lapTimeEntity.managedObjectClassName = "LapTime"
        
        let mediaEntity = NSEntityDescription()
        mediaEntity.name = "Media"
        mediaEntity.managedObjectClassName = "Media"
        
        // Атрибуты для Session
        let sessionIdAttribute = NSAttributeDescription()
        sessionIdAttribute.name = "id"
        sessionIdAttribute.attributeType = .UUIDAttributeType
        sessionIdAttribute.isOptional = false
        
        let sessionDateAttribute = NSAttributeDescription()
        sessionDateAttribute.name = "date"
        sessionDateAttribute.attributeType = .dateAttributeType
        sessionDateAttribute.isOptional = false
        
        sessionEntity.properties = [sessionIdAttribute, sessionDateAttribute]
        
        // Атрибуты для Track
        let trackIdAttribute = NSAttributeDescription()
        trackIdAttribute.name = "id"
        trackIdAttribute.attributeType = .UUIDAttributeType
        trackIdAttribute.isOptional = false
        
        let trackNameAttribute = NSAttributeDescription()
        trackNameAttribute.name = "name"
        trackNameAttribute.attributeType = .stringAttributeType
        trackNameAttribute.isOptional = false
        
        let trackLatitudeAttribute = NSAttributeDescription()
        trackLatitudeAttribute.name = "latitude"
        trackLatitudeAttribute.attributeType = .doubleAttributeType
        trackLatitudeAttribute.isOptional = false
        
        let trackLongitudeAttribute = NSAttributeDescription()
        trackLongitudeAttribute.name = "longitude"
        trackLongitudeAttribute.attributeType = .doubleAttributeType
        trackLongitudeAttribute.isOptional = false
        
        trackEntity.properties = [trackIdAttribute, trackNameAttribute, trackLatitudeAttribute, trackLongitudeAttribute]
        
        // Атрибуты для Car
        let carIdAttribute = NSAttributeDescription()
        carIdAttribute.name = "id"
        carIdAttribute.attributeType = .UUIDAttributeType
        carIdAttribute.isOptional = false
        
        let carModelAttribute = NSAttributeDescription()
        carModelAttribute.name = "model"
        carModelAttribute.attributeType = .stringAttributeType
        carModelAttribute.isOptional = false
        
        let carHorsepowerAttribute = NSAttributeDescription()
        carHorsepowerAttribute.name = "horsepower"
        carHorsepowerAttribute.attributeType = .integer16AttributeType
        carHorsepowerAttribute.isOptional = false
        
        carEntity.properties = [carIdAttribute, carModelAttribute, carHorsepowerAttribute]
        
        // Атрибуты для Weather
        let weatherIdAttribute = NSAttributeDescription()
        weatherIdAttribute.name = "id"
        weatherIdAttribute.attributeType = .UUIDAttributeType
        weatherIdAttribute.isOptional = false
        
        let weatherTemperatureAttribute = NSAttributeDescription()
        weatherTemperatureAttribute.name = "temperature"
        weatherTemperatureAttribute.attributeType = .doubleAttributeType
        weatherTemperatureAttribute.isOptional = false
        
        let weatherHumidityAttribute = NSAttributeDescription()
        weatherHumidityAttribute.name = "humidity"
        weatherHumidityAttribute.attributeType = .doubleAttributeType
        weatherHumidityAttribute.isOptional = false
        
        let weatherDescriptionAttribute = NSAttributeDescription()
        weatherDescriptionAttribute.name = "descriptionText"
        weatherDescriptionAttribute.attributeType = .stringAttributeType
        weatherDescriptionAttribute.isOptional = false
        
        weatherEntity.properties = [weatherIdAttribute, weatherTemperatureAttribute, weatherHumidityAttribute, weatherDescriptionAttribute]
        
        // Атрибуты для LapTime
        let lapTimeIdAttribute = NSAttributeDescription()
        lapTimeIdAttribute.name = "id"
        lapTimeIdAttribute.attributeType = .UUIDAttributeType
        lapTimeIdAttribute.isOptional = false
        
        let lapTimeTimeAttribute = NSAttributeDescription()
        lapTimeTimeAttribute.name = "time"
        lapTimeTimeAttribute.attributeType = .doubleAttributeType
        lapTimeTimeAttribute.isOptional = false
        
        lapTimeEntity.properties = [lapTimeIdAttribute, lapTimeTimeAttribute]
        
        // Атрибуты для Media
        let mediaIdAttribute = NSAttributeDescription()
        mediaIdAttribute.name = "id"
        mediaIdAttribute.attributeType = .UUIDAttributeType
        mediaIdAttribute.isOptional = false
        
        let mediaFilePathAttribute = NSAttributeDescription()
        mediaFilePathAttribute.name = "filePath"
        mediaFilePathAttribute.attributeType = .stringAttributeType
        mediaFilePathAttribute.isOptional = false
        
        mediaEntity.properties = [mediaIdAttribute, mediaFilePathAttribute]
        
        // Отношения для Session
        let trackRelationship = NSRelationshipDescription()
        trackRelationship.name = "track"
        trackRelationship.destinationEntity = trackEntity
        trackRelationship.minCount = 1
        trackRelationship.maxCount = 1
        trackRelationship.deleteRule = .cascadeDeleteRule
        
        let carRelationship = NSRelationshipDescription()
        carRelationship.name = "car"
        carRelationship.destinationEntity = carEntity
        carRelationship.minCount = 1
        carRelationship.maxCount = 1
        carRelationship.deleteRule = .cascadeDeleteRule
        
        let weatherRelationship = NSRelationshipDescription()
        weatherRelationship.name = "weather"
        weatherRelationship.destinationEntity = weatherEntity
        weatherRelationship.minCount = 1
        weatherRelationship.maxCount = 1
        weatherRelationship.deleteRule = .cascadeDeleteRule
        
        let lapTimesRelationship = NSRelationshipDescription()
        lapTimesRelationship.name = "lapTimes"
        lapTimesRelationship.destinationEntity = lapTimeEntity
        lapTimesRelationship.minCount = 0
        lapTimesRelationship.maxCount = 0
        lapTimesRelationship.deleteRule = .cascadeDeleteRule
        
        let mediaRelationship = NSRelationshipDescription()
        mediaRelationship.name = "media"
        mediaRelationship.destinationEntity = mediaEntity
        mediaRelationship.minCount = 0
        mediaRelationship.maxCount = 0
        mediaRelationship.deleteRule = .cascadeDeleteRule
        
        sessionEntity.properties.append(contentsOf: [trackRelationship, carRelationship, weatherRelationship, lapTimesRelationship, mediaRelationship])
        
        // Установка сущностей в модель
        model.entities = [sessionEntity, trackEntity, carEntity, weatherEntity, lapTimeEntity, mediaEntity]
        
        // Создаем контейнер с нашей моделью
        let container = NSPersistentContainer(name: "RacingSessionsModel", managedObjectModel: model)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
