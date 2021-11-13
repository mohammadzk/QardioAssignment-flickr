//
//  SearchViewModel.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
import Combine

class SearchViewModel{
    var list:[SearchResult] = []
    var searchText:String = ""
    @Published var loadState:ContentloadState = .idle
    var currentPage:Int = 1
    var perpage:String = "10"
    var didResiveData:(([SearchResult])->())? = nil
    var searchHistory:[String] = []{
        didSet{
            UserDefaults.standard.set(searchHistory, forKey:UserDefaultKeys.kSearchHistory)
            UserDefaults.standard.synchronize()
        }
    }
    init(){
        if let history = UserDefaults.standard.value(forKey: UserDefaultKeys.kSearchHistory) as? [String] {
            self.searchHistory = history
        }
       
        
    }
    func resetvariables(){
        self.loadState = .idle
        self.searchText = ""
        self.list = []
    }
    private func append(_ items:[SearchResult]){
        self.list += items
        self.loadState = .moreBatchesLoaded
        self.didResiveData?(self.list)
    }
    private func refresh(_ items:[SearchResult]){
        self.list = items
        self.loadState = .oneBatchLoaded
        self.didResiveData?(self.list)
    }
    func searchItem(txt:String,page:Int ,perpage:String,refresh:Bool = false){
        let service = SearchService(searchText:txt , page: "\(page)", perpage: perpage)
        self.loadState = .loading
        self.searchText = txt
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
            case .failure(let error):
                strongSelf.loadState = .failed(APIError(error: error))
                
            }
        }
    }
    func loadMoreItems(){
        guard self.loadState != .loading ,self.loadState.nextLoadStatus == .moreBatchesLoaded else{return}
        self.currentPage += 1
        searchItem(txt: self.searchText, page: currentPage, perpage: self.perpage)
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
