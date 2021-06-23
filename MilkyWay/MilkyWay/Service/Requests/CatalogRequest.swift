import Foundation

// MARK: - All Catalog images

struct GetAllCatalogImagesRequest: Request {
    
    typealias Response = CatalogResponse
    
    var method: HTTPMethod { return .GET }
    var path: String { return "/search?q=''" }
    var contentType: String { return "application/json" }
    var additionalHeaders: [String : String] { return [:] }
    var body: Data? { return nil }
    var parameters: [String:String]? {return nil}
    
    func handle(response: Data) throws -> CatalogResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(CatalogResponse.self, from: response)
    }
}
