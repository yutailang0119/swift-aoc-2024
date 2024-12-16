import Foundation

struct Day11: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let stones = self.entities
    return count(for: stones, to: 25)
  }

  func part2() async throws -> Any {
    let stones = self.entities
    return count(for: stones, to: 75)
  }
}

private extension Day11 {
  var entities: [Int] {
    data.split(separator: " ").compactMap {
      Int($0.trimmingCharacters(in: .newlines))
    }
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
