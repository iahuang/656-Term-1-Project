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
		var end = keys.count
		
		while end - start > 1 {
			let middle = (start + end) / 2
			let keyAtMiddle = keys[middle]
			if key < keyAtMiddle {
				end = middle
			} else if key > keyAtMiddle {
				start = middle
			} else {
				return middle
			}
		}
		
		if keys[start] == key {return start}
		if keys[end - 1] == key {return end - 1}
		return nil
	}
	
	mutating func set (_ key: Key, _ value: Value) {
		if let index = binarySearch(key) {
			values[index] = value
		} else {
			
			var insertIndex = keys.count
			
			for (index, n) in keys.enumerated() {
				if (key < n) {
					insertIndex = index
					break
				}
			}
			
			keys.insert(key, at: insertIndex)
			values.insert(value, at: insertIndex)
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
			var output = "\(myType) ["
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
