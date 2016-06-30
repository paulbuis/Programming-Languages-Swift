struct IntReader :SequenceType {

    class IntGenerator : GeneratorType {
        typealias Element = Int
        func next() -> Int? {
            let line : String? = readLine()
            if (line == nil) {
                return nil
            } 
        return Int(line!)
        }
    }
    typealias Generator = IntGenerator
    func generate() -> Generator {
        return IntGenerator()
    }
}


func averageOf<S : SequenceType where S.Generator.Element == Int>(values : S) -> Double? {
    var sum : Int = 0
    var count : Int = 0
    for x in values {
        sum += x
        count += 1
        print(sum)
    }
    if count == 0 {
        return nil
    }
    return Double(sum)/Double(count)
}

let average = averageOf(IntReader())
if average == nil {
    print("no data to averge")
}
else {
    print(average!)
}