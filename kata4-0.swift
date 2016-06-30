import Glibc

struct StopWatch {
    internal let billion : Int64 = 1000000000
    let clockResolution : Double // seconds per tick
    var t0  : Glibc.timespec = Glibc.timespec()
    var t1  : Glibc.timespec = Glibc.timespec()

    init() {
        var tv_res : Glibc.timespec = Glibc.timespec()
        Glibc.clock_getres(Glibc.CLOCK_THREAD_CPUTIME_ID, &tv_res)
        clockResolution = Double(Int64(tv_res.tv_sec) * billion + Int64(tv_res.tv_nsec))/Double(billion)
    }

    mutating func start() -> Void {
        Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t0)
        t1 = Glibc.timespec()
    }

    mutating func stop() -> Void {
        Glibc.clock_gettime(Glibc.CLOCK_THREAD_CPUTIME_ID, &t1)
    }

    var elapsed : Double? {
        get {
            let nano0 = Int64(t0.tv_sec)*billion + Int64(t0.tv_nsec)
            let nano1 = Int64(t1.tv_sec)*billion + Int64(t1.tv_nsec)
            let diff = nano1 - nano0
            if nano1 == 0 || nano0 == 0 {
                return nil
            }
            return Double(diff) * clockResolution
        }
    }
}


func getFib() -> (UInt -> UInt64) {
    func fib(n: UInt) -> UInt64 {
        if n < 2 {
            return UInt64(n)
        }
        else {
            return fib(n-1) + fib(n-2)
        }
    }
    return fib
}

let f = getFib()
print("fib(1): \(f(1))")
print("fib(2): \(f(2))")
print("fib(3): \(f(3))")
print("fib(5): \(f(5))")
print("fib(10): \(f(10))")

var t : StopWatch = StopWatch()
t.start()
let f20 = f(20)
t.stop()
print("fib(20): \(f20)")
print("elapsed time \(t.elapsed!) seconds")

t.start()
let f30 = f(30)
t.stop()
print("fib(30): \(f30)")
print("elapsed time \(t.elapsed!) seconds")

t.start()
let f40 = f(40)
t.stop()
print("fib(40): \(f40)")
print("elapsed time \(t.elapsed!) seconds")

/*
t.start()
let f50 = f(50)
t.stop()
print("fib(50): \(f50)")
print("elapsed time \(t.elapsed!) seconds")
*/