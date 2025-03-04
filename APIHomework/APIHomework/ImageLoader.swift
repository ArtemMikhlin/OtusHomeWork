import UIKit

class ImageLoader {
    private let imageCache = NSCache<NSString, UIImage>()
    private let imageLoadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    static let shared = ImageLoader()
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        let operation = BlockOperation {
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            OperationQueue.main.addOperation {
                completion(image)
            }
        }
        
        imageLoadQueue.addOperation(operation)
    }
    
    func cancelAllOperations() {
        imageLoadQueue.cancelAllOperations()
    }
}
