
import Foundation

enum State {
    case idle
    case fetching
    case fetched
    case error(Error)
}
enum App {
    static let dateFormat = "dd MMM,yyyy"
}
