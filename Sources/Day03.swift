import Foundation
import RegexBuilder

struct Day03: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day03 {
  struct Mul {
    var left: Int
    var right: Int
  }
}

private extension String {
  var muls: [Day03.Mul] {
    let regex = Regex {
      One("mul")
      One("(")
      Capture {
        ZeroOrMore(.digit)
      }
      One(",")
      Capture {
        ZeroOrMore(.digit)
      }
      One(")")
    }

    return matches(of: regex).compactMap { matched in
      guard let left = Int(matched.output.1),
        let right = Int(matched.output.2)
      else {
        return nil
      }
      return Day03.Mul(left: left, right: right)
    }
  }
}
