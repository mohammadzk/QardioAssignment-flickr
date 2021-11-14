//
//  HistoryCell.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/14/21.
//

import Foundation
import UIKit
class HistoryCell:UICollectionViewCell{
   private var titleLabel:UILabel = UILabel()
    //reuse identifier
    static var reuseIndetifier:String{
        return "\(HistoryCell.self)"
    }
    private func commonInit() {
        //initilize view
        contentView.addSubview(self.titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true        
    }
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
            setNeedsDisplay()
        }
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
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.font = UIFont.systemFont(ofSize: 15)
    }
}
