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
    var path:String 
    var parameters:[String:String]
    var baseurl:String
    var session: URLSessionProtocol
    var urlRequest: RequestBuilder{
        RequestBuilder.init(baseUrl: self.baseurl,path: self.path).add(parameters: self.parameters)
    }
    
}
