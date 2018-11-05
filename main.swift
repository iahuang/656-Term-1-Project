func time() -> Double { // Returns Unix epoch time
    return Date().timeIntervalSince1970
}
func testSetFunc<BenchMap: Map> (_ map: inout BenchMap, length: Int, iters: Int) -> [Double] where BenchMap.Key == Int, BenchMap.Value == Int {
    // The final dataset. Index is the number of items (n) and
    // the value is the average time it took to perform a set operation 
    // over [iters] iterations.

    var results = Array<Double>(repeating: 0, count: length)

    for _ in 1...iters {
        for i in 1...length {
            var startTime = time()
            map.set(i, i+1) // Use dummy data, in this case simply the index:index+1
            var elapsed = time()-startTime

            results[i-1] = Double(elapsed)/Double(iters)
        }
        map.clear()
    }
    return results
}

