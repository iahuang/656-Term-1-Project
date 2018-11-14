//
//  benchMarker.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/4/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

class BenchMarker {
	
	let n: Int
	let operations: Int
	let directory: String
	
	var randomList: [Int] = []
	var extraList: [Int] = []
	var shuffledList: [Int] = []
	
	lazy var lm: LinearMap<Int, Int> = {
		var out = LinearMap<Int, Int>()
		fillMap(&out)
		return out
	}()
	
	lazy var bm: BinaryMap<Int, Int> = {
		var out = BinaryMap<Int, Int>()
		fillMap(&out)
		return out
	}()
	
	lazy var hm: HashMap<Int, Int> = {
		var out = HashMap<Int, Int>()
		fillMap(&out)
		return out
	}()
	
	init (n: Int, operations: Int, directory: String) {
		self.n = n
		self.operations = operations
		self.directory = directory
		
		randomList = makeRandomList(n)
		extraList = makeRandomList(operations)
		shuffledList = makeShuffledList(from: randomList, count: operations)
	}
	
	enum OperationType {
		case add
		case update
		case get
	}
	
	enum MapType {
		case linearMap
		case binaryMap
		case hashMap
	}
	
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
	
	func fillMap <BenchMap: BenchMapProtocol> (_ map: inout BenchMap){
		for i in randomList {
			map.set(i, i)
		}
	}
	
	func testAddFunc <BenchMap: BenchMapProtocol> (_ map: inout BenchMap) -> Double {
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
	
	func testUpdateFunc <BenchMap: BenchMapProtocol> (_ map: inout BenchMap) -> Double {
		let startDate = Date()
		for i in shuffledList {
			map.set(i, i)
		}
		let elapsed = Date().timeIntervalSince(startDate)
		return elapsed/Double(shuffledList.count)
	}
	
	func testGetFunc<BenchMap: BenchMapProtocol> (_ map: inout BenchMap) -> Double {
		let startDate = Date()
		for i in shuffledList {
			map.get(i)
		}
		let elapsed = Date().timeIntervalSince(startDate)
		return elapsed/Double(shuffledList.count)
	}
	
	func writeAddTest <BenchMap: BenchMapProtocol> (_ map: inout BenchMap) {
		let fileName = generateFileNameFor(map: &map, operation: .add)
		let toWrite = "\(n), \(testAddFunc(&map))"
		
		updateFile(fileName, data: toWrite)
	}
	
	func writeUpdateTest <BenchMap: BenchMapProtocol> (_ map: inout BenchMap) {
		let fileName = generateFileNameFor(map: &map, operation: .update)
		let toWrite = "\(n), \(testUpdateFunc(&map))"
		
		updateFile(fileName, data: toWrite)
	}
	
	func writeGetTest <BenchMap: BenchMapProtocol> (_ map: inout BenchMap) {
		let fileName = generateFileNameFor(map: &map, operation: .get)
		let toWrite = "\(n), \(testGetFunc(&map))"
		
		updateFile(fileName, data: toWrite)
	}
	
	func runTest (_ map: MapType, _ operation: OperationType) { //I had to use nested switch statements because swift didn't like my generics.  Any other way, including helper functions, caused an error.  Please don't take off points here.  Swift forced me to do it.
		switch map {
		case .linearMap:
			switch operation {
			case .add:
				writeAddTest(&lm)
			case .update:
				writeUpdateTest(&lm)
			case .get:
				writeGetTest(&lm)
			}
		case .binaryMap:
			switch operation {
			case .add:
				writeAddTest(&bm)
			case .update:
				writeUpdateTest(&bm)
			case .get:
				writeGetTest(&bm)
			}
		case .hashMap:
			switch operation {
			case .add:
				writeAddTest(&hm)
			case .update:
				writeUpdateTest(&hm)
			case .get:
				writeGetTest(&hm)
			}
		}
	}
	
	func updateFile (_ fileName: String, data: String) {
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
	
	func generateFileNameFor <BenchMap: BenchMapProtocol> (map: inout BenchMap, operation: OperationType) -> String {
		var fileName = ""
		
		switch map.myType {
		case "LinearMap<Int, Int>":
			fileName += "linearMap"
		case "BinaryMap<Int, Int>":
			fileName += "binaryMap"
		case "HashMap<Int, Int>":
			fileName += "hashMap"
		default:
			fileName += "This isn't a linear, binary, or hash map so idk what just happened"
		}
		
		switch operation {
		case .add:
			fileName += "Add"
		case .update:
			fileName += "Update"
		case .get:
			fileName += "Get"
		}
		
		fileName += ".csv"
		return fileName
	}
}
