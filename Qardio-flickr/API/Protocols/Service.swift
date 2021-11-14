//
//  Service.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/11/21.
//

import Foundation
import Combine
protocol Service{
    ///service protocol for all services to conform to
    ///service model that conforms to codable model as constraint
    associatedtype ResultType : Codable
    //url request build with request builder object
    var urlRequest:RequestBuilder{get}
    //additional path that appends at the end of url Request
    var path:String{get set}
    //urlSession to set requests
    var session:URLSessionProtocol{set get}
    func run(_ completionHandler:@escaping (Result<ResultType>)->Void)
    
}
extension Service {
    //run fuction implementation
    func run(_ completionHandler:@escaping (Result<ResultType>)->Void){
       
        let task  =  session.dataTask(request: self.urlRequest.request) { result, response, error in
          if let _result = result {
              do{
                  let finalResult =  try JSONDecoder().decode(ResultType.self, from: _result)
                  DispatchQueue.main.async {
                      //data passed succesfully and gets pass in main queue
                      completionHandler(.success(finalResult))
                  }
              }
              catch (let er){
                  DispatchQueue.main.async {
                      //passing model parse error
                      completionHandler(.failure(APIError(error: er)))
                  }
              }
          }
          else if let er = error {
              DispatchQueue.main.async {
                  //passing error
                  //return in main queue
                  completionHandler(.failure(APIError(error: er)))
              }
          }
        }
        task.resume()
       
    }
}
