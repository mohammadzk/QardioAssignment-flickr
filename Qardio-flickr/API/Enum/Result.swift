//
//  Result.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/11/21.
//

import Foundation
enum Result<T> where T:Encodable{
    case success(T)
    case failure(Error)
}
