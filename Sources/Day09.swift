import Foundation

struct Day09: AdventDay {
  var data: String

  var entities: [Int] {
    data.compactMap { Int(String($0)) }
  }

  func part1() async throws -> Any {
    var blocks: [Block] = []
    for (offset, chunk) in entities.chunks(ofCount: 2).enumerated() {
      let c = Array(chunk)
      if let file = c[safe: 0] {
        blocks.append(contentsOf: Array(repeating: Block.number(offset), count: file))
      }
      if let space = c[safe: 1] {
        blocks.append(contentsOf: Array(repeating: Block.space, count: space))
      }
    }

    var diskMap = DiskMap(blocks: blocks)

    var swapped: [Block] = diskMap.blocks
    for (offset, block) in swapped.enumerated() {
      if block.isSpace {
        if let lastIndex = swapped.lastIndex(where: { !$0.isSpace }) {
          swapped.swapAt(offset, lastIndex)
        }
      }
      if swapped.suffix(from: offset + 1).allSatisfy(\.isSpace) {
        break
      }
    }

    diskMap.blocks = swapped

    return diskMap.checksum
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
