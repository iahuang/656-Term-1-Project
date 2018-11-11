import Foundation

let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath + "/data"
let benchMarker = BenchMarker()
benchMarker.filedTest3Maps(10, 100, at: path)
benchMarker.filedTest3Maps(100, 100, at: path)
benchMarker.filedTest3Maps(1000, 100, at: path)
benchMarker.filedTest3Maps(10000, 100, at: path)
benchMarker.filedTest3Maps(100000, 100, at: path)
