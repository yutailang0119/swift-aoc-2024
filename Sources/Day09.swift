import Foundation

struct Day09: AdventDay {
  var data: String

  var entities: [Int] {
    data.compactMap { Int(String($0)) }
  }

  func part1() async throws -> Any {
    let blocks: [Block] = entities.chunks(ofCount: 2).enumerated()
      .reduce(into: []) { blocks, enumerated in
        let chunk = Array(enumerated.element)
        if let file = chunk[safe: 0] {
          blocks.append(contentsOf: Array(repeating: Block.number(enumerated.offset), count: file))
        }
        if let space = chunk[safe: 1] {
          blocks.append(contentsOf: Array(repeating: Block.space(count: 1), count: space))
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
    case space(count: Int)

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
      case .number(let num):
        return "\(num)"
      case .space(let count):
        return  Array(repeating: ".", count: count).joined()
      }
    }
  }
}
