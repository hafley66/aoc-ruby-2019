Manhattan = ->(
  (x1, y1),
  (x2, y2)
) {
  (x1 - x2).abs + (y1 - y2).abs
}

class Day3

  def initialize(lines)
    @lines = lines
    @step_maps = {
      [lines[0]]: {},
      [lines[1]]: {},
    }
  end
  def log1 s; puts(s.to_s); s; end
  def log *s; puts(s.to_s); s; end

  Ops = {
    U: [nil, :+],
    D: [nil, :-],
    R: [:+, nil],
    L: [:-, nil]
  }

  def run_op((x,y), op_code, arg)
    opX, opY = Ops[op_code.to_sym]
    return [
      opX ? x.send(opX, arg) : x,
      opY ? y.send(opY, arg) : y,
    ]
  end

  def op_2_points(origin, relative_path_op)
    ox, oy = origin

    r = relative_path_op
    (op, dist) = [
      r[0].upcase,
      r[1..-1].to_i
    ]

    new_points = []
    i = 1

    while i <= dist
      new_points << (run_op(origin, op, i))
      i += 1
    end
    new_points
  end

  def ops_2_points
    @lines.map do |line_ops|
      points = [[0,0]]
      line_ops.each do |op|
        points.concat op_2_points(points.last, op)
      end
      points
    end
  end

  def closest_intersections
    ptsA, ptsB = ops_2_points
    pts = (ptsA & ptsB) - [[0,0]]
    log1 pts
    pts.min_by do |pt|
      log1 (pt[0].abs + pt[1].abs)
    end
  end
end


puts (
  (
    Day3.new(
      File
        .read('3.txt')
        .split("\n")
        .map do |it| it.split(",") end
    )
  ).closest_intersections.to_s
)
