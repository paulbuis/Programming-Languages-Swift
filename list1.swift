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

public struct List<T> {
    private typealias Node = ListNode<T>
    private let headRef: Node?
    
    private init(_ headRef: Node? = nil) {
        self.headRef = headRef
    }


    public init(_ head: T, _ tail: List<T>? = nil) {
        headRef = Node(head, tail?.headRef)
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

    static func cons(_ head: T, _ tail: List<T>? = nil) -> List<T> {
        return List<T>(Node(head, tail?.headRef))
    }
}

let one = List(1)
let two = List(2)
let list = List.cons(1, two)
print(one.head!)
print(two.tail!)
print(list.head!)
print(list.tail!.head!)
print(one.length)
print(list.length)