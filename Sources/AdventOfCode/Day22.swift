import Foundation

struct Day22: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
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
  }

  func generate(from secret: Secret) -> Secret {
    var secret = secret
    secret = secret.mix(secret.rawValue * 64)
    secret = secret.prune()
    secret = secret.mix(secret.rawValue / 32)
    secret = secret.prune()
    secret = secret.mix(secret.rawValue * 2048)
    secret = secret.prune()
    return secret
  }
}

private extension Day22 {
  var entities: [Int] {
    data.split(separator: "\n")
      .compactMap { Int(String($0)) }
  }
}
