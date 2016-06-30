func factorial(n:Int32) -> Int64 {
    if n == 0 {
        return 1
    }
    else {
        return Int64(n)*factorial(n-1)
    }
}

print("0! = \(factorial(0))")
print("1! = \(factorial(1))")
print("2! = \(factorial(2))")
print("5! = \(factorial(5))")
print("20! = \(factorial(20))")
//print("50! = \(factorial(50))")