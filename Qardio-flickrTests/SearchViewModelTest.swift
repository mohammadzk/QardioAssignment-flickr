//
//  SearchViewModelTest.swift
//  Qardio-flickrTests
//
//  Created by Mohammad khazaee on 11/13/21.
//

import XCTest
@testable import Qardio_flickr
class SearchViewModelTest: XCTestCase {
    var sut:SearchViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SearchViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResult(){
        var service = ItemlistMockService(path: "", parameters: [:], baseurl: "https://api.flickr.com/services/rest/", session: MockSession())
        let testBundle = Bundle(for: type(of: self))
        let filepath = testBundle.path(forResource: "Content", ofType: "json")
        let data = try! String(contentsOfFile: filepath!).data(using: .utf8)
        let newurlSession = MockSession()
        newurlSession.data = data
        newurlSession.error = nil
        let timeout:Double = 0.1
        let expectation = self.expectation(description: "Items Parsed Fully")
        var errorresult:Error?
        service.session = newurlSession
        service.run { [weak self] result in
            switch result{
            case .success(let itemsresult):
                self?.sut.list = itemsresult.photos.listItems.compactMap({try? SearchResult(item: $0)})
                
            case .failure(let error):
                errorresult = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        XCTAssertNotNil(sut.list.first?.imageUrl)
        XCTAssertNil(errorresult)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
