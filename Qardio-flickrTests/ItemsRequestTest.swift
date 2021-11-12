//
//  ItemsRequestText.swift
//  Qardio-flickrTests
//
//  Created by Mohammad khazaee on 11/12/21.
//

import XCTest
@testable import Qardio_flickr
class ItemsRequestTest: XCTestCase {
    var sut:ItemlistMockService!
    override func setUpWithError() throws {
        let urlsession = MockSession()
        urlsession.data = nil
        urlsession.error = nil
        urlsession.urlResponse = nil
        sut = ItemlistMockService.init(parameters: ["method":"flickr.photos.search","api_key":"9480a18b30ba78893ebd8f25feaabf17","format":"json","nojsoncallback":"1","text":"kittens"], baseurl: URL(string: "https://api.flickr.com/services/rest/")!, session: urlsession)
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequest(){
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9480a18b30ba78893ebd8f25feaabf17&format=json&nojsoncallback=1&text=kittens"
        XCTAssertEqual(sut.urlRequest.request.url, URL(string: urlString)!)
    }
    func testresultofRequest(){
        let testBundle = Bundle(for: type(of: self))
        let filepath = testBundle.path(forResource: "Content", ofType: "json")
        let data = try! String(contentsOfFile: filepath!).data(using: .utf8)
        let newurlSession = MockSession()
        newurlSession.data = data
        newurlSession.error = nil
        let timeout:Double = 0.1
        let expectation = self.expectation(description: "Items Parsed Fully")
        var searchResult:PhotosData?
        var errorresult:Error?
        sut.session = newurlSession
        sut.run { result in
            switch result{
            case .success(let itemsresult):
                searchResult = itemsresult
                
            case .failure(let error):
                errorresult = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        XCTAssertNotNil(searchResult)
        XCTAssertNil(errorresult)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
