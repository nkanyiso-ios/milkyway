

import XCTest
import Combine
@testable import MilkyWay


class MilkyWayTests: XCTestCase {
    func testValidResponse(){
        let request = GetAllCatalogImagesRequest()
        guard let data = JsonData.validResponse.data(using: .utf8) else { return XCTFail("Invalid json data") }
        do {
            let response = try request.handle(response: data)
            XCTAssertEqual(response.collection?.items.count, 1)
        } catch let error {
            XCTFail("Failed to handle data\(error.localizedDescription)")
        }
        
    }
    
    func testInvalidResponse(){
        let request = GetAllCatalogImagesRequest()
        guard let data = JsonData.invalidResponse.data(using: .utf8) else { return XCTFail("Invalid json data") }
        XCTAssertThrowsError(try request.handle(response: data)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
}
