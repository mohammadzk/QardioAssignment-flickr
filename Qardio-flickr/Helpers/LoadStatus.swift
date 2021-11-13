//
//  LoadStatus.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
enum ContentloadState:Equatable{
    case idle
    case loading
    case oneBatchLoaded
    case moreBatchesLoaded
    case failed(APIError)
    var refresh:Bool {
        return self == .idle
    }
    var loaded:Bool{
        switch self {
        case .idle:
            return false
        case .loading:
            return false
        case .failed(_):
            return false
        default:
            return true
        }
    }
    var nextLoadStatus: ContentloadState {
        switch self {
        case .loading,.failed(_): return .oneBatchLoaded
        case .idle: return .oneBatchLoaded
        case .oneBatchLoaded, .moreBatchesLoaded: return .moreBatchesLoaded
        }
    }
}
