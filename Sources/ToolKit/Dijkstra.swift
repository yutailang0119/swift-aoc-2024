import Collections
import Foundation

public struct Dijkstra<Element> {
  private var elements: [Position: Element]
  private var directions: [Direction]
  private var start: Position
  private var end: Position
  private var validate: (Element?) -> Bool

  public init(
    elements: [Position: Element],
    start: Position,
    end: Position,
    directions: [Direction],
    validate: @escaping (Element?) -> Bool
  ) {
    self.elements = elements
    self.start = start
    self.end = end
    self.directions = directions
    self.validate = validate
  }

  public var path: Set<Position>? {
    _paths(isAll: false).first?.positions
  }

  public var paths: [Set<Position>] {
    _paths(isAll: true).map(\.positions)
  }
}

private extension Dijkstra {
  struct Path: Hashable {
    var positions: Set<Position>
    var weight: Int
  }

  struct Node: Comparable {
    struct Context: Hashable {
      var position: Position
      var direction: Direction
    }

    var context: Context
    var path: Path

    func nexts(to directions: [Direction]) -> [Context] {
      directions.filter { $0 != context.direction.reverse }
        .map { Context(position: context.position.moved(to: $0), direction: $0) }
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
      lhs.path.weight < rhs.path.weight
    }
  }

  func _paths(isAll: Bool) -> [Path] {
    var weights: [Position: Int] = [start: 0]
    var heap = Heap<Node>()
    heap.insert(
      Node(context: Node.Context(position: start, direction: .right), path: Path(positions: [start], weight: 0))
    )

    var paths: [Path] = []
    while let node = heap.popMin() {
      if node.context.position == end {
        paths.append(node.path)
        continue
      }

      var nds: [Node] = []
      for next in node.nexts(to: directions) {
        if !node.path.positions.contains(next.position),
          validate(elements[next.position])
        {
          nds.append(
            Node(
              context: next,
              path: Path(positions: node.path.positions.union([next.position]), weight: node.path.weight + 1)
            )
          )
        }
      }

      for nd in nds {
        let previous = weights[nd.context.position]
        if previous == nil || nd.path.weight < previous! + (isAll ? 1 : 0) {
          weights[nd.context.position] = nd.path.weight

          heap.insert(nd)
        }
      }
    }

    return paths
  }
}
