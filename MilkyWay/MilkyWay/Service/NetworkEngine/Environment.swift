import Foundation

struct Environment {
    var baseUrl: URL
}

extension Environment {
    static let development = Environment(baseUrl: URL(string: "https://images-api.nasa.gov/")!)
}
