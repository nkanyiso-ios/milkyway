
import Foundation
import UIKit.UIImage
import Combine


protocol ImageLoaderServiceProtocol: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class ImageLoaderService: ImageLoaderServiceProtocol {
    let imageCache = NSCache<NSString, AnyObject>()
    
    let tapSubject = PassthroughSubject<UIImage, Never>()
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            return Result.Publisher(cachedImage).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in
                let imageToCache = UIImage(data: data)
                self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { _ in })
            .eraseToAnyPublisher()
    }
}
