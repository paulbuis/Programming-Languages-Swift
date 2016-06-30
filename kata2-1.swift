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

func averageOf<S : SequenceType where S.Generator.Element == Int>(values : S) -> Double? {
    var sum : Int = 0
    var count : Int = 0
    for x in values {
        sum += x
        count += 1
    }
    if count == 0 {
        return nil
    }
    return Double(sum)/Double(count)
}

let values = readInts()
let average = averageOf(values)
if average == nil {
    print("no data to averge")
}
else {
    print(average!)
}