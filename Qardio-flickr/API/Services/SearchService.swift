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
    //default query parameters
    private var defaultParameters:[String:String] {
      return  ["method":"flickr.photos.search","api_key":"9480a18b30ba78893ebd8f25feaabf17","format":"json","nojsoncallback":"1"]
    }
    /// these properties will be added to querystring
    var searchText:String // searchQuery
    var page:String //page number
    var perpage:String // items perpage
    
    var urlRequest: RequestBuilder{
    //building request url for search
      RequestBuilder(baseUrl:Constant.baseUrlString,path: self.path).add(parameters: defaultParameters + ["text":searchText,"page":page,"per_page":perpage])
       
       
    }
}
