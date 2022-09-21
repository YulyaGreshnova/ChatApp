//
//  URLImageFetchable.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 27.04.2022.
//

import UIKit

final class ImageLoader {
    private static let loader = ImageDataLoader()
    
    static func fetchImageFrom(url: URL, id: AnyObject?, completion: @escaping(UIImage?) -> Void) {
        var key: ObjectIdentifier?
        if let id = id {
            key = ObjectIdentifier(id)
        }
        
        Self.loader.fetchImageFrom(url: url, key: key) { (image) in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    static func cancelLoad(id: AnyObject) {
        Self.loader.cancelLoad(key: .init(id))
    }
}

final private class ImageDataLoader {
    private let session = URLSession(configuration: .default)
    private let imageQueue: OperationQueue
    private let cache: NSCache<NSString, UIImage>
    private var dataTaskDict: [ObjectIdentifier: URLSessionTask] = [:]
    
    private let lock = NSLock()
    
    init() {
        imageQueue = OperationQueue()
        imageQueue.maxConcurrentOperationCount = 8
        imageQueue.qualityOfService = .utility
        
        cache = NSCache()
    }
    
    func fetchImageFrom(url: URL, key: ObjectIdentifier?, completion: @escaping(UIImage?) -> Void) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
            return
        }
        
        let blockOperation = BlockOperation()
        blockOperation.addExecutionBlock { [weak self] in
            guard let self = self else { return }
            let dataTask = self.session.dataTask(with: url) { (data, response, error) in
                self.setTask(nil, key: key)
                
                if error != nil {
                    completion(nil)
                }
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(nil)
                    return
                }
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
                
            }
            self.setTask(dataTask, key: key)
            dataTask.resume()
        }
        imageQueue.addOperation(blockOperation)        
    }
    
    func cancelLoad(key: ObjectIdentifier) {
        lock.lock()
        dataTaskDict[key]?.cancel()
        dataTaskDict[key] = nil
        lock.unlock()
    }
    
    private func setTask(_ task: URLSessionTask?, key: ObjectIdentifier?) {
        guard let key = key else { return }
        
        lock.lock()
        self.dataTaskDict[key] = task
        lock.unlock()
    }
}
