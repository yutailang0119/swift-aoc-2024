import Foundation

struct Day11: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day11 {
  var entities: [Int] {
    data.split(separator: " ").compactMap {
      Int($0.trimmingCharacters(in: .newlines))
    }
  }
}

private extension Int {
  var divided: (leading: Int, trailing: Int?) {
    guard self != 0 else {
      return (1, nil)
    }
    let text = Array("\(self)")
    let digits = text.count
    if digits.isMultiple(of: 2) {
      let center = digits / 2
      let leading = text.prefix(center)
      let trailing = text.suffix(center)
      return (Int(String(leading))!, Int(String(trailing)))
    } else {
      return (self * 2024, nil)
    }
  }
}
