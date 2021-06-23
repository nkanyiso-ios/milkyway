import Foundation
import Combine

enum APIError: Error {
    case requestFailed(Int)
    case noDataFound
    
}
extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed(_):
            return  NSLocalizedString("Sorry seems there is a problem with the service.", comment: "")
        case .noDataFound:
            return NSLocalizedString("Sorry no data found.", comment: "")
        }
    }
}

struct Client {
    
    private let urlSession: URLSession
    private let environment: Environment
    
    init(urlSession: URLSession = .shared, environment: Environment = .development) {
        self.urlSession = urlSession
        self.environment = environment
    }
    
    func publisherForRequest<T: Request>(_ request: T) -> AnyPublisher<T.response, Error> {
        let url = environment.baseUrl.appendingPathComponent(request.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = URL(string: urlRequest.url?.absoluteString.removingPercentEncoding ?? "")
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        let publisher = urlSession.dataTaskPublisher(for: urlRequest).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                throw APIError.requestFailed(statusCode)
            }
            return data
        }
        .tryMap { responseData -> T.response in
            try request.handle(response: responseData)
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        
        return publisher
    }
    
    
}
