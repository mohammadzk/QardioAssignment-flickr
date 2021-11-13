//
//  LoadingView.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
import UIKit
///a loading view to show messages and loading data to user
class LoadingView:UIView{
    //private properties
    private  var topView:UIView = UIView()
    private  var textLabel:UILabel = UILabel()
    private var activityIndegator:UIActivityIndicatorView = UIActivityIndicatorView()
    private var imageView:UIImageView = UIImageView()
   //public properties
    var image:UIImage? = UIImage(named: ""){
        didSet{
            activityIndegator.isHidden = image != nil
            imageView.isHidden = image == nil
            imageView.image = image
            setNeedsDisplay()
        }
    }
    var loading:Bool = false {
        didSet{
            activityIndegator.isHidden = loading
            imageView.isHidden = !loading
            activityIndegator.startAnimating()
            setNeedsDisplay()
        }
    }
    var textTitle :String = "" {
        didSet{
            textLabel.text = textTitle
            setNeedsDisplay()
        }
    }
    //MARK: view Initialization
    func initializeView(){
        //make view not to translate in superview mask (this makes views to rely on their constraints)
        topView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndegator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topView)
        addSubview(textLabel)
// MARK: topView Constraints
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        /// imageview and activityindigator are both subviews of topView to be presented in order when needed
        topView.addSubview(imageView)
        topView.insertSubview(activityIndegator, aboveSubview: imageView)
        imageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activityIndegator.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        activityIndegator.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        activityIndegator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndegator.heightAnchor.constraint(equalToConstant: 30).isActive = true
// MARK: textLabel Constraint
        ///textLabel constrains relative to topView
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 8).isActive = true
        textLabel.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: 8).isActive = true
      
        
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //render View after init
        initializeView()
        awakeFromNib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //render view after init
        initializeView()
        awakeFromNib()
    }
    override  func awakeFromNib() {
        super.awakeFromNib()
        //setting up textLabel
        textLabel.numberOfLines = 2
        textLabel.minimumScaleFactor = 0.5
        textLabel.textAlignment = .center
        //setting up ImageView
        imageView.contentMode = .scaleAspectFit
        
    }
    
    
}
