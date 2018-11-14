//
//  hashMap.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/2/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

struct HashMap <Key: Hashable & Comparable, Value> : CustomStringConvertible, Map {
	
	var keys = [Key?]()
	var values = [Value?]()
	var collisionsMap = LinearMap<Key, Value>()
	var hashCount = 0
	
	init (initialArraySize: Int = 10000) {
		keys = [Key?](repeating: nil, count: initialArraySize)
		values = [Value?](repeating: nil, count: initialArraySize)
	}
	
	func getIndex (of key: Key) -> Int {
		let maybeNegativeIndex = key.hashValue % keys.count
		let alwaysPositiveIndex = maybeNegativeIndex >= 0 ? maybeNegativeIndex : maybeNegativeIndex + keys.count
		return alwaysPositiveIndex
	}
	
	mutating func set (_ key: Key, _ value: Value) {
		if keys[getIndex(of: key)] == key {
			values[getIndex(of: key)] = value
		} else if keys[getIndex(of: key)] == nil {
			keys[getIndex(of: key)] = key
			values[getIndex(of: key)] = value
			hashCount += 1
		} else {
			collisionsMap[key] = value
		}
	}
	
	func get (_ key: Key) -> Value? {
		if keys[getIndex(of: key)] == key {
			return values[getIndex(of: key)]
		} else {
			return collisionsMap[key]
		}
	}
	
	var count: Int {
		get {
			return hashCount + collisionsMap.count
		}
	}
	
	var description: String {
		get {
			var output = "\(myType) ["
			for (index, maybeKey) in keys.enumerated() {
				if let key = maybeKey {
					output += String(describing: key)
					output += ": "
					output += String(describing: values[index]!)
					output += ", "
				}
			}
			for (index, key) in collisionsMap.keys.enumerated() {
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
