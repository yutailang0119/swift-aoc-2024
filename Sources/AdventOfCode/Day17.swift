import Foundation

struct Day17: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day17 {
  struct Computer {
    enum Operand: Int {
      case adv = 0
      case bxl
      case bst
      case jnz
      case bxc
      case out
      case bdv
      case cdv
    }

    var registerA: Int
    var registerB: Int
    var registerC: Int
    var program: [Operand]
  }
}
