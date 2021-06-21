
import Foundation
import UIKit.UIImage
import Combine


protocol ImageLoaderServiceProtocol: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

final class ImageLoaderService: ImageLoaderServiceProtocol {

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
    
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
            })
            .print("Image loading \(url):")
            .eraseToAnyPublisher()
    }
}
