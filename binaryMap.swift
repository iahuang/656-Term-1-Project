struct BinaryMap <K : Comparable, V> : CustomStringConvertible {
    var count = 0
    var keys = [K?]()
    var values = [V?]()

    func cleanUnwrap(_ k:Any?) -> String {
        if let realK = k {
            return String(describing: realK)
        }
        return "nil"
    }

    var description: String {
       var output = "{"
       for (i, k) in keys.enumerated() {
           let v = values[i]
           output+="\(cleanUnwrap(k)): \(cleanUnwrap(v))"
           if i < keys.count - 1 {
               output+=", "
           }
       }
       return output+"}"
    }

    subscript(_ k: K) -> V? {
        get {
            return self.get(k)
        }
        set(v) {
            self.set(k,v: v!)
        }
    }
    
    mutating func set (_ k: K, v: V) {
        if let index = getIndex(k) {
            values[index] = v
        } else {

            var insertIndex = keys.count

            for (index, n) in keys.enumerated() {
                if (k > n!) {
                    insertIndex = index
                    break
                }
            }

            keys.insert(k, at: insertIndex)
            values.insert(v, at: insertIndex)
            count+=1
        }
    }

    func get (_ k: K) -> V? {
        if let index = getIndex(k) {
            return values[index]
        }
        return nil
    }

    func getIndex (_ k: K) -> Int? {
        return _getIndex(k, 0, keys.count)
    }

    func _getIndex(_ k: K, _ lower: Int, _ upper: Int) -> Int? {
        if upper == lower {
            return nil
        } else {
            let middle = (lower+upper)/2
            if k < keys[middle]! {
                return _getIndex(k, middle+1, upper)
            } else if k > keys[middle]! {
                return _getIndex(k, lower, middle)
            } else {
                return middle
            }
        }
    }
    
}