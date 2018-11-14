//
//  map.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/2/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

protocol Map: CustomStringConvertible {
	associatedtype Key: Hashable, Comparable
	associatedtype Value
	
	mutating func set (_: Key, _: Value)
	func get (_: Key) -> Value?
	
	var count: Int {get}
	var description: String {get}
}

extension Map {
	subscript (_ k: Key) -> Value? {
		set {
			set(k, newValue!)
		}
		get {
			return get(k)
		}
	}
	
	var myType: String {return "\(type(of: self))"}
}
