//
//  SearchViewModel.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
import Combine
class SearchViewModel{
    var cancleable:Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var list:[SearchResult] = []
    @Published var searchText:String = ""
    @Published var error:APIError?
    var didResiveData:(()->())? = nil
    init(){
        $searchText
            .dropFirst()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { text in
                self.searchItem(txt: text, page: "1", perpage: "10")
            }
            .store(in: &cancleable)
    }
    private func append(_ items:[SearchResult]){
        self.list += items
    }
    private func refresh(_ items:[SearchResult]){
        self.list = items
    }
    func searchItem(txt:String,page:String,perpage:String,refresh:Bool = false){
        let service = SearchService(searchText:txt , page: page, perpage: perpage)
        service.run { [weak self] searchResult in
            guard let strongSelf = self else {return}
            switch searchResult{
            case.success(let photos):
                let items = photos.photos.listItems.compactMap{try? SearchResult(item: $0)}
                if refresh{
                    strongSelf.refresh(items)
                }
                else {
                    strongSelf.append(items)
                }
                strongSelf.didResiveData?()
            case .failure(let error):
                strongSelf.error = APIError(error: error)
                
            }
        }
    }
}
struct SearchResult{
    let title:String
    let imageUrl:URL?
    var imageBaseUrl:String = Constant.imagesBaseUrlString
    init(item:FlickrItem) throws{
        self.title = item.title
        let urlString = String(format:imageBaseUrl , "\(item.farm)")
        guard var baseUrl = URL(string: urlString) else
        {
            self.imageUrl = nil
            throw objectValidatorError.invalid(message: "image url string is not valid")
            
        }
        baseUrl.appendPathComponent(item.server)
        self.imageUrl =  baseUrl.appendingPathComponent("\(item.Id)_\(item.secret)").appendingPathExtension("jpg")
      
    }
}
