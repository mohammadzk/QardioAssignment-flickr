//
//  SearchCollectionViewController.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import UIKit



class SearchCollectionViewController: UICollectionViewController {
    var model :SearchViewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setUpCollectionView()
        model.didResiveData = { [weak self] in
            self?.collectionView.reloadData()
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
    }
    func setUpCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
              layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
              layout.minimumInteritemSpacing = 0
              layout.minimumLineSpacing = 0
              collectionView!.collectionViewLayout = layout
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(FlickrItemCollectionViewCell.self, forCellWithReuseIdentifier: FlickrItemCollectionViewCell.reuseIndetifier)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrItemCollectionViewCell.reuseIndetifier, for: indexPath)
        guard let itemCell = cell as? FlickrItemCollectionViewCell else{return cell}
        let item  = model.list[indexPath.row]
        itemCell.title = item.title
        itemCell.imageUrl = item.imageUrl
    
        return itemCell
    }

    
}
extension SearchCollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCell = FlickrItemCollectionViewCell()
        let item = model.list[indexPath.row]
        collectionCell.title = item.title
        return collectionCell.sizeThatFits(CGSize(width: UIScreen.main.bounds.width/2 - 10, height: (UIScreen.main.bounds.width/2 - 10) * 2))
    }
    
}
extension SearchCollectionViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var text = searchText
        if text == "" || text.count <= 1 {
            text = ""
        }
      //make search request
        model.searchText = text
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" , searchBar.text?.count ?? 0 > 1 else { return }
        
       //make search request
        model.searchText = text
        searchBar.resignFirstResponder()
    }
}
