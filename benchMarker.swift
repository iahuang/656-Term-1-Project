//
//  benchMarker.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/4/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

class BenchMarker {
	func makeRandomList (_ length: Int) -> [Int] {
		var randomList = [Int]()
		randomList.reserveCapacity(length)
		for _ in 0..<length {
			randomList.append(randomInt())
		}
		return randomList
	}
	
	func randomInt () -> Int {
		//if newest version of swift, uncomment that line
		//return Int.random(in: Int.min...Int.max)
		let firstRandom = UInt(arc4random_uniform(UInt32.max))
		let randomUInt: UInt
		if Int.max == Int32.max {
			randomUInt = firstRandom
		} else {
			let secondRandom = UInt(arc4random_uniform(UInt32.max))
			randomUInt = (firstRandom << 32) + secondRandom
		}
		let output: Int
		if randomUInt > Int.max {
			output = Int(randomUInt - UInt(Int.max))
		} else {
			output = Int(randomUInt)
		}
		return output
	}
	
	func fillMap<BenchMap: Map> (_ map: inout BenchMap, _ randomList: [Int]) where BenchMap.Key == Int, BenchMap.Value == Int { //fills map with random values from randomList(1)
		for i in randomList {
			map.set(i, i)
		}
	}
	
	func testSetFunc<BenchMap: Map> (_ map: inout BenchMap, _ randomList: [Int], _ randomList2: [Int]) -> Double where BenchMap.Key == Int, BenchMap.Value == Int { //inserts each item from randomList2 into their own copy of the full map and returns the average operation time
		var time: Double = 0
		for i in randomList2 {
			var mapCopy = map
			let startDate = Date()
			mapCopy.set(i, i)
			let elapsed = Date().timeIntervalSince(startDate)
			time += elapsed
		}
		return time/Double(randomList2.count)
	}
	
	func testGetFunc<BenchMap: Map> (_ map: inout BenchMap, _ randomList: [Int], _ operations: Int) -> Double where BenchMap.Key == Int, BenchMap.Value == Int { //gets from a list of the same length as randomList2 from set but it is randomized items from randomList(1) and returns average operation time
		var randomList2 = [Int]()
		randomList2.reserveCapacity(operations)
		for _ in 0..<operations {
			randomList2.append(randomList[Int(arc4random_uniform(UInt32(randomList.count)))])
		}
		
		let startDate = Date()
		for i in randomList2 {
			map.get(i)
		}
		let elapsed = Date().timeIntervalSince(startDate)
		return elapsed/Double(operations)
	}
	
	func testMap<BenchMap: Map> (_ map: inout BenchMap, _ randomList: [Int], _ randomList2: [Int]) -> (setTime: Double, getTime: Double) where BenchMap.Key == Int, BenchMap.Value == Int { //tests the average operation time for set and get for a given map and returns them
		fillMap(&map, randomList)
		let setTime = testSetFunc (&map, randomList, randomList2)
		let getTime = testGetFunc(&map, randomList, randomList2.count)
		return (setTime, getTime)
	}
	
	func test3Maps (_ mapSize: Int, _ operations: Int) -> (linearMap: (setTime: Double, getTime: Double), binaryMap: (setTime: Double, getTime: Double), hashMap: (setTime: Double, getTime: Double)) { //returns the average set time and average get time for maps of size mapSize doing operations number of operations
		let randomList = makeRandomList(mapSize)
		let randomList2 = makeRandomList(operations)
		
		let hashMapSize = 2 * mapSize
		
		var lm = LinearMap<Int, Int>()
		var bm = BinaryMap<Int, Int>()
		var hm = HashMap<Int, Int>(initialArraySize: hashMapSize)
		
		
		let lmResults = testMap(&lm, randomList, randomList2)
		let bmResults = testMap(&bm, randomList, randomList2)
		let hmResults = testMap(&hm, randomList, randomList2)
		
		return (lmResults, bmResults, hmResults)
	}
	
	func printedTest3Maps (_ mapSize: Int, _ operations: Int) {
		let data = test3Maps(mapSize, operations)
		print("linearMapSet: \(mapSize), \(data.linearMap.setTime)")
		print("linearMapGet: \(mapSize), \(data.linearMap.getTime)")
		print("binaryMapSet: \(mapSize), \(data.binaryMap.setTime)")
		print("binaryMapGet: \(mapSize), \(data.binaryMap.getTime)")
		print("hashMapSet: \(mapSize), \(data.hashMap.setTime)")
		print("hashMapGet: \(mapSize), \(data.hashMap.getTime)")
	}
	
	func filedTest3Maps (_ mapSize: Int, _ operations: Int, at directory: String) {
		let data = test3Maps(mapSize, operations)
		updateFile(directory, "linearMapSet.csv", write: "\(mapSize), \(data.linearMap.setTime)")
		updateFile(directory, "linearMapGet.csv", write: "\(mapSize), \(data.linearMap.getTime)")
		updateFile(directory, "binaryMapSet.csv", write: "\(mapSize), \(data.binaryMap.setTime)")
		updateFile(directory, "binaryMapGet.csv", write: "\(mapSize), \(data.binaryMap.getTime)")
		updateFile(directory, "hashMapSet.csv", write: "\(mapSize), \(data.hashMap.setTime)")
		updateFile(directory, "hashMapGet.csv", write: "\(mapSize), \(data.hashMap.getTime)")
		
		
		
	}
	
	func updateFile (_ directory: String, _ fileName: String, write data: String) {
		var maybeFile = FileHandle(forUpdatingAtPath: directory + "/" + fileName)
		if maybeFile == nil {
			FileManager.default.createFile(atPath: directory + "/" + fileName, contents: nil, attributes: nil)
			maybeFile = FileHandle(forUpdatingAtPath: directory + "/" + fileName)
		}
		let file = maybeFile!
		file.seekToEndOfFile()
		let toWrite = data + "\n"
		file.write(toWrite.data(using: String.Encoding.utf8)!)
		file.closeFile()
	}
}
