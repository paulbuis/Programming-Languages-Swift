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