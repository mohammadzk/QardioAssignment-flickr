//
//  RequestBuilder.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//
/*
 Creating Url Request object
 to handle request
 add headers,method,parameters
 with builder pattern
 */
import Foundation
class RequestBuilder{
    var request:URLRequest
    
    init(baseUrl:String,path:String = ""){
        //initializing Requestbuilder
        guard let url = URL(string: baseUrl  + "\(path)") else {
            fatalError("Wrong baseUrl.")
        }
        var rq = URLRequest(url: url)
        rq.httpMethod = RequestMethod.get.rawValue
        self.request = rq
    }
    
    func add(headers:[String:String])->RequestBuilder{
        //add headers to request
        var rq = self.request
        for (key,value) in headers{
            rq.setValue(value, forHTTPHeaderField: key)
        }
        return RequestBuilder(rq)
    }
    func add(parameters:[String:String])->RequestBuilder{
       //adding quary parameters to url
        guard let rq = self.encode(request: self.request, with: parameters) else {
            return self
        }
        return RequestBuilder(rq)
    }
    private func encode(request:URLRequest,with quaryParameters:[String:String])->URLRequest?{
        //encoding quary parameters to url request
        let rq = request
        guard var urlComponents = URLComponents(url: rq.url!,resolvingAgainstBaseURL: false) else {
            return nil
        }
        let sortedQuary = quaryParameters.sorted(by: {$0.key<$1.key})
        urlComponents.queryItems = sortedQuary.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
//        urlComponents.queryItems = quaryParameters.compactMap({URLQueryItem(name: $0.key, value: $0.value)})
        let quaryitems = urlComponents.query
        urlComponents.query = quaryitems?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let componentUrl = urlComponents.url else {
            return nil
        }
    
       return URLRequest(url: componentUrl)
    }
    func set(method:RequestMethod)->RequestBuilder{
        //set the request method
        var rq = self.request
        rq.httpMethod = method.rawValue
        return RequestBuilder(rq)
    }
    
    private init(_ request:URLRequest){
        self.request = request
    }
   
}
enum RequestMethod:String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
