//
//  binaryMap.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/2/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

struct BinaryMap <Key: Hashable & Comparable, Value> : CustomStringConvertible, Map {
	var keys = [Key]()
	var values = [Value]()
	
	func binarySearch (_ key: Key) -> Int? {
		if keys.count == 0 {
			return nil
		}
		var start = 0
		var end = keys.count - 1
		var middle: Int
		while end - start > 2 {
			middle = (start + end) / 2
			let current = keys[middle]
			if key < current {
				end = middle - 1
				continue
			} else if key > current {
				start = middle + 1
			} else {
				return middle
			}
		}
		for (index, current) in keys[start...end].enumerated() {
			if current == key {
				return index + start
			}
		}
		return nil
	}
	
	mutating func set (_ key: Key, _ value: Value) {
		if let index = binarySearch(key) {
			values[index] = value
		} else {
			for (index, current) in keys.enumerated() {
				if current > key {
					keys.insert(key, at: index)
					values.insert(value, at: index)
					return
				}
			}
			keys.append(key)
			values.append(value)
		}
	}
	
	func get (_ key: Key) -> Value? {
		let index = binarySearch(key)
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
