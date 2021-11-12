//
//  Service.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/11/21.
//

import Foundation
import Combine
protocol Service{
    associatedtype ResultType : Codable
    var urlRequest:URLRequest{get}
    var path:String{get}
    func run(_ completionHandler:@escaping (Result<ResultType>)->Void)
    
}
extension Service {
    
    func run(_ completionHandler:@escaping (Result<ResultType>)->Void){
       
      let task  =  URLSession.shared.dataTask(with: self.urlRequest) { result, response, error in
          if let _result = result {
              do{
                  let finalResult =  try JSONDecoder().decode(ResultType.self, from: _result)
                  DispatchQueue.main.async {
                      completionHandler(.success(finalResult))
                  }
              }
              catch (let er){
                  DispatchQueue.main.async {
                      completionHandler(.failure(APIError(error: er)))
                  }
              }
          }
          else if let er = error {
              DispatchQueue.main.async {
                  completionHandler(.failure(APIError(error: er)))
              }
          }
        }
        task.resume()
       
    }
 
    
    
}
