func time() -> Double { // Returns Unix epoch time
    return Date().timeIntervalSince1970
}
func testSetFunc<BenchMap: Map> (_ map: inout BenchMap, _ filter: Set<Int>, _ iters: Int) -> Dictionary<Int,Double> where BenchMap.Key == Int, BenchMap.Value == Int {
    var results = Dictionary<Int, Double>()
    
    for _ in 1...iters {
        for i in 1...filter.max()! {
            var startTime = time()
            map.set(i, i+1) // Use dummy data, in this case simply the index:index+1
            var elapsed = time()-startTime
            if filter.contains(i) {
                results[i-1] = Double(elapsed)/Double(iters)
            }
        }
        map.clear()
    }
    return results
}
func testSetFunc<BenchMap: Map> (_ map: inout BenchMap, _ length: Int, _ iters: Int) -> [Double] where BenchMap.Key == Int, BenchMap.Value == Int {
    // The final dataset. Index is the number of items (n) and
    // the value is the average time it took to perform a set operation 
    // over [iters] iterations.

    var results = Array<Double>(repeating: 0, count: length)

    for _ in 1...iters {
        for i in 1...length {
            var startTime = time()
            map.set(i, i+1) // Use dummy data, in this case simply the index:index+1
            var elapsed = time()-startTime

            results[i] = Double(elapsed)/Double(iters)
        }
        map.clear()
    }
    return results
}
var map1 = LinearMap<Int, Int>()
var results = testSetFunc(&map1, Set([10000]), 100)
print(results)
// let fileManager = FileManager.default
// let path = fileManager.currentDirectoryPath
// let benchMarker = BenchMarker()
// benchMarker.filedTest3Maps(100, 1000, at:path)
// benchMarker.filedTest3Maps(1000, 1000, at:path)
// benchMarker.filedTest3Maps(10000, 1000, at:path)
// benchMarker.filedTest3Maps(100000, 1000, at:path)
// benchMarker.filedTest3Maps(1000000, 1000, at:path)

