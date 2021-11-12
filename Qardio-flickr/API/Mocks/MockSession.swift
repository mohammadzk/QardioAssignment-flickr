//
//  MockSession.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
///mock url session for unit testin
class MockSession: URLSessionProtocol {
    //dat for injecting local data
    var data:Data?
    //generated http url response
    var urlResponse:HTTPURLResponse?
    //error for cheking error handling
    var error:Error?
    //data task function for creating the original data task behavior
    func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.data,self.urlResponse,self.error)
        return MockTask()
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.data,self.urlResponse,self.error)
        return MockTask()
    }
    
}


