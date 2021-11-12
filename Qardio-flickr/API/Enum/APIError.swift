//
//  APIError.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/11/21.
//

import Foundation

enum APIError:Error{
    case badRequest
    case badResponse
    case networkError
    case unauthorized
    var localizedDescription:String{
        switch self {
        case .badRequest:
          return  "invalid Request "
        case .badResponse:
            return "invalid response"
        case .networkError:
            return "network connection problem"
        case .unauthorized:
            return "access denied"
        }
    }
    init(error:Error){
        guard error._domain == NSURLErrorDomain
            else {
                self = .networkError
                return
        }
        
        guard let specifiedError = errorCodes[error._code]
            else {
                self = .networkError
                return
        }
        
        self = specifiedError
        
    }
}
extension APIError:Equatable{
    static public func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest, .badRequest),
             (.badResponse, .badResponse),
             (.networkError, .networkError),
             (.unauthorized, .unauthorized):
            return true
        default:
            return false
        }
    }
}
let errorCodes: [Int: APIError] = [
    // MARK: .BadRequest
    NSURLErrorBadURL:                            .badRequest, // -1000
    NSURLErrorUnsupportedURL:                    .badRequest, // -1002
    NSURLErrorHTTPTooManyRedirects:                .badRequest, // -1007
    NSURLErrorResourceUnavailable:                .badRequest, // -1008
    NSURLErrorRedirectToNonExistentLocation:    .badRequest, // -1010
    NSURLErrorFileDoesNotExist:                    .badRequest, // -1100
    NSURLErrorFileIsDirectory:                    .badRequest, // -1101
    NSURLErrorNoPermissionsToReadFile:            .badRequest, // -1102
    NSURLErrorDataLengthExceedsMaximum:            .badRequest, // -1103
    
    
    // MARK: .NetworkError
    NSURLErrorCancelled:                        .networkError, // -999
    NSURLErrorTimedOut:                            .networkError, // -1001
    NSURLErrorNetworkConnectionLost:            .networkError, // -1005
    NSURLErrorNotConnectedToInternet:            .networkError, // -1009
    NSURLErrorCannotFindHost:                    .networkError, // -1003
    NSURLErrorCannotConnectToHost:                .networkError, // -1004
    NSURLErrorDNSLookupFailed:                    .networkError, // -1006
    
    
    // MARK: .BadResponse
    NSURLErrorBadServerResponse:                .badResponse, // -1011
    NSURLErrorZeroByteResource:                    .badResponse, // -1014
    NSURLErrorCannotDecodeRawData:                .badResponse, // -1015
    NSURLErrorCannotDecodeContentData:            .badResponse, // -1016
    NSURLErrorCannotParseResponse:                .badResponse, // -1017
    
    
    // MARK: .Unauthorized
    NSURLErrorUserCancelledAuthentication:        .unauthorized, // -1012
    NSURLErrorUserAuthenticationRequired:        .unauthorized, // -1013
]
extension Error{
    static func from(detail:String,statusCode:Int) -> Error {
       return NSError.init(domain: NSErrorDomain(string:detail) as String, code: statusCode, userInfo: nil) as Error
    }
}
