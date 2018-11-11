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
			randomList.append(Int.random(in: Int.min...Int.max))
		}
		return randomList
	}
	
	func makeShuffledList <Element> (from list: [Element], count: Int) -> [Element] {
		var shuffledList = [Element]()
		shuffledList.reserveCapacity(count)
		for _ in 0..<count {
			shuffledList.append(list[Int.random(in: 0..<list.count)])
		}
		return shuffledList
	}
	
	func fillMap<BenchMap: Map> (_ map: inout BenchMap, with list: [Int]) where BenchMap.Key == Int, BenchMap.Value == Int {
		for i in list {
			map.set(i, i)
		}
	}
	
	func testAddFunc<BenchMap: Map> (_ map: inout BenchMap, for extraList: [Int]) -> Double where BenchMap.Key == Int, BenchMap.Value == Int {
		var time: Double = 0
		for i in extraList {
			var mapCopy = map
			let startDate = Date()
			mapCopy.set(i, i)
			let elapsed = Date().timeIntervalSince(startDate)
			time += elapsed
		}
		return time/Double(extraList.count)
	}
	
	func testUpdateFunc<BenchMap: Map> (_ map: inout BenchMap, for shuffledList: [Int]) -> Double where BenchMap.Key == Int, BenchMap.Value == Int {
		let startDate = Date()
		for i in shuffledList {
			map.set(i, i)
		}
		let elapsed = Date().timeIntervalSince(startDate)
		return elapsed/Double(shuffledList.count)
	}
	
	func testGetFunc<BenchMap: Map> (_ map: inout BenchMap, for shuffledList: [Int]) -> Double where BenchMap.Key == Int, BenchMap.Value == Int {
		let startDate = Date()
		for i in shuffledList {
			map.get(i)
		}
		let elapsed = Date().timeIntervalSince(startDate)
		return elapsed/Double(shuffledList.count)
	}
	
	func testMap<BenchMap: Map> (_ map: inout BenchMap, fillerList: [Int], extraList: [Int], shuffledList: [Int]) -> mapTimes where BenchMap.Key == Int, BenchMap.Value == Int {
		fillMap(&map, with: fillerList)
		let addTime = testAddFunc (&map, for: extraList)
		let updateTime = testUpdateFunc(&map, for: shuffledList)
		let getTime = testGetFunc(&map, for: shuffledList)
		return (addTime, updateTime, getTime)
	}
	
	typealias mapTimes = (addTime: Double, updateTime: Double, getTime: Double)
	
	func test3Maps (_ mapSize: Int, _ operations: Int) -> (linearMap: mapTimes, binaryMap: mapTimes, hashMap: mapTimes) {
		let fillerList = makeRandomList(mapSize)
		let extraList = makeRandomList(operations)
		let shuffledList = makeShuffledList(from: fillerList, count: operations)
		
		let hashMapSize = 2 * mapSize
		
		var lm = LinearMap<Int, Int>()
		var bm = BinaryMap<Int, Int>()
		var hm = HashMap<Int, Int>(initialArraySize: hashMapSize)
		
		
		let lmResults = testMap(&lm, fillerList: fillerList, extraList: extraList, shuffledList: shuffledList)
		let bmResults = testMap(&bm, fillerList: fillerList, extraList: extraList, shuffledList: shuffledList)
		let hmResults = testMap(&hm, fillerList: fillerList, extraList: extraList, shuffledList: shuffledList)
		
		return (lmResults, bmResults, hmResults)
	}
	
	func filedTest3Maps (_ mapSize: Int, _ operations: Int, at directory: String) {
		let data = test3Maps(mapSize, operations)
		updateFile(directory, "linearMapAdd.csv", write: "\(mapSize), \(data.linearMap.addTime)")
		updateFile(directory, "linearMapUpdate.csv", write: "\(mapSize), \(data.linearMap.updateTime)")
		updateFile(directory, "linearMapGet.csv", write: "\(mapSize), \(data.linearMap.getTime)")
		
		updateFile(directory, "binaryMapAdd.csv", write: "\(mapSize), \(data.binaryMap.addTime)")
		updateFile(directory, "binaryMapUpdate.csv", write: "\(mapSize), \(data.binaryMap.updateTime)")
		updateFile(directory, "binaryMapGet.csv", write: "\(mapSize), \(data.binaryMap.getTime)")
		
		updateFile(directory, "hashMapAdd.csv", write: "\(mapSize), \(data.hashMap.addTime)")
		updateFile(directory, "hashMapUpdate.csv", write: "\(mapSize), \(data.hashMap.updateTime)")
		updateFile(directory, "hashMapGet.csv", write: "\(mapSize), \(data.hashMap.getTime)")
		
		
		
	}
	
	func updateFile (_ directory: String, _ fileName: String, write data: String) {
		var maybeFile = FileHandle(forUpdatingAtPath: directory + "/" + fileName)
		if maybeFile == nil {
			FileManager.default.createFile(atPath: directory + "/" + fileName, contents: nil, attributes: nil)
			maybeFile = FileHandle(forUpdatingAtPath: directory + "/" + fileName)
		}
		guard let file = maybeFile else {
			print("Directory of file does not exist.")
			return
		}
		file.seekToEndOfFile()
		let toWrite = data + "\n"
		file.write(toWrite.data(using: String.Encoding.utf8)!)
		file.closeFile()
	}
}
