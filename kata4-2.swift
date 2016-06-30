import Glibc

public struct StopWatch {
    private static let billion : Int64 = 1000000000
    private static var clockResolution : Float = 1.0e-9 // seconds per tick
    private static var timerOverhead : Int64 = 0
    private static var token: Int = 0
    
    private var t0  : Glibc.timespec = Glibc.timespec()
    private var t1  : Glibc.timespec = Glibc.timespec()
    private var errorFlag : Int32 = 0
    private let timeScale : Float


    init(timeScale : Float = 1.0) {
        self.timeScale = timeScale
        if (StopWatch.token == 0) {
            StopWatch.token = 1 // multithreaded race condition
            var tv_res : Glibc.timespec = Glibc.timespec()
            Glibc.clock_getres(Glibc.CLOCK_THREAD_CPUTIME_ID, &tv_res)
            StopWatch.clockResolution = Float(Int64(tv_res.tv_sec) * StopWatch.billion + Int64(tv_res.tv_nsec))/Float(StopWatch.billion)
        
            var t0overhead = Glibc.timespec()
            var t1overhead = Glibc.timespec()
            Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t0overhead)
            Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t1overhead)
            Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t0overhead)
            Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t1overhead)
            StopWatch.timerOverhead = (Int64(t1overhead.tv_sec) * StopWatch.billion + Int64(t1overhead.tv_nsec)) - 
                (Int64(t0overhead.tv_sec) * StopWatch.billion + Int64(t0overhead.tv_nsec))
            print("timerOverhead= \(StopWatch.timerOverhead) nanoseconds")
        }
    }

    public mutating func start() -> Void {
        if errorFlag == 0 {
            errorFlag = Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t0)
        }
        t1 = Glibc.timespec()
    }

    public mutating func stop() -> Void {
        if errorFlag == 0 {
            errorFlag = Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t1)
        }
    }

    // elapsed is a "computed, read-only property"
    public var elapsed : Float? {
        get {
            if (errorFlag != 0) {
                return nil
            }
            let nano0 = Int64(t0.tv_sec)*StopWatch.billion + Int64(t0.tv_nsec)
            let nano1 = Int64(t1.tv_sec)*StopWatch.billion + Int64(t1.tv_nsec)
            if nano1 == 0 || nano0 == 0 {
                return nil
            }
            return Float(nano1 - nano0 - StopWatch.timerOverhead) * StopWatch.clockResolution / timeScale
        }
    }

    public static func time(body: Void->Void) -> Float {
        var t = StopWatch()
        t.start()
        body()
        t.stop()
        return t.elapsed!
    }
}


func getFib() -> (UInt -> UInt64) {

    func fib(n: UInt) -> UInt64 {
        var a : UInt64 = 0
        var b : UInt64 = 1
        var counter : UInt = 0
        while counter < n {
            counter = counter + 1
            let t = a
            a = b
            b = b + t
        }
        return a
    }

    return fib
}

let f = getFib()
print("fib(1): \(f(1))")
print("fib(2): \(f(2))")
print("fib(3): \(f(3))")
print("fib(5): \(f(5))")
print("fib(10): \(f(10))")

var t : StopWatch = StopWatch(timeScale: 0.000001)
t.start()
t.stop()
print("do nothing\nelapsed time: \(t.elapsed!) microseconds\n")

t.start()
let f20 = f(20)
t.stop()
print("fib(20): \(f20)")
print("elapsed time: \(t.elapsed!) microseconds\n")

t.start()
let f30 = f(30)
t.stop()
print("fib(30): \(f30)")
print("elapsed time: \(t.elapsed!) microseconds\n")

t.start()
let f40 = f(40)
t.stop()
print("fib(40): \(f40)")
print("elapsed time: \(t.elapsed!) microseconds\n")

t.start()
let f50 = f(50)
t.stop()
print("fib(50): \(f50)")
print("elapsed time: \(t.elapsed!) microseconds\n")

let fiba = getFib()
var fiba50 : UInt64 = 0
let time = StopWatch.time({
    fiba50 = fiba(50)
})
print("fib(50): \(fiba50)")
print("elapsed time: \(time) seconds\n")
