//
//  StringExtension.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
import UIKit
extension String{
    func size(input font:UIFont) -> CGSize{
        let fontAttributes = [NSAttributedString.Key.font: font]
           return (self as NSString).size(withAttributes: fontAttributes)
    }
}
