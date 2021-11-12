//
//  PhotosData.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
///Model to parse all the data 
struct PhotosData:Codable{
    let photos:SearchItem
    let stat:String?
    enum PhotosKeys:String,CodingKey{
        case photos
        case stat
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PhotosKeys.self)
        self.photos = try container.decode(SearchItem.self, forKey: .photos)
        self.stat = try container.decode(String.self, forKey: .stat)
    }
}
