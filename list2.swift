private class ListNode<T> {
    private let next: ListNode?
    private let value: T

    private init(_ value:T, _ next:ListNode? = nil) {
        self.next = next
        self.value = value
    }
}

public enum ListMatcher<T> {
	case Nil
	case Cons(T, List<T>)
}

public class ListGenerator<T>: GeneratorType {
    private var node: ListNode<T>?

    private init(_ head: ListNode<T>?) {
        node = head;
    }

    public func next() -> T? {
        let value = self.node?.value
        self.node = self.node?.next;
        return value
    }
}

public struct List<T> : SequenceType {
    private typealias Node = ListNode<T>
    public typealias Generator = ListGenerator<T>
    private let headRef: Node?
    
    private init(_ headRef: Node? = nil) {
        self.headRef = headRef
    }


    public init(_ head: T, _ tail: List<T>? = nil) {
        headRef = Node(head, tail?.headRef)
    }

    public func generate() -> Generator {
        return ListGenerator<T>(headRef)
    }

    public var head: T? {
        get {
            return headRef?.value
        }
    }

    public var tail: List<T>? {
        get {
            if headRef == nil {
                return nil;
            }
            return List<T>(headRef!.next)
        }
    }

    public var length: UInt {
        get {
            var counter : UInt = 0
            var node : Node? = headRef
            while node != nil {
                counter = counter + 1
                node = node!.next
            }
            return counter 
        }
    }


//    public var match : ListMatcher<T> {
//        if headRef == nil {
//            return .Nil
//        }
//        return .Cons(headRef!.value, headRef!.next)
//    }

    static func cons(head: T, _ tail: List<T>? = nil) -> List<T> {
        return List<T>(Node(head, tail?.headRef))
    }
}

let one = List(1)
let two = List(2)
let list = List.cons(1, two)
let doubleList = list.map({x in 2*x})
for x in doubleList {
    print(x)
}