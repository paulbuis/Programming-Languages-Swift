


public class LazyValue<T> {
    var forced : Bool = false;
    public typealias Fun = ()->T
    var fun : Fun? = nil
    var value : T? = nil

    public init(_ f : Fun) {
        fun = f
    }

    public init(_ v : T) {
        forced = true
        value = v
    }

    public func force() -> T {
        if (!forced) {
            forced = true
            value = fun!();
        }
        return value!;
    }
}

public class List<T> : SequenceType {

    public typealias Generator = AnyGenerator<T>
    public typealias OptionalList = List<T>?
    public typealias OptionalClosure = ()->OptionalList
    public typealias ValueType = LazyValue<T?>
    public typealias NextType = LazyValue<OptionalList>

    private let value: ValueType
    private let next: NextType

    public init(_ h: T?,  fun t: OptionalClosure ) {
        value = ValueType(h)
        next = NextType(t)
    }

    public init(_ h: T?, _ t: OptionalList = nil ) {
        value = ValueType(h)
        next = NextType(t)
    }

    public func generate() -> AnyGenerator<T> {
        var node : List<T>? = self
        return AnyGenerator<T> {
            let result : T? = node?.head()
            node = node?.tail()
            return result
        }
    }

    public func head() -> T? {
        return value.force()
    }

    public func tail() -> List<T>? {
        return next.force()
    }

    public var length: UInt {
        get {
            var counter : UInt = 0
            var node : List<T>? = self
            while node != nil {
                counter = counter + 1
                node = node!.tail()
            }
            return counter 
        }
    }


//    public var match : ListMatcher<T> {
//        if headRef == nil {
//            return .Nil
//        }
//        return .Cons(value, next)
//    }

    static func cons(h: T, _ tail: List<T>?) -> List<T> {
        return List(h, tail)
    }

    static func cons(h: T, _ tail: OptionalClosure) -> List<T> {
        return List(h, fun: tail)
    }
}



var one = List(1)
var three = List(2)
print(one.head()!)

func foo() -> List<Int>? {
    let list = List<Int>.cons(2, foo);
    print("hi")
    return list
}
 
let list = List<Int>.cons(1, foo)
let t = list.tail();
print("bar")
//let doubleList = list.map({x in 2*x})
for x in t! {
    print(x)
}