//
//  URLDataTaskProtocol.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
protocol URLSessionDataTaskProtocol{
    func resume()
}
///data task conformation to 'URLSessionDataTaskProtocol'
extension URLSessionDataTask:URLSessionDataTaskProtocol{}
