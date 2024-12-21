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

  public var path: OrderedSet<Position>? {
    _paths(isAll: false).first?.positions
  }

  public var paths: [OrderedSet<Position>] {
    _paths(isAll: true).map(\.positions)
  }
}

private extension Dijkstra {
  struct Path: Hashable {
    var positions: OrderedSet<Position>
    var weight: Int
  }

  struct Node: Comparable {
    var position: Position
    var path: Path

    func nexts(to directions: [Direction]) -> [Position] {
      directions.map(position.moved(to:))
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
      lhs.path.weight < rhs.path.weight
    }
  }

  func _paths(isAll: Bool) -> [Path] {
    var weights: [Position: Int] = [start: 0]
    var heap = Heap<Node>()
    heap.insert(
      Node(position: start, path: Path(positions: [start], weight: 0))
    )

    var paths: [Path] = []
    while let node = heap.popMin() {
      if node.position == end {
        paths.append(node.path)
        continue
      }

      var nds: [Node] = []
      for next in node.nexts(to: directions) {
        if !node.path.positions.contains(next),
          validate(elements[next])
        {
          nds.append(
            Node(
              position: next,
              path: Path(positions: node.path.positions.union([next]), weight: node.path.weight + 1)
            )
          )
        }
      }

      for nd in nds {
        let previous = weights[nd.position]
        if previous == nil || nd.path.weight < previous! + (isAll ? 1 : 0) {
          weights[nd.position] = nd.path.weight

          heap.insert(nd)
        }
      }
    }

    return paths
  }
}
