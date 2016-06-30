import Glibc

struct StopWatch {
    private let billion : Int64 = 1000000000
    private let clockResolution : Float // seconds per tick
    private var t0  : Glibc.timespec = Glibc.timespec()
    private var errorFlag : Int32
    private var t1  : Glibc.timespec = Glibc.timespec()
    private let timeScale : Float

    init(timeScale : Float = 1.0) {
        self.timeScale = timeScale
        var tv_res : Glibc.timespec = Glibc.timespec()
        errorFlag = Glibc.clock_getres(Glibc.CLOCK_THREAD_CPUTIME_ID, &tv_res)
        clockResolution = Float(Int64(tv_res.tv_sec) * billion + Int64(tv_res.tv_nsec))/Float(billion)
    }

    mutating func start() -> Void {
        if errorFlag == 0 {
            errorFlag = Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t0)
        }
        t1 = Glibc.timespec()
    }

    mutating func stop() -> Void {
        if errorFlag == 0 {
            errorFlag = Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t1)
        }
    }

    var elapsed : Float? {
        get {
            if (errorFlag != 0) {
                return nil
            }
            let nano0 = Int64(t0.tv_sec)*billion + Int64(t0.tv_nsec)
            let nano1 = Int64(t1.tv_sec)*billion + Int64(t1.tv_nsec)
            if nano1 == 0 || nano0 == 0 {
                return nil
            }
            return Float(nano1 - nano0) * clockResolution / timeScale
        }
    }
}


func getFib() -> (UInt -> UInt64) {
    var memo : [UInt64] = [0, 1]
    memo.reserveCapacity(100)
    print("memo.capacity is \(memo.capacity)")
    func fib(n: UInt) -> UInt64 {
        if n >= UInt(memo.count) {
            memo.append(fib(n-1) + fib(n-2))
        }
        return memo[Int(n)]
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

t.start()
let f50a = f(50)
t.stop()
print("fib(50): \(f50a)")
print("elapsed time: \(t.elapsed!) microseconds\n")

let fib2 = getFib()
t.start()
let f50b = fib2(50)
t.stop()
print("fib(50): \(f50b)")
print("elapsed time: \(t.elapsed!) microseconds")
