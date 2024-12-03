import Foundation
import RegexBuilder

struct Day03: AdventDay {
  var data: String

  func part1() async throws -> Any {
    data.muls
      .reduce(into: 0) { $0 += $1.left * $1.right }
  }

  func part2() async throws -> Any {
    var donts = data.split(separator: "don't()")
    var dos: [String] = [String(donts.removeFirst())]
    for dont in donts {
      for d in dont.split(separator: "do()").dropFirst() {
        dos.append(String(d))
      }
    }

    let muls: [Mul] = dos.flatMap(\.muls)

    return muls.reduce(into: 0) { $0 += $1.left * $1.right }
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
