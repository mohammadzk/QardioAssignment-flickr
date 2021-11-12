//
//  URLSessionProtocol.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
protocol URLSessionProtocol{
    func dataTask( url: URL, completionHandler: @escaping (Data?,URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?,URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
///UrlSession to conformation to URLSession protocol
extension URLSession:URLSessionProtocol{
    
    func dataTask(url: URL, completionHandler: @escaping (Data?,URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol{
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?,URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol{
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
    
}
