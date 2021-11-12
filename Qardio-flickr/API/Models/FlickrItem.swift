//
//  FlickrItem.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
//the model for the flickr item . photo items that should be presented
struct FlickrItem:Codable{
    //properties
    let Id:String
    let owner:String
    let secret:String
    let server:String
    let farm:Int
    let title:String
    let isPublic: Bool
    let isFriend:Bool?
    let isFamily:Bool?
   
    private enum codingKeys:String,CodingKey{
        case Id = "id"
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
     }
  
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.Id = try container.decode(String.self, forKey: .Id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try  container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.title = try container.decode(String.self, forKey: .title)
        self.isPublic = try  container.decode(Int.self, forKey: .isPublic) == 1
        self.isFriend = try container.decodeIfPresent(Int.self, forKey: .isFriend) == 1
        self.isFamily = try container.decodeIfPresent(Int.self, forKey: .isFamily) == 1
    }
   
}
