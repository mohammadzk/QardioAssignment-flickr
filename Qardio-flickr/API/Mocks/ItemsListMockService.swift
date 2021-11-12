//
//  ItemsListMockService.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
///fake searchitem service
struct ItemlistMockService:Service{
    typealias ResultType = PhotosData
    var path:String {
        "data/path"
    }
    var parameters:[String:String]
    var baseurl:URL
    var session: URLSessionProtocol
    var urlRequest: RequestBuilder{
        RequestBuilder.init(baseUrl: self.baseurl).add(parameters: self.parameters)
    }
    
}
