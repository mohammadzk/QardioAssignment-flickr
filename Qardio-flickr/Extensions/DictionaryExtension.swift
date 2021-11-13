//
//  DictionaryExtension.swift
//  Qardio-flickr
//
//  Created by Mohammad khazaee on 11/13/21.
//

import Foundation
func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>)
    -> Dictionary<K, V> {
        var map = Dictionary<K, V>()
        for (k, v) in left {
            map[k] = v
        }
        for (k, v) in right {
            map[k] = v
        }
        return map
}
