import Algorithms
import Foundation

struct Day22: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let entities = self.entities
    let secrets = entities.map(Secret.init(rawValue:))

    var sum = 0
    for secret in secrets {
      var secret = secret
      for _ in 0..<2000 {
        secret = secret.generate()
      }
      sum += secret.rawValue
    }

    return sum
  }

  func part2() async throws -> Any {
    let entities = self.entities
    let secrets = entities.map(Secret.init(rawValue:))
    let prices = secrets.map { self.prices(from: $0, count: 2000) }
    let changes = prices.map(changes(with:))

    let aggregates = changes.reduce(into: [String: Int]()) {
      for key in $1.keys {
        $0[key, default: 0] += $1[key] ?? 0
      }
    }
    return aggregates.values.max() ?? 0
  }
}

extension Day22 {
  struct Secret {
    var rawValue: Int

    func mix(_ number: Int) -> Secret {
      Secret(rawValue: rawValue ^ number)
    }

    func prune() -> Secret {
      Secret(rawValue: rawValue % 16777216)
    }

    func generate() -> Secret {
      var secret = self
      secret = secret.mix(secret.rawValue * 64)
      secret = secret.prune()
      secret = secret.mix(secret.rawValue / 32)
      secret = secret.prune()
      secret = secret.mix(secret.rawValue * 2048)
      secret = secret.prune()
      return secret
    }
  }
}

private extension Day22 {
  var entities: [Int] {
    data.split(separator: "\n")
      .compactMap { Int(String($0)) }
  }

  struct Price {
    var digit: Int
    var change: Int
  }
}

private extension Day22 {
  func prices(from secret: Secret, count: Int) -> [Price] {
    var secret = secret
    var previous = secret.rawValue % 10
    var prices: [Price] = []
    for _ in 0..<count {
      secret = secret.generate()
      let digit = secret.rawValue % 10
      prices.append(Price(digit: digit, change: digit - previous))
      previous = digit
    }

    return prices
  }

  func changes(with prices: [Price]) -> [String: Int] {
    var dictionary: [String: Int] = [:]
    for window in prices.windows(ofCount: 4) {
      let key = window.map { "\($0.change)" }.joined(separator: ",")
      if dictionary[key] != nil {
        continue
      }
      dictionary[key] = window.last!.digit
    }
    return dictionary
  }
}
