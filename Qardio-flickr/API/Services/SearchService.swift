//
//  SearchService.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
struct SearchService:Service{
   
    typealias ResultType = PhotosData
    
    var path: String = ""
    
    var session: URLSessionProtocol = URLSession.shared
    var defaultParameters:[String:String] {
      return  ["method":"flickr.photos.search","api_key":"9480a18b30ba78893ebd8f25feaabf17","format":"json","nojsoncallback":"1"]
    }
    var searchText:String
    var page:String
    var perpage:String
    var urlRequest: RequestBuilder{
        RequestBuilder(baseUrl:Constant.baseUrlString,path: self.path).add(parameters: defaultParameters + ["text":searchText,"page":page,"per_page":perpage])
    }
}
