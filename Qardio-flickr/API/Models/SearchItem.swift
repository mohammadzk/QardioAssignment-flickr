//
//  ListObject.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/12/21.
//

import Foundation
///indivisual search items model 'SearchItem'
struct SearchItem:Codable{
    let pageNumber:Int
    let numberofpages:Int
    let perpage:Int
    let totalnumberOfitem:Int
    let listItems:[FlickrItem]
    enum searchcodingKeys:String,CodingKey{
        case pageNumber = "page"
        case numberOfPages = "pages"
        case perpage = "perpage"
        case totalnumberofItems = "total"
        case items = "photo"
        
    }
    init(from decoder: Decoder) throws {
        let container = try  decoder.container(keyedBy: searchcodingKeys.self)
        self.pageNumber = try  container.decode(Int.self, forKey: .pageNumber)
        self.numberofpages = try container.decode(Int.self, forKey: .numberOfPages)
        self.perpage = try  container.decode(Int.self, forKey: .perpage)
        self.totalnumberOfitem = try  container.decode(Int.self, forKey: .totalnumberofItems)
        do {
            self.listItems = try container.decode([FlickrItem].self, forKey: .items)
        }
        catch(let error){
            print(error.localizedDescription)
            self.listItems = []
        }
    }
     
}
