import Foundation

func gcd<I>(_ a: I, _ b: I) -> I where I: BinaryInteger {
  precondition(a > 0 && b >= 0)
  return b == 0 ? a : gcd(b, a % b)
}

func gcd<I>(_ nums: [I]) -> I where I: BinaryInteger {
  var num = nums[0]
  for i in nums {
    num = gcd(num, i)
  }
  return num
}

func lcm<I>(_ a: I, _ b: I) -> I where I: BinaryInteger {
  precondition(a > 0 && b >= 0)
  return a * b / gcd(a, b)
}

func lcm<I>(_ nums: [I]) -> I where I: BinaryInteger {
  nums.reduce(1) { lcm($0, $1) }
}
