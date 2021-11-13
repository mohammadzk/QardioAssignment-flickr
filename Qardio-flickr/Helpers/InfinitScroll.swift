//
//  InfinitScroll.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
import UIKit
private enum ObserverKeys: String {
    case contentOffset = "contentOffset"
    case contentSize = "contentSize"
    case frame = "frame"
    case hidden = "hidden"
}

private struct Context {
    static var contentChangeContext = "contentChangeContext"
}

extension UIScrollView {
    // MARK: Properties
    
    fileprivate struct AssosiatedKey {
        static var view = "view"
        static var loadMoreAction = "refreshAction"
    }
    
    fileprivate var loadMoreView: LoadMoreFooter? {
        get {
            return objc_getAssociatedObject(self, &AssosiatedKey.view) as? LoadMoreFooter
        }
        
        set {
            objc_setAssociatedObject(self, &AssosiatedKey.view, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK: Setup
    fileprivate func setupLoadMore(_ view: LoadMoreFooter) {
        loadMoreView?.removeFromSuperview()
        
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        view.frame.origin.y = contentSize.height//+ contentInset.top
        contentInset.bottom += view.frame.size.height
        view.frame.size.width = bounds.width
        addSubview(view)
        self.loadMoreView = view
    }
    
    
    // MARK: KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &Context.contentChangeContext {
            guard let keyPath = keyPath.flatMap(ObserverKeys.init) else { return }
            
            switch keyPath {
            case .contentOffset: offsetChanged()
            case .contentSize: sizeChanged()
            case .frame: loadMoreFrameChanged(change)// as! [String : AnyObject]?)
            case .hidden: loadMoreDidChangeHidden(change)// as! [String : AnyObject]?)
            }
        }
    }
    
    
     @objc  func offsetChanged() {
        guard let loadMoreView = loadMoreView, loadMoreView.loadState == .notAnimating && !loadMoreView.isHidden else { return }
        
        let bottomOffset = contentOffset.y + bounds.size.height
        if bottomOffset >= contentSize.height   {
            startLoadMore()
        }
    }
    
    fileprivate func loadMoreDidChangeHidden(_ change: [NSKeyValueChangeKey: Any]?) {
        guard let hidden = change?[NSKeyValueChangeKey.newKey] as? Bool,
            let oldHidden = change?[NSKeyValueChangeKey.oldKey] as? Bool, hidden != oldHidden
            else { return }
        
        guard let height = self.loadMoreView?.frame.height else { fatalError("view height is not valid") }
        let delta = hidden ? height : -height
        self.muteContentObserver({
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.contentInset.bottom -= delta
            if self.contentOffset.y > -self.contentInset.top {
                self.contentOffset.y += delta
            }
            CATransaction.commit()
        })
    }
    
    fileprivate func sizeChanged() {
        loadMoreView?.frame.origin.y = contentSize.height
    }
    
    fileprivate func loadMoreFrameChanged(_ change: [NSKeyValueChangeKey: Any]?) {
        guard let oldValue = change?[NSKeyValueChangeKey.oldKey] as? NSValue,
            let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue, self.loadMoreView?.isHidden == false else { return }
        
        let oldHeight = oldValue.cgRectValue.height
        let newHeight = newValue.cgRectValue.height
        
        guard oldHeight != newHeight else { return }
        
        
        let delta = newHeight - oldHeight
        muteContentObserver { [unowned self] in
            //            self.contentSize.height -= oldValue
//            self.contentInset.bottom -= oldHeight
            
            //            self.contentSize.height += newValue
//            self.contentInset.bottom += newHeight
            self.contentInset.bottom += delta
        }
    }
    fileprivate func muteContentObserver(_ code: () -> ()) {
        removeObserver(self, forKeyPath: ObserverKeys.contentSize.rawValue)
        removeObserver(self, forKeyPath: ObserverKeys.contentOffset.rawValue)
        code()
        addObserver(self, forKeyPath: ObserverKeys.contentSize.rawValue, options: .new, context: &Context.contentChangeContext)
        addObserver(self, forKeyPath: ObserverKeys.contentOffset.rawValue, options: .new, context: &Context.contentChangeContext)
    }
    
    // MARK: Actions
    
    fileprivate func showLoadMore() {
        loadMoreView?.frame.size.height = 100
        loadMoreView?.isHidden = false
        loadMoreView?.loadState = .animating
    }
    
    fileprivate func startLoadMore() {
        showLoadMore()
    }
    
    fileprivate func stopLoadMore() {
        loadMoreView?.loadState = .notAnimating
    }
    
    fileprivate func noMoreLoadMore() {
        loadMoreView?.loadState = .noMore
    }
    
    fileprivate func isLoadMoreVisible() -> Bool {
        guard let loadMoreView = loadMoreView, !loadMoreView.isHidden else { return false }
        return loadMoreView.frame.intersects(bounds)
    }
}
class LoadMoreFooter: LoadingView {
    enum Stat {
        case animating
        case notAnimating
        case noMore
    }
    
    var loadState: Stat = .animating
    
    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMoveToSuperview(newSuperview)
        
        if superview is UIScrollView || newSuperview == nil {
            removeObservers()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addObservers()
    }
    
    func addObservers() {
        guard let superview = superview else { return }
        superview.addObserver(superview, forKeyPath: ObserverKeys.contentOffset.rawValue, options: .new, context: &Context.contentChangeContext)
        superview.addObserver(superview, forKeyPath: ObserverKeys.contentSize.rawValue, options: .new, context: &Context.contentChangeContext)
        addObserver(superview, forKeyPath: ObserverKeys.frame.rawValue, options: [.new, .old], context: &Context.contentChangeContext)
        addObserver(superview, forKeyPath: ObserverKeys.hidden.rawValue, options: [.new, .old], context: &Context.contentChangeContext)
    }
    
    func removeObservers() {
        guard let superview = superview else { return }
        superview.removeObserver(superview, forKeyPath: ObserverKeys.contentOffset.rawValue)
        superview.removeObserver(superview, forKeyPath: ObserverKeys.contentSize.rawValue)
        removeObserver(superview, forKeyPath: ObserverKeys.frame.rawValue)
        removeObserver(superview, forKeyPath: ObserverKeys.hidden.rawValue)
    }
}
