func readOneInt() -> Int? {
    let line : String? = readLine()
    if (line == nil) {
        return nil
    }
    let value = Int(line!)
    return value
}

func readInts() -> [Int] {
    var result : [Int] = []
    var value : Int? = readOneInt()
    while (value != nil) {
        result.append(value!)
        value = readOneInt()
    }
    return result
}

func averageOf<C : CollectionType where C.Generator.Element == Int, C.Index.Distance == Int>(values : C) -> Double? {
    if values.isEmpty {
        return nil
    }
    let sum : Int = values.reduce(0, combine:+)
    return Double(sum)/Double(values.count)
}

let values = readInts()
let average = averageOf(values)
if average == nil {
    print("no data to averge")
}
else {
    print(average!)
}