import Foundation

let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath + "/data"
let benchMarkers = [BenchMarker(n: 10, operations: 100, directory: path),
					BenchMarker(n: 100, operations: 100, directory: path),
					BenchMarker(n: 1000, operations: 100, directory: path),
					BenchMarker(n: 10000, operations: 100, directory: path),
					BenchMarker(n: 10000, operations: 100, directory: path)
]

func runAllBenchMarks (_ benchMarker: BenchMarker) {
	benchMarker.runTest(.linearMap, .add)
	benchMarker.runTest(.linearMap, .update)
	benchMarker.runTest(.linearMap, .get)
	
	benchMarker.runTest(.binaryMap, .add)
	benchMarker.runTest(.binaryMap, .update)
	benchMarker.runTest(.binaryMap, .get)
	
	benchMarker.runTest(.hashMap, .add)
	benchMarker.runTest(.hashMap, .update)
	benchMarker.runTest(.hashMap, .get)
}

for benchMarker in benchMarkers {
	benchMarker.runTest(.binaryMap, .update)
}
