ORIGIN_NODE = "COM"
DIRECTED_ORBIT_OPERATOR = ")"
require "set"


class GraphOrbiter

  attr_reader :graph

  def initialize(specs, track_backlinks = false)
    @specs = specs
    @track_backlinks = track_backlinks
    @graph ||= (
      @specs
        .select{|it| !it.empty?}
        .reduce(
          Hash.new do |h, k|
            h[k] = Set.new
          end
        ) { |sum, spec|
          _make_edge(sum, spec)
        }
    )
  end

  def _make_edge(graph, spec)
    from, to = spec.split(DIRECTED_ORBIT_OPERATOR)
    graph[from] << to
    graph[to] << from if @track_backlinks
    graph
  end

  def breadth_first(start_node = ORIGIN_NODE)
    start = [start_node, 0, nil]
    queue = [start]
    traveled = []
    queue.each { |(from_node, count, from)|
      if traveled.include? from_node
        puts "CYCLE Detected"
        puts [from_node, count, from].to_s
        next
      end
      traveled << from_node
      graph[from_node].each { |neighbor_node|
        if !traveled.include? neighbor_node
          queue << [neighbor_node, count + 1, from_node]
          yield(queue.last) if block_given?
        end
      }
    }
    queue
  end

  def count_path_sum target
      breadth_first(target).map{|(_, count)| count }.sum
  end

  def get_breadth_shortest_path source, target
    breadth_first(source) do |weighted_edge|
      puts weighted_edge.to_s
      return weighted_edge if target == weighted_edge[0] # to_node field
    end
  end

end


puts(
  GraphOrbiter.new(
    File.read("./in.txt").split("\n"),
    true
  ).get_breadth_shortest_path("YOU", "SAN")
)

# puts it.count_path_sum("COM")

