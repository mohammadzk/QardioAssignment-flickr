//
//  Result.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/11/21.
//

import Foundation
/// customize result to get exact codable data
enum Result<T> where T:Codable{
    case success(T)
    case failure(Error)
}
