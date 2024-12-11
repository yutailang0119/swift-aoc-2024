import Foundation

struct Day11: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let stones = self.entities
    return count(for: stones, to: 25)
  }
}

private extension Day11 {
  var entities: [Int] {
    data.split(separator: " ").compactMap {
      Int($0.trimmingCharacters(in: .newlines))
    }
  }

  func rearrangement(for stones: [Int], to count: Int) -> [Int] {
    var dictionary: [Int: Divided] = [:]
    var stns = stones
    for i in 0..<count {
      let s = stns.reduce(into: [Int]()) {
        if let divided = dictionary[$1] {
          $0.append(divided.leading)
          if let trailing = divided.trailing {
            $0.append(trailing)
          }
        } else {
          let divided = $1.divided
          $0.append(divided.leading)
          if let trailing = divided.trailing {
            $0.append(trailing)
          }
          dictionary[$1] = divided
        }
      }
      stns = s
    }
    return stns
  }

  func count(for stones: [Int], to count: Int) -> Int {
    func rearrangement(_ stns: [Int: Int]) -> [Int: Int] {
      var outputs = [Int: Int]()
      for stn in stns {
        if stn.key == 0 {
          outputs[1, default: 0] += stn.value
          continue
        }
        let text = "\(stn.key)"
        let digits = text.count
        if digits.isMultiple(of: 2) {
          let center = digits / 2
          outputs[Int(text.prefix(center))!, default: 0] += stn.value
          outputs[Int(text.suffix(center))!, default: 0] += stn.value
        } else {
          outputs[stn.key * 2024, default: 0] += stn.value
        }
      }
      return outputs
    }

    var dictionary: [Int: Int] = Dictionary(grouping: stones) { $0 }.mapValues(\.count)
    for _ in 0..<count {
      dictionary = rearrangement(dictionary)
    }
    return dictionary.values.reduce(0, +)
  }
}

private extension Int {
  var divided: (leading: Int, trailing: Int?) {
    guard self != 0 else {
      return (1, nil)
    }
    let text = "\(self)"
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
