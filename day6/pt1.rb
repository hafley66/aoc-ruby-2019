ORIGIN_NODE = "COM"
DIRECTED_ORBIT_OPERATOR = ")"

class GraphOrbiter
  def initialize(specs)
    @specs = specs
    @graph = (
        specs
           .reject(&:empty?)
           .reduce(Hash.new { |h, k| h[k] = Set.new }) do |sum, spec|
             _make_edge(sum, spec)
           end
    )
  end

  attr_reader :graph

  def _make_edge(graph, spec)
    from, to = spec.split(DIRECTED_ORBIT_OPERATOR)
    graph[from] << to
    # graph[to] << from
    graph
  end

  def breadth_first(start_node = ORIGIN_NODE)
    start = [start_node, 0, nil]
    queue = [start]
    traveled = []
    queue.each do |(from_node, count, from)|
      next if raveled.include? from_node
      traveled << from_node
      graph[from_node].each do |neighbor_node|
        queue << [neighbor_node, count + 1, from_node]
        puts "[BF_LOOP] #{queue.last.to_s}"
        yield queue.last if block_given?
      end
    end
    queue
  end

  def count_path_sum target
      breadth_first(target).map{|(_, count)| count }.sum
  end

  def get_breadth_shortest_path source, target
    breadth_first(target) do |(to_node, distance, from_node)|
      target == to_node
      return distance
    end
  end
end


c = File.read("./in.txt").split("\n")

it = GraphOrbiter.new(c)

puts it.get_breadth_shortest_path "YOU", "SAN"
# puts it.graph["YOU"].to_s
