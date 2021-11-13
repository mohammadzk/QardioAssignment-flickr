//
//  SearchCollectionViewController.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import UIKit
import Combine

let simpleReuseIndentifier = "simpleCellReuseIdentifier"
class SearchCollectionViewController: UICollectionViewController {
    var model :SearchViewModel = SearchViewModel()
    var loading:LoadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    var searchList:[SearchResult] = []
    var searchHistory:[String] = []
    var searchBar:UISearchBar!
    var cancleAble:AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up views
        setupSearchBar()
        setUpCollectionView()
        model.didResiveData = { [weak self] items in
            self?.searchList = items
            self?.collectionView.reloadData()
        }
        self.searchHistory = model.searchHistory
        cancleAble = model.$loadState
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] modelstate in
               guard let strongSelf = self else {return}
                strongSelf.loading.removeFromSuperview()
                switch modelstate{
                case .loading:
                    strongSelf.searchHistory = []
                    strongSelf.collectionView.reloadData()
                    strongSelf.loadingViewConfigration(isloading: true)
                   
                case .failed(let error):
                    strongSelf.loadingViewConfigration(isloading: false, img: UIImage(systemName: "xmark.octagon.fill"), message: error.localizedDescription)
                case .idle:
                    if strongSelf.searchHistory.count <= 0 {
                        strongSelf.loadingViewConfigration(isloading: false, img: UIImage(systemName: "magnifyingglass.circle.fill"), message: "No search data yet!")
                  
                    }
                default:
                    break
                }
            }
    }
    func setupSearchBar() {
        self.navigationItem.titleView = nil
        let consWidth = UIScreen.main.bounds.width/2
        let viewWidth = consWidth + consWidth/2
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width:viewWidth , height: (self.navigationController?.navigationBar.frame.height) ?? 64))
        view.backgroundColor = .clear
        let searchBar = UISearchBar.init(frame: view.bounds)
        searchBar.placeholder = "Search image ... "
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        view.addSubview(searchBar)
        self.navigationItem.titleView = view
        self.searchBar = searchBar
    }
    func setUpCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
              layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
              layout.minimumInteritemSpacing = 0
              layout.minimumLineSpacing = 5
              collectionView!.collectionViewLayout = layout
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(FlickrItemCollectionViewCell.self, forCellWithReuseIdentifier: FlickrItemCollectionViewCell.reuseIndetifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: simpleReuseIndentifier)
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.reuseIndetifier)
        
    }
    func loadingViewConfigration(isloading:Bool = false,img:UIImage? = nil ,message:String = ""){
        loading.loading = isloading
        loading.image = img
        loading.textTitle = message
        loading.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        collectionView.contentInset.bottom += loading.frame.size.height
        loading.frame.size.width =  collectionView.bounds.width
        loading.frame.origin.y = collectionView.contentSize.height
        loading.translatesAutoresizingMaskIntoConstraints = true
        collectionView.addSubview(loading)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model.loadState{
        case .idle:
            return searchHistory.count
        default:
            return searchList.count
        }
       
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        switch model.loadState{
        case .idle:
        
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.reuseIndetifier, for: indexPath)
                guard let historyCell = cell as? HistoryCell else {return cell}
                historyCell.title = searchHistory[indexPath.row]
                return historyCell
//            }
//            else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: simpleReuseIndentifier, for: indexPath)
//
//            return messageCell(cell: cell, image: UIImage(systemName: "magnifyingglass.circle.fill"), title: "No search data yet!", isloading: false)
//            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrItemCollectionViewCell.reuseIndetifier, for: indexPath)
            guard let itemCell = cell as? FlickrItemCollectionViewCell else{return cell}
            let item  = searchList[indexPath.row]
            itemCell.title = item.title
            itemCell.imageUrl = item.imageUrl
            return itemCell
        }
      
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch model.loadState{
        case .idle:
            if model.searchHistory.count > 0 {
                let text = searchHistory[indexPath.row]
                searchBar.text = text
                model.searchItem(txt: text, page:model.currentPage , perpage: model.perpage)
                
            }
        default:
            return
        }
    }

    
}
extension SearchCollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch model.loadState {
        case .idle:
            if model.searchHistory.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 64)
            }
            else {
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
            }
            
        default:
            let collectionCell = FlickrItemCollectionViewCell()
            let item = model.list[indexPath.row]
            collectionCell.title = item.title
            return collectionCell.sizeThatFits(CGSize(width: UIScreen.main.bounds.width/2 - 10, height: (UIScreen.main.bounds.width/2 - 10) * 1.2))
        }
       
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomOffset = scrollView.contentOffset.y
        
        if bottomOffset > scrollView.contentSize.height - scrollView.bounds.height {
            self.model.loadMoreItems()
        }
    }

    
}

extension SearchCollectionViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText
        if text == "" {
            model.resetvariables()
            
        }
        else if text.count > 2 {
            //make search request
            model.searchItem(txt: text, page:model.currentPage , perpage: model.perpage)
            
        }
     
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" , searchBar.text?.count ?? 0 > 2 else { return }
        
       //make search request
        model.searchItem(txt: text, page:model.currentPage , perpage: model.perpage)
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" , searchBar.text?.count ?? 0 > 2 else { return }
        model.searchHistory.append(text)
    }
}
