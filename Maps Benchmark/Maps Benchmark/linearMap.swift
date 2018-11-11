//
//  linearMap.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/2/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

struct LinearMap <Key: Hashable & Comparable, Value> : CustomStringConvertible, Map {
	
	var keys = [Key]()
	var values = [Value]()
	
	mutating func set (_ key: Key, _ value: Value) {
		if let index = keys.index(of: key) {
			values[index] = value
		} else {
			keys.append(key)
			values.append(value)
		}
	}
	
	func get (_ key: Key) -> Value? {
		let index = keys.index(of: key)
		return index == nil ? nil : values[index!]
	}

	var count: Int {
		get {
			return keys.count
		}
	}
	
	var description: String {
		get {
			var output = "\(type(of: self)) ["
			for (index, key) in keys.enumerated() {
				output += String(describing: key)
				output += ": "
				output += String(describing: values[index])
				output += ", "
			}
			if output.last == " " {
				output.removeLast(2)
			}
			output += "]"
			return output
		}
	}
	
}
