[About Swift](./AboutSwift.html)

#Simple Programming Exercises in Swift

##Kata 0

###Level 0: Say "Hello World"
```swift
print("Hello World")
```

With this code in kata0-0.swift run
```bash
swift kata0-0.swift
```
at the command prompt to have the code run by the interpreter.

Alternatively, run the commands
```bash
swiftc -o kata0-0 kata0-0.swift
./kata0-0
to first compile & link the source code to form an executable and then
run the executable in the current directory.


###Level 1: Say hello to someone specific
```swift
func hello(name: String, _ greeting: String = "Hello") -> Void {
    print("\(greeting), \(name)!")
}

hello("Paul")
hello("Bob", "Hola")
```

This code illustrates defining and calling a function. The function has a default parameter, so 
can be called with one or two paramters. If called with one parameter, it will behave as if the
default value for the second parameter had been used.

The print statement illustrates [string interpolation](https://en.wikipedia.org/wiki/String_interpolation),
where values of specially delimited expresssions
are converted to strings and inserted in the place of the delimited expression.

###Level 3: Print the time of day

```swift
import Glibc

// simplistic wrapper for Glibc.time() function
func time() -> Int {
    var t : Glibc.time_t = 0;
    Glibc.time(&t)
    return t;
}

// simplistic threadsafe wrapper for Glibc.localtime function
func localtime(t : Int) -> Glibc.tm  {
    var copy = t
    var result : Glibc.tm = Glibc.tm()
    localtime_r(&copy, &result)
    return result;
}

// function to trim newline off of a raw C String
func trimNewline(psb : UnsafeMutablePointer<Int8>) -> Void {
    let newline : Int8 = 10
    var pch = psb
    while (pch.memory != 0) {
        if (pch.memory == newline) {
            pch.memory = 0
            break;
        }
        pch = pch + 1 // mutation of a pointer to unmanaged memory
    }
}

// simplistic threadsafe wrapper for Glibc.asctime function
func asctime(tm:Glibc.tm) -> String? {
    var copy = tm
    let buf : UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.alloc(26)
    Glibc.asctime_r(&copy, buf)
    trimNewline(buf)
    let result = String.fromCString(buf)
    buf.dealloc(26) // manually deallocate, since manually allocated
    return result
}

func ctime() -> String? {
    return asctime(localtime(time()))
}

let timeStr = ctime()!
print(timeStr)
```

This illustrates Swift code invoking code from the GNU C library `Glib`. `time()`, `localtime()`, `asctime()`,
and `ctime()` all wrap functions provided by the `Glibc` module to provide functionality similar to the similarly
named functions in that module that is more in line with Swift idioms.

We see here function definition syntax and declaration of local identifiers. The `let` keyword indicates the identifer
may not be the target of an assignment statement. The `var` keyword indicates that the identifier may be.
Note some type declarations include type annotations and others are having their type inferred from the type of
their initializing expressions.

The `?` after type names indicates the result is an "option" which may have the value `nil`. The `!` "forces" the option
and will generate a run-time error if the value is `nil`.

The `UnsafeMutablePointer<Int8>` is a pointer to 8-bit integer values. In this case, they represent characters in a
null-terminated C-style string. The pointer refers to data that is not being managed by the Swift memory manager and
no index-out-of-bounds runtime checks are done. The data being pointed to is "mutable" and can be changed. `trimNewline()`
makes such a change by replacing a newline with a 0 (null) value to terminate the string earlier. Note it also does
pointer arithmetic with the value of `pch`.


##Kata 1

##Kata 2

##Kata 3

##Kata 4

##Linked Lists
