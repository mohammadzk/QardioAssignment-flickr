//
//  FlickrItemCollectionViewCell.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import UIKit
import SDWebImage
class FlickrItemCollectionViewCell: UICollectionViewCell {
    // prperties
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemTitle: UILabel!
    //reuseIndentifier for registreing the cell
    var title:String = "" {
        didSet{
            self.itemTitle.text = title
            setNeedsDisplay()
        }
    }
    var imageUrl:URL?{
        didSet{
            itemImage.sd_setImage(with: imageUrl)
            setNeedsDisplay()
        }
    }
    static var reuseIndetifier:String{
        return "\(FlickrItemCollectionViewCell.self)"
    }
    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("\(FlickrItemCollectionViewCell.self)", owner: self, options: nil)![0] as? UIView else{return}
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        awakeFromNib()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //set up title
        itemTitle.numberOfLines = 4
        itemTitle.textAlignment = .left
        itemTitle.minimumScaleFactor = 0.7
        itemTitle.font = UIFont.systemFont(ofSize: 15)
        itemImage.contentMode = .scaleToFill
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        let font = itemTitle.font ?? UIFont.systemFont(ofSize: 15)
        let stringSize = title.size(input: font)
        return CGSize(width: size.width, height: max(size.height,stringSize.height))
    }
}
