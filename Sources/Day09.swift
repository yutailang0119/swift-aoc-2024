import Foundation

struct Day09: AdventDay {
  var data: String

  var entities: [Int] {
    data.compactMap { Int(String($0)) }
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day09 {
  struct DiskMap: CustomStringConvertible {
    var blocks: [Block]

    var checksum: Int {
      var checksum = 0
      for (offset, block) in blocks.enumerated() {
        checksum += offset * block.num
      }
      return checksum
    }

    var description: String {
      blocks.map(\.description).joined()
    }
  }

  enum Block: CustomStringConvertible {
    case number(Int)
    case space

    var isSpace: Bool {
      switch self {
      case .number: return false
      case .space: return true
      }
    }

    var num: Int {
      switch self {
      case .number(let num): return num
      case .space: return 0
      }
    }

    var description: String {
      switch self {
      case .number(let n): return "\(n)"
      case .space: return "."
      }
    }
  }
}
